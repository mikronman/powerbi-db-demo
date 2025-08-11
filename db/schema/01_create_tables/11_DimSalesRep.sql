CREATE TABLE DimSalesRep (
    SalesRepId INT IDENTITY(1,1) PRIMARY KEY,
    SalesRepCode NVARCHAR(50) NOT NULL,
    SalesRepName NVARCHAR(200) NOT NULL,
    RegionId INT NULL,                               -- FK later to DimRegion
    CONSTRAINT UQ_DimSalesRep_Code UNIQUE(SalesRepCode)
);