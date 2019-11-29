function [p,T,h,s,v,Wdot_cycle,Qdot_in,eta] = conceptC(p_boiler,p_reheat,p_cond,T_max,T_reheat,mdot,eta_p,eta_t)

if nargin~=8
    error('You must supply 8 arguments');
end

p=zeros(7,1);
T=zeros(7,1);
h=zeros(7,1);
s=zeros(7,1);
v=zeros(7,1);

% Superheated vapor
p(1)=p_boiler;
T(1)=T_max;
h(1)=XSteam('h_pT',p(1),T(1));
s(1)=XSteam('s_pT',p(1),T(1));
v(1)=XSteam('v_pT',p(1),T(1));

% Superheated vapor
p(2)=p_reheat;
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
p(3)=p_reheat;
T(3)=T_reheat;
h(3)=XSteam('h_pT',p(3),T(3));
s(3)=XSteam('s_pT',p(3),T(3));
v(3)=XSteam('v_pT',p(3),T(3));

% Saturated liquid
p(4)=p_cond;
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

% Saturated liquid
p(5)=p_cond;
T(5)=XSteam('TSat_p',p(5));
h(5)=XSteam('hL_p',p(5));
s(5)=XSteam('sL_p',p(5));
v(5)=XSteam('vL_p',p(5));

% Compressed liquid
p(6)=p_boiler;
h(6)=v(5)*100*(p(6)-p(5))/eta_p+h(5);
T(6)=XSteam('T_ph',p(6),h(6));
s(6)=XSteam('s_ph',p(6),h(6));
v(6)=XSteam('v_ph',p(6),h(6));

% Compressed liquid
p(7)=p_boiler;
h(7)=120*0.3*(XSteam('Cp_pT',14.35,180)*180-XSteam('Cp_pT',14.35,40)*40)/mdot+h(6);
T(7)=XSteam('T_ph',p(7),h(7));
s(7)=XSteam('s_pT',p(7),T(7));
v(7)=XSteam('v_pT',p(7),T(7));

% Pumps work in
Wdot_pump=mdot*(h(6)-h(5));
% Heat in
Qdot_HE=mdot*(h(7)-h(6));
Qdot_boiler=mdot*(h(1)-h(7))
Qdot_in=Qdot_HE+Qdot_boiler
% Work out (kJ/kg)
Wdot_turbine1=mdot*(h(1)-h(2));
Wdot_turbine2=mdot*(h(3)-h(4));
% Net work
Wdot_cycle=Wdot_turbine1+Wdot_turbine2-Wdot_pump;
% Thermal efficiency
eta=Wdot_cycle/Qdot_in*100;

end

