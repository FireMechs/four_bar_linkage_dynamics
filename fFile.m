% [-------Eric--ENM221-0068/2017-----------] %
%  inputs for the various lengths
crank = input("Crank?:");
coupler = input("Coupler?:");
follower = input("Follower?:");
fixed_link = input("fixed_link?:");
ww = input("Input angular Velocity:");
anw = input("Input angular acceleration:");

bar_lengths = [crank , coupler, follower , fixed_link];

% apply grashof's theorem
% s and l
l = max(bar_lengths(:));
s = min(bar_lengths(:));

sl = s+l;
% p and q
pq = 0;
for i=1:length(bar_lengths)
    if (bar_lengths(i) ~= s) && (bar_lengths(i) ~= l)
        pq = pq + bar_lengths(i);
    end
end

disp(["Value s+l: ",sl," : p+q: ", pq,"."]);

% [-------Eric--ENM221-0068/2017-----------] %

% Decide of the type of the bar
if sl <= pq
   % double crank and crank rocker mechanism
   % 1st : double crank , parallel
   if (crank == follower)&&(coupler == fixed_link)
       disp("Mechanism = Parallel double crank")
       disp(["crank = follower: ", crank , "=" , follower , "and"]);
       disp(["coupler  = fixed link: ", coupler , "=", fixed_link , "."]);
   elseif s == fixed_link
       disp("Mechanism = drag double crank");
       disp("It's Grashofs");
       disp([" and shortest link is fixed: ", fixed_link,"."]);
   elseif (s == crank)|| (s == follower)
       disp("Mechanism = crank-rocker");
       disp("It's Grashofs");
       disp("Shortest link one of the sides links");
       % If the link is crank-rocker then...
       % using Newton-Raphson method , we can obtain the values of O3 and
       % O4 iteratively for the different values of O2
       % This is used combined with Vector-loop method
           L2 = crank; % crank
           L3  =coupler; % coupler
           L4 = follower; % Follower
           L1 = fixed_link; % Fixed_link
          % counters
           i = 1; j  = 1; k = 1;
           % initial values of O3 and O4
           nr = (1/3)*pi; nf = (7/18)*pi;
           % Data to be plotted in x
           DataO3 = (0:72)*5;
           % DataTO3 = (0:69)*5;
           % arrays for storing the values
% [-------Eric--ENM221-0068/2017-----------] % 
           DataW3(k) = sym(0); DataW4(k)=sym(0); DataA3(k)= sym(0);DataA4(k)= sym(0);
           Datanr(i) = 0; Datanf(j) = 0;
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
            Datanr(i) = rad2deg(nr);
            Datanf(j) = rad2deg(nf);
            i = i + 1; j = j + 1;
            disp("----------------------------------------------");
% [-------Eric--ENM221-0068/2017-----------] %            
            % Velocity Analysis
            w = -1 * L3 * sin(nr);x = L4*sin(nf);y = L3 *cos(nr); 
            z = -1 * L4 * cos(nf);
           
            r = L2 * sin(nw) * ww; t = -1 *L2*cos(nw)*ww; % ww is the  angular velocity of the crank 
            
            %Compute results for wr and wf
            disp("Patience please [let the machine do the job]");
            
            syms wr wf 
            veqn1 = w * wr + x * wf == r;
			veqn2 = y * wf + z * wf == t;
            
            vsol = solve([veqn1, veqn2],[wr,wf]);
            vu = vsol.wr; vh = vsol.wf;
            DataW3(k) = sym(vu); DataW4(k)= sym(vh);
            
            % Acceleration Analysis
            
            aw = -1 * L3 * sin(nr);ax = L4*sin(nf);ay = L3 *cos(nr); 
            az = -1 * L4 * cos(nf);
          
            ar = L2*(sin(nw)*anw + cos(nw)*ww^2) + L3*cos(nr)*vu^2 - L4*cos(nf)*vh^2;% anw is the angular velocity of the crank 
            at = -1 * L2*(cos(nw)*anw - sin(nw)*ww^2) + L3*sin(nr)*vu^2 - L4*sin(nf)*vh^2;
            
            %Compute results for wr and wf
            syms awr awf
            aeqn1 = aw * awr + ax * awf == ar;
			aeqn2 = ay * awr + az * awf == at;
            
            asol = solve([aeqn1,aeqn2],[awr , awf]);
            au = asol.awr; ah = asol.awf;
            DataA3(k) = sym((au/1000)); DataA4(k)=sym((ah/1000));
            k = k + 1;
            
       end
       % clean up duplicates and print out the result
       % Duplicates occur due to memory management. MATLAB can only expand
       % an array dynamically upto 50. After then it deletes and renews it.
       
       % Angular displacement of link 3
       fnr = unique(Datanr, 'stable');
       disp(fnr);
	   % uncomment the lines below to print the data to excel files
       % Dim = size(fnr);
       % Range = ['A1:',strrep([char(64+floor(Dim(2)/26)),char(64+rem(Dim(2),26))],'@',''),num2str(Dim(1))];
       % xlswrite( 'Thita3', fnr, 'sheet1', Range);
       figure('Name','Thita3');
       plot(DataO3,fnr,'-x');
       title("Coupler displacement");
       xlabel("Crank's displacement(deg)");ylabel("Coupler's Displacement");
       disp("---------");
       
       % Angular displacement of link 4
       fnf = unique(Datanf,'stable');
       disp(fnf);
       % Dim = size(fnf);
       % Range = ['A1:',strrep([char(64+floor(Dim(2)/26)),char(64+rem(Dim(2),26))],'@',''),num2str(Dim(1))];
       % xlswrite( 'Thita4', fnf, 'sheet1', Range);
       figure('Name','Thita4');
       plot(DataO3,fnf,'-x');
       title("Follower's displacement");
       xlabel("Crank's displacement(deg)");ylabel("Follower's Displacement");
       disp("---------");
       
       % angular velocity W for link 3
       Double_DataW3 = double(DataW3);
       fV3 = unique(Double_DataW3 , 'stable');
       disp(fV3);
       % Dim = size(fV3);
       % Range = ['A1:',strrep([char(64+floor(Dim(2)/26)),char(64+rem(Dim(2),26))],'@',''),num2str(Dim(1))];
       % xlswrite( 'DataW3', fV3, 'sheet1', Range);
       figure('Name','Angular Velocity 3');
       plot(DataO3,fV3,'-x');
       title("Coupler's Velocity");
       xlabel("Crank's displacement(deg)");ylabel("Coupler's Velocity");
       disp("---------");
       
       % angular velocity W for link 4
       Double_DataW4 = double(DataW4); % convert syms to double for storage
       % fV4 = unique(Double_DataW4 , 'stable');
       disp(Double_DataW4);
       % Dim = size(Double_DataW4);
       % Range = ['A1:',strrep([char(64+floor(Dim(2)/26)),char(64+rem(Dim(2),26))],'@',''),num2str(Dim(1))];
       % xlswrite( 'DataW4', Double_DataW4, 'sheet1', Range);
       figure('Name','Angular Velocity 4');
       plot(DataO3,Double_DataW4,'-x');
       title("Follower's Velocity");
       xlabel("Crank's displacement(deg)");ylabel("Follower's Velocity");
       disp("---------");
       
       % Angular acceleration  A for link 3 
       Double_DataA3 = double(DataA3);
       fA3 = unique(Double_DataA3 , 'stable');
       disp(fA3);
       % Dim = size(fA3);
       % Range = ['A1:',strrep([char(64+floor(Dim(2)/26)),char(64+rem(Dim(2),26))],'@',''),num2str(Dim(1))];
       % xlswrite( 'fA3',fA3, 'sheet1', Range);
       figure('Name','Angular acceleration 3');
       plot(DataO3,fA3,'-x');
       title("Coupler's Acceleration");
       xlabel("Crank's displacement(deg)");ylabel("Coupler's Acceleration");
       disp("---------");
       
       % Angular acceleration A for link 4
       Double_DataA4 = double(DataA4);
       fA4 = unique(Double_DataA4 , 'stable');
       disp(fA4);
       % Dim = size(fA4);
       % Range = ['A1:',strrep([char(64+floor(Dim(2)/26)),char(64+rem(Dim(2),26))],'@',''),num2str(Dim(1))];
       % xlswrite( 'fA4', fA4, 'sheet1', Range);
       figure('Name','Angular acceleration 4');
       plot(DataO3,fA4,'-x');
       title("Follower's Acceleration");
       xlabel("Crank's displacement(deg)");ylabel("Follower's Acceleration");
       
   end
else
   %  double rocker mechanism
   disp("Mechanism is double-rocker");
   disp(["s+l: ", sl , " > ", pq,"."]);
end
% [-------Eric--ENM221-0068/2017-----------] %