TRUNCATE TABLE PRICE_MGMT.PR_PRICE_CAT_HIST_TEMP;
DROP TABLE PRICE_MGMT.PR_PRICE_CAT_HIST_TEMP;
CREATE TABLE PRICE_MGMT.PR_PRICE_CAT_HIST_TEMP
NOLOGGING
AS
SELECT X.YEARMONTH,
      X.INVOICE_NUMBER_GK,
      X.PRICE_CODE,
      X.ORIG_PRICE_CODE,
      X.INVOICE_LINE_NUMBER,
      X.PRODUCT_GK,
      X.SPECIAL_PRODUCT_GK,
      X.EXT_AVG_COGS_AMOUNT,
      X.CORE_ADJ_AVG_COST,
      X.EXT_ACTUAL_COGS_AMOUNT,
      X.EXT_SALES_AMOUNT,
      X.PRICE_CATEGORY,
      X.PRICE_CATEGORY_OVR_PR,
      X.PRICE_CATEGORY_OVR_GR,
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
             PRICE_CATEGORY_FINAL,
      X.INSERT_TIMESTAMP,
      X.PROCESS_DATE,
      X.PRICE_FORMULA

FROM  PRICE_MGMT.PR_PRICE_CAT_HISTORY_PURGED X
;
GRANT SELECT ON PRICE_MGMT.PR_PRICE_CAT_HIST_TEMP TO PUBLIC;