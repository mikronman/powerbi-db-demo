CREATE TABLE DimFPnAGroup (
    FPnAGroupId INT IDENTITY(1,1) PRIMARY KEY,
    FPnAGroupCode NVARCHAR(50) NOT NULL,            -- e.g., REVENUE, COGS_MATERIAL, OPEX_S&M
    FPnAGroupName NVARCHAR(200) NOT NULL,
    CONSTRAINT UQ_DimFPnAGroup_Code UNIQUE(FPnAGroupCode)
);

CREATE TABLE Bridge_AccountToFPnAGroup (
    GLAccountId INT NOT NULL,
    FPnAGroupId INT NOT NULL,
    Weight DECIMAL(9,6) NOT NULL DEFAULT 1.0,       -- allow split mappings; typically 1.0
    CONSTRAINT PK_Bridge_AccountToFPnAGroup PRIMARY KEY (GLAccountId, FPnAGroupId)
    -- FKs added later
);