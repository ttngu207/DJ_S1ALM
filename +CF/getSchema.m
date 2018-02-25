function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'CF', 'arseny_cf');
end
obj = schemaObject;
end
