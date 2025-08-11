IF NOT EXISTS (SELECT 1 FROM dbo.DimCostCenter)
INSERT dbo.DimCostCenter (CostCenterCode, CostCenterName, DeptId)
SELECT CONCAT('CC',RIGHT('00'+CAST(v.n AS varchar(2)),2)),
       CONCAT('Cost Center ',v.n),
       (SELECT DeptId FROM dbo.DimDept WHERE DeptCode =
          CASE WHEN v.n%5=1 THEN 'S&M' WHEN v.n%5=2 THEN 'G&A' WHEN v.n%5=3 THEN 'R&D'
               WHEN v.n%5=4 THEN 'OPS' ELSE 'FIN' END)
FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15)) v(n);