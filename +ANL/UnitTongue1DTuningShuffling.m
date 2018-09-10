%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)             #
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
---
tongue_tuning_1d_si_shuffled                    : longblob              # spatial information, shuffled values
tongue_tuning_1d_si_shuffled_mean=null               : decimal(8,4)          # spatial information, mean shuffled values
%}

classdef UnitTongue1DTuningShuffling < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome="hit" or outcome="all"') * ANL.FlagBasicTrials * (ANL.TongueTuning1DType & 'tuning_param_name="lick_rt_video_onset"');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            kk=key;
            smooth_flag=key.smooth_flag;
            
            if strcmp(key.outcome,'all')
                kk=rmfield(kk,'outcome');
            end
            hist_bins=linspace(0,1,7);
            smooth_bins=3;
            Param = struct2table(fetch (ANL.Parameters,'*'));
            number_of_shuffles = Param.parameter_value{(strcmp('tongue_tuning_number_of_shuffles',Param.parameter_name))};
            
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            end
            
            SPIKES=fetchn(rel_spikes,'spike_times_go','ORDER BY trial');
            
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
            
            
            kk.outcome=key.outcome;
            
            
            Y=TONGUE.lick_horizoffset_relative;
            
%             histogram(Y)
            left_trials=Y<0.5;
            right_trials=Y>=0.5;
            
            % We set a different range for decoding left or right trials. This is to ensure that we don't decode the binary identity of the trial-type (i.e. trial went left, vs trial went right) but the actual offset value on each side
            x_est_range_trials=zeros(size(Y,1),2);
            x_est_range_trials(left_trials,1)=0;
            x_est_range_trials(left_trials,2)=0.5;
            
            x_est_range_trials(right_trials,1)=0.5;
            x_est_range_trials(right_trials,2)=1;
            
            
            t_vec=-2.8:0.2:1;
            t_wind=0.25;
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+t_wind];
                %             t_wnd{end+1}=[0.4,  0.6];
            end
            
            
            
            for i_twnd=1:numel(t_wnd)
                
                kk.time_window_start=t_wnd{i_twnd}(1);
                tongue_tuning_1d_si_shuffled=[];
                
                trials_vec=1:1:size(TONGUE,1);
                
                for i_s=1:1:number_of_shuffles
                    trials_vec_shuffled = trials_vec(randperm(length(trials_vec)));
                    SPIKES_SHUFFLED=SPIKES(trials_vec_shuffled);
                    [tuning1D_shuffled, SI, hist_bins_centers, FR_TRIAL]=  fn_tongue_tuning1D_shuffling (X, SPIKES_SHUFFLED, t_wnd{i_twnd}, hist_bins, min_trials_1D_bin, smooth_bins, labels,smooth_flag);
                    tongue_tuning_1d_si_shuffled(i_s)=SI;
                    
                    
%                     % MLE decoder
%                     fns_tuning=@(x)  interp1(hist_bins_centers,tuning1D_shuffled,x,'linear','extrap');
%                     tol=0.05;
%                     for i_tr=1:1:numel(FR_TRIAL)
%                         fr_tr = FR_TRIAL(i_tr);
%                         mle =@(x) -fr_tr(1)*log(fns_tuning(x))+fns_tuning(x);
%                         mle_real=@(x) real(mle(x)); %debug why this is needed
%                         xest(i_tr) = fminbnd(mle_real,x_est_range_trials(i_tr,1),x_est_range_trials(i_tr,2),optimset('TolX',tol)) ;
%                         %                     xest(i_tr) = fminbnd(mle,0,1,optimset('TolX',tol)) ;
%                     end
%                     ml_error_left(i_s)=nanmean(abs(X(left_trials)-xest(left_trials)'));
%                     ml_error_right(i_s)=nanmean(abs(X(right_trials)-xest(right_trials)'));
                    
                end
                kk.tongue_tuning_1d_si_shuffled=tongue_tuning_1d_si_shuffled;
                kk.tongue_tuning_1d_si_shuffled_mean=nanmean(tongue_tuning_1d_si_shuffled);
                
%                 kk.ml_error_left_shuffled=ml_error_left;
%                 kk.ml_error_left_shuffled_mean=nanmean(ml_error_left);
%                 kk.ml_error_right_shuffled=ml_error_right;
%                 kk.ml_error_right_shuffled_mean=nanmean(ml_error_right);
                
                
                insert(self,kk)
            end
            
            
            
        end
    end
    
end


