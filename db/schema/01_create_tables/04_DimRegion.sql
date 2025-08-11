CREATE TABLE DimRegion (
    RegionId INT IDENTITY(1,1) PRIMARY KEY,
    RegionCode NVARCHAR(50) NOT NULL,
    RegionName NVARCHAR(200) NOT NULL,
    Country NVARCHAR(100) NULL,
    StateProvince NVARCHAR(100) NULL,
    CONSTRAINT UQ_DimRegion_Code UNIQUE(RegionCode)
);