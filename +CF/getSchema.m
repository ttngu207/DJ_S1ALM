function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config; 
    schemaObject = dj.Schema(dj.conn, 'CF', [cfg.custom.databasePrefix, 'cf']);
end
obj = schemaObject;
end
