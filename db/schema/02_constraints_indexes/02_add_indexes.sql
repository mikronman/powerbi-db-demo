/* ===========================================================
   02_add_indexes.sql
   Warehouse indexing: dims, bridge, helpers, facts
   Toggle columnstore for facts with @UseColumnstore.
   =========================================================== */

SET NOCOUNT ON;

DECLARE @UseColumnstore BIT = 1;  -- 1 = CCI on facts (recommended), 0 = rowstore + FK b-tree indexes

/* -------------------------
   Dimensions (rowstore)
   ------------------------- */

-- DimDate: cluster on PK (DateId). Often used for range filters.
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimDate' AND object_id = OBJECT_ID('dbo.DimDate'))
BEGIN
    ALTER TABLE dbo.DimDate
    ADD CONSTRAINT PK_DimDate PRIMARY KEY CLUSTERED (DateId);
END

-- DimCustomer: PK clustered (CustomerId), filtered current BK for SCD2 lookups
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimCustomer' AND object_id = OBJECT_ID('dbo.DimCustomer'))
BEGIN
    ALTER TABLE dbo.DimCustomer
    ADD CONSTRAINT PK_DimCustomer PRIMARY KEY CLUSTERED (CustomerId);
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimCustomer_CurrentBK' AND object_id = OBJECT_ID('dbo.DimCustomer'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimCustomer_CurrentBK
        ON dbo.DimCustomer (CustomerBK)
        INCLUDE (CustomerId, RegionId, CustomerName)
        WHERE IsCurrent = 1;
END

-- DimProduct: PK clustered, filtered current BK
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimProduct' AND object_id = OBJECT_ID('dbo.DimProduct'))
BEGIN
    ALTER TABLE dbo.DimProduct
    ADD CONSTRAINT PK_DimProduct PRIMARY KEY CLUSTERED (ProductId);
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimProduct_CurrentBK' AND object_id = OBJECT_ID('dbo.DimProduct'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimProduct_CurrentBK
        ON dbo.DimProduct (ProductBK)
        INCLUDE (ProductId, ProductCategory, UOM)
        WHERE IsCurrent = 1;
END

-- DimRegion
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimRegion' AND object_id = OBJECT_ID('dbo.DimRegion'))
BEGIN
    ALTER TABLE dbo.DimRegion
    ADD CONSTRAINT PK_DimRegion PRIMARY KEY CLUSTERED (RegionId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimRegion_Code' AND object_id = OBJECT_ID('dbo.DimRegion'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimRegion_Code ON dbo.DimRegion (RegionCode);
END

-- DimGLAccount
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimGLAccount' AND object_id = OBJECT_ID('dbo.DimGLAccount'))
BEGIN
    ALTER TABLE dbo.DimGLAccount
    ADD CONSTRAINT PK_DimGLAccount PRIMARY KEY CLUSTERED (GLAccountId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimGLAccount_Number' AND object_id = OBJECT_ID('dbo.DimGLAccount'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimGLAccount_Number ON dbo.DimGLAccount (GLAccountNumber);
END

-- DimDept
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimDept' AND object_id = OBJECT_ID('dbo.DimDept'))
BEGIN
    ALTER TABLE dbo.DimDept
    ADD CONSTRAINT PK_DimDept PRIMARY KEY CLUSTERED (DeptId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimDept_Code' AND object_id = OBJECT_ID('dbo.DimDept'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimDept_Code ON dbo.DimDept (DeptCode);
END

-- DimCostCenter
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimCostCenter' AND object_id = OBJECT_ID('dbo.DimCostCenter'))
BEGIN
    ALTER TABLE dbo.DimCostCenter
    ADD CONSTRAINT PK_DimCostCenter PRIMARY KEY CLUSTERED (CostCenterId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimCostCenter_Code' AND object_id = OBJECT_ID('dbo.DimCostCenter'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimCostCenter_Code ON dbo.DimCostCenter (CostCenterCode);
END

-- DimPlant
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimPlant' AND object_id = OBJECT_ID('dbo.DimPlant'))
BEGIN
    ALTER TABLE dbo.DimPlant
    ADD CONSTRAINT PK_DimPlant PRIMARY KEY CLUSTERED (PlantId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimPlant_Code' AND object_id = OBJECT_ID('dbo.DimPlant'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimPlant_Code ON dbo.DimPlant (PlantCode);
END

-- DimWorkCenter
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimWorkCenter' AND object_id = OBJECT_ID('dbo.DimWorkCenter'))
BEGIN
    ALTER TABLE dbo.DimWorkCenter
    ADD CONSTRAINT PK_DimWorkCenter PRIMARY KEY CLUSTERED (WorkCenterId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimWorkCenter_Code' AND object_id = OBJECT_ID('dbo.DimWorkCenter'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimWorkCenter_Code ON dbo.DimWorkCenter (WorkCenterCode);
END

-- DimScenario
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimScenario' AND object_id = OBJECT_ID('dbo.DimScenario'))
BEGIN
    ALTER TABLE dbo.DimScenario
    ADD CONSTRAINT PK_DimScenario PRIMARY KEY CLUSTERED (ScenarioId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimScenario_Code' AND object_id = OBJECT_ID('dbo.DimScenario'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimScenario_Code ON dbo.DimScenario (ScenarioCode);
END

-- DimSalesRep (optional)
IF OBJECT_ID('dbo.DimSalesRep') IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimSalesRep' AND object_id = OBJECT_ID('dbo.DimSalesRep'))
BEGIN
    ALTER TABLE dbo.DimSalesRep
    ADD CONSTRAINT PK_DimSalesRep PRIMARY KEY CLUSTERED (SalesRepId);
END
IF OBJECT_ID('dbo.DimSalesRep') IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimSalesRep_Code' AND object_id = OBJECT_ID('dbo.DimSalesRep'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimSalesRep_Code ON dbo.DimSalesRep (SalesRepCode);
END

/* -------------------------
   Bridge / Helper tables
   ------------------------- */

-- DimFPnAGroup
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_DimFPnAGroup' AND object_id = OBJECT_ID('dbo.DimFPnAGroup'))
BEGIN
    ALTER TABLE dbo.DimFPnAGroup
    ADD CONSTRAINT PK_DimFPnAGroup PRIMARY KEY CLUSTERED (FPnAGroupId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimFPnAGroup_Code' AND object_id = OBJECT_ID('dbo.DimFPnAGroup'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_DimFPnAGroup_Code ON dbo.DimFPnAGroup (FPnAGroupCode);
END

-- Bridge_AccountToFPnAGroup: cluster PK on (GLAccountId, FPnAGroupId); add reverse lookup
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_Bridge_AccountToFPnAGroup' AND object_id = OBJECT_ID('dbo.Bridge_AccountToFPnAGroup'))
BEGIN
    ALTER TABLE dbo.Bridge_AccountToFPnAGroup
    ADD CONSTRAINT PK_Bridge_AccountToFPnAGroup PRIMARY KEY CLUSTERED (GLAccountId, FPnAGroupId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Bridge_FPnAGroup_GLAccount' AND object_id = OBJECT_ID('dbo.Bridge_AccountToFPnAGroup'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Bridge_FPnAGroup_GLAccount ON dbo.Bridge_AccountToFPnAGroup (FPnAGroupId, GLAccountId);
END

-- Alloc_Drivers: typical lookups by Period + Source/Target
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AllocDrivers_Period' AND object_id = OBJECT_ID('dbo.Alloc_Drivers'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_AllocDrivers_Period ON dbo.Alloc_Drivers (PeriodId);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AllocDrivers_Source' AND object_id = OBJECT_ID('dbo.Alloc_Drivers'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_AllocDrivers_Source
        ON dbo.Alloc_Drivers (SourceEntityType, SourceEntityCode) INCLUDE (PeriodId, DriverType, DriverValue);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AllocDrivers_Target' AND object_id = OBJECT_ID('dbo.Alloc_Drivers'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_AllocDrivers_Target
        ON dbo.Alloc_Drivers (TargetEntityType, TargetEntityCode) INCLUDE (PeriodId, DriverType, DriverValue);
END

-- Assumption_CommodityPrices: date+commodity filtering
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Assumption_CommodityPrices_DateCommodity' AND object_id = OBJECT_ID('dbo.Assumption_CommodityPrices'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Assumption_CommodityPrices_DateCommodity
        ON dbo.Assumption_CommodityPrices (DateId, Commodity) INCLUDE (PricePerUnit);
END

-- WhatIf_Params: unique on ParamName already; add updatedAt sorter
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_WhatIf_Params_UpdatedAt' AND object_id = OBJECT_ID('dbo.WhatIf_Params'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_WhatIf_Params_UpdatedAt ON dbo.WhatIf_Params (UpdatedAt);
END

/* -------------------------
   Facts
   ------------------------- */

-- ============ OPTION A: Columnstore (recommended for large facts) ============
IF @UseColumnstore = 1
BEGIN
    -- FactSales
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactSales' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactSales ON dbo.FactSales;
    END
    -- Optional narrow lookup for invoice tracing
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_Invoice' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_Invoice
            ON dbo.FactSales (InvoiceId, InvoiceLineNumber) INCLUDE (DateId, CustomerId, ProductId, NetRevenue);
    END

    -- FactGLActuals
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactGLActuals' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactGLActuals ON dbo.FactGLActuals;
    END

    -- FactBudget
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactBudget' AND object_id = OBJECT_ID('dbo.FactBudget'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactBudget ON dbo.FactBudget;
    END

    -- FactForecast
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactForecast' AND object_id = OBJECT_ID('dbo.FactForecast'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactForecast ON dbo.FactForecast;
    END

    -- FactAROpen
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactAROpen' AND object_id = OBJECT_ID('dbo.FactAROpen'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactAROpen ON dbo.FactAROpen;
    END
    -- Targeted lookup: collections workflows by customer/due date
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactAROpen_CustomerDue' AND object_id = OBJECT_ID('dbo.FactAROpen'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactAROpen_CustomerDue
            ON dbo.FactAROpen (CustomerId, DueDateId) INCLUDE (Balance, Terms, ARInvoiceId);
    END

    -- FactInventorySnapshot
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactInventorySnapshot' AND object_id = OBJECT_ID('dbo.FactInventorySnapshot'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactInventorySnapshot ON dbo.FactInventorySnapshot;
    END

    -- FactProduction
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'CCI_FactProduction' AND object_id = OBJECT_ID('dbo.FactProduction'))
    BEGIN
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactProduction ON dbo.FactProduction;
    END
END
ELSE
-- ============ OPTION B: Rowstore facts (dev/smaller data) ===================
BEGIN
    -- FactSales
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactSales' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        ALTER TABLE dbo.FactSales
        ADD CONSTRAINT PK_FactSales PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_Date' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_Date ON dbo.FactSales (DateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_Cust' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_Cust ON dbo.FactSales (CustomerId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_Prod' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_Prod ON dbo.FactSales (ProductId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_Region' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_Region ON dbo.FactSales (RegionId);
    END
    IF OBJECT_ID('dbo.DimSalesRep') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_SalesRep' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_SalesRep ON dbo.FactSales (SalesRepId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactSales_Invoice' AND object_id = OBJECT_ID('dbo.FactSales'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactSales_Invoice
            ON dbo.FactSales (InvoiceId, InvoiceLineNumber) INCLUDE (DateId, CustomerId, ProductId, NetRevenue);
    END

    -- FactGLActuals
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactGLActuals' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        ALTER TABLE dbo.FactGLActuals
        ADD CONSTRAINT PK_FactGLActuals PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactGLActuals_Date' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactGLActuals_Date ON dbo.FactGLActuals (DateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactGLActuals_GLAccount' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactGLActuals_GLAccount ON dbo.FactGLActuals (GLAccountId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactGLActuals_Dept' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactGLActuals_Dept ON dbo.FactGLActuals (DeptId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactGLActuals_CostCenter' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactGLActuals_CostCenter ON dbo.FactGLActuals (CostCenterId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactGLActuals_Region' AND object_id = OBJECT_ID('dbo.FactGLActuals'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactGLActuals_Region ON dbo.FactGLActuals (RegionId);
    END

    -- FactBudget
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactBudget' AND object_id = OBJECT_ID('dbo.FactBudget'))
    BEGIN
        ALTER TABLE dbo.FactBudget
        ADD CONSTRAINT PK_FactBudget PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactBudget_Date' AND object_id = OBJECT_ID('dbo.FactBudget'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactBudget_Date ON dbo.FactBudget (DateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactBudget_GLAccount' AND object_id = OBJECT_ID('dbo.FactBudget'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactBudget_GLAccount ON dbo.FactBudget (GLAccountId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactBudget_Scenario' AND object_id = OBJECT_ID('dbo.FactBudget'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactBudget_Scenario ON dbo.FactBudget (ScenarioId);
    END

    -- FactForecast
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactForecast' AND object_id = OBJECT_ID('dbo.FactForecast'))
    BEGIN
        ALTER TABLE dbo.FactForecast
        ADD CONSTRAINT PK_FactForecast PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactForecast_Date' AND object_id = OBJECT_ID('dbo.FactForecast'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactForecast_Date ON dbo.FactForecast (DateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactForecast_GLAccount' AND object_id = OBJECT_ID('dbo.FactForecast'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactForecast_GLAccount ON dbo.FactForecast (GLAccountId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactForecast_Scenario' AND object_id = OBJECT_ID('dbo.FactForecast'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactForecast_Scenario ON dbo.FactForecast (ScenarioId);
    END

    -- FactAROpen
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactAROpen' AND object_id = OBJECT_ID('dbo.FactAROpen'))
    BEGIN
        ALTER TABLE dbo.FactAROpen
        ADD CONSTRAINT PK_FactAROpen PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactAROpen_Customer' AND object_id = OBJECT_ID('dbo.FactAROpen'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactAROpen_Customer ON dbo.FactAROpen (CustomerId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactAROpen_InvoiceDate' AND object_id = OBJECT_ID('dbo.FactAROpen'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactAROpen_InvoiceDate ON dbo.FactAROpen (InvoiceDateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactAROpen_DueDate' AND object_id = OBJECT_ID('dbo.FactAROpen'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactAROpen_DueDate ON dbo.FactAROpen (DueDateId);
    END

    -- FactInventorySnapshot
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactInventorySnapshot' AND object_id = OBJECT_ID('dbo.FactInventorySnapshot'))
    BEGIN
        ALTER TABLE dbo.FactInventorySnapshot
        ADD CONSTRAINT PK_FactInventorySnapshot PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactInventorySnapshot_Date' AND object_id = OBJECT_ID('dbo.FactInventorySnapshot'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactInventorySnapshot_Date ON dbo.FactInventorySnapshot (DateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactInventorySnapshot_Product' AND object_id = OBJECT_ID('dbo.FactInventorySnapshot'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactInventorySnapshot_Product ON dbo.FactInventorySnapshot (ProductId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactInventorySnapshot_Location' AND object_id = OBJECT_ID('dbo.FactInventorySnapshot'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactInventorySnapshot_Location ON dbo.FactInventorySnapshot (LocationId);
    END

    -- FactProduction
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_FactProduction' AND object_id = OBJECT_ID('dbo.FactProduction'))
    BEGIN
        ALTER TABLE dbo.FactProduction
        ADD CONSTRAINT PK_FactProduction PRIMARY KEY CLUSTERED (FactId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactProduction_Date' AND object_id = OBJECT_ID('dbo.FactProduction'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactProduction_Date ON dbo.FactProduction (DateId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactProduction_Product' AND object_id = OBJECT_ID('dbo.FactProduction'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactProduction_Product ON dbo.FactProduction (ProductId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactProduction_Plant' AND object_id = OBJECT_ID('dbo.FactProduction'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactProduction_Plant ON dbo.FactProduction (PlantId);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactProduction_WorkCenter' AND object_id = OBJECT_ID('dbo.FactProduction'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_FactProduction_WorkCenter ON dbo.FactProduction (WorkCenterId);
    END
END
GO

/* -------------------------
   Notes:
   - Leave foreign keys unindexed on facts when using CCI; batch mode + segment elimination usually win.
   - Added selective NC indexes where operational lookups matter (e.g., invoices, AR collections).
   - SCD2 filtered indexes speed “current row” lookups by business key.
   - If you bulk load, consider creating CCIs after load for faster ingest, then rebuild.
   ------------------------- */
