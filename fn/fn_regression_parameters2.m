function [beta,Rsq, regression_p,beta_normalized]= fn_regression_parameters2 (FR_TRIAL,Y, num_repeat, fraction_train)

Predictor = [ones(size(FR_TRIAL,2),1) FR_TRIAL'];
% Predictor_normalized = [ones(size(FR_TRIAL,2),1) rescale(FR_TRIAL)'];
Predictor_normalized = [ones(size(FR_TRIAL,2),1) rescale(FR_TRIAL)'];

num_trials=numel(FR_TRIAL);
for i_repeat=1:1:num_repeat
    train_set=randsample(num_trials,round(num_trials*fraction_train));
    train_Y=Y(train_set);
    
    train_Predictor=Predictor(train_set,:);
    %                     [beta(:,i_repeat),stats]= robustfit(train_Predictor,train_Y);
    [beta(:,i_repeat),~,~,~,stats]= regress(train_Y,train_Predictor);
    Rsq(i_repeat) = stats(1);  %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
    regression_p(i_repeat)=stats(3);
    
    train_Predictor_normalized=Predictor_normalized(train_set,:);
    [beta_normalized(:,i_repeat),~,~,~,~]= regress(train_Y,train_Predictor_normalized);
    
    %                     [beta_normalized(:,i_repeat)]= robustfit(train_Predictor_normalized,train_Y);
    
    %                     yCalc1 =  beta(1,i_repeat) + beta(2,i_repeat)*train_Predictor;
    %                     Rsq= 1 - sum((train_Y - yCalc1).^2)/sum((train_Y - mean(train_Y)).^2); %coefficient of determination
end