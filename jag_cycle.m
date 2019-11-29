function [] = jag_cycle(p_boiler,p_cond,T_max,mdot)

h=zeros(5,1);

h(1)=XSteam('h_pT',p_boiler,T_max);

h(2)=h(1)-(h(1)-XSteam('h_ps',p_cond,XSteam('s_pT',p_boiler,T_max)))*0.8;

h(3)=XSteam('hL_p',p_cond);

h(4)=XSteam('h_ps',p_boiler,XSteam('sL_p',p_cond));

h(5)=120*0.65*(XSteam('Cp_pT',14.35,180)*180-XSteam('Cp_pT',14.35,107.5)*107.5)/mdot+h(4);

Wdot_cycle=h(1)-h(2)-h(4)-h(3)

eta=Wdot_cycle/(h(1)-h(4))

end

