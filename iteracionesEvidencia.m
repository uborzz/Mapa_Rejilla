%%% Numero de mediciones para evidencia >0.8

eOcu = 0.5;
eOcuF = 0.5;
eLib = 0.5;

a= 0.5+0.5/3; %P(H|ocupada)
b= 1-a;

c =0;

while eOcu <= 0.8
    eOcuF = (a*eOcu)/((a*eOcu)+(b*eLib));
    eLibF = (b*eLib)/((a*eOcu)+(b*eLib));
    c = c+1;
    eOcu = eOcuF;
    eLib = eLibF;
end

c
eOcu