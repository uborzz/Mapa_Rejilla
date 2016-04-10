clc, close all, clear all

mapaReal =load('Mapa.mat');
mapa = ones(size(mapaReal.M));
mapa = 0.5.*mapa;
mapa;
%image(35*mapaReal.M);
mapaReal = mapaReal.M;

E = load('Encoder.mat');

ruedaIzq = E.Enc(:,1);
ruedaDer = E.Enc(:,2);
clear E


mapaLibre = mapa;
mapaOcupado = mapa;

%[mapaOcupado, cono, mapaLibre] = ultrasonidos(200, 100, -90, mapaOcupado, mapaLibre, mapaReal);
% 
for m = 0:-5:-180
    [mapaOcupado, cono, mapaLibre] = ultrasonidos(200, 100, m, mapaOcupado, mapaLibre, mapaReal);
end

for m = 180:-5:0
    [mapaOcupado, cono, mapaLibre] = ultrasonidos(200, 100, m, mapaOcupado, mapaLibre, mapaReal);
end

figure
image(40.*mapaOcupado)




