/* ======================================================
   drop_all.sql  (SQLCMD mode)
   Drops all schema objects in reverse dependency order
   ====================================================== */

:setvar DBName "StarSchemaDemo"

-- Ensure SQLCMD mode is ON (SSMS/ADS: Query > SQLCMD Mode)

PRINT '=== DROP START ===';

IF DB_ID('$(DBName)') IS NULL
BEGIN
    PRINT 'Database [$(DBName)] not found. Nothing to drop.';
    GOTO _done;
END

DECLARE @use nvarchar(max) = 'USE [' + REPLACE('$(DBName)',']',']]') + '];';
EXEC(@use);

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    PRINT '--- Dropping foreign keys ---';
    :r ..\schema\02_constraints_indexes\drop_foreign_keys.sql

    PRINT '--- Dropping facts ---';
    DROP TABLE IF EXISTS dbo.FactProduction;
    DROP TABLE IF EXISTS dbo.FactInventorySnapshot;
    DROP TABLE IF EXISTS dbo.FactAROpen;
    DROP TABLE IF EXISTS dbo.FactForecast;
    DROP TABLE IF EXISTS dbo.FactBudget;
    DROP TABLE IF EXISTS dbo.FactGLActuals;
    DROP TABLE IF EXISTS dbo.FactSales;

    PRINT '--- Dropping bridges/helpers ---';
    DROP TABLE IF EXISTS dbo.Bridge_AccountToFPnAGroup;
    DROP TABLE IF EXISTS dbo.DimFPnAGroup;
    DROP TABLE IF EXISTS dbo.Alloc_Drivers;
    DROP TABLE IF EXISTS dbo.Assumption_CommodityPrices;
    DROP TABLE IF EXISTS dbo.WhatIf_Params;

    PRINT '--- Dropping dimensions ---';
    DROP TABLE IF EXISTS dbo.DimSalesRep;
    DROP TABLE IF EXISTS dbo.DimScenario;
    DROP TABLE IF EXISTS dbo.DimWorkCenter;
    DROP TABLE IF EXISTS dbo.DimPlant;
    DROP TABLE IF EXISTS dbo.DimCostCenter;
    DROP TABLE IF EXISTS dbo.DimDept;
    DROP TABLE IF EXISTS dbo.DimGLAccount;
    DROP TABLE IF EXISTS dbo.DimRegion;
    DROP TABLE IF EXISTS dbo.DimProduct;
    DROP TABLE IF EXISTS dbo.DimCustomer;
    DROP TABLE IF EXISTS dbo.DimDate;

    COMMIT TRAN;
    PRINT '=== DROP COMPLETE ===';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;

    DECLARE @msg nvarchar(4000) =
        CONCAT('Drop failed: ', ERROR_MESSAGE(), ' (', ERROR_NUMBER(), '/', ERROR_SEVERITY(), ') at line ', ERROR_LINE());
    RAISERROR(@msg, 16, 1);
END CATCH

_done:
GO
