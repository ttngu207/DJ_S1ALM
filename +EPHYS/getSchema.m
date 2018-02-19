function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'EPHYS', 'arseny_s1alm_ephys');
end
obj = schemaObject;
end
