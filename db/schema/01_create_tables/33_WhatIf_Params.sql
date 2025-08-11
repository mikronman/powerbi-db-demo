CREATE TABLE WhatIf_Params (
    ParamId INT IDENTITY(1,1) PRIMARY KEY,
    ParamName NVARCHAR(100) NOT NULL,                -- PriceLiftPct/ChurnDelta/CopperPct
    ParamValue DECIMAL(18,6) NOT NULL,
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_WhatIf_Params_Name UNIQUE(ParamName)
);