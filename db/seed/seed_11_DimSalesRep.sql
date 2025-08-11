IF OBJECT_ID('dbo.DimSalesRep') IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM dbo.DimSalesRep)
INSERT dbo.DimSalesRep (SalesRepCode, SalesRepName, RegionId)
VALUES
 ('SR-001','Ava Martinez', (SELECT RegionId FROM dbo.DimRegion WHERE RegionCode='NE')),
 ('SR-002','Ben Johnson',  (SELECT RegionId FROM dbo.DimRegion WHERE RegionCode='W')),
 ('SR-003','Chris Patel',  (SELECT RegionId FROM dbo.DimRegion WHERE RegionCode='SE')),
 ('SR-004','Dana Kim',     (SELECT RegionId FROM dbo.DimRegion WHERE RegionCode='MW')),
 ('SR-005','Evan Li',      (SELECT RegionId FROM dbo.DimRegion WHERE RegionCode='SW'));