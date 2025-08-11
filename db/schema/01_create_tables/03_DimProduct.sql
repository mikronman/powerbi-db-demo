CREATE TABLE DimProduct (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    ProductBK NVARCHAR(64) NOT NULL,               -- item number/SKU
    ProductName NVARCHAR(200) NOT NULL,
    ProductCategory NVARCHAR(100) NULL,            -- Coaxial/Fiber/Bundle
    MaterialType NVARCHAR(100) NULL,               -- Copper/Aluminum/PVC
    UOM NVARCHAR(20) NULL,                         -- Unit of measure
    -- SCD2 fields
    EffectiveFrom DATE NOT NULL,
    EffectiveTo   DATE NULL,
    IsCurrent     BIT  NOT NULL DEFAULT 1,
    CONSTRAINT UQ_DimProduct_BK_Eff UNIQUE(ProductBK, EffectiveFrom)
);