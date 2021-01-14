function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config; 
    schemaObject = dj.Schema(dj.conn, 'EXP', [cfg.custom.databasePrefix, 'experiment']);
end
obj = schemaObject;
end
