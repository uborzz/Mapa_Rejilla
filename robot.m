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

%[mapaOcupado, mapaLibre, cono] = ultrasonidos(200, 100, -90, mapaOcupado, mapaLibre, mapaReal);
% 
for m = -30:-15:-150
    [mapaOcupado, cono, mapaLibre] = ultrasonidos(200, 100, m, mapaOcupado, mapaLibre, mapaReal);
end

% for m = 180:-15:0
%     [mapaOcupado, mapaLibre, cono] = ultrasonidos(200, 100, m, mapaOcupado, mapaLibre, mapaReal);
% end

image(40.*mapaOcupado)




