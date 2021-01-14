function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config; 
    schemaObject = dj.Schema(dj.conn, 'MISC', [cfg.custom.databasePrefix, 'misc']);
end
obj = schemaObject;
end
