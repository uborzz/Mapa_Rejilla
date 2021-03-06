function [posicionX, posicionY, angleDeg, t] = movimiento(NI, ND, p1, p2, a, interv)

%Config m�vil.
R = 5;
L = 10;
ratio = 100;

t = 0:interv:length(NI);

DI = 2*pi*R*NI/ratio;
DD = 2*pi*R*ND/ratio;

%C�lculo de las distancias/�ngulos 'relativos' (respecto punto anterior)
posRel = (DD+DI) / 2;
angleRel = (DD-DI) / L;

posicionX(1) = p1;
posicionY(1) = p2;
angle(1) = a; % 0 rad = vector [1, 0]

%C�lculo posici�n valores absolutos y orientaci�n del veh�culo en en plano
for i = 2:length(NI)
    angle(i) = angle(i-1)+angleRel(i);
    posicionX(i) = posicionX(i-1)+posRel(i)*cos(angle(i));
    posicionY(i) = posicionY(i-1)+posRel(i)*sin(angle(i));
end

angleDeg = angle * 180 / pi;
end


