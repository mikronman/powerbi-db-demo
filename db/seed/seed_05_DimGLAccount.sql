IF NOT EXISTS (SELECT 1 FROM dbo.DimGLAccount)
INSERT dbo.DimGLAccount (GLAccountNumber, GLAccountName, GLAccountType)
VALUES
 ('4000','Product Revenue','Revenue'),
 ('4010','Service Revenue','Revenue'),
 ('5000','Material Costs','COGS'),
 ('5010','Conversion Costs','COGS'),
 ('6100','Sales & Marketing','Opex'),
 ('6200','General & Admin','Opex'),
 ('6300','Research & Development','Opex'),
 ('1500','Capital Equipment','Capex');