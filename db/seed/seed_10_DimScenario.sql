INSERT INTO dbo.DimScenario (ScenarioCode, ScenarioName, IsActive)
SELECT v.Code, v.Name, 1
FROM (VALUES
 ('BASELINE','Baseline Budget'),
 ('OPT','Optimistic'),
 ('DOWN','Downside'),
 ('REPLAN_2507','Replan Jul 2025'),
 ('REPLAN_2510','Replan Oct 2025')
) v(Code,Name)
WHERE NOT EXISTS (SELECT 1 FROM dbo.DimScenario);