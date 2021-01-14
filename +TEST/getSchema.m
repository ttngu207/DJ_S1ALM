function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config; 
    schemaObject = dj.Schema(dj.conn, 'TEST', [cfg.custom.databasePrefix, 'test']);
end
obj = schemaObject;
end
