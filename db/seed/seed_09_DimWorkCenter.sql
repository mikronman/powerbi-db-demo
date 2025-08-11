IF NOT EXISTS (SELECT 1 FROM dbo.DimWorkCenter)
INSERT dbo.DimWorkCenter (WorkCenterCode, WorkCenterName, PlantId)
SELECT CONCAT('WC',RIGHT('00'+CAST(n AS varchar(2)),2)), CONCAT('Work Center ',n),
       (SELECT TOP 1 PlantId FROM dbo.DimPlant ORDER BY PlantId OFFSET (n%4) ROWS FETCH NEXT 1 ROWS ONLY)
FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) v(n);