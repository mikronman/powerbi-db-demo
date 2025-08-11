CREATE TABLE DimWorkCenter (
    WorkCenterId INT IDENTITY(1,1) PRIMARY KEY,
    WorkCenterCode NVARCHAR(50) NOT NULL,
    WorkCenterName NVARCHAR(200) NOT NULL,
    PlantId INT NULL,                                -- FK later to DimPlant
    CONSTRAINT UQ_DimWorkCenter_Code UNIQUE(WorkCenterCode)
);