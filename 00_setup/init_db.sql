-- Kiểm tra các schema
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw', 'staging', 'dwh')
ORDER BY schema_name;
