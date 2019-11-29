function [p,T,h,s,v,Wdot_cycle,Qdot_in,eta] = conceptB(p_boiler,p_CFWH,p_OFWH,p_cond,T_max,z,mdot,eta_p,eta_t)

if nargin~=9
    error('You must supply 9 arguments');
end

p=zeros(12,1);
T=zeros(12,1);
h=zeros(12,1);
s=zeros(12,1);
v=zeros(12,1);

% Superheated vapor
p(1)=p_boiler;
T(1)=T_max;
h(1)=XSteam('h_pT',p(1),T(1));
s(1)=XSteam('s_pT',p(1),T(1));
v(1)=XSteam('v_pT',p(1),T(1));

% Superheated vapor OR mixture
p(2)=p_CFWH;
h(2)=h(1)-(h(1)-XSteam('h_ps',p(2),s(1)))*eta_t;
if h(2)>XSteam('hV_p',p(2)) % Superheated vapor
    T(2)=XSteam('T_ph',p(2),h(2));
    s(2)=XSteam('s_pT',p(2),T(2));
    v(2)=XSteam('v_pT',p(2),T(2));
else % Mixture
    T(2)=XSteam('TSat_p',p(2));
    s(2)=(XSteam('sV_p',p(2))-XSteam('sL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));
    v(2)=(XSteam('vV_p',p(2))-XSteam('vL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));
end

% Superheated vapor OR mixture
p(3)=p_OFWH;
h(3)=h(2)-(h(2)-XSteam('h_ps',p(3),s(2)))*eta_t;
if h(3)>XSteam('hV_p',p(3)) % Superheated vapor
    T(3)=XSteam('T_ph',p(3),h(3));
    s(3)=XSteam('s_pT',p(3),T(3));
    v(3)=XSteam('v_pT',p(3),T(3));
else % Mixture
    T(3)=XSteam('TSat_p',p(3));
    s(3)=(XSteam('sV_p',p(3))-XSteam('sL_p',p(3)))*XSteam('x_ph',p(3),h(3))+XSteam('sL_p',p(3));
    v(3)=(XSteam('vV_p',p(3))-XSteam('vL_p',p(3)))*XSteam('x_ph',p(3),h(3))+XSteam('vL_p',p(3));
end

% Superheated vapor OR mixture 
p(4)=p_cond;
h(4)=h(3)-(h(3)-XSteam('h_ps',p(4),s(3)))*eta_t;
if h(4)>XSteam('hV_p',p(4)) % Superheated vapor
    T(4)=XSteam('T_ph',p(4),h(4));
    s(4)=XSteam('s_pT',p(4),T(4));
    v(4)=XSteam('v_pT',p(4),T(4));
else % Mixture
    T(4)=XSteam('TSat_p',p(4));
    s(4)=(XSteam('sV_p',p(4))-XSteam('sL_p',p(4)))*XSteam('x_ph',p(4),h(4))+XSteam('sL_p',p(4));
    v(4)=(XSteam('vV_p',p(4))-XSteam('vL_p',p(4)))*XSteam('x_ph',p(4),h(4))+XSteam('vL_p',p(4));
end

% Saturated liquid
p(5)=p_cond;
T(5)=XSteam('TSat_p',p(5));
h(5)=XSteam('hL_p',p(5));
s(5)=XSteam('sL_p',p(5));
v(5)=XSteam('vL_p',p(5));

% Compressed liquid
p(6)=p_OFWH;
h(6)=v(5)*100*(p(6)-p(5))/eta_p+h(5);
T(6)=XSteam('T_ph',p(6),h(6));
s(6)=XSteam('s_pT',p(6),T(6));
v(6)=XSteam('v_pT',p(6),T(6));

% Saturated liquid
p(7)=p_OFWH;
T(7)=XSteam('TSat_p',p(7));
h(7)=XSteam('hL_p',p(7));
s(7)=XSteam('sL_p',p(7));
v(7)=XSteam('vL_p',p(7));

% Compressed liquid
p(8)=p_boiler;
h(8)=v(7)*100*(p(8)-p(7))/eta_p+h(7);
T(8)=XSteam('T_ph',p(8),h(8));
s(8)=XSteam('s_pT',p(8),T(8));
v(8)=XSteam('v_pT',p(8),T(8));

% Compressed liquid
p(9)=p_boiler;
h(9)=120*0.65*(XSteam('Cp_pT',14.35,180)*180-XSteam('Cp_pT',14.35,107.5)*107.5)/mdot+h(8);
T(9)=XSteam('T_ph',p(9),h(9));
s(9)=XSteam('s_pT',p(9),T(9));
v(9)=XSteam('v_pT',p(9),T(9));

% Compressed liquid
p(10)=p_boiler;
h(10)=(h(2)-h(11))*y*eta_CFWH+h(11);
h(10)=XSteam('h_pT',p(10),T(10));
s(10)=XSteam('s_pT',p(10),T(10));
v(10)=XSteam('v_pT',p(10),T(10));

% Saturated liquid
p(11)=p_CFWH;
T(11)=XSteam('TSat_p',p(11));
h(11)=XSteam('hL_p',p(11));
s(11)=XSteam('sL_p',p(11));
v(11)=XSteam('vL_p',p(11));

% Mixture
p(12)=p_cond;
T(12)=XSteam('TSat_p',p(12));
h(12)=XSteam('h_px',p(12),0.5);
s(12)=XSteam('s_ph',p(12),h(12));
v(12)=XSteam('v_pT',p(12),T(12));

y=(h(7)-h(6))/(h(3)-h(6));

% Pumps work in
Wdot_pump1=mdot*(1-z)*(h(6)-h(5));
Wdot_pump2=mdot*(h(8)-h(7));
% Heat in
Qdot_HE=mdot*(h(9)-h(8));
Qdot_boiler=mdot*(h(1)-h(10))
Qdot_in=Qdot_HE+Qdot_boiler;
% Work out (kJ/kg)
Wdot_turbine1=mdot*(h(1)-h(2));
Wdot_turbine2=mdot*(1-y)*(h(2)-h(3));
Wdot_turbine3=mdot*(1-y-z)*(h(3)-h(4));
% Net work
Wdot_cycle=Wdot_turbine1+Wdot_turbine2+Wdot_turbine3-Wdot_pump1-Wdot_pump2;
% Thermal efficiency
eta=Wdot_cycle/Qdot_in*100

end

