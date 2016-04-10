function [mapaOcupado, cono, mapaLibre] = ultrasonidos(posX, posY, angRobot, mapaRobot, mapaAuxiliar, mapaReal)

%Tests
% clc, clear all, close all
% 
% mapaReal =load('Mapa.mat');
% mapaRobot = ones(size(mapaReal.M));
% 
% %image(35*mapaReal.M);
% mapaReal = mapaReal.M;
% 
% posX = 200;
% posY = 100;
% angRobot = 10;

%Config sensor:
rmax = 80; 
angSensor = 30; %Grados
Kd = 3;
eps = 10;


mapaOcupado=mapaRobot;
mapaLibre=mapaAuxiliar;

%-------------------------------------------- Limites ---------
        prec1 = 0;
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
%----------------------------------------------------------------       

dimensionesMapa = size(mapaRobot);        


%Cono sensor (máscara)

mapaCono = ones(dimensionesMapa);

for i = 1:dimensionesMapa(1)
    for j = 1:dimensionesMapa(2)
        if (i-posX) == 0 && (j < posY)
            angCasilla = -90;
        
        elseif (i-posX) == 0 && (j > posY)
            angCasilla = 90;
        else
            angCasilla = atand((j-posY)/(i-posX));
        end
        
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
                
               
    %Definen las rectas del "cono"
    
    %Caso habitual, ninguna linea limite sobrepasa
        if  prec1 == 0 && prec2 == 0 
            if angCasilla > lim1 %> 
                mapaCono(j,i) = 0;
            end
            if angCasilla < lim2 %<
                mapaCono(j,i) = 0;
            end
        elseif prec1 == 1 || prec2 == 1

            if angCasilla > lim1 && angCasilla < lim2 %<
                mapaCono(j,i) = 0;
            end
            
        end
                            %test(j, i) = angCasilla;
    %El arco del cono        
        if sqrt((i-posX)^2+(j-posY)^2) > rmax
            mapaCono(j,i) = 0;
        end
    end
end

%mapaCono = zeros(300,500); (y, X)

cono = convert(mapaCono); %fixeado para representación
distObj = 10000;

 %-------------------------------------- Matriz más pequeña ------

% % 
posY = 501-posY; %fix representacion

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


%----------------------------------------------------------------
 
 for i = mReducMinX:mReducMaxX
    for j = mReducMinY:mReducMaxY
        if (mapaReal(j,i)*cono(j,i))
            if sqrt((i-posX)^2+(j-posY)^2) < distObj
               distObj = sqrt((i-posX)^2+(j-posY)^2)
            end
        end
    end
end



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

        suma = PHocu*mapaRobot(j,i) + (1-PHocu)*mapaAuxiliar(j,i);
        mapaOcupado(j,i) = PHocu*mapaRobot(j,i) / suma;
        mapaLibre(j,i) = (1-PHocu)*mapaAuxiliar(j,i) / suma;
            
    end
end


end