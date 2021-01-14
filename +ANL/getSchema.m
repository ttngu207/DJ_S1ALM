function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config;
    schemaObject = dj.Schema(dj.conn, 'ANL', [cfg.custom.databasePrefix, 'analysis']);
end
obj = schemaObject;
end
