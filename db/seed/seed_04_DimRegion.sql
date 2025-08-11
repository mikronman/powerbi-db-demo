IF NOT EXISTS (SELECT 1 FROM dbo.DimRegion)
INSERT dbo.DimRegion (RegionCode, RegionName, Country, StateProvince)
VALUES ('NE','Northeast','USA',NULL),('SE','Southeast','USA',NULL),('MW','Midwest','USA',NULL),
       ('SW','Southwest','USA',NULL),('W','West','USA',NULL),('CAN','Canada','Canada',NULL);