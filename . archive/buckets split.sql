CASE
  WHEN ihf.order_code = 'IC'
  THEN
     'CREDITS'
  WHEN ihf.order_code = 'SP'
  THEN
     'SPECIALS'
  WHEN ilf.price_code = 'Q'
  THEN
     'QUOTE'
  WHEN REGEXP_LIKE (ilf.price_code, '[0-9]?[0-9]?[0-9]')
  THEN
     'MATRIX'
  WHEN ilf.price_code IN ('FC', 'PM')
  THEN
     'MATRIX'
  WHEN ilf.price_code LIKE 'M%'
  THEN
     'MATRIX'
  WHEN ilf.price_formula IN ('CPA', 'CPO')
  THEN
     'OVERRIDE' --CONTRACTS
  WHEN ilf.price_code IN ('PR', 'GR', 'CB', 'GJ', 'PJ', '*G', '*P', 'G*', 'P*', 'G', 'GJ', 'P')
  THEN
     'OVERRIDE' --CONTRACTS
  WHEN ilf.price_code IN ('GI', 'GPC', 'HPF', 'HPN', 'NC')
  THEN
     'MANUAL'
  WHEN ilf.price_code = '*E'
  THEN
     'OTH/ERROR'
  WHEN ilf.price_code = 'SKC'
  THEN
     'OTH/ERROR'
  WHEN ilf.price_code IN ('%', '$', 'N', 'F', 'B', 'PO')
  THEN
     'TOOLS'
  WHEN ilf.price_code IS NULL
  THEN
     'MANUAL'
  WHEN ilf.price_code IN ('R', 'N/A')
  THEN
     CASE
        WHEN ROUND (NVL (ilf.MATRIX_PRICE, ilf.MATRIX), 2) = --Rounding needed for net price comparison
                ilf.UNIT_NET_PRICE_AMOUNT
        THEN
           'MATRIX'
        WHEN ihf.CONTRACT_NUMBER IS NOT NULL
        THEN
           'OVERRIDE' --CONTRACTS
        ELSE
           'MANUAL'
     END
  ELSE
     'MANUAL'
END
      AS PRICE_CATEGORY,
