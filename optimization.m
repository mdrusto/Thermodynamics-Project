% Solver starting point
params0=[260,90,40,0.08,565,500,400];

% Lower bounds
params_lb=[221,10,10,0.08,450,0,0];

% Upper bounds
params_ub=[330,330,330,4,600,600,600];

% Constraints
% TODO

% Run optimization (find maximum efficiency)
fmincon(@eff,params0,A,[0,0,0,0,0,0,0,],[],[],params_lb,params_ub)