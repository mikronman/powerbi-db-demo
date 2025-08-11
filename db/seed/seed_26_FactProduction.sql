-- Simple daily production for July 1–15, 2025 across plants/workcenters/products
IF NOT EXISTS (SELECT 1 FROM dbo.FactProduction WHERE DateId BETWEEN 20250701 AND 20250715)
BEGIN
  ;WITH D AS (
    SELECT DateId FROM dbo.DimDate WHERE DateId BETWEEN 20250701 AND 20250715
  ),
  P AS (SELECT TOP 2 ProductId FROM dbo.DimProduct WHERE IsCurrent=1 ORDER BY ProductId),
  PL AS (SELECT TOP 2 PlantId FROM dbo.DimPlant ORDER BY PlantId),
  WC AS (SELECT TOP 2 WorkCenterId FROM dbo.DimWorkCenter ORDER BY WorkCenterId)
  INSERT dbo.FactProduction (DateId, ProductId, PlantId, WorkCenterId, WorkOrderId, LotId,
                             OutputQty, ScrapQty, RuntimeHrs, LaborHrs, MaterialCost, ConversionCost)
  SELECT d.DateId, p.ProductId, pl.PlantId, wc.WorkCenterId,
         CONCAT('WO', d.DateId, '-', RIGHT('000'+CAST(pl.PlantId AS varchar(3)),3)),
         CONCAT('LOT', RIGHT('0000'+CAST(p.ProductId AS varchar(4)),4)),
         CAST(50 + (ABS(CHECKSUM(NEWID()))%150) AS decimal(18,4)),
         CAST(ABS(CHECKSUM(NEWID()))%5 AS decimal(18,4)),
         CAST(4 + (ABS(CHECKSUM(NEWID()))%6) AS decimal(18,2)),
         CAST(3 + (ABS(CHECKSUM(NEWID()))%5) AS decimal(18,2)),
         CAST(1000 + (ABS(CHECKSUM(NEWID()))%2500) AS decimal(18,2)),
         CAST(600 + (ABS(CHECKSUM(NEWID()))%1500) AS decimal(18,2))
  FROM D d CROSS JOIN P p CROSS JOIN PL pl CROSS JOIN WC wc;
END