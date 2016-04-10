clc, close all, clear all

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

for k = 1:length(RecX)
    for m = 0:-5:-180
        [mapaOcupado, cono, mapaLibre] = ultrasonidos(RecX(k), RecY(k), m, mapaOcupado, mapaLibre, mapaReal);
    end
    for m = 180:-5:0
        [mapaOcupado, cono, mapaLibre] = ultrasonidos(RecX(k), RecY(k), m, mapaOcupado, mapaLibre, mapaReal);
    end
end

figure
image(40.*mapaReal), title('Apartado 1: Reconocimiento inicial robot tras giro completo')

hold on
plot(RecX, 501-RecY, '-*r')


figure
image(50.*mapaOcupado), title('Apartado 1: Reconocimiento inicial robot tras giro completo')

hold on
plot(RecX, 501-RecY, '-*r')

%fill(10, 10, 'r')



