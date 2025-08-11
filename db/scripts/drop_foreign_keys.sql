/* ==========================================================
   drop_foreign_keys.sql  (SQLCMD mode-friendly)
   Drops ALL FOREIGN KEYS for a given schema (default: dbo)
   Safe to re-run. Prints what it drops.
   ========================================================== */

:setvar SchemaName "dbo"

SET NOCOUNT ON;

DECLARE @schemaname sysname = N'$(SchemaName)';
IF @schemaname IS NULL OR LTRIM(RTRIM(@schemaname)) = N'' SET @schemaname = N'dbo';

DECLARE @sql nvarchar(max) = N'';
DECLARE @crlf nchar(2) = NCHAR(13) + NCHAR(10);

;WITH fks AS (
    SELECT 
        fk_name = QUOTENAME(fk.name),
        parent_table = QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    FROM sys.foreign_keys fk
    JOIN sys.tables  t ON fk.parent_object_id = t.object_id
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE fk.is_ms_shipped = 0
      AND s.name = @schemaname
)
SELECT @sql = STRING_AGG(
N'IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = ' 
 + QUOTENAME(REPLACE(fk_name, '[',''),'''') + N' AND parent_object_id = OBJECT_ID(''' 
 + parent_table + N'''))
BEGIN
    PRINT ''Dropping FK ' + REPLACE(fk_name, '''', '''''') + N' on ' + parent_table + N''';
    ALTER TABLE ' + parent_table + N' DROP CONSTRAINT ' + fk_name + N';
END'
, @crlf + @crlf)
FROM fks;

IF @sql IS NULL OR LEN(@sql) = 0
BEGIN
    PRINT 'No foreign keys found to drop for schema ' + QUOTENAME(@schemaname) + '.';
END
ELSE
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'All foreign keys dropped for schema ' + QUOTENAME(@schemaname) + '.';
END
GO
