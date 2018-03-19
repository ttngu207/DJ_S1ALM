%{
# Sorted unit
-> EPHYS.Unit
---
unit_isi                    : longblob       # inter spike interval (seconds) for this unit
unit_isi_hist               : blob           # ISI histogram (ms) on a logarithmic scale
unit_isi_hist_bins          : blob           # bin centers of the ISI histogram, (ms) on a logarithmic scale
%}

classdef UnitISI < dj.Computed
    
    methods(Access=protected)
        function makeTuples(self, key)
            spike_times=cell2mat([fetchn(EPHYS.TrialSpikes & key,'spike_times')]);
            dt = diff(spike_times);
            dt(dt>10 | dt<0)=[];
            
            %computing ISI histogram in miliseconds on a logarithmic scale
            dt_log = log10(dt*1000); % in miliseconds
            isi_hist_edges = [-2,0:0.1:4];
            isi_hist_bins = [-0.02, isi_hist_edges(2:end) + mean(diff(isi_hist_edges(2:end)))./2];
            [isi_hist, ~] = histc(dt_log, isi_hist_edges);

            key.unit_isi = dt;
            key.unit_isi_hist = isi_hist;
            key.unit_isi_hist_bins = isi_hist_bins;
            insert(self, key);
            
%             hold on;
%             b = bar(isi_hist_bins, isi_hist);
%             plot([log10(2),log10(2)],[0, max(isi_hist)],'-k');
%             set(b, 'LineStyle', '-', 'BarWidth', 1, 'EdgeColor','r', 'FaceColor', 'r');
%             set(gca,'XTick',[0,1,2,3,4],'XTickLabels',[1,10,100,1000,10000]);
%             set(gca,'TickLength',[0.04 0.01],'TickDir','out')
%             xlabel('ISI (ms)');
%             ylabel ('Counts');
%             xlim([-0.3,4]);
        end
    end
end

