-- A few open AR items with risk scores (Summer 2025)
IF NOT EXISTS (SELECT 1 FROM dbo.FactAROpen WHERE ARInvoiceId IN ('AR-2507-1001','AR-2507-1002','AR-2508-1003','AR-2508-1004'))
BEGIN
  INSERT dbo.FactAROpen (CustomerId, InvoiceDateId, DueDateId, ARInvoiceId, Terms, Balance, RiskScore)
  SELECT c.CustomerId, 20250715, 20250814, 'AR-2507-1001', 'Net30', 12500.00, 42.5
  FROM dbo.DimCustomer c WHERE c.CustomerBK='CUST-001'
  UNION ALL
  SELECT c.CustomerId, 20250722, 20250821, 'AR-2507-1002', 'Net30',  8300.00, 55.0
  FROM dbo.DimCustomer c WHERE c.CustomerBK='CUST-002'
  UNION ALL
  SELECT c.CustomerId, 20250801, 20250831, 'AR-2508-1003', 'Net30', 15600.00, 61.0
  FROM dbo.DimCustomer c WHERE c.CustomerBK='CUST-003'
  UNION ALL
  SELECT c.CustomerId, 20250805, 20250904, 'AR-2508-1004', 'Net30',  6200.00, 30.0
  FROM dbo.DimCustomer c WHERE c.CustomerBK='CUST-005';
END