IF NOT EXISTS (SELECT 1 FROM dbo.DimProduct)
BEGIN
  INSERT dbo.DimProduct (ProductBK, ProductName, ProductCategory, MaterialType, UOM, EffectiveFrom, EffectiveTo, IsCurrent)
  VALUES
  -- Coaxial
  ('SKU-COAX-RG6',     'RG6 Coaxial Cable',                  'Coaxial','Copper','FT','2023-01-01',NULL,1),
  ('SKU-COAX-RG6P',    'RG6 Coaxial Cable - Plenum',         'Coaxial','Copper','FT','2023-01-01',NULL,1),
  ('SKU-COAX-RG11',    'RG11 Coaxial Cable',                 'Coaxial','Copper','FT','2023-01-01',NULL,1),

  -- Fire Alarm / Security
  ('SKU-FIRE-FPLP',    'Fire Alarm Cable FPLP (Plenum)',     'Fire Alarm','Copper','FT','2023-01-01',NULL,1),
  ('SKU-FIRE-FPLR',    'Fire Alarm Cable FPLR (Riser)',      'Fire Alarm','Copper','FT','2023-01-01',NULL,1),
  ('SKU-SEC-CMR-U',    'Security Cable CMR Unshielded',      'Security','Copper','FT','2023-01-01',NULL,1),
  ('SKU-SEC-CMP-S',    'Security Cable CMP Shielded',        'Security','Copper','FT','2023-01-01',NULL,1),

  -- Control / Specialty LV
  ('SKU-CTRL-CMP-SP',  'Control Cable CMP Shielded Pairs',   'Control','Copper','FT','2023-01-01',NULL,1),
  ('SKU-CTRL-DB',      'Direct-Burial Control Cable',        'Control','Copper','FT','2023-01-01',NULL,1),
  ('SKU-AUD-SPK',      'Audio/Speaker Cable 4C',             'Audio','Copper','FT','2023-01-01',NULL,1),
  ('SKU-LAND-LIGHT',   'Landscape Lighting Cable',           'Specialty LV','Copper','FT','2023-01-01',NULL,1),

  -- Building Wire
  ('SKU-BLD-THHN',     'THHN/THWN-2 Building Wire',          'Building Wire','Copper','FT','2023-01-01',NULL,1),
  ('SKU-BLD-XHHW2-CU', 'XHHW-2 Building Wire (Copper)',      'Building Wire','Copper','FT','2023-01-01',NULL,1),
  ('SKU-BLD-USE2-AL',  'USE-2 Building Wire (Aluminum)',     'Building Wire','Aluminum','FT','2023-01-01',NULL,1),

  -- Tray Cable
  ('SKU-TRAY-PVC-U',   'Tray Cable THHN/PVC Unshielded',     'Tray Cable','Copper','FT','2023-01-01',NULL,1),
  ('SKU-TRAY-PVC-S',   'Tray Cable THHN/PVC Shielded',       'Tray Cable','Copper','FT','2023-01-01',NULL,1),

  -- Automotive / Hook-Up
  ('SKU-AUTO-SGT',     'Automotive Battery Cable SGT',       'Automotive','Copper','FT','2023-01-01',NULL,1),
  ('SKU-HOOK-UL1015',  'Hook-Up Wire UL1015',                'Hook-Up','Copper','FT','2023-01-01',NULL,1),

  -- Traffic / IMSA-style
  ('SKU-TRAF-19-1',    'Traffic Signal Cable (19-1 style)',  'Traffic','Copper','FT','2023-01-01',NULL,1),

  -- Renewable Energy
  ('SKU-PV-USE2-CU',   'PV USE-2 Cable (Copper)',            'Renewable','Copper','FT','2023-01-01',NULL,1),
  ('SKU-PV-WIRE-2KV',  'PV Wire 2000V (Copper)',             'Renewable','Copper','FT','2023-01-01',NULL,1),

  -- RF / Communications
  ('SKU-RF-RG58',      '50Ω RF Coax Cable RG-58',            'RF','Copper','FT','2023-01-01',NULL,1),
  ('SKU-RF-CONN',      'RF Coax Connectors & Adapters',      'RF','Mixed','EA','2023-01-01',NULL,1),

  -- Irrigation
  ('SKU-IRR-SPRINK',   'Sprinkler Control Cable',            'Irrigation','Copper','FT','2023-01-01',NULL,1),
  ('SKU-IRR-PUMP-FL',  'Flat Pump Cable (Heavy Duty)',       'Irrigation','Copper','FT','2023-01-01',NULL,1);

  -- SCD2 change for RG6: close original, add Rev B
  UPDATE dbo.DimProduct
    SET EffectiveTo = '2024-03-31', IsCurrent = 0
  WHERE ProductBK = 'SKU-COAX-RG6' AND EffectiveFrom = '2023-01-01';

  INSERT dbo.DimProduct (ProductBK, ProductName, ProductCategory, MaterialType, UOM, EffectiveFrom, EffectiveTo, IsCurrent)
  VALUES ('SKU-COAX-RG6', 'RG6 Coaxial Cable (Rev B)', 'Coaxial','Copper','FT','2024-04-01',NULL,1);
END