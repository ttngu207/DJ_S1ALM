function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'TEST', 'map_arsenytest');
end
obj = schemaObject;
end
