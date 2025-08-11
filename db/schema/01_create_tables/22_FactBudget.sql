CREATE TABLE FactBudget (
    FactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    -- Keys (FKs added later)
    DateId INT NOT NULL,                -- month grain
    GLAccountId INT NOT NULL,
    DeptId INT NULL,
    CostCenterId INT NULL,
    RegionId INT NULL,
    ScenarioId INT NOT NULL,            -- DimScenario (Baseline budget, etc.)

    -- Measures
    Amount DECIMAL(18,2) NOT NULL
);