# Data Warehouse Demo – Star Schema for Power BI

## Purpose
This repository contains a demo-ready SQL data warehouse built using a star schema to support analytics, reporting, and dashboarding — particularly with Power BI.  
It is designed as a training, proof-of-concept, and reference environment for building high-performance BI models, testing ETL/ELT processes, and demonstrating best practices for dimensional modeling.

The repo includes:
- DDL scripts to create all tables (dimensions, facts, helper/bridge).
- Constraints and indexing scripts to ensure referential integrity and query performance.
- Seed data to populate the database with realistic, interconnected sample data.
- Master scripts for full deploy and teardown.

This setup lets you:
- Deploy a complete demo warehouse in minutes.
- Connect Power BI or other BI tools directly for hands-on modeling.
- Explore how fact/dimension relationships work in a star schema.
- Demonstrate incremental load, SCD Type 2, and scenario analysis patterns.

---

## Star Schema Overview

### What is a Star Schema?
A star schema is a data model that organizes data into:
- Fact tables: Store numeric, additive business metrics (e.g., sales, budgets, forecasts) at a defined grain.
- Dimension tables: Contain descriptive attributes for slicing/dicing facts (e.g., customers, products, dates).
- All dimensions link directly to facts through foreign keys, forming a structure that resembles a star.

### Why a Star Schema?
- Performance: Optimized for analytical queries, aggregates, and BI tool performance.
- Simplicity: Easy for end users to understand — clear join paths, no complex snowflake joins.
- Scalability: Handles large fact volumes efficiently when paired with indexing.
- Best Practice: Recommended by Kimball methodology for analytics systems.

---

## Data Model

**Dimensions** (surrogate keys, some SCD Type 2 ready):
- DimDate – full date intelligence attributes
- DimCustomer – customer master (SCD2)
- DimProduct – product master (SCD2)
- DimRegion, DimGLAccount, DimDept, DimCostCenter, DimPlant, DimWorkCenter
- DimScenario – budget/forecast/scenario tracking
- DimSalesRep – sales rep assignments

**Fact Tables** (business events and measures):
- FactSales – detailed invoice line sales transactions
- FactGLActuals – general ledger postings
- FactBudget – budget plan data
- FactForecast – forward-looking forecasts
- FactAROpen – accounts receivable open items
- FactInventorySnapshot – month-end inventory levels
- FactProduction – production output by plant/work center

**Helper / Bridge Tables**:
- Bridge_AccountToFPnAGroup – account grouping
- Alloc_Drivers – allocation driver weights
- Assumption_CommodityPrices – commodity price assumptions
- WhatIf_Params – adjustable “what-if” variables

---

## Project Structure

    db/
      schema/
        01_create_tables/         # CREATE TABLE scripts (dimensions, facts, helpers)
        02_constraints_indexes/   # FK + index scripts
      seed/                       # One-to-one seed data scripts for each table
      scripts/
        deploy_all.sql             # Run entire deploy & seed sequence
        drop_all.sql               # Drop all tables in correct order
    README.md

---

## How to Use
1. Clone repo and connect to your SQL Server instance.  
2. Run `/scripts/deploy_all.sql` to create and populate all tables.  
3. Connect Power BI (or your BI tool of choice) to the database.  
4. Start exploring relationships, building measures, and testing queries.  
5. To reset, run `/scripts/drop_all.sql` and redeploy.  

---

## Performance
This repo includes indexing scripts to improve query performance significantly.  
These indexes:
- Accelerate fact-to-dimension joins.
- Speed up filtering, grouping, and aggregation in BI queries.
- Keep model refreshes fast as the dataset grows.

---

## Notes
- Seed data reflects recent history (July 2025) and forward forecasts (Aug–Dec 2025).  
- Facts are connected with valid dimension keys to allow immediate analysis.  
- Some dimensions (DimCustomer, DimProduct) are set up for SCD Type 2 changes.

---

## License
Use freely for internal training, demos, or proofs of concept. No warranty is provided.
