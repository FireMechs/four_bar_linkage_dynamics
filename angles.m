crank = 50;
coupler = 200;
follower = 150;
fixed_link = 205;

% thita 4 - angular displacement 
for BAD = 0: 5 : 360
    BD = sqrt((crank^2 + fixed_link^2)-(2*crank*follower*cosd(BAD)));
    ABD = acosd((BD^2 + crank^2 -fixed_link^2 )/(2 * BD * crank));
    ADB = 180 - (ABD + BAD);
    BCD = acosd((coupler^2 + follower^2 - BD^2)/(2*coupler*follower));
    BDC = acosd((BD^2 + follower^2 - coupler^2)/(2*BD*follower));
    ADC = ADB + BDC;
    CBD = 180-(BDC + BCD);
    o4 = 180 - (ADC);
    o3 = 180 - (ADC + BCD);
    % simulating the mechanism
    % The follower do not rotate fully
    plot([0 crank*cos(BAD)], [0 crank*sin(BAD)],'ro-');hold on;
    plot([crank*cos(BAD) crank*cos(BAD)+coupler*cos(o3)], [crank*sin(BAD) crank*sin(BAD)+coupler*sin(o3)], 'ro-'); hold on;
    plot([0 fixed_link], [0 0], 'ro-'); hold on;
    plot([fixed_link crank*cos(BAD)+coupler*cos(o3)], [0 crank*sin(BAD)+coupler*sin(o3)], 'ro-');hold off;
    axis([-100 250 -150 300]);
    pause(0.1);
    % disp(["O3 : ",o3 , " | O4: ",o4]);
end