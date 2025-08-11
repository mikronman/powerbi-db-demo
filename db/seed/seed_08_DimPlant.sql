IF NOT EXISTS (SELECT 1 FROM dbo.DimPlant)
INSERT dbo.DimPlant (PlantCode, PlantName, City, StateProvince)
VALUES ('PLT01','East Plant','Scranton','PA'),('PLT02','West Plant','Reno','NV'),
       ('PLT03','Central Plant','Tulsa','OK'),('PLT04','Canada Plant','Windsor','ON');