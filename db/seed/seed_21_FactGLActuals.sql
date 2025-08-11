-- Monthly actuals for July 2025 across a small combo of GL x Dept x Region
IF NOT EXISTS (SELECT 1 FROM dbo.FactGLActuals WHERE DateId = 20250701)
BEGIN
  ;WITH MonthOne AS (
    SELECT CAST(20250701 AS int) AS DateId
  ),
  GL AS (SELECT GLAccountId, GLAccountNumber FROM dbo.DimGLAccount WHERE GLAccountNumber IN ('4000','5000','5010','6100','6200')),
  DP AS (SELECT TOP 3 DeptId FROM dbo.DimDept ORDER BY DeptId),
  RG AS (SELECT TOP 3 RegionId FROM dbo.DimRegion ORDER BY RegionId)
  INSERT dbo.FactGLActuals (DateId, GLAccountId, DeptId, CostCenterId, RegionId, Amount, Source)
  SELECT m.DateId, gl.GLAccountId, dp.DeptId, NULL, rg.RegionId,
         CAST((ABS(CHECKSUM(NEWID()))%90000)/100.0 AS decimal(18,2)) * CASE WHEN gl.GLAccountNumber IN ('4000') THEN 1 ELSE -1 END,
         'ERP'
  FROM MonthOne m CROSS JOIN GL gl CROSS JOIN DP dp CROSS JOIN RG rg;
END