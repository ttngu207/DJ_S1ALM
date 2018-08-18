function [corr_mat, cov_mat, unit_num] = fn_compute_noise_corr(key)
corr_mat=[];
cov_mat=[];
unit_num=[];
Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = key.smooth_time_noise_correlation;
smooth_bins=ceil(smooth_time/psth_time_bin);


% rel = (EXP.Session  & EPHYS.Unit & ANL.IncludeUnit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * EXP.SessionID * (EPHYS.UnitPosition & "brain_area='ALM'");

psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');

%
% session_uid = fetchn(rel,'session_uid');
% key.session_uid=session_uid(1);
% unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key & 'unit_quality="ok" or unit_quality="good"', 'unit', 'ORDER BY unit_uid');
if strcmp(key.unit_quality,'ok or good')
    key=rmfield(key,'unit_quality');
    unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key & 'unit_quality!="multi"', 'unit', 'ORDER BY unit_uid');
else
    unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key, 'unit', 'ORDER BY unit_uid');
end
if numel(unit_num)<2
    return
end
psth_t_u_tr = fetch1(ANL.PSTHMatrix * EXP.SessionID & key , 'psth_t_u_tr');

if strcmp(key.time_interval_correlation_description,'pre-sample')
    key=rmfield(key,'trial_instruction');
    analyzed_trials = fetchn(EXP.BehaviorTrial* ANL.TrialTypeGraphic * EXP.SessionID * EXP.TrialName & key & 'trialtype_no_presample =1' & 'early_lick="no early"','trial','ORDER BY trial');
else
    if key.flag_include_distractor_trials ==1
        analyzed_trials = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key  & 'early_lick="no early"','trial','ORDER BY trial');
    elseif key.flag_include_distractor_trials ==0
        analyzed_trials = fetchn(EXP.BehaviorTrial* ANL.TrialTypeGraphic * EXP.SessionID * EXP.TrialName & key & 'trialtype_left_and_right_no_distractors =1' & 'early_lick="no early"','trial','ORDER BY trial');
    end
end


if numel(analyzed_trials)<10
    return
end

time_window_analyzed= psth_t_vector>key.time_interval_correlation_st & key.time_interval_correlation_end>psth_t_vector;
psth_t_u_tr=psth_t_u_tr(time_window_analyzed, unit_num, analyzed_trials);

psth_t_u_tr = movmean(psth_t_u_tr ,[smooth_bins 0], 1,'omitnan', 'Endpoints','shrink');

for i_u=1:1:size(psth_t_u_tr,2)
    iu=squeeze(psth_t_u_tr(:,i_u,:));
    for j_u=1:1:size(psth_t_u_tr,2)
        ju=squeeze(psth_t_u_tr(:,j_u,:));
        r=corr(iu(:),ju(:),'type','Pearson','rows','pairwise');
        corr_mat(i_u,j_u)=r;
        %         corr_mat(i_u,j_u)=nanmean(diag(r));
        c=cov(iu,ju,'omitrows');
        cov_mat(i_u,j_u)=c(1,2);
    end
end
end
% num_analyzed_trials = numel(analyzed_trials);
% stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/4;
% psth_t_u_tr = psth_t_u_tr(:,stable_cells,:);
% if sum(stable_cells)<5
%     return
% end

