function [obj, hash] = getObj(key)
%  read object file with memorization
%  s1.getObj('clear')  -- clears the store
%  obj = s1.getObj(key)  -- returns the object for a given session key

global dir_data
persistent store session pkey
if isempty(store) || strcmp(key, 'clear')
    store = containers.Map;
    session = EXP.Session;
    pkey = session.header.primaryKey;
end


if ~strcmp(key, 'clear')
    hash = strjoin(cellfun(@(k) sprintf('%g', key.(k)), pkey, 'uni', false), '-');
    if ~store.isKey(hash)
        
        file_name1 =['data_structure_anm' num2str(fetch1(EXP.Session & key, 'subject_id')) '_' fetch1(EXP.Session & key, 'session_date') '.mat'];
        file_name2 =['behv_structure_anm' num2str(fetch1(EXP.Session & key, 'subject_id')) '_' fetch1(EXP.Session & key, 'session_date') '.mat'];
        
        if exist([dir_data file_name1], 'file') == 2
            s = load([dir_data file_name1]);
        elseif exist([dir_data file_name2], 'file') == 2
            s = load([dir_data file_name2]);
        end
        store(hash) = s.obj;
    end
    obj = store(hash);
end
end