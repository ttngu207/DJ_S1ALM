%{
#
-> EXP.Session
flag_include_distractor_trials                 :  smallint      # 0 - no distractor trials included, 1 - distractor trials are included
---
number_of_trials_svm                           :  int           # number of trials used to train/test SVM (the total number of labeled trials)
svm_performance_time                           : longblob                  # mean performance of an svm classifier along the trial time
time_vector_svm                                : longblob                  # time vector with bins for which the performance was computed
%}


classdef SVMregression < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes& ANL.Video1stLickTrial & 'session=8' & 'subject_id=365942'
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            key.flag_include_distractor_trials =0;
            [t,perf_time_mat,smallest_set_num] = fn_SVM_regression(key);
            if ~isempty(perf_time_mat)
                key.svm_performance_time = perf_time_mat;
                key.time_vector_svm = t;
                key.number_of_trials_svm = smallest_set_num*2;
                insert(self,key)
            end
            key.flag_include_distractor_trials =1;
            [t,perf_time_mat,smallest_set_num] = fn_SVM_regression(key);
            if ~isempty(perf_time_mat)
                key.svm_performance_time = perf_time_mat;
                key.time_vector_svm = t;
                key.number_of_trials_svm = smallest_set_num*2;
                insert(self,key)
            end
            toc
        end
        
    end
end