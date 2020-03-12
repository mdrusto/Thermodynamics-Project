function [] = thermo_graphs(p,T,v,h,s)

hold on

% Plot T-s diagram
figure(1)
Trange=linspace(0,373.93);
sLrange=XSteam_array('sL_T',Trange);
sVrange=XSteam_array('sV_T',Trange);
plot([sLrange sVrange],[Trange Trange],'k');
xlabel('Specific Entropy (kJ/kg*K)');
ylabel('Temperature (degrees C)');
scatter(s,T);
xlim([-0.4,10]);
ylim([-20,620]);
title('T-s diagram');
stext=s-0.4;
Ttext=T+20;
if size(p,1)==5
    Ttext(3)=Ttext(3)-10;
    stext(4)=stext(4)+0.2;
    Ttext(4)=Ttext(4)+10;
elseif size(p,1)==14
    Ttext(7)=Ttext(7)-10;
    stext(8)=stext(8)+0.2;
    Ttext(8)=Ttext(8)+10;
    Ttext(9)=Ttext(9)-10;
    stext(10)=stext(10)+0.2;
    Ttext(10)=Ttext(10)+10;
elseif size(p,1)==7
    Ttext(5)=Ttext(5)-10;
    stext(6)=stext(6)+0.2;
    Ttext(6)=Ttext(6)+10;
elseif size(p,1)==9
    Ttext(7)=Ttext(7)-10;
    stext(8)=stext(8)+0.2;
    Ttext(8)=Ttext(8)+10;
end
text(stext,Ttext,cellstr(num2str((1:size(s,1))')));

if size(p,1)==5 % Concept A
    
    p1_2s=linspace(s(1),s(2));
    p1_2T=linspace(T(1),T(2));
    plot(p1_2s,p1_2T,'--m');
    
    p2_3s=linspace(s(2),s(3));
    p2_3T=linspace(T(2),T(3));
    plot(p2_3s,p2_3T,'-m');
    
    p3_4s=linspace(s(3),s(4));
    p3_4T=linspace(T(3),T(4));
    plot(p3_4s,p3_4T,'-m');
    
    p4_5s=linspace(s(4),s(5));
    p4_5T=XSteam_array('T_ps',p(4)*ones(size(p4_5s,1),size(p4_5s,2)),p4_5s);
    plot(p4_5s,p4_5T,'-m');
    
    p5_1s=linspace(s(5),XSteam('sL_p',p(5)));
    p5_1T=XSteam_array('T_ps',p(5)*ones(size(p5_1s,1),size(p5_1s,2)),p5_1s);
    p5_1s_sat=linspace(XSteam('sL_p',p(5)),s(1));
    plot(p5_1s,p5_1T,'-m');
    plot(p5_1s_sat,XSteam('TSat_p',p(1))*ones(size(p5_1s_sat,1),size(p5_1s_sat,2)),'-m');
    
elseif size(p,1)==12 % Concept B
    
    p1_2s=linspace(s(1),s(2));
    p1_2T=linspace(T(1),T(2));
    plot(p1_2s,p1_2T,'--m');
    
    p2_3s=linspace(s(2),s(3));
    p2_3T=linspace(T(2),T(3));
    plot(p2_3s,p2_3T,'--m');
    
    p3_7s=linspace(s(3),XSteam('sV_p',p(3)));
    p3_7T=XSteam_array('T_ps',p(3)*ones(size(p3_7s,1),size(p3_7s,2)),p3_7s);
    p3_7s_sat=linspace(XSteam('sV_p',p(3)),XSteam('sL_p',p(7)));
    plot(p3_7s,p3_7T,'-m');
    plot(p3_7s_sat,XSteam('TSat_p',p(3))*ones(size(p3_7s_sat,1),size(p3_7s_sat,2)),'-m');
    
    p3_4s=linspace(s(3),s(4));
    p3_4T=linspace(T(3),T(4));
    plot(p3_4s,p3_4T,'--m');
    
    p4_5s=linspace(s(4),s(5));
    plot(p4_5s,XSteam('TSat_p',p(4))*ones(size(p4_5s,1),size(p4_5s,2)),'-m');
    
    p5_6s=linspace(s(5),s(6));
    p5_6T=linspace(T(5),T(6));
    plot(p5_6s,p5_6T,'--m');
    
    p6_7s=linspace(s(6),s(7));
    p6_7T=XSteam_array('T_ps',p(6)*ones(size(p6_7s,1),size(p6_7s,2)),p6_7s);
    plot(p6_7s,p6_7T,'-m');
    
    p7_8s=linspace(s(7),s(8));
    p7_8T=linspace(T(7),T(8));
    plot(p7_8s,p7_8T,'-m');
    
    p8_9s=linspace(s(8),s(9));
    p8_9T=XSteam_array('T_ps',p(8)*ones(size(p8_9s,1),size(p8_9s,2)),p8_9s);
    plot(p8_9s,p8_9T,'-m');
    
    p9_10s=linspace(s(9),s(10));
    p9_10T=XSteam_array('T_ps',p(9)*ones(size(p9_10s,1),size(p9_10s,2)),p9_10s);
    plot(p9_10s,p9_10T,'-m');
    
    p12_1s=linspace(s(12),s(1));
    p12_1T=XSteam_array('T_ps',p(12)*ones(size(p12_1s,1),size(p12_1s,2)),p12_1s);
    plot(p12_1s,p12_1T,'-m');
    
    p2_11s=linspace(s(2),XSteam('sV_p',p(2)));
    p2_11T=XSteam_array('T_ps',p(2)*ones(size(p2_11s,1),size(p2_11s,2)),p2_11s);
    p2_11s_sat=linspace(XSteam('sV_p',p(2)),XSteam('sL_p',p(2)));
    plot(p2_11s,p2_11T,'-m');
    plot(p2_11s_sat,XSteam('TSat_p',p(2))*ones(size(p2_11s_sat,1),size(p2_11s_sat,2)),'-m');
    
    p11_12s=linspace(s(11),s(12));
    p11_12T=linspace(T(11),T(12));
    plot(p11_12s,p11_12T,'-m');
    
elseif size(p,1)==7 % Concept C
    
    p1_2s=linspace(s(1),s(2));
    p1_2T=linspace(T(1),T(2));
    plot(p1_2s,p1_2T,'--m');
    
    p2_3s=linspace(s(2),s(3));
    p2_3T=XSteam_array('T_ps',p(2)*ones(size(p2_3s,1),size(p2_3s,2)),p2_3s);
    plot(p2_3s,p2_3T,'-m');
    
    p3_4s=linspace(s(3),s(4));
    p3_4T=linspace(T(3),T(4));
    plot(p3_4s,p3_4T,'--m');
    
    p4_5s=linspace(s(4),s(5));
    p4_5T=linspace(T(4),T(5));
    plot(p4_5s,p4_5T,'-m');
    
    p5_6s=linspace(s(5),s(6));
    p5_6T=linspace(T(5),T(6));
    plot(p5_6s,p5_6T,'-m');
    
    p6_7s=linspace(s(6),s(7));
    p6_7T=XSteam_array('T_ps',p(6)*ones(size(p6_7s,1),size(p6_7s,2)),p6_7s);
    plot(p6_7s,p6_7T,'-m');
    
    p7_1s=linspace(s(7),s(1));
    p7_1T=XSteam_array('T_ps',p(7)*ones(size(p7_1s,1),size(p7_1s,2)),p7_1s);
    plot(p7_1s,p7_1T,'-m');
    
elseif size(p,1)==9 % Concept D
    
    p1_2s=linspace(s(1),s(2));
    p1_2T=linspace(T(1),T(2));
    plot(p1_2s,p1_2T,'--m');
    
    p2_3s=linspace(s(2),s(3));
    p2_3T=XSteam_array('T_ps',p(2)*ones(size(p2_3s,1),size(p2_3s,2)),p2_3s);
    plot(p2_3s,p2_3T,'-m');
    
    p3_4s=linspace(s(3),s(4));
    p3_4T=linspace(T(3),T(4));
    plot(p3_4s,p3_4T,'--m');
    
    p4_5s=linspace(s(4),s(5));
    p4_5T=XSteam_array('T_ps',p(4)*ones(size(p4_5s,1),size(p4_5s,2)),p4_5s);
    plot(p4_5s,p4_5T,'-m');
    
    p5_6s=linspace(s(5),s(6));
    p5_6T=linspace(T(5),T(6));
    plot(p5_6s,p5_6T,'--m');
    
    p6_7s=linspace(s(6),s(7));
    if h(6)>XSteam('hV_p',p(6))
        p6_7T=XSteam_array('T_ps',p(6)*ones(size(p6_7s,1),size(p6_7s,2)),p6_7s);
        plot(p6_7s,p6_7T,'-m');
        p6_7s_sat=linspace(XSteam('sV_p',p(6)),XSteam('sL_p',p(6)));
        plot(p6_7s_sat,T(7)*ones(size(p6_7s_sat,1),size(p6_7s_sat,2)),'-m');
    else
        plot(p6_7s,XSteam('TSat_p',p(6))*ones(size(p6_7s,1),size(p6_7s,2)),'-m');
    end
    
    p7_8s=linspace(s(7),s(8));
    p7_8T=linspace(T(7),T(8));
    plot(p7_8s,p7_8T,'-m');
    
    p8_9s=linspace(s(8),s(9));
    p8_9T=XSteam_array('T_ps',p(8)*ones(size(p8_9s,1),size(p8_9s,2)),p8_9s);
    plot(p8_9s,p8_9T,'-m');
    
    p9_1s=linspace(s(9),s(1));
    p9_1T=XSteam_array('T_ps',p(9)*ones(size(p9_1s,1),size(p9_1s,2)),p9_1s);
    plot(p9_1s,p9_1T,'-m');
    
elseif size(p,1)==8 % Concept E
    
elseif size(p,1)==14 % Concept F
    p1_2s=linspace(s(1),s(2));
    p1_2T=linspace(T(1),T(2));
    plot(p1_2s,p1_2T,'--m');
    
    p2_3s=linspace(s(2),s(3));
    p2_3T=linspace(T(2),T(3));
    plot(p2_3s,p2_3T,'--m');
    
    p3_4s=linspace(s(3),s(4));
    p3_4T=XSteam_array('T_ps',p(3)*ones(size(p3_4s,1),size(p3_4s,2)),p3_4s);
    plot(p3_4s,p3_4T,'-m');
    
    p4_5s=linspace(s(4),s(5));
    p4_5T=linspace(T(4),T(5));
    plot(p4_5s,p4_5T,'--m');
    
    p5_9s=linspace(s(5),XSteam('sV_p',p(5)));
    p5_9T=XSteam_array('T_ps',p(5)*ones(size(p5_9s,1),size(p5_9s,2)),p5_9s);
    p5_9s_sat=linspace(XSteam('sV_p',p(5)),XSteam('sL_p',p(9)));
    plot(p5_9s,p5_9T,'-m');
    plot(p5_9s_sat,XSteam('TSat_p',p(5))*ones(size(p5_9s_sat,1),size(p5_9s_sat,2)),'-m');
    
    p5_6s=linspace(s(5),s(6));
    p5_6T=linspace(T(5),T(6));
    plot(p5_6s,p5_6T,'--m');
    
    p6_7s=linspace(s(6),s(7));
    if h(6)>XSteam('hV_p',p(6))
        p6_7T=XSteam_array('T_ps',p(6)*ones(size(p6_7s,1),size(p6_7s,2)),p6_7s);
        plot(p6_7s,p6_7T,'-m');
        p6_7s_sat=linspace(XSteam('sV_p',p(6)),XSteam('sL_p',p(6)));
        plot(p6_7s_sat,T(7)*ones(size(p6_7s_sat,1),size(p6_7s_sat,2)),'-m');
    else
        plot(p6_7s,XSteam('TSat_p',p(6))*ones(size(p6_7s,1),size(p6_7s,2)),'-m');
    end
    
    p7_8s=linspace(s(7),s(8));
    p7_8T=linspace(T(7),T(8));
    plot(p7_8s,p7_8T,'-m');
    
    p8_9s=linspace(s(8),s(9));
    p8_9T=XSteam_array('T_ps',p(8)*ones(size(p8_9s,1),size(p8_9s,2)),p8_9s);
    plot(p8_9s,p8_9T,'-m');
    
    p9_10s=linspace(s(9),s(10));
    p9_10T=linspace(T(9),T(10));
    plot(p9_10s,p9_10T,'-m');
    
    p10_11s=linspace(s(10),s(11));
    p10_11T=XSteam_array('T_ps',p(10)*ones(size(p10_11s,1),size(p10_11s,2)),p10_11s);
    plot(p10_11s,p10_11T,'-m');
    
    p11_12s=linspace(s(11),s(12));
    p11_12T=XSteam_array('T_ps',p(11)*ones(size(p11_12s,1),size(p11_12s,2)),p11_12s);
    plot(p11_12s,p11_12T,'-m');
    
    p12_1s=linspace(s(12),s(1));
    p12_1T=XSteam_array('T_ps',p(12)*ones(size(p12_1s,1),size(p12_1s,2)),p12_1s);
    plot(p12_1s,p12_1T,'-m');
    
    p2_13s=linspace(s(2),XSteam('sV_p',p(2)));
    p2_13T=XSteam_array('T_ps',p(2)*ones(size(p2_13s,1),size(p2_13s,2)),p2_13s);
    p2_13s_sat=linspace(XSteam('sV_p',p(2)),XSteam('sL_p',p(2)));
    plot(p2_13s,p2_13T,'-m');
    plot(p2_13s_sat,XSteam('TSat_p',p(2))*ones(size(p2_13s_sat,1),size(p2_13s_sat,2)),'-m');
    
    p13_14s=linspace(s(13),s(14));
    p13_14T=linspace(T(13),T(14));
    plot(p13_14s,p13_14T,'-m');
    
end
end

function [data_out] = XSteam_array(func,data_in1,data_in2)
data_out=zeros(1,size(data_in1,2));
if nargin==3
    for i=1:size(data_in1,1)
        for j=1:size(data_in1,2)
            data_out(i,j)=XSteam(func,data_in1(i,j),data_in2(i,j));
        end
    end
elseif nargin==2
    for i=1:size(data_in1,1)
        for j=1:size(data_in1,2)
            data_out(i,j)=XSteam(func,data_in1(i,j));
        end
    end
end
end