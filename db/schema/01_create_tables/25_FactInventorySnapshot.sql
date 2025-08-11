CREATE TABLE FactInventorySnapshot (
    FactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    -- Keys (FKs added later)
    DateId INT NOT NULL,                -- daily or month-end snapshot (DimDate)
    ProductId INT NOT NULL,             -- DimProduct
    LocationId INT NULL,                -- use DimPlant as location, or add DimLocation later

    -- Measures
    OnHandQty DECIMAL(18,4) NOT NULL,
    OnHandValue DECIMAL(18,2) NOT NULL,

    -- Attributes
    AgingBucket NVARCHAR(20) NULL       -- e.g., '0-30','31-60','61-90','90+'
);