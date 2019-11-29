function [p,T,h,s,v,Wdot_cycle,Qdot_in,eta] = conceptF(p_boiler,p_CFWH,p_reheat,p_OFWH,p_cond,T_max,T_reheat,y,mdot,eta_p,eta_t,eta_CFWH)

if nargin~=12
    error('You must supply 12 arguments');
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
if h(2)>XSteam('hV_p',p(2))
    T(2)=XSteam('T_ph',p(2),h(2));
    s(2)=XSteam('s_pT',p(2),T(2));
    v(2)=XSteam('v_pT',p(2),T(2));
else
    T(2)=XSteam('TSat_p',p(2));
    s(2)=(XSteam('sV_p',p(2))-XSteam('sL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));
    v(2)=(XSteam('vV_p',p(2))-XSteam('vL_p',p(2)))*XSteam('x_ph',p(2),h(2))+XSteam('vL_p',p(2));
end

% Superheated vapor OR mixture
p(3)=p_reheat;
h(3)=h(2)-(h(2)-XSteam('h_ps',p(3),s(2)))*eta_t;
if h(3)>XSteam('hV_p',p(3))
    T(3)=XSteam('T_ph',p(3),h(3));
    s(3)=XSteam('s_pT',p(3),T(3));
    v(3)=XSteam('v_pT',p(3),T(3));
else
    T(3)=XSteam('TSat_p',p(3));
    s(3)=(XSteam('sV_p',p(3))-XSteam('sL_p',p(3)))*XSteam('x_ph',p(3),h(3))+XSteam('sL_p',p(3));
    v(3)=(XSteam('vV_p',p(3))-XSteam('vL_p',p(3)))*XSteam('x_ph',p(3),h(3))+XSteam('vL_p',p(3));
end

% Superheated vapor
p(4)=p_reheat;
T(4)=T_reheat;
h(4)=XSteam('h_pT',p(4),T(4));
s(4)=XSteam('s_pT',p(4),T(4));
v(4)=XSteam('v_pT',p(4),T(4));

% Superheated vapor OR mixture
p(5)=p_OFWH;
h(5)=h(4)-(h(4)-XSteam('h_ps',p(5),s(4)))*eta_t;
if h(5)>XSteam('hV_p',p(5))
    T(5)=XSteam('T_ph',p(5),h(5));
    s(5)=XSteam('s_pT',p(5),T(5));
    v(5)=XSteam('v_pT',p(5),T(5));
else
    T(5)=XSteam('TSat_p',p(5));
    s(5)=(XSteam('sV_p',p(5))-XSteam('sL_p',p(5)))*XSteam('x_ph',p(5),h(5))+XSteam('sL_p',p(5));
    v(5)=(XSteam('vV_p',p(5))-XSteam('vL_p',p(5)))*XSteam('x_ph',p(5),h(5))+XSteam('vL_p',p(5));
end

% Superheated vapor OR mixture 
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
p(8)=p_OFWH;
h(8)=v(7)*100*(p(8)-p(7))/eta_p+h(7);
T(8)=XSteam('T_ph',p(8),h(8));
s(8)=XSteam('s_pT',p(8),T(8));
v(8)=XSteam('v_pT',p(8),T(8));

% Saturated liquid
p(9)=p_OFWH;
T(9)=XSteam('TSat_p',p(9));
h(9)=XSteam('hL_p',p(9));
s(9)=XSteam('sL_p',p(9));
v(9)=XSteam('vL_p',p(9));

% Compressed liquid
p(10)=p_boiler;
h(10)=v(9)*100*(p(10)-p(9))/eta_p+h(9);
T(10)=XSteam('T_ph',p(10),h(10));
s(10)=XSteam('s_pT',p(10),T(10));
v(10)=XSteam('v_pT',p(10),T(10));

% Saturated liquid
p(13)=p_CFWH;
T(13)=XSteam('TSat_p',p(13));
h(13)=XSteam('hL_p',p(13));
s(13)=XSteam('sL_p',p(13));
v(13)=XSteam('vL_p',p(13));

% Compressed liquid
p(11)=p_boiler;
h(11)=120*0.3*(XSteam('Cp_pT',14.35,180)*180-XSteam('Cp_pT',14.35,40)*40)/mdot+h(10);
T(11)=XSteam('T_ph',p(11),h(11));
s(11)=XSteam('s_pT',p(11),T(11));
v(11)=XSteam('v_pT',p(11),T(11));

% Compressed liquid
p(12)=p_boiler;
h(12)=(h(2)-h(13))*y*eta_CFWH+h(11);
T(12)=XSteam('T_ph',p(12),h(12));
s(12)=XSteam('s_pT',p(12),T(12));
v(12)=XSteam('v_pT',p(12),T(12));

% Mixture
p(14)=p_cond;
T(14)=XSteam('TSat_p',p(14));
h(14)=XSteam('h_px',p(14),0.6);
s(14)=XSteam('s_ph',p(14),h(14));
v(14)=XSteam('v_pT',p(14),T(14));

z=(h(9)-h(8))/(h(5)-h(8));

% Pumps work in
Wdot_pump1=mdot*(1-y)*(h(8)-h(7));
Wdot_pump2=mdot*(h(10)-h(9));
% Heat in
Qdot_HE=mdot*(h(11)-h(10));
Qdot_boiler=mdot*(h(1)-h(12))+mdot*(1-y)*(h(4)-h(3))
Qdot_in=Qdot_HE+Qdot_boiler;
% Work out (kJ/kg)
Wdot_turbine1=mdot*(h(1)-h(2));
Wdot_turbine2=mdot*(1-y)*(h(2)-h(3));
Wdot_turbine3=mdot*(1-y)*(h(4)-h(5));
Wdot_turbine4=mdot*(1-y-z)*(h(5)-h(6));
% Net work
Wdot_cycle=Wdot_turbine1+Wdot_turbine2+Wdot_turbine3+Wdot_turbine4-Wdot_pump1-Wdot_pump2;
% Thermal efficiency
eta=Wdot_cycle/Qdot_in*100

end

