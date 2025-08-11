-- Budget for 2025 BASELINE
IF NOT EXISTS (SELECT 1 FROM dbo.FactBudget WHERE EXISTS (SELECT 1 WHERE 1=1))
BEGIN
  DECLARE @ScenarioId int = (SELECT ScenarioId FROM dbo.DimScenario WHERE ScenarioCode='BASELINE');

  ;WITH Months AS (
    SELECT DateId FROM dbo.DimDate
    WHERE CalendarYear=2025 AND DayNumberOfMonth=1
  ),
  GL AS (SELECT GLAccountId, GLAccountNumber FROM dbo.DimGLAccount WHERE GLAccountNumber IN ('4000','5000','5010','6100','6200')),
  DP AS (SELECT TOP 3 DeptId FROM dbo.DimDept ORDER BY DeptId),
  RG AS (SELECT TOP 3 RegionId FROM dbo.DimRegion ORDER BY RegionId)
  INSERT dbo.FactBudget (DateId, GLAccountId, DeptId, CostCenterId, RegionId, ScenarioId, Amount)
  SELECT m.DateId, gl.GLAccountId, dp.DeptId, NULL, rg.RegionId, @ScenarioId,
         CAST((ABS(CHECKSUM(NEWID()))%120000)/100.0 AS decimal(18,2)) * CASE WHEN gl.GLAccountNumber='4000' THEN 1 ELSE -1 END
  FROM Months m CROSS JOIN GL gl CROSS JOIN DP dp CROSS JOIN RG rg;
END