CREATE TABLE Alloc_Drivers (
    AllocDriverId INT IDENTITY(1,1) PRIMARY KEY,
    PeriodId INT NOT NULL,                           -- e.g., 202501 (YYYYMM); can also be DateId if you prefer daily
    DriverType NVARCHAR(50) NOT NULL,                -- Headcount/SqFt/RevenueShare/etc.
    SourceEntityType NVARCHAR(50) NOT NULL,          -- Dept/CostCenter/Plant/etc.
    SourceEntityCode NVARCHAR(50) NOT NULL,
    TargetEntityType NVARCHAR(50) NOT NULL,          -- Region/Product/Dept/etc.
    TargetEntityCode NVARCHAR(50) NOT NULL,
    DriverValue DECIMAL(18,6) NOT NULL               -- proportion or raw measure
);