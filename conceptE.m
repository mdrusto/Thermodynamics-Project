function [p,T,h,s,v,Wdot_cycle,Qdot_in,eta] = conceptE(p_boiler,p_OFWH,p_cond,T_max,mdot,eta_p,eta_t)

if nargin~=7
    error('You must supply 7 arguments');
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
p(2)=p_OFWH;
h(2)=v(1)*100*(p(2)-p(1))/eta_t+h(1);
T(2)=XSteam('T_ph',p(2),h(2));
s(2)=(XSteam('sV_p',p(2))-XSteam('sL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('sL_p',p(2));
v(2)=(XSteam('vV_p',p(2))-XSteam('vL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));

% Mixture
p(3)=p_cond;
h(3)=v(2)*100*(p(3)-p(2))/eta_t+h(2);
T(3)=XSteam('TSat_p',p(3));
s(3)=(XSteam('sV_p',p(3))-XSteam('sL_p',p(3)))*XSteam('x_ph',p(3),h(3))+XSteam('sL_p',p(3));
v(3)=(XSteam('vV_p',p(3))-XSteam('vL_p',p(3)))*XSteam('x_ph',p(3),h(3))+XSteam('vL_p',p(3));

% Saturated liquid
p(4)=p_cond;
T(4)=XSteam('TSat_p',p(4));
h(4)=XSteam('hL_p',p(4));
s(4)=XSteam('sL_p',p(4));
v(4)=XSteam('vL_p',p(4));

% Compressed liquid
p(5)=p_OFWH;
h(5)=v(4)*100*(p(5)-p(4))/eta_p+h(4);
T(5)=XSteam('T_ph',p(5),h(5));
s(5)=XSteam('s_pT',p(5),T(5));
v(5)=XSteam('v_pT',p(5),T(5));

% Saturated liquid
p(6)=p_OFWH;
T(6)=XSteam('TSat_p',p(6));
h(6)=XSteam('hL_p',p(6));
s(6)=XSteam('sL_p',p(6));
v(6)=XSteam('vL_p',p(6));

% Compressed liquid
p(7)=p_boiler;
h(7)=v(6)*100*(p(7)-p(6))/eta_p+h(6);
T(7)=XSteam('T_ph',p(7),h(7));
s(7)=XSteam('s_pT',p(7),T(7));
v(7)=XSteam('v_pT',p(7),T(7));

% Compressed liquid
p(8)=p_boiler;
h(8)=v(7)*100*(p(8)-p(7))/eta_p+h(7);
T(8)=XSteam('T_ph',p(8),h(8));
s(8)=XSteam('s_pT',p(8),T(8));
v(8)=XSteam('v_pT',p(8),T(8));

y=(h(6)-h(5))/(h(2)-h(5))

% Pumps work in
Wdot_pump1=mdot*(1-y)*(h(5)-h(4))
Wdot_pump2=mdot*(h(7)-h(6))
% Heat in
Qdot_HE=mdot*(h(8)-h(7))
Qdot_boiler=mdot*(h(1)-h(8))
Qdot_in=Qdot_HE+Qdot_boiler
% Work out (kJ/kg)
Wdot_turbine1=mdot*(h(1)-h(2))
Wdot_turbine2=mdot*(1-y)*(h(2)-h(3))
% Net work
Wdot_cycle=Wdot_turbine1+Wdot_turbine2-Wdot_pump1-Wdot_pump2;
% Thermal efficiency
eta=Wdot_cycle/Qdot_in*100;

end

