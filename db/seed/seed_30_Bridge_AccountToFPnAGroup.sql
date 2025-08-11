-- FP&A groups
IF NOT EXISTS (SELECT 1 FROM dbo.DimFPnAGroup)
INSERT dbo.DimFPnAGroup (FPnAGroupCode, FPnAGroupName)
VALUES ('REVENUE','Revenue'),('COGS_MAT','COGS - Material'),('COGS_CONV','COGS - Conversion'),
       ('OPEX_SM','Opex - Sales & Marketing'),('OPEX_GA','Opex - G&A'),('OPEX_RD','Opex - R&D'),
       ('CAPEX','Capital Expenditures'),('OTHER','Other');

-- Map GL accounts to groups (1:1 for demo)
IF NOT EXISTS (SELECT 1 FROM dbo.Bridge_AccountToFPnAGroup)
INSERT dbo.Bridge_AccountToFPnAGroup (GLAccountId, FPnAGroupId, Weight)
SELECT gla.GLAccountId,
       CASE gla.GLAccountNumber
         WHEN '4000' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='REVENUE')
         WHEN '4010' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='REVENUE')
         WHEN '5000' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='COGS_MAT')
         WHEN '5010' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='COGS_CONV')
         WHEN '6100' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='OPEX_SM')
         WHEN '6200' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='OPEX_GA')
         WHEN '6300' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='OPEX_RD')
         WHEN '1500' THEN (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='CAPEX')
         ELSE (SELECT FPnAGroupId FROM dbo.DimFPnAGroup WHERE FPnAGroupCode='OTHER')
       END,
       1.0
FROM dbo.DimGLAccount gla;