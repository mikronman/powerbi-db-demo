-- Month-end snapshots for a few products/locations (Jul & Aug 2025)
IF NOT EXISTS (SELECT 1 FROM dbo.FactInventorySnapshot WHERE DateId BETWEEN 20250701 AND 20250831)
BEGIN
  ;WITH MonthEnd AS (
    SELECT DateId FROM dbo.DimDate
    WHERE FullDate >= '2025-07-01' AND FullDate < '2025-09-01'
      AND DayNumberOfMonth IN (28,29,30,31)  -- approximate month-end
  ),
  P AS (SELECT TOP 3 ProductId FROM dbo.DimProduct WHERE IsCurrent=1 ORDER BY ProductId),
  L AS (SELECT TOP 3 PlantId   AS LocationId FROM dbo.DimPlant   ORDER BY PlantId)
  INSERT dbo.FactInventorySnapshot (DateId, ProductId, LocationId, OnHandQty, OnHandValue, AgingBucket)
  SELECT me.DateId, p.ProductId, l.LocationId,
         CAST(100 + (ABS(CHECKSUM(NEWID()))%900) AS decimal(18,4)),
         CAST(5000 + (ABS(CHECKSUM(NEWID()))%50000) AS decimal(18,2)),
         (SELECT v.B FROM (VALUES ('0-30'),('31-60'),('61-90'),('90+')) v(B) ORDER BY NEWID() OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY)
  FROM MonthEnd me CROSS JOIN P p CROSS JOIN L l;
END