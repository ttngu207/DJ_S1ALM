te_gc = struct2cell(fetch(EXP.TrialEvent & 'trial_event_type="go"','*'));



% te = fetch(EXP.TrialEvent,'*')
% b = fetch(EXP.BehaviorTrial,'*')


c = (EXP.BehaviorTrialEvent ) * (EXP.BehaviorTrial & 'early_lick="no early"')  * (EXP.ActionEvent)   ;
f = c.fetch('*');
field = [f.subject_id];
field = {f.subject_id};
% field = cell2mat({f.subject_id});

% usefull commands: inserti  insertreplace

% fetch(s1.Session & sprintf('session_date = "%s"',currentSessionDate))
% te = fetch(EXP.TrialEvent, 'ORDER BY trial_event_type' )
% fetch(rel, 'ORDER BY attr1 DESC, attr2, attr3 DESC')
% a= fetchn(EXP.ActionEvent & 'action_event_type="left lick"', 'action_event_time')
% key = fetch(EXP.Session & sprintf('subject_id=%d',currentSubject_id),'session');
% key = fetch(EXP.Session,'subject_id','session' & 'subject_id=currentSubject_id' &  'session=currentSession' );

% c = (EXP.TrialEvent & 'trial_event_type="go"') * EXP.BehaviorTrial * EXP.BehaviorTrialTest ;
% c = (EXP.TrialEvent ) * (EXP.BehaviorTrial & 'early_lick="early"') * (EXP.BehaviorTrialTest & 'early_lick_test!="no early"')   ;

% f = c.fetch('*');

% draw(dj.ERD(EXP.Session)+1-1+1-1 +1-1)


%Defining a public method fill
classdef TestTrialSpikes < dj.Imported
    methods (Access=protected)
        function makeTuples(self, key)
        end
    end
    methods (Access=public)
        function fill(self, key)
            a=1
        end
    end
end

%calling the method fill
fill(EPHYS.TestTrialSpikes,1)

%             rel1=ANL.TrialTypes; rel1=rel1.proj('stim_onsetss');
%             rel2= EXP.BehaviorTrial; rel2=rel2.proj('task->temp_task','*');


% drop an entire schema
% dropQuick(package_name.getSchema)

% This redefines `description` with a new name.
% alterAttribute(EXP.TrainingType, 'desription', 'training_description   : varchar(1000)   # detailed description of the training protocol')
