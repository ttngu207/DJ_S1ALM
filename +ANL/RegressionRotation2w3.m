%{
#
-> EXP.Session
-> EPHYS.CellType
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
---
regress_b2_mat                          : longblob                  # matrix of the regression coefficient for different units at different times along the trial
regress_b2_mat_corr                     : longblob                  # corelation matrix of the above parameter
regress_rsq_mat                          : longblob                  # matrix of the regression rsquare for different units at different times along the trial
regress_rsq_mat_corr                     : longblob                  # corelation matrix of the above parameter
regress_weights_mat                          : longblob                  # matrix of the regressio weights defined as beta x rsquare
regress_weight_corr                     : longblob                  # corelation matrix of the above parameter
regress_weights2_mat                          : longblob                  # matrix of the regressio weights defined as beta x surprise
regress_weight2_corr                     : longblob                  # corelation matrix of the above parameter


regress_mat_timebin_vector                     : longblob                  # time bin vector corresponding to bin centers of the regress_mat_t_weights
%}


classdef RegressionRotation2w3 < dj.Computed
    properties
        keySource = (EXP.Session & ANL.RegressionTongueSingleUnit2) * (EPHYS.CellType & 'cell_type="PYR" or cell_type="FS" or cell_type="all"')   * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * (ANL.LickDirectionType);
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
            dir_save_figure = [dir_root 'Results\video_tracking\analysis\regression_rotation2_w3\' key.tuning_param_name	'\' key.lick_direction '\'];
            
            
            kk=key;
            if strcmp(kk.cell_type,'all')
                kk=rmfield(kk,'cell_type');
            end
            tic
            
            
            time_vector=fetchn(ANL.RegressionTime2,'regression_time_start','ORDER BY regression_time_start');
            
            rel=ANL.RegressionTongueSingleUnit2*EPHYS.UnitCellType & kk;
            
            if rel.count==0
                return
            end
            
            for it=1:1:numel(time_vector)
                k_time.regression_time_start = time_vector (it);
                regression_coeff_b2_normalized(:,it) =fetchn(rel & k_time,'regression_coeff_b2_normalized','ORDER BY unit');
                regression_coeff_b2(:,it) =fetchn(rel & k_time,'regression_coeff_b2','ORDER BY unit');
                regression_rsq(:,it) =fetchn(rel & k_time,'regression_rsq','ORDER BY unit');
                unit(:,it) =fetchn(rel & k_time,'unit','ORDER BY unit');
                regression_p(:,it) =fetchn(rel & k_time,'regression_p','ORDER BY unit');
                
                
            end
            num_units=size(regression_coeff_b2_normalized,1);
            
            if num_units<2
                return
            end
            
            regression_p=-log10(regression_p+eps);
            
            regression_weight=regression_coeff_b2_normalized.*regression_rsq;
            regression_weight2=regression_coeff_b2_normalized.*regression_p;
            
            colormap(jet);
            
            figure;
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);
            
            panel_width1=0.12;
            panel_height1=0.4;
            horizontal_distance1=0.16;
            vertical_distance1=0.45;
            
            position_x1(1)=0.06;
            position_x1(2)=position_x1(1)+horizontal_distance1;
            position_x1(3)=position_x1(2)+horizontal_distance1;
            position_x1(4)=position_x1(3)+horizontal_distance1;
            position_x1(5)=position_x1(4)+horizontal_distance1;
            position_x1(6)=position_x1(5)+horizontal_distance1;
            
            
            position_y1(1)=0.5;
            position_y1(2)=position_y1(1)-vertical_distance1;
            
            
            
            
            
            axes('position',[position_x1(1), position_y1(1), panel_width1, panel_height1]);
            
            imagescnan(time_vector,1:1:num_units , regression_coeff_b2)
            colorbar ('Location','southoutside')
            title('beta')
            ylabel('Unit #');
            xlabel('Time (s)');
            
            axes('position',[position_x1(2), position_y1(1), panel_width1, panel_height1]);
            imagescnan(time_vector,1:1:num_units,regression_coeff_b2_normalized)
            colorbar ('Location','southoutside')
            title('beta normalized')
            xlabel('Time (s)');
            
            axes('position',[position_x1(3), position_y1(1), panel_width1, panel_height1]);
            imagescnan(time_vector,1:1:num_units ,regression_rsq)
            colorbar ('Location','southoutside')
            title('R^2')
            xlabel('Time (s)');
            
            axes('position',[position_x1(4), position_y1(1), panel_width1, panel_height1]);
            imagescnan(time_vector,1:1:num_units ,regression_p)
            caxis([-log10(0.05) -log10(0.001)])
            colorbar ('Location','southoutside')
            title(sprintf('surprise \n-log10 (p-value)'))
            xlabel('Time (s)');
            
            axes('position',[position_x1(5), position_y1(1), panel_width1, panel_height1]);
            imagescnan(time_vector,1:1:num_units ,regression_weight)
            %                         caxis([-log10(0.05) -log10(0.001)])
            %             colormap(redblue)
            colorbar ('Location','southoutside')
            title(sprintf('Weights\n betanorm X R^2'));
            xlabel('Time (s)');
            
            axes('position',[position_x1(6), position_y1(1), panel_width1, panel_height1]);
            imagescnan(time_vector,1:1:num_units ,regression_weight2)
            %                         caxis([-log10(0.05) -log10(0.001)])
            %             colormap(redblue)
            colorbar ('Location','southoutside')
            title(sprintf('Weights\n beta norm X surprise'));
            xlabel('Time (s)');
            
            
            
            r_beta = corr(regression_coeff_b2,'rows','Pairwise');
            r_beta_normalized = corr(regression_coeff_b2_normalized,'rows','Pairwise');
            
            r_rsq= corr(regression_rsq,'rows','Pairwise');
            r_p= corr(regression_p,'rows','Pairwise');
            r_weight= corr(regression_weight,'rows','Pairwise');
            r_weight2= corr(regression_weight2,'rows','Pairwise');
            
            blank=diag(ones(size(r_beta,1),1)'+NaN);
            
            
            axes('position',[position_x1(1), position_y1(2), panel_width1, panel_height1]);
            imagescnan(time_vector,time_vector,r_beta+blank)
            colorbar ('Location','southoutside')
            xlabel('Time (s)');
            ylabel('Time (s)');
            title('correlation');
            axis equal;
            axis tight
            
            axes('position',[position_x1(2), position_y1(2), panel_width1, panel_height1]);
            imagescnan(time_vector,time_vector,r_beta_normalized+blank)
            colorbar ('Location','southoutside')
            xlabel('Time (s)');
            ylabel('Time (s)');
            title('correlation');
            axis equal;
            axis tight
            
            axes('position',[position_x1(3), position_y1(2), panel_width1, panel_height1]);
            imagescnan(time_vector,time_vector,r_rsq+blank)
            colorbar ('Location','southoutside')
            xlabel('Time (s)');
            ylabel('Time (s)');
            title('correlation');
            axis equal;
            axis tight
            
            axes('position',[position_x1(4), position_y1(2), panel_width1, panel_height1]);
            imagescnan(time_vector,time_vector,r_p+blank)
            colorbar ('Location','southoutside')
            xlabel('Time (s)');
            ylabel('Time (s)');
            title('correlation');
            axis equal;
            axis tight
            
            axes('position',[position_x1(5), position_y1(2), panel_width1, panel_height1]);
            imagescnan(time_vector,time_vector,r_weight+blank)
            colorbar ('Location','southoutside')
            xlabel('Time (s)');
            ylabel('Time (s)');
            title('correlation');
            axis equal;
            axis tight
            
            axes('position',[position_x1(6), position_y1(2), panel_width1, panel_height1]);
            imagescnan(time_vector,time_vector,r_weight2+blank)
            colorbar ('Location','southoutside')
            xlabel('Time (s)');
            ylabel('Time (s)');
            title('correlation');
            axis equal;
            axis tight
            
            key.regress_b2_mat=regression_coeff_b2;
            key.regress_b2_mat_corr=r_beta;
            
            key.regress_rsq_mat=regression_rsq;
            key.regress_rsq_mat_corr=r_rsq;
            
            key.regress_weights_mat=regression_weight;
            key.regress_weight_corr=r_weight;
            
            key.regress_weights2_mat=regression_weight2;
            key.regress_weight2_corr=r_weight2;
            
            key.regress_mat_timebin_vector=time_vector;
            insert(self,key);
            toc
            
            
            if strcmp(key.cell_type,'all')
                details=fetch(ANL.SessionPosition*EXP.SessionID &key,'*');
                if isempty(dir(dir_save_figure))
                    mkdir (dir_save_figure)
                end
                if strcmp(details.brain_area,'ALM')
                    filename=['tongue_regression_' num2str(details.session_uid) '_' details.hemisphere ''];
                    figure_name_out=[ dir_save_figure filename];
                    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
                end
            end
            
            close;
            
        end
        
    end
end