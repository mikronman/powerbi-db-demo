CREATE TABLE DimDate (
    DateId INT NOT NULL PRIMARY KEY, -- YYYYMMDD format
    FullDate DATE NOT NULL,
    DayNumberOfWeek TINYINT NOT NULL,
    DayNameOfWeek NVARCHAR(20) NOT NULL,
    DayNumberOfMonth TINYINT NOT NULL,
    DayNumberOfYear SMALLINT NOT NULL,
    WeekNumberOfYear TINYINT NOT NULL,
    MonthNumberOfYear TINYINT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    CalendarQuarter TINYINT NOT NULL,
    CalendarYear SMALLINT NOT NULL,
    IsWeekend BIT NOT NULL,
    IsHoliday BIT NOT NULL
);