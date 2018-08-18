%{
#
-> EXP.Session
-> EXP.Outcome
-> EXP.TrialInstruction
-> EPHYS.UnitQualityType
-> EPHYS.CellType
flag_include_distractor_trials        : smallint      # 0 - no distractor trials included, 1 - distractor trials are included
time_interval_correlation_st          : smallint           # time interval (start) (relative to go cue) for computing the correlation
time_interval_correlation_end         : smallint           # time interval (end) (relative to go cue) for computing the correlation
---
cov_matrix                            : longblob           # covariance matrix
corr_matrix                           : longblob           # correlation matrix
smooth_time_noise_correlation         : double             # smooth time for correlations
time_interval_correlation_description : varchar(4000)      # description of the time interval used to compute correlations
unit_num_noise_correlation            : longblob           # unit num in the noise correlation matrix
%}


classdef NoiseCorrelation2 < dj.Computed
    properties
        keySource = (EXP.Session & EPHYS.TrialSpikes) * (EXP.Outcome) * EXP.TrialInstruction * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"')
%             keySource = (EXP.Session & EPHYS.TrialSpikes) * (EXP.Outcome & 'outcome="miss"') * EXP.TrialInstruction * (EPHYS.CellType & 'cell_type="FS"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"')

    end
    methods(Access=protected)
        function makeTuples(self, key)
            key.smooth_time_noise_correlation=0.01;
            
            time_interval(1).it=[-4 -3];
            time_interval(1).label='pre-sample';
            %             time_interval(end+1).it=[-3 -2];
            %             time_interval(end).label='sample';
            time_interval(end+1).it=[-2 0];
            time_interval(end).label='delay';
            %             time_interval(end+1).it=[0 2];
            %             time_interval(end).label='response';
            tic
            
            for i = 1:1: numel(time_interval)
                key.time_interval_correlation_st = time_interval(i).it(1);
                key.time_interval_correlation_end = time_interval(i).it(2);
                key.time_interval_correlation_description = time_interval(i).label;
                
                key.flag_include_distractor_trials =0;
                [corr_mat, cov_mat, unit_num] = fn_compute_noise_corr(key);
                if ~isempty(corr_mat)
                    key.cov_matrix = cov_mat;
                    key.corr_matrix = corr_mat;
                    key.unit_num_noise_correlation = unit_num;
                    insert(self,key)
                end
                
                key.flag_include_distractor_trials =1;
                [corr_mat, cov_mat, unit_num] = fn_compute_noise_corr(key);
                if ~isempty(corr_mat)
                    key.cov_matrix = cov_mat;
                    key.corr_matrix = corr_mat;
                    key.unit_num_noise_correlation = unit_num;
                    insert(self,key)
                end
            end
            
            toc
        end
        
    end
end