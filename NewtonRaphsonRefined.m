% Newton-Raphson is a numerical method for solving non-linear algebraic
% equations. The method is based on linearizing non linear equation(s)
% using taylor series , then solving linear equations iteratively.

% --- This example is base on a four bar chain 
L2 = 2; % crank
L3  =6; % coupler
L4 = 4; % Follower
L1 = 5; % Fixed_link

O2 = (2/3)*pi; % initial value of O2 120 deg

% initial values of O3 and O4
O3 = (1/6)*pi; O4 = (1/2)*pi;

while(1)
    % iterative functions
    f1= L2*cos(O2) + L3 * cos(O3) - L4*cos(O4) - L1;
    f2= L2*sin(O2) + L3 * sin(O3) - L4*sin(O4);
    f1f2 = [f1;f2]; % functions matrix
    disp(["O3:",O3," O4:",O4,"f1:",f1," f2:",f2]);
    % check if those functions values are close enough to zero
    temp_f1 = round(f1,3);temp_f2 = round(f2,3);
    if(temp_f1 == 0) || (temp_f2 == 0)
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