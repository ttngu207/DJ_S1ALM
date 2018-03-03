function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'ANL', 'arseny_s1alm_analysis');
end
obj = schemaObject;
end
