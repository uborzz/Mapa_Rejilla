function [mapaOcupado, cono, mapaLibre] = ultrasonidos(posX, posY, angRobot, mapaRobot, mapaAuxiliar, mapaReal)

%% ------------------- Config sensor:  ----------------------------
%
rmax = 80; 
angSensor = 30; %Grados
Kd = 3;
eps = 10;


mapaOcupado=mapaRobot; %Mapa probabilidad obstaculo
mapaLibre=mapaAuxiliar; %Mapa probabilidad no-obstaculo

dimensionesMapa = size(mapaRobot);%Dimensiones del mapa        

%% ----------------------- FUNCIONAMIENTO ---------------------------
%
% - Se crea el "cono" del rango delsensor mediante 2 lineas y una circunferencia.
% - Dicha figura se emplea para localizar objetos contrastandola con el 
%     mapa real conocido. Se toma la menor distancia a un obst�culo dentro del
%     cono. De esta forma se simula la medici�n del ultrasonidos.
% - Se actualiza la zona dentro del cono que no se tiene por seguro que est� vac�a
%     iterando con el teorema de Bayes.
%


%% ---------------------- Limites �ngulos Cono ---------------------
    prec1 = 0; %auxiliares para conocer paso por pi radianes
    prec2 = 0;

    lim1 = angRobot+(angSensor/2);
    if lim1 > 180
        lim1 = lim1-360;
        prec1 = 1;
    end

    lim2 = angRobot-(angSensor/2);
    if lim2 < -180
        lim2 = lim2+360;
        prec2 = 1;
    end


%% ---------------- Reduccion Matriz para loop ----------------------
% Utilizamos una matriz del tama�o del rango del sensor x2 por facilidad
% Habr�a que considerar optimizar si el tiempo de procesado se ve alto

    mReducMinY = posY - rmax;
    if mReducMinY < 1
        mReducMinY = 1;
    end

    mReducMaxY = posY + rmax;
    if mReducMaxY > dimensionesMapa(2);
        mReducMaxY = dimensionesMapa(2);
    end

    mReducMinX = posX - rmax;
    if mReducMinX < 1
        mReducMinX = 1;
    end

    mReducMaxX = posX + rmax;
    if mReducMaxX > dimensionesMapa(1);
        mReducMaxX = dimensionesMapa(1);
    end

%% --- Cono comprobando el �ngulo respecto al punto del robot ------------

mapaCono = zeros(dimensionesMapa); 
mapaCono(mReducMinY:mReducMaxY, mReducMinX:mReducMaxX) = ones(rmax*2+1,rmax*2+1);


% estado = 1

 for i = mReducMinX:mReducMaxX
    for j = mReducMinY:mReducMaxY

        %Posiciones division por cero
        if (i-posX) == 0 && (j < posY)
            angCasilla = -90;
        
        elseif (i-posX) == 0 && (j > posY)
            angCasilla = 90;
        else
            angCasilla = atand((j-posY)/(i-posX));
        end
        
        %Correcci�n para tercer y cuarto cuadrantes
        if (i < posX) && j > posY 
             angCasilla = angCasilla + 180;
             if angCasilla > 180
                angCasilla = angCasilla-360
             end
        elseif (i < posX) && j < posY
             angCasilla = angCasilla - 180;
             if angCasilla < -180
                angCasilla = angCasilla+360
             end
        end
                
               
    %  Definen las rectas del "cono"
     
    	%Caso habitual, ninguna linea limite sobrepasa
        if  prec1 == 0 && prec2 == 0 
            if angCasilla > lim1 %> 
                mapaCono(j,i) = 0;
            end
            if angCasilla < lim2 %<
                mapaCono(j,i) = 0;
            end
            
        %Caso cruzamos 180 grados
        elseif prec1 == 1 || prec2 == 1

            if angCasilla > lim1 && angCasilla < lim2 %<
                mapaCono(j,i) = 0;
            end
            
        end

        %El arco del cono        
        if sqrt((i-posX)^2+(j-posY)^2) > rmax
            mapaCono(j,i) = 0;
        end
    end
end

%mapaCono = zeros(300,500); (y, X) % tests
cono = convert(mapaCono); %fixeado para representaci�n por image()
distObj = 10000;


%% ---------------- Reduccion Matriz para loop ----------------------
% Utilizamos una matriz del tama�o del rango del sensor x2 por facilidad
% Habr�a que considerar optimizar si el tiempo de procesado se ve alto
% Es distinta a la anterior empleada porque se tiene en cuenta Y para 
% ser representada con image()

posY = 501-posY; %fix representacion por image()

mReducMinY = posY - rmax;
if mReducMinY < 1
    mReducMinY = 1;
end

mReducMaxY = posY + rmax;
if mReducMaxY > dimensionesMapa(2);
    mReducMaxY = dimensionesMapa(2);
end

mReducMinX = posX - rmax;
if mReducMinX < 1
    mReducMinX = 1;
end

mReducMaxX = posX + rmax;
if mReducMaxX > dimensionesMapa(1);
    mReducMaxX = dimensionesMapa(1);
end


%% ------------------- Simulacion US -----------------------------
% estado = 3
% Distancia m�nima (simulaci�n detecci�n ultrasonido)
% Se atiende a la m�nima distancia dentro del rango del sensor
 for i = mReducMinX:mReducMaxX
    for j = mReducMinY:mReducMaxY
        if (mapaReal(j,i)*cono(j,i))
            if sqrt((i-posX)^2+(j-posY)^2) < distObj
               distObj = sqrt((i-posX)^2+(j-posY)^2);
            end
        end
    end
 end

 

%% --------------------------- Bayes -----------------------------
% estado =4 
% Actualizaci�n estado de la ocupaci�n celda: teorema de Bayes
Ro=distObj;
 for i = mReducMinX:mReducMaxX
    for j = mReducMinY:mReducMaxY
        if (cono(j,i)) && (sqrt((i-posX)^2+(j-posY)^2) < Ro)
            PHocu = 0;
        elseif (cono(j,i)) && (sqrt((i-posX)^2+(j-posY)^2) > Ro) && (sqrt((i-posX)^2+(j-posY)^2) < (Ro+eps))
            PHocu = 0.5+0.5/Kd;
        else
            PHocu = 0.5;
        end

        if (cono(j,i)) && mapaOcupado(j,i) ~= 0
            suma = PHocu*mapaRobot(j,i) + (1-PHocu)*mapaAuxiliar(j,i);
            mapaOcupado(j,i) = PHocu*mapaRobot(j,i) / suma;
            mapaLibre(j,i) = (1-PHocu)*mapaAuxiliar(j,i) / suma;
        end    
    end
end


end