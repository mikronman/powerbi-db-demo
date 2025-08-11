-- Example drivers by period and cross-entity mapping
IF NOT EXISTS (SELECT 1 FROM dbo.Alloc_Drivers)
BEGIN
  INSERT dbo.Alloc_Drivers (PeriodId, DriverType, SourceEntityType, SourceEntityCode, TargetEntityType, TargetEntityCode, DriverValue)
  VALUES
   (202401,'Headcount','Dept','OPS','Dept','S&M',0.25),
   (202401,'Headcount','Dept','OPS','Dept','G&A',0.35),
   (202401,'Headcount','Dept','OPS','Dept','R&D',0.40),

   (202402,'SqFt','Plant','PLT01','Dept','G&A',0.50),
   (202402,'SqFt','Plant','PLT01','Dept','OPS',0.50),

   (202403,'RevenueShare','Region','NE','Region','W',0.30),
   (202403,'RevenueShare','Region','NE','Region','SE',0.70);
END