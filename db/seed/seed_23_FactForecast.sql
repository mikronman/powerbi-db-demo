-- Forecast for the remainder of 2025 (Aug–Dec) using REPLAN_2507
IF NOT EXISTS (SELECT 1 FROM dbo.FactForecast WHERE DateId BETWEEN 20250801 AND 20251201)
BEGIN
  DECLARE @ScenarioId int = (SELECT ScenarioId FROM dbo.DimScenario WHERE ScenarioCode='REPLAN_2507');

  ;WITH Months AS (
    SELECT DateId FROM dbo.DimDate
    WHERE FullDate >= '2025-08-01' AND FullDate < '2026-01-01' AND DayNumberOfMonth = 1
  ),
  GL AS (SELECT GLAccountId, GLAccountNumber FROM dbo.DimGLAccount WHERE GLAccountNumber IN ('4000','5000','5010','6100','6200')),
  DP AS (SELECT TOP 3 DeptId FROM dbo.DimDept ORDER BY DeptId),
  RG AS (SELECT TOP 3 RegionId FROM dbo.DimRegion ORDER BY RegionId)
  INSERT dbo.FactForecast (DateId, GLAccountId, DeptId, CostCenterId, RegionId, ScenarioId, Amount)
  SELECT m.DateId, gl.GLAccountId, dp.DeptId, NULL, rg.RegionId, @ScenarioId,
         -- Slight uplift vs. budget-style amounts to look like a replan
         CAST((ABS(CHECKSUM(NEWID()))%130000)/100.0 AS decimal(18,2)) * CASE WHEN gl.GLAccountNumber='4000' THEN 1 ELSE -1 END
  FROM Months m CROSS JOIN GL gl CROSS JOIN DP dp CROSS JOIN RG rg;
END