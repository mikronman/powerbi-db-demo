IF NOT EXISTS (SELECT 1 FROM dbo.DimCustomer)
BEGIN
  -- Current versions
  INSERT dbo.DimCustomer (CustomerBK, CustomerName, CustomerType, RegionId, Terms, CreditLimit, EffectiveFrom, EffectiveTo, IsCurrent)
  SELECT v.bk, v.name, v.ctype, r.RegionId, 'Net30', v.Credit, '2023-01-01', NULL, 1
  FROM (VALUES
    ('CUST-001','Acme Fiber LLC','Business', 80000),
    ('CUST-002','Pioneer Cabling','Business', 75000),
    ('CUST-003','Northstar Utilities','Distributor', 120000),
    ('CUST-004','HomeConnect','Residential', 15000),
    ('CUST-005','Blue Ridge Telco','Business', 90000)
  ) v(bk,name,ctype,Credit)
  CROSS APPLY (SELECT TOP 1 RegionId FROM dbo.DimRegion ORDER BY NEWID()) r;

  -- Historical change for CUST-002 (region/terms)
  UPDATE dbo.DimCustomer SET EffectiveTo='2024-06-30', IsCurrent=0
  WHERE CustomerBK='CUST-002' AND EffectiveFrom='2023-01-01';

  INSERT dbo.DimCustomer (CustomerBK, CustomerName, CustomerType, RegionId, Terms, CreditLimit, EffectiveFrom, EffectiveTo, IsCurrent)
  SELECT 'CUST-002','Pioneer Cabling','Business',
         (SELECT RegionId FROM dbo.DimRegion WHERE RegionCode='W'),
         'Net45', 90000, '2024-07-01', NULL, 1;
END