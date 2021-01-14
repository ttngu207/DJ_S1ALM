function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config; 
    schemaObject = dj.Schema(dj.conn, 'LAB', [cfg.custom.databasePrefix, 'lab']);
end
obj = schemaObject;
end
