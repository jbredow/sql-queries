TRUNCATE TABLE AAA6863.PR_PRICE_CAT_HIST_201809;
DROP TABLE AAA6863.PR_PRICE_CAT_HIST_201809;
CREATE TABLE AAA6863.PR_PRICE_CAT_HIST_201809
NOLOGGING
AS
SELECT YEARMONTH,
      INVOICE_NUMBER_GK,
      PRICE_CODE,
      ORIG_PRICE_CODE,
      INVOICE_LINE_NUMBER,
      PRODUCT_GK,
      SPECIAL_PRODUCT_GK,
      EXT_AVG_COGS_AMOUNT,
      CORE_ADJ_AVG_COST,
      EXT_ACTUAL_COGS_AMOUNT,
      EXT_SALES_AMOUNT,
      PRICE_CATEGORY,
      PRICE_CATEGORY_OVR_PR,
      PRICE_CATEGORY_OVR_GR,
      PRICE_CATEGORY_FINAL,
      INSERT_TIMESTAMP,
      PROCESS_DATE,
      PRICE_FORMULA,
      CASE 
             WHEN     COALESCE (X.PRICE_CATEGORY_OVR_PR,
                                X.PRICE_CATEGORY_OVR_GR,
                                X.PRICE_CATEGORY) IN
                         ('MANUAL', 'QUOTE', 'MATRIX_BID')
                  AND X.ORIG_PRICE_CODE IS NOT NULL
             THEN
                CASE
                   WHEN REGEXP_LIKE (X.ORIG_PRICE_CODE, '[0-9]?[0-9]?[0-9]')
                   THEN
                      'MATRIX'
                   WHEN X.ORIG_PRICE_CODE IN ('FC', 'PM', 'SPEC')
                   THEN
                      'MATRIX'
                   WHEN X.ORIG_PRICE_CODE LIKE 'M%'
                   THEN
                      'NDP'
                   WHEN X.ORIG_PRICE_CODE IN ('CPA', 'CPO')
                   THEN
                      'OVERRIDE'
                   WHEN X.ORIG_PRICE_CODE IN ('PR',
                                              'GR',
                                              'CB',
                                              'GJ',
                                              'PJ',
                                              '*G',
                                              '*P',
                                              'G*',
                                              'P*',
                                              'G',
                                              'GJ',
                                              'P')
                   THEN
                      'OVERRIDE'
                   WHEN X.ORIG_PRICE_CODE IN ('GI',
                                              'GPC',
                                              'HPF',
                                              'HPN',
                                              'NC')
                   THEN
                      'MANUAL'
                   WHEN X.ORIG_PRICE_CODE = '*E'
                   THEN
                      'OTH/ERROR'
                   WHEN X.ORIG_PRICE_CODE = 'SKC'
                   THEN
                      'OTH/ERROR'
                   WHEN X.ORIG_PRICE_CODE IN ('%',
                                              '$',
                                              'N',
                                              'F',
                                              'B',
                                              'PO')
                   THEN
                      'TOOLS'
                   WHEN X.ORIG_PRICE_CODE IS NULL
                   THEN
                      'MANUAL'
                   ELSE
                      'MANUAL'
                END
             ELSE
                COALESCE (X.PRICE_CATEGORY_OVR_PR,
                          X.PRICE_CATEGORY_OVR_GR,
                          X.PRICE_CATEGORY)
          END
             PRICE_CATEGORY_FINAL

FROM 

;
GRANT SELECT ON AAA6863.PR_PRICE_CAT_HIST_201809 TO PUBLIC;