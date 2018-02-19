function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'LAB', 'arseny_lab');
end
obj = schemaObject;
end
