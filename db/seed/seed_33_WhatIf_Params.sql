-- Global what-if parameters
IF NOT EXISTS (SELECT 1 FROM dbo.WhatIf_Params)
INSERT dbo.WhatIf_Params (ParamName, ParamValue)
VALUES ('PriceLiftPct', 0.025),
       ('ChurnDelta',   0.010),
       ('CopperPct',    0.340),
       ('DiscountPct',  0.050);