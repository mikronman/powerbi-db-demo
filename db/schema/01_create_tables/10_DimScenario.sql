CREATE TABLE DimScenario (
    ScenarioId INT IDENTITY(1,1) PRIMARY KEY,
    ScenarioCode NVARCHAR(50) NOT NULL,             -- Baseline/Optimistic/Downside/Replan_2507
    ScenarioName NVARCHAR(200) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT UQ_DimScenario_Code UNIQUE(ScenarioCode)
);