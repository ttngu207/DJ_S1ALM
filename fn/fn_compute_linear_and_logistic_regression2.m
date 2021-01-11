function [X,Y, Linear, Logistic, RMSE_mean, RMSE_mean_left_right] = fn_compute_linear_and_logistic_regression2 (X,Y,idx_lick_direction)


Y= rescale(Y);
X=rescale(X,-1,1);

%% Linear regression
Predictor = [ones(size(X,1),1) X];
[beta,~,~,~,stats]= regress(Y,Predictor);
Rsq = stats(1);  %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
% regression_p=stats(3);
YRegLinear =  beta(1) + beta(2)*X;



%% Logistic regression (fitting a logistic function) with 3 parameters (the other are fixed)
%---------------------------------------------------------------------------------------
logisticfunc = @(A, x) ( (A(1) ./ (1 + exp(-1000*(x-A(3)) ))) +A(2)); %Logistic function
% Initial values fed into the iterative algorithm
A0(1) = 0.5; % Stretch in Y
A0(2)=0.2;   %  baseline
A0(3)=0;   %  Y-intersection



% %% Logistic regression (fitting a logistic function) with 4 parameters
% %---------------------------------------------------------------------------------------
% logisticfunc = @(A, x) ( (A(1) ./ (1 + exp(-A(3)*(x-A(4)) ))) +A(2)); %Logistic function
% % Initial values fed into the iterative algorithm
% A0(1) = 1; % Stretch in Y
% A0(2)=0;   %  baseline
% A0(3)=100; % slope
% A0(4)=0;   % Y intersection


% opts = statset('nlinfit');
% opts.RobustWgtFun = 'bisquare';
A_fit = nlinfit(X, Y, logisticfunc, A0);
YLogisticRegFit= logisticfunc(A_fit,X);


%% Computing Root mean square error of both types of fits (linear and logistic)


R2_LinearRegression=fn_rsquare (Y,YRegLinear);
R2_LogisticRegression=fn_rsquare (Y,YLogisticRegFit);

%computing lines
xvec=min(X):0.01:max(X);
YRegLinear_line =  beta(1) + beta(2)*xvec;
YLogisticRegFit_line =  logisticfunc(A_fit,xvec);

Linear.Yfit=YRegLinear;
Linear.FittedCurve=YRegLinear_line;
Linear.R2=R2_LinearRegression;
Linear.RMSE = sqrt(mean((Y - YRegLinear).^2));  % Root Mean Squared Error

Logistic.Yfit=YLogisticRegFit;
Logistic.FittedCurve=YLogisticRegFit_line;
Logistic.R2=R2_LogisticRegression;
Logistic.RMSE = sqrt(mean((Y - YLogisticRegFit).^2));  % Root Mean Squared Error

RMSE_mean = sqrt(mean((Y - mean(Y)).^2));  % Root Mean Squared Error - assuming just the average of the distribution

% separately for left,right direction
mean1=mean(Y(idx_lick_direction==1));
mean2=mean(Y(idx_lick_direction==0));

left_right_mean= zeros(size(Y));
left_right_mean(idx_lick_direction==1)=mean1;
left_right_mean(idx_lick_direction==0)=mean2;

RMSE_mean_left_right = sqrt(mean((Y - left_right_mean).^2));  % Root Mean Squared Error - assuming just the average of the distribution

