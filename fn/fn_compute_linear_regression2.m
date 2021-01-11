function [X,Y, Linear] = fn_compute_linear_regression2 (X,Y)


Y= zscore(Y);
X=zscore(X);

%% Linear regression
Predictor = [ones(size(X,1),1) X];
[beta,~,~,~,stats]= regress(Y,Predictor);
Rsq = stats(1);  %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
% regression_p=stats(3);
YRegLinear =  beta(1) + beta(2)*X;

%% Computing Root mean square error of both types of fits (linear and logistic)

R2_LinearRegression=fn_rsquare (Y,YRegLinear);

%computing lines
xvec=min(X):0.01:max(X);
YRegLinear_line =  beta(1) + beta(2)*xvec;

Linear.Yfit=YRegLinear;
Linear.FittedCurve=YRegLinear_line;
Linear.R2=R2_LinearRegression;

