%  inputs for the various lengths
crank = input("Crank?:");
coupler = input("Coupler?:");
follower = input("Follower?:");
fixed_link = input("fixed_link?:");

bar_lengths = [crank , coupler, follower , fixed_link];

% apply grashof's theorem
% s and l
s = max(bar_lengths(:));
l = min(bar_lengths(:));

sl = s+l;
% p and q
pq = 0;
for i=1:length(bar_lengths)
    if (bar_lengths(i) ~= s) && (bar_lengths(i) ~= l)
        pq = pq + bar_lengths(i);
    end
end

disp(["Value s+l: ",sl," : p+q: ", pq,"."]);

% Decide of the type of the bar
if sl <= pq
   % double crank and crank rocker mechanism
   % 1st : double crank , parallel
   if (crank == follower)&&(coupler == fixed_link)
       disp("Mechanism = Parallel double crank")
       disp(["crank = follower: ", crank , "=" , follower , "and"]);
       disp(["coupler  = fixed link: ", coupler , "=", fixed_link , "."]);
   elseif l == fixed_link
       disp("Mechanism = drag double crank");
       disp("It's Grashofs");
       disp([" and shortest link is fixed: ", fixed_link,"."]);
   elseif (l == crank)|| (l == follower)
       disp("Mechanism = crank-rocker");
       disp("It's Grashofs");
       disp("Shortest link one of the sides links");
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
            disp(["O3 : ",o3 , " | O4: ",o4]);
        end
   end
else
   %  double rocker mechanism
   disp("Mechanism is double-rocker");
   disp(["s+l: ", sl , " > ", pq,"."]);
end