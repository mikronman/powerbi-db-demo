IF NOT EXISTS (SELECT 1 FROM dbo.DimDept)
INSERT dbo.DimDept (DeptCode, DeptName)
VALUES ('S&M','Sales & Marketing'),('G&A','General & Admin'),('R&D','Research & Development'),
       ('OPS','Operations'),('FIN','Finance');