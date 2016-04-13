clc, clear all

%%% Modificación programa robot para definir un modo diferente de
%%% funcionamiento

mapaReal =load('Mapa.mat');
mapa = ones(size(mapaReal.M));
mapa = 0.5.*mapa;

mapaReal = mapaReal.M; %En forma de matriz

E = load('Encoder.mat');

ruedaIzq = E.Enc(:,1);
ruedaDer = E.Enc(:,2);
clear E

posInicialX = 200;
posInicialY = 100;
angleInicial= 0;


mapaLibre = mapa;
mapaOcupado = mapa;
intervalo = 1; %intervalo de tiempo entre medidas de los encoders, nos da igual.

[RecX, RecY, Giro, t] = movimiento(ruedaIzq, ruedaDer, posInicialX, posInicialY, angleInicial, intervalo);

RecX = double(int16(RecX));
RecY = double(int16(RecY));
Giro = double(int16(Giro));
[ruedaDer, ruedaIzq, RecX', RecY', Giro']


for k = 1:length(RecX) %
    %for asd= 1:3 %Descomentar for para Ap.C
        [mapaOcupado, cono, mapaLibre] = ultrasonidos(RecX(k), RecY(k), Giro(k), mapaOcupado, mapaLibre, mapaReal);
    %end
end

figure
image(50.*mapaOcupado), title('B. Medidas en el mismo sentido de dirección robot')

hold on
plot(RecX, 501-RecY, '-*r')


