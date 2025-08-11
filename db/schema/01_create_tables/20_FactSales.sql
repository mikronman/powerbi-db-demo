CREATE TABLE FactSales (
    FactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    -- Keys (FKs added later)
    DateId INT NOT NULL,                -- DimDate
    CustomerId INT NOT NULL,            -- DimCustomer
    ProductId INT NOT NULL,             -- DimProduct
    RegionId INT NULL,                  -- DimRegion (can derive from customer)
    SalesRepId INT NULL,                -- DimSalesRep (optional)

    -- Traceability
    InvoiceId NVARCHAR(64) NULL,
    InvoiceLineNumber INT NULL,

    -- Measures
    Qty DECIMAL(18,4) NOT NULL,
    NetPrice DECIMAL(18,4) NOT NULL,
    NetRevenue DECIMAL(18,2) NOT NULL,          -- Qty * NetPrice - Discounts
    StdCost DECIMAL(18,4) NULL,                 -- standard unit cost
    ActualMaterialCost DECIMAL(18,4) NULL,
    ActualConversionCost DECIMAL(18,4) NULL,    -- labor/overhead per unit
    Discounts DECIMAL(18,2) NULL,
    Freight DECIMAL(18,2) NULL
);