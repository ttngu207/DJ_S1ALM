function fn_regression_tongue_singleunit (Y, SPIKES, key,kk, time_window_duration, t_vec, num_repeat, fraction_train, self)

            %removing video outliers
            idx_outlier=isoutlier(Y);
            Y(idx_outlier)=[];
            Y=zscore(Y);
            kk.number_of_trials=numel(Y);
    
            kk.outcome_grouping=key.outcome_grouping;
            kk.time_window_duration=time_window_duration;
            
            
            % computing tuning for various time windows
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+time_window_duration];
            end
            
            for i_twnd=1:numel(t_wnd)
                current_twnd= t_wnd{i_twnd};
                kk.time_window_start=current_twnd(1);
                
                for i_tr=1:1:numel(SPIKES)
                    spk_t=SPIKES(i_tr).spike_times_go;
                    spk(i_tr)=sum(spk_t>current_twnd(1) & spk_t<current_twnd(2));%/diff(t_wnd);
                end
                FR_TRIAL=spk/time_window_duration;
                
                number_of_spikes = sum(spk);
                kk.mean_fr_window=(number_of_spikes/time_window_duration)/numel(SPIKES);
                
                
                %remove video outliers
                FR_TRIAL(idx_outlier)=[];
               

                [beta,Rsq, regression_p,beta_normalized]= fn_regression_parameters (FR_TRIAL,Y, num_repeat, fraction_train);
    
                
                kk.regression_coeff_b1=nanmean(beta(1,:));
                kk.regression_coeff_b2=nanmean(beta(2,:));
                kk.regression_rsq=nanmean(Rsq);
                p= nanmean(regression_p);
                if isnan(p)
                    kk.regression_p=1;
                else
                    kk.regression_p=p;
                end
                kk.regression_coeff_b2_normalized=nanmean(beta_normalized(2,:));
                
                
                
                %                 if isnan(stats(3))
                %                     kk.regression_pvalue=1;
                %                 else
                %                     kk.regression_pvalue=stats(3);
                %                 end
                
                %                 kk.regression_coeff=beta;
                %                                        yCalc1 =  beta(1) + beta(2)*FR_TRIAL';
                %
                %                 b1 = FR_TRIAL'\Y;
                %
                %                yCalc1 = b1*FR_TRIAL';
%                 scatter(FR_TRIAL',Y)
                % hold on
                % plot(FR_TRIAL',yCalc1)
                % xlabel('Population of state')
                % ylabel('Fatal traffic accidents per state')
                % title('Linear Regression Relation Between Accidents & Population')
                % grid on
                
                insert(self,kk)
            end