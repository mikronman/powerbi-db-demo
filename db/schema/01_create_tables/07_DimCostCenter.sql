CREATE TABLE DimCostCenter (
    CostCenterId INT IDENTITY(1,1) PRIMARY KEY,
    CostCenterCode NVARCHAR(50) NOT NULL,
    CostCenterName NVARCHAR(200) NOT NULL,
    DeptId INT NULL,                                -- optional relationship to Dept
    CONSTRAINT UQ_DimCostCenter_Code UNIQUE(CostCenterCode)
);