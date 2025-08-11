CREATE TABLE FactProduction (
    FactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    -- Keys (FKs added later)
    DateId INT NOT NULL,                -- DimDate (daily)
    ProductId INT NOT NULL,             -- DimProduct
    PlantId INT NULL,                   -- DimPlant
    WorkCenterId INT NULL,              -- DimWorkCenter

    -- Traceability (optional)
    WorkOrderId NVARCHAR(64) NULL,
    LotId NVARCHAR(64) NULL,

    -- Measures
    OutputQty DECIMAL(18,4) NOT NULL,
    ScrapQty DECIMAL(18,4) NULL,
    RuntimeHrs DECIMAL(18,2) NULL,
    LaborHrs DECIMAL(18,2) NULL,
    MaterialCost DECIMAL(18,2) NULL,
    ConversionCost DECIMAL(18,2) NULL
);