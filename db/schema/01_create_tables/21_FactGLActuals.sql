CREATE TABLE FactGLActuals (
    FactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    -- Keys (FKs added later)
    DateId INT NOT NULL,                -- month grain via DimDate
    GLAccountId INT NOT NULL,           -- DimGLAccount
    DeptId INT NULL,                    -- DimDept
    CostCenterId INT NULL,              -- DimCostCenter
    RegionId INT NULL,                  -- DimRegion

    -- Measures
    Amount DECIMAL(18,2) NOT NULL,      -- signed (+/-)

    -- Meta
    Source NVARCHAR(20) NOT NULL        -- 'ERP','ADJ','ALLOC'
);