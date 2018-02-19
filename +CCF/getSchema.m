function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'CCF', 'arseny_ccf');
end
obj = schemaObject;
end
