CREATE TABLE DimCustomer (
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    CustomerBK NVARCHAR(64) NOT NULL,              -- business key from ERP (code/number)
    CustomerName NVARCHAR(200) NOT NULL,
    CustomerType NVARCHAR(50),                     -- Residential/Business/Distributor
    RegionId INT NULL,                             -- FK later to DimRegion
    Terms NVARCHAR(50) NULL,
    CreditLimit DECIMAL(18,2) NULL,
    -- SCD2 fields
    EffectiveFrom DATE NOT NULL,
    EffectiveTo   DATE NULL,
    IsCurrent     BIT  NOT NULL DEFAULT 1,
    CONSTRAINT UQ_DimCustomer_BK_Eff UNIQUE(CustomerBK, EffectiveFrom)
);