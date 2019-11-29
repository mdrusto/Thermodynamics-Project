function [p,T,h,s,v,Wdot_cycle,Qdot_in,eta] = conceptD(p_boiler,p_reheat1,p_reheat2,p_cond,T_max,T_reheat1,T_reheat2,mdot,eta_p,eta_t)

if nargin~=10
    error('You must supply 10 arguments');
end

p=zeros(9,1);
T=zeros(9,1);
h=zeros(9,1);
s=zeros(9,1);
v=zeros(9,1);

% Superheated vapor
p(1)=p_boiler;
T(1)=T_max;
h(1)=XSteam('h_pT',p(1),T(1));
s(1)=XSteam('s_pT',p(1),T(1));
v(1)=XSteam('v_pT',p(1),T(1));

% Superheated vapor
p(2)=p_reheat1;
h(2)=h(1)-(h(1)-XSteam('h_ps',p(2),s(1)))*eta_t;
if h(2)>XSteam('hV_p',p(2))
    T(2)=XSteam('T_ph',p(2),h(2));
    s(2)=XSteam('s_pT',p(2),T(2));
    v(2)=XSteam('v_pT',p(2),T(2));
else
    T(2)=XSteam('TSat_p',p(2));
    s(2)=(XSteam('sV_p',p(2))-XSteam('sL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('sL_p',p(2));
    v(2)=(XSteam('vV_p',p(2))-XSteam('vL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));
end

% Superheated vapor
p(3)=p_reheat1;
T(3)=T_reheat1;
h(3)=XSteam('h_pT',p(3),T(3));
s(3)=XSteam('s_pT',p(3),T(3));
v(3)=XSteam('v_pT',p(3),T(3));

% Saturated liquid
p(4)=p_reheat2;
h(4)=h(3)-(h(3)-XSteam('h_ps',p(4),s(3)))*eta_t;
if h(4)>XSteam('hV_p',p(4))
    T(4)=XSteam('T_ph',p(4),h(4));
    s(4)=XSteam('s_pT',p(4),T(4));
    v(4)=XSteam('v_pT',p(4),T(4));
else
    T(4)=XSteam('TSat_p',p(4));
    s(4)=(XSteam('sV_p',p(4))-XSteam('sL_p',p(4)))*XSteam('x_ph',p(4),h(4))+XSteam('sL_p',p(4));
    v(4)=(XSteam('vV_p',p(4))-XSteam('vL_p',p(4)))*XSteam('x_ph',p(4),h(4))+XSteam('vL_p',p(4));
end

% Superheated vapor
p(5)=p_reheat2;
T(5)=T_reheat2;
h(5)=XSteam('h_pT',p(5),T(5));
s(5)=XSteam('s_pT',p(5),T(5));
v(5)=XSteam('v_pT',p(5),T(5));

% Saturated liquid
p(6)=p_cond;
h(6)=h(5)-(h(5)-XSteam('h_ps',p(6),s(5)))*eta_t;
if h(6)>XSteam('hV_p',p(6))
    T(6)=XSteam('T_ph',p(6),h(6));
    s(6)=XSteam('s_pT',p(6),T(6));
    v(6)=XSteam('v_pT',p(6),T(6));
else
    T(6)=XSteam('TSat_p',p(6));
    s(6)=(XSteam('sV_p',p(6))-XSteam('sL_p',p(6)))*XSteam('x_ph',p(6),h(6))+XSteam('sL_p',p(6));
    v(6)=(XSteam('vV_p',p(6))-XSteam('vL_p',p(6)))*XSteam('x_ph',p(6),h(6))+XSteam('vL_p',p(6));
end

% Saturated liquid
p(7)=p_cond;
T(7)=XSteam('TSat_p',p(7));
h(7)=XSteam('hL_p',p(7));
s(7)=XSteam('sL_p',p(7));
v(7)=XSteam('vL_p',p(7));

% Compressed liquid
p(8)=p_boiler;
h(8)=v(7)*100*(p(8)-p(7))/eta_p+h(7);
T(8)=XSteam('T_ph',p(8),h(8));
s(8)=XSteam('s_ph',p(8),h(8));
v(8)=XSteam('v_ph',p(8),h(8));

% Compressed liquid
p(9)=p_boiler;
h(9)=120*0.3*(XSteam('Cp_pT',14.35,180)*180-XSteam('Cp_pT',14.35,40)*40)/mdot+h(8);
T(9)=XSteam('T_ph',p(9),h(9));
s(9)=XSteam('s_pT',p(9),T(9));
v(9)=XSteam('v_pT',p(9),T(9));

% Pumps work in
Wdot_pump=mdot*(h(8)-h(7));
% Heat in
Qdot_HE=mdot*(h(9)-h(8));
Qdot_boiler=mdot*(h(1)-h(9));
Qdot_in=Qdot_HE+Qdot_boiler;
% Work out (kJ/kg)
Wdot_turbine1=mdot*(h(1)-h(2))
Wdot_turbine2=mdot*(h(3)-h(4))
Wdot_turbine3=mdot*(h(5)-h(6))
% Net work
Wdot_cycle=Wdot_turbine1+Wdot_turbine2+Wdot_turbine3-Wdot_pump;
% Thermal efficiency
eta=Wdot_cycle/Qdot_in*100;

end

