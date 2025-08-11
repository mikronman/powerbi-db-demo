CREATE TABLE FactAROpen (
    FactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    -- Keys (FKs added later)
    CustomerId INT NOT NULL,            -- DimCustomer
    InvoiceDateId INT NOT NULL,         -- DimDate (invoice date)
    DueDateId INT NOT NULL,             -- DimDate (due date)

    -- Business keys / meta
    ARInvoiceId NVARCHAR(64) NOT NULL,
    Terms NVARCHAR(50) NULL,            -- e.g., Net30

    -- Measures
    Balance DECIMAL(18,2) NOT NULL,

    -- Risk
    RiskScore DECIMAL(5,2) NULL         -- optional 0–100 or z-score
);