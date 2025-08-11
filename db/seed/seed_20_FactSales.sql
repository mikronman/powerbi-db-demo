-- Small but rich demo set: July 2025 (weekdays), ~120 lines
SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM dbo.FactSales WHERE InvoiceId LIKE 'INV202507%')
BEGIN
  DECLARE @Start int = 20250701, @End int = 20250731;

  ;WITH D AS (
    SELECT DateId FROM dbo.DimDate
    WHERE DateId BETWEEN @Start AND @End AND IsWeekend = 0
  ),
  C AS (
    SELECT TOP 3 CustomerId FROM dbo.DimCustomer WHERE IsCurrent=1 ORDER BY CustomerId
  ),
  P AS (
    SELECT TOP 4 ProductId FROM dbo.DimProduct WHERE IsCurrent=1 ORDER BY ProductId
  )
  INSERT dbo.FactSales (DateId, CustomerId, ProductId, RegionId, SalesRepId,
                        InvoiceId, InvoiceLineNumber, Qty, NetPrice, NetRevenue,
                        StdCost, ActualMaterialCost, ActualConversionCost, Discounts, Freight)
  SELECT
    d.DateId, c.CustomerId, p.ProductId,
    NULL AS RegionId,
    NULL AS SalesRepId,
    CONCAT('INV', d.DateId, '-', RIGHT('00000'+CAST(ROW_NUMBER() OVER (PARTITION BY d.DateId ORDER BY p.ProductId,c.CustomerId) AS varchar(5)),5)),
    1,
    CAST(1 + (ABS(CHECKSUM(NEWID())) % 50) AS decimal(18,4)) AS Qty,
    CAST(15 + (ABS(CHECKSUM(NEWID())) % 85) AS decimal(18,4)) AS NetPrice,
    0,0,0,0,0
  FROM D d
  CROSS JOIN C c
  CROSS JOIN P p;

  -- Compute derived measures after insert
  UPDATE fs
    SET NetRevenue = CAST(fs.Qty * fs.NetPrice AS decimal(18,2)),
        StdCost = CAST(fs.NetPrice * 0.55 AS decimal(18,4)),
        ActualMaterialCost = CAST(fs.NetPrice * 0.35 AS decimal(18,4)),
        ActualConversionCost = CAST(fs.NetPrice * 0.15 AS decimal(18,4)),
        Discounts = CAST((ABS(CHECKSUM(NEWID()))%300)/10.0 AS decimal(18,2)),
        Freight = CAST((ABS(CHECKSUM(NEWID()))%500)/10.0 AS decimal(18,2))
  FROM dbo.FactSales fs
  WHERE fs.InvoiceId LIKE 'INV202507%';
END