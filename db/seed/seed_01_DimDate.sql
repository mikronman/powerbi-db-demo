-- Daily calendar: 2019-01-01 to 2027-12-31
SET NOCOUNT ON;
DECLARE @Start date='20190101', @End date='20271231';

;WITH n AS (
  SELECT TOP (DATEDIFF(DAY,@Start,@End)+1)
         ROW_NUMBER() OVER (ORDER BY (SELECT 1))-1 AS d
  FROM sys.all_objects
)
INSERT INTO dbo.DimDate (DateId, FullDate, DayNumberOfWeek, DayNameOfWeek,
  DayNumberOfMonth, DayNumberOfYear, WeekNumberOfYear, MonthNumberOfYear,
  MonthName, CalendarQuarter, CalendarYear, IsWeekend, IsHoliday)
SELECT
  CONVERT(int, FORMAT(DATEADD(DAY,d,@Start),'yyyyMMdd')),
  DATEADD(DAY,d,@Start),
  DATEPART(WEEKDAY, DATEADD(DAY,d,@Start)),
  DATENAME(WEEKDAY, DATEADD(DAY,d,@Start)),
  DATEPART(DAY, DATEADD(DAY,d,@Start)),
  DATEPART(DAYOFYEAR, DATEADD(DAY,d,@Start)),
  DATEPART(ISO_WEEK, DATEADD(DAY,d,@Start)),
  DATEPART(MONTH, DATEADD(DAY,d,@Start)),
  DATENAME(MONTH, DATEADD(DAY,d,@Start)),
  DATEPART(QUARTER, DATEADD(DAY,d,@Start)),
  DATEPART(YEAR, DATEADD(DAY,d,@Start)),
  CASE WHEN DATENAME(WEEKDAY, DATEADD(DAY,d,@Start)) IN ('Saturday','Sunday') THEN 1 ELSE 0 END,
  0
FROM n
WHERE NOT EXISTS (SELECT 1 FROM dbo.DimDate);