CREATE TABLE Assumption_CommodityPrices (
    AssumptionId INT IDENTITY(1,1) PRIMARY KEY,
    DateId INT NOT NULL,                             -- join to DimDate
    Commodity NVARCHAR(50) NOT NULL,                 -- Copper/Aluminum/PVC
    PricePerUnit DECIMAL(18,6) NOT NULL
);