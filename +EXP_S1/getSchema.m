function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'EXP_S1', 'arseny_s1alm_experiment_s1');
end
obj = schemaObject;
end
