%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)              #
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
---
tongue_ml_error_left                            : blob                      #
tongue_ml_error_right                           : blob                      #
%}

classdef UnitTongue1DTuningML < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType &  'tuning_param_name="lick_horizoffset_relative"');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            plot_flag=0;
            tol=0.01;

            kk=key;
            smooth_flag=key.smooth_flag;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
            
            hist_bins=linspace(0,1,7);
            smooth_bins=3;
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            end

            SPIKES=fetch(rel_spikes,'*','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel_video=(ANL.Video1stLickTrialNormalized & kk & rel_spikes);
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            number_of_trials=size(TONGUE,1);
            
            if number_of_trials<10
                return
            end
                        
            VariableNames=TONGUE.Properties.VariableNames';
            var_table_offset=5;
            VariableNames=VariableNames(var_table_offset:18);
            
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            X=TONGUE{:,idx_v_name+var_table_offset-1};
            
            labels=VariableNames{idx_v_name};
            
            kk.outcome_grouping=key.outcome_grouping;

            Y=TONGUE.lick_horizoffset_relative;
%             histogram(Y)
            left_trials=Y<0.5;
            right_trials=Y>=0.5;
            
            if strcmp(kk.tuning_param_name,'lick_horizoffset_relative')
                % We set a different range for decoding left or right trials. This is to ensure that we don't decode the binary identity of the trial-type (i.e. trial went left, vs trial went right) but the actual offset value on each side
                x_est_range_trials=zeros(size(Y,1),2);
                x_est_range_trials(left_trials,1)=0;
                x_est_range_trials(left_trials,2)=0.5;
                
                x_est_range_trials(right_trials,1)=0.5;
                x_est_range_trials(right_trials,2)=1;
            else
                x_est_range_trials=zeros(size(Y,1),2);
                x_est_range_trials(:,1)=0;
                x_est_range_trials(:,2)=1;
            end

            t_vec=-3:0.2:2;
            t_wind=0.5;
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+t_wind];
                %             t_wnd{end+1}=[0.4,  0.6];
            end
            
            for i_twnd=1:numel(t_wnd)
                
                %% computing tuning curve and SI
                [tongue_tuning_1d, hist_bins_centers, ~, ~, ~, ~, ~, FR_TRIAL]= ...
                    fn_tongue_tuning1D (X, SPIKES, t_wnd{i_twnd}, hist_bins, min_trials_1D_bin, smooth_bins, labels,smooth_flag, plot_flag);
                kk.time_window_start=t_wnd{i_twnd}(1);
                % MLE decoder
                xest=[];
                fns_tuning=@(x)  interp1(hist_bins_centers,tongue_tuning_1d,x,'linear','extrap');
                for i_tr=1:1:numel(FR_TRIAL)
                    fr_tr = FR_TRIAL(i_tr);
%                   mle =@(x) -(fr_tr*log(fns_tuning(x))-fns_tuning(x)); % we add a minus sign because we want to find the minumum of this function
                    mle =@(x) real(-(fr_tr*log(fns_tuning(x))-fns_tuning(x))); % we add a minus sign because we want to find the minumum of this function
                    xest(i_tr) = fminbnd(mle,x_est_range_trials(i_tr,1),x_est_range_trials(i_tr,2),optimset('TolX',tol)) ;
                    % !!! debug why sometimes (very rarely ) during the fminbnd search the output of mle function is complex - which is why I added "real" to mle function
%                     xest(i_tr) = fminbnd(mle,0,1,optimset('TolX',tol)) ;
                end
                kk.tongue_ml_error_left=nanmean(abs(X(left_trials)-xest(left_trials)'));
                kk.tongue_ml_error_right=nanmean(abs(X(right_trials)-xest(right_trials)'));
                insert(self,kk);
            end
            
            
            
        end
    end
    
end


