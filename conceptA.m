function [p,T,h,s,v,Wdot_cycle,Qdot_in,eta] = conceptA(p_boiler,p_cond,x,mdot,eta_p,eta_t)

if nargin~=6
    error('You must supply 6 arguments');
end

p=zeros(5,1);
T=zeros(5,1);
h=zeros(5,1);
s=zeros(5,1);
v=zeros(5,1);

% Mixture
p(1)=p_boiler;
T(1)=XSteam('TSat_p',p(1));
h(1)=XSteam('hL_p',p(1))+x*(XSteam('hV_p',p(1))-XSteam('hL_p',p(1)));
s(1)=XSteam('sL_p',p(1))+x*(XSteam('sV_p',p(1))-XSteam('sL_p',p(1)));
v(1)=XSteam('vL_p',p(1))+x*(XSteam('vV_p',p(1))-XSteam('vL_p',p(1)));

% Mixture
p(2)=p_cond;
h(2)=h(1)-(h(1)-XSteam('h_ps',p(2),s(1)))*eta_t;
T(2)=XSteam('TSat_p',p(2));
s(2)=(XSteam('sV_p',p(2))-XSteam('sL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('sL_p',p(2));
v(2)=(XSteam('vV_p',p(2))-XSteam('vL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));

% Saturated liquid
p(3)=p_cond;
T(3)=XSteam('TSat_p',p(3));
h(3)=XSteam('hL_p',p(3));
s(3)=XSteam('sL_p',p(3));
v(3)=XSteam('vL_p',p(3));

% Compressed liquid
p(4)=p_boiler;
h(4)=v(3)*100*(p(4)-p(3))/eta_p+h(3);
T(4)=XSteam('T_ph',p(4),h(4));
s(4)=XSteam('s_ph',p(4),h(4));
v(4)=XSteam('v_ph',p(4),h(4));

% Compressed liquid
p(5)=p_boiler;
h(5)=120*0.3*(XSteam('Cp_pT',14.35,180)*180-XSteam('Cp_pT',14.35,40)*40)/mdot+h(4);
T(5)=XSteam('T_ph',p(5),h(5));
s(5)=XSteam('s_pT',p(5),T(5));
v(5)=XSteam('v_pT',p(5),T(5));

% Pumps work in
Wdot_pump=mdot*(h(4)-h(3))
% Heat in
Qdot_HE=mdot*(h(5)-h(4))
Qdot_boiler=mdot*(h(1)-h(5))
Qdot_in=Qdot_HE+Qdot_boiler
% Work out (kJ/kg)
Wdot_turbine=mdot*(h(1)-h(2))
% Net work
Wdot_cycle=Wdot_turbine-Wdot_pump;
% Thermal efficiency
eta=Wdot_cycle/Qdot_in*100;

end

