-- Daily commodity assumptions (Summer 2025)
IF NOT EXISTS (SELECT 1 FROM dbo.Assumption_CommodityPrices WHERE DateId BETWEEN 20250701 AND 20250831)
INSERT dbo.Assumption_CommodityPrices (DateId, Commodity, PricePerUnit)
VALUES
 (20250702,'Copper', 4.12),(20250702,'Aluminum',1.18),(20250702,'PVC',0.84),
 (20250715,'Copper', 4.20),(20250715,'Aluminum',1.16),(20250715,'PVC',0.85),
 (20250801,'Copper', 4.25),(20250801,'Aluminum',1.19),(20250801,'PVC',0.86);
