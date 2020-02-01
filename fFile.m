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
          % counters
           i = 1; j  = 1; k = 0;
           % initial values of O3 and O4
           nr = (1/3)*pi; nf = (7/18)*pi;
           % arrays for storing the values
           Datanr(i) = rad2deg(nr); Datanf(j) = rad2deg(nf);
       for nw = 0: ((1/36)*pi): (2*pi)
                % iterative functions
                f_one= L2*cos(nw) + L3 * cos(nr) - L4*cos(nf) - L1;
                f_two= L2*sin(nw) + L3 * sin(nr) - L4*sin(nf);
                % check if those functions values are close enough to zero
                temp_fone = round(f_one,10);temp_ftwo = round(f_two,10);
               
           while((temp_fone ~= 0) || (temp_ftwo ~= 0))
                % Position Analysis
                % iterative functions
                f_one= L2*cos(nw) + L3 * cos(nr) - L4*cos(nf) - L1;
                f_two= L2*sin(nw) + L3 * sin(nr) - L4*sin(nf);
                
                f1f2 = [f_one;f_two]; % functions matrix
                disp(["O3:",nr," O4:",nf,"f1:",f_one," f2:",f_two]);
                
                temp_fone = round(f_one,10);temp_ftwo = round(f_two,10);
                
                % Jacobian Matrix
                a = -1 * L3 * sin(nr); b = L4 * sin(nf); c = L3*cos(nr);
                d = -1 * L4 * cos(nf);
                Jacobi = [a b;c d];
                CO3O4 = -1*(Jacobi\f1f2);
                % new values of O3= nr and O4 = nf
     
                nr =nr + CO3O4(1);
                nf =nf + CO3O4(2);
           end
            disp("----------------------------------------------");
            k = k + 1;
            i = i + 1; j = j + 1;
            Datanr(i) = rad2deg(nr);
            Datanf(j) = rad2deg(nf);
       end
       % clean up duplicates and print out the result
       % Duplicates occur due to memory management of MATLAB
       fnr = unique(Datanr, 'stable');
       disp(fnr);
       disp("---------");
       fnf = unique(Datanf,'stable');
       disp(fnf);
       disp(k);
   end
else
   %  double rocker mechanism
   disp("Mechanism is double-rocker");
   disp(["s+l: ", sl , " > ", pq,"."]);
end