function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'EXP', 'arseny_s1alm_experiment');
end
obj = schemaObject;
end
