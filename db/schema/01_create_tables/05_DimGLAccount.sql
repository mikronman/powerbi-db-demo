CREATE TABLE DimGLAccount (
    GLAccountId INT IDENTITY(1,1) PRIMARY KEY,
    GLAccountNumber NVARCHAR(50) NOT NULL,         -- e.g., 4100
    GLAccountName NVARCHAR(200) NOT NULL,
    GLAccountType NVARCHAR(50) NULL,               -- Revenue/COGS/Opex/Capex/Other
    CONSTRAINT UQ_DimGLAccount_Number UNIQUE(GLAccountNumber)
);