function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    cfg = dj.config; 
    schemaObject = dj.Schema(dj.conn, 'EPHYS', [cfg.custom.databasePrefix, 'ephys']);
end
obj = schemaObject;
end
