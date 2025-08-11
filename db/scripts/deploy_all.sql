/* ======================================================
   deploy_all.sql  (CI/SSMS/ADS friendly for Azure SQL DB)
   Creates all schema objects in dependency order:
     1) Dimensions, bridges, helpers
     2) Facts
     3) Foreign keys
     4) Indexes
     5) (Optional) Seed data
     6) Sanity checks
   ====================================================== */

:setvar DBName "powerbi-demo-api-database"
:setvar IncludeSeeds "1"     -- 1 = run seeds, 0 = skip seeds

-- Ensure SQLCMD mode is ON if running in SSMS/ADS (Query > SQLCMD Mode)

PRINT '=== START DEPLOY ===';

-- NOTE: On Azure SQL DB, connect directly to the target DB with -d.
-- Do NOT attempt CREATE DATABASE or USE here.

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT '--- Creating Dimensions ---';
:r ../schema/01_create_tables/01_DimDate.sql
:r ../schema/01_create_tables/02_DimCustomer.sql
:r ../schema/01_create_tables/03_DimProduct.sql
:r ../schema/01_create_tables/04_DimRegion.sql
:r ../schema/01_create_tables/05_DimGLAccount.sql
:r ../schema/01_create_tables/06_DimDept.sql
:r ../schema/01_create_tables/07_DimCostCenter.sql
:r ../schema/01_create_tables/08_DimPlant.sql
:r ../schema/01_create_tables/09_DimWorkCenter.sql
:r ../schema/01_create_tables/10_DimScenario.sql
:r ../schema/01_create_tables/11_DimSalesRep.sql
GO

PRINT '--- Creating Bridge & Helper Tables ---';
:r ../schema/01_create_tables/30_Bridge_AccountToFPnAGroup.sql
:r ../schema/01_create_tables/31_Alloc_Drivers.sql
:r ../schema/01_create_tables/32_Assumption_CommodityPrices.sql
:r ../schema/01_create_tables/33_WhatIf_Params.sql
GO

PRINT '--- Creating Facts ---';
:r ../schema/01_create_tables/20_FactSales.sql
:r ../schema/01_create_tables/21_FactGLActuals.sql
:r ../schema/01_create_tables/22_FactBudget.sql
:r ../schema/01_create_tables/23_FactForecast.sql
:r ../schema/01_create_tables/24_FactAROpen.sql
:r ../schema/01_create_tables/25_FactInventorySnapshot.sql
:r ../schema/01_create_tables/26_FactProduction.sql
GO

PRINT '--- Adding Foreign Keys ---';
:r ../schema/02_constraints_indexes/01_add_foreign_keys.sql
GO

PRINT '--- Adding Indexes ---';
:r ../schema/02_constraints_indexes/02_add_indexes.sql
GO

-- 5) Seeds (optional)
IF '$(IncludeSeeds)' = '1'
BEGIN
    PRINT '--- Seeding Dimensions ---';
    :r ../seed/seed_01_DimDate.sql
    :r ../seed/seed_02_DimCustomer.sql
    :r ../seed/seed_03_DimProduct.sql
    :r ../seed/seed_04_DimRegion.sql
    :r ../seed/seed_05_DimGLAccount.sql
    :r ../seed/seed_06_DimDept.sql
    :r ../seed/seed_07_DimCostCenter.sql
    :r ../seed/seed_08_DimPlant.sql
    :r ../seed/seed_09_DimWorkCenter.sql
    :r ../seed/seed_10_DimScenario.sql
    :r ../seed/seed_11_DimSalesRep.sql

    PRINT '--- Seeding Bridge & Helpers ---';
    :r ../seed/seed_30_Bridge_AccountToFPnAGroup.sql
    :r ../seed/seed_31_Alloc_Drivers.sql
    :r ../seed/seed_32_Assumption_CommodityPrices.sql
    :r ../seed/seed_33_WhatIf_Params.sql

    PRINT '--- Seeding Facts ---';
    :r ../seed/seed_20_FactSales.sql
    :r ../seed/seed_21_FactGLActuals.sql
    :r ../seed/seed_22_FactBudget.sql
    :r ../seed/seed_23_FactForecast.sql
    :r ../seed/seed_24_FactAROpen.sql
    :r ../seed/seed_25_FactInventorySnapshot.sql
    :r ../seed/seed_26_FactProduction.sql
END
ELSE
BEGIN
    PRINT 'Seeds are disabled (IncludeSeeds = 0).';
END
GO

-- 6) Sanity checks
PRINT '--- Row Count Sanity Checks ---';
IF OBJECT_ID('tempdb..#counts') IS NOT NULL DROP TABLE #counts;
CREATE TABLE #counts (TableName sysname, RowCount bigint);

INSERT #counts
SELECT t.name,
       SUM(p.rows) AS RowCount
FROM sys.tables t
JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1)
GROUP BY t.name
ORDER BY t.name;

SELECT * FROM #counts ORDER BY TableName;

PRINT '=== DEPLOY COMPLETE ===';
GO
