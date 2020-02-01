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
       % If the link is crank-rocker then...
       
           L2 = crank; % crank
           L3  =coupler; % coupler
           L4 = follower; % Follower
           L1 = fixed_link; % Fixed_link
          
       for O2 = 0: ((1/36)*pi) : (2*pi)
           % initial values of O3 and O4
           O3 = (1/90)*pi; O4 = (1/60)*pi;
           while(1)
                % iterative functions
                f1= L2*cos(O2) + L3 * cos(O3) - L4*cos(O4) - L1;
                f2= L2*sin(O2) + L3 * sin(O3) - L4*sin(O4);
                f1f2 = [f1;f2]; % functions matrix
                disp(["O3:",O3," O4:",O4,"f1:",f1," f2:",f2]);
                % check if those functions values are close enough to zero
                temp_f1 = round(f1,5);temp_f2 = round(f2,5);
                if(temp_f1 == 0) || (temp_f2 == 0)
                    disp("----------------------------------");
                    break
                end
                % Jacobian Matrix
                a = -1 * L3 * sin(O3); b = L4 * sin(O4); c = L3*cos(O3);
                d = -1 * L4 * cos(O4);
                Jacobi = [a b;c d];
                CO3O4 = -1*(Jacobi\f1f2);
                % new values of O3 and O4
                O3 =O3 + CO3O4(1);
                O4 =O4 + CO3O4(2);
            end
       end
   end
else
   %  double rocker mechanism
   disp("Mechanism is double-rocker");
   disp(["s+l: ", sl , " > ", pq,"."]);
end