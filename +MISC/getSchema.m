function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'MISC', 'arseny_s1alm_misc');
end
obj = schemaObject;
end
