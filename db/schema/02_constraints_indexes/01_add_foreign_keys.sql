-- ============================================
-- FOREIGN KEY CONSTRAINTS (STAR SCHEMA WIRING)
-- Run after all CREATE TABLE scripts
-- ============================================

-- ---------------------
-- Dimension → Dimension
-- ---------------------
-- Optional: tie Cost Center to Dept (uncomment if you want this strict link)
-- ALTER TABLE DimCostCenter
--   ADD CONSTRAINT FK_DimCostCenter_Dept
--   FOREIGN KEY (DeptId) REFERENCES DimDept(DeptId);

-- ---------------------
-- Bridge (many-to-many)
-- ---------------------
ALTER TABLE Bridge_AccountToFPnAGroup
  ADD CONSTRAINT FK_Bridge_AccountToFPnAGroup_GLAccount
  FOREIGN KEY (GLAccountId) REFERENCES DimGLAccount(GLAccountId);

ALTER TABLE Bridge_AccountToFPnAGroup
  ADD CONSTRAINT FK_Bridge_AccountToFPnAGroup_FPnAGroup
  FOREIGN KEY (FPnAGroupId) REFERENCES DimFPnAGroup(FPnAGroupId);

-- ---------------------
-- Assumptions
-- ---------------------
ALTER TABLE Assumption_CommodityPrices
  ADD CONSTRAINT FK_Assumption_CommodityPrices_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

-- NOTE: Alloc_Drivers stores flexible Source/Target *Type/*Code pairs.
-- Leave it unconstrained for the demo (you'll join by codes in SQL/Power BI).

-- -----------
-- FactSales
-- -----------
ALTER TABLE FactSales
  ADD CONSTRAINT FK_FactSales_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

ALTER TABLE FactSales
  ADD CONSTRAINT FK_FactSales_Customer
  FOREIGN KEY (CustomerId) REFERENCES DimCustomer(CustomerId);

ALTER TABLE FactSales
  ADD CONSTRAINT FK_FactSales_Product
  FOREIGN KEY (ProductId) REFERENCES DimProduct(ProductId);

ALTER TABLE FactSales
  ADD CONSTRAINT FK_FactSales_Region
  FOREIGN KEY (RegionId) REFERENCES DimRegion(RegionId);

ALTER TABLE FactSales
  ADD CONSTRAINT FK_FactSales_SalesRep
  FOREIGN KEY (SalesRepId) REFERENCES DimSalesRep(SalesRepId);

-- ---------------
-- FactGLActuals
-- ---------------
ALTER TABLE FactGLActuals
  ADD CONSTRAINT FK_FactGLActuals_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

ALTER TABLE FactGLActuals
  ADD CONSTRAINT FK_FactGLActuals_GLAccount
  FOREIGN KEY (GLAccountId) REFERENCES DimGLAccount(GLAccountId);

ALTER TABLE FactGLActuals
  ADD CONSTRAINT FK_FactGLActuals_Dept
  FOREIGN KEY (DeptId) REFERENCES DimDept(DeptId);

ALTER TABLE FactGLActuals
  ADD CONSTRAINT FK_FactGLActuals_CostCenter
  FOREIGN KEY (CostCenterId) REFERENCES DimCostCenter(CostCenterId);

ALTER TABLE FactGLActuals
  ADD CONSTRAINT FK_FactGLActuals_Region
  FOREIGN KEY (RegionId) REFERENCES DimRegion(RegionId);

-- -------------
-- FactBudget
-- -------------
ALTER TABLE FactBudget
  ADD CONSTRAINT FK_FactBudget_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

ALTER TABLE FactBudget
  ADD CONSTRAINT FK_FactBudget_GLAccount
  FOREIGN KEY (GLAccountId) REFERENCES DimGLAccount(GLAccountId);

ALTER TABLE FactBudget
  ADD CONSTRAINT FK_FactBudget_Dept
  FOREIGN KEY (DeptId) REFERENCES DimDept(DeptId);

ALTER TABLE FactBudget
  ADD CONSTRAINT FK_FactBudget_CostCenter
  FOREIGN KEY (CostCenterId) REFERENCES DimCostCenter(CostCenterId);

ALTER TABLE FactBudget
  ADD CONSTRAINT FK_FactBudget_Region
  FOREIGN KEY (RegionId) REFERENCES DimRegion(RegionId);

ALTER TABLE FactBudget
  ADD CONSTRAINT FK_FactBudget_Scenario
  FOREIGN KEY (ScenarioId) REFERENCES DimScenario(ScenarioId);

-- ---------------
-- FactForecast
-- ---------------
ALTER TABLE FactForecast
  ADD CONSTRAINT FK_FactForecast_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

ALTER TABLE FactForecast
  ADD CONSTRAINT FK_FactForecast_GLAccount
  FOREIGN KEY (GLAccountId) REFERENCES DimGLAccount(GLAccountId);

ALTER TABLE FactForecast
  ADD CONSTRAINT FK_FactForecast_Dept
  FOREIGN KEY (DeptId) REFERENCES DimDept(DeptId);

ALTER TABLE FactForecast
  ADD CONSTRAINT FK_FactForecast_CostCenter
  FOREIGN KEY (CostCenterId) REFERENCES DimCostCenter(CostCenterId);

ALTER TABLE FactForecast
  ADD CONSTRAINT FK_FactForecast_Region
  FOREIGN KEY (RegionId) REFERENCES DimRegion(RegionId);

ALTER TABLE FactForecast
  ADD CONSTRAINT FK_FactForecast_Scenario
  FOREIGN KEY (ScenarioId) REFERENCES DimScenario(ScenarioId);

-- -------------
-- FactAROpen
-- -------------
ALTER TABLE FactAROpen
  ADD CONSTRAINT FK_FactAROpen_Customer
  FOREIGN KEY (CustomerId) REFERENCES DimCustomer(CustomerId);

ALTER TABLE FactAROpen
  ADD CONSTRAINT FK_FactAROpen_InvoiceDate
  FOREIGN KEY (InvoiceDateId) REFERENCES DimDate(DateId);

ALTER TABLE FactAROpen
  ADD CONSTRAINT FK_FactAROpen_DueDate
  FOREIGN KEY (DueDateId) REFERENCES DimDate(DateId);

-- -----------------------
-- FactInventorySnapshot
-- -----------------------
ALTER TABLE FactInventorySnapshot
  ADD CONSTRAINT FK_FactInventorySnapshot_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

ALTER TABLE FactInventorySnapshot
  ADD CONSTRAINT FK_FactInventorySnapshot_Product
  FOREIGN KEY (ProductId) REFERENCES DimProduct(ProductId);

ALTER TABLE FactInventorySnapshot
  ADD CONSTRAINT FK_FactInventorySnapshot_Location
  FOREIGN KEY (LocationId) REFERENCES DimPlant(PlantId);

-- ----------------
-- FactProduction
-- ----------------
ALTER TABLE FactProduction
  ADD CONSTRAINT FK_FactProduction_Date
  FOREIGN KEY (DateId) REFERENCES DimDate(DateId);

ALTER TABLE FactProduction
  ADD CONSTRAINT FK_FactProduction_Product
  FOREIGN KEY (ProductId) REFERENCES DimProduct(ProductId);

ALTER TABLE FactProduction
  ADD CONSTRAINT FK_FactProduction_Plant
  FOREIGN KEY (PlantId) REFERENCES DimPlant(PlantId);

ALTER TABLE FactProduction
  ADD CONSTRAINT FK_FactProduction_WorkCenter
  FOREIGN KEY (WorkCenterId) REFERENCES DimWorkCenter(WorkCenterId);

-- ---------------------
-- Dimension → Dimension (optional)
-- ---------------------
ALTER TABLE DimCustomer
  ADD CONSTRAINT FK_DimCustomer_Region
  FOREIGN KEY (RegionId) REFERENCES DimRegion(RegionId);

ALTER TABLE DimSalesRep
  ADD CONSTRAINT FK_DimSalesRep_Region
  FOREIGN KEY (RegionId) REFERENCES DimRegion(RegionId);

ALTER TABLE DimWorkCenter
  ADD CONSTRAINT FK_DimWorkCenter_Plant
  FOREIGN KEY (PlantId) REFERENCES DimPlant(PlantId);

-- Already optional in your script:
-- ALTER TABLE DimCostCenter
--   ADD CONSTRAINT FK_DimCostCenter_Dept
--   FOREIGN KEY (DeptId) REFERENCES DimDept(DeptId);
