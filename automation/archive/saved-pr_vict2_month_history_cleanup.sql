-- Please press Visualize Query context menu item to synchronize query and diagram after editing.

CREATE TABLE AAA6863.PR_PRICE_CAT_HISTORY_201808 NOLOGGING
AS
   (SELECT V2.YEARMONTH,
           V2.INVOICE_NUMBER_GK,
           V2.PRICE_CODE,
           V2.ORIG_PRICE_CODE,
           V2.INVOICE_LINE_NUMBER,
           V2.PRODUCT_GK,
           V2.SPECIAL_PRODUCT_GK,
           V2.EXT_AVG_COGS_AMOUNT,
           V2.CORE_ADJ_AVG_COST,
           V2.EXT_ACTUAL_COGS_AMOUNT,
           V2.EXT_SALES_AMOUNT,
           V2.PRICE_CATEGORY,
           V2.PRICE_CATEGORY_OVR_PR,
           V2.PRICE_CATEGORY_OVR_GR,
           CASE
              WHEN     COALESCE (V2.PRICE_CATEGORY_OVR_PR,
                                 V2.PRICE_CATEGORY_OVR_GR,
                                 V2.PRICE_CATEGORY) IN
                          ('MANUAL', 'QUOTE', 'MATRIX_BID')
                   AND V2.ORIG_PRICE_CODE IS NOT NULL
              THEN
                 CASE
                    WHEN REGEXP_LIKE (V2.ORIG_PRICE_CODE,
                                      '[0-9]?[0-9]?[0-9]')
                    THEN
                       'MATRIX'
                    WHEN V2.ORIG_PRICE_CODE IN ('FC', 'PM', 'SPEC')
                    THEN
                       'MATRIX'
                    WHEN V2.ORIG_PRICE_CODE LIKE 'M%'
                    THEN
                       'NDP'
                    WHEN V2.ORIG_PRICE_CODE IN ('CPA', 'CPO')
                    THEN
                       'OVERRIDE'
                    WHEN V2.ORIG_PRICE_CODE IN ('PR',
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
                    WHEN V2.ORIG_PRICE_CODE IN ('GI',
                                                'GPC',
                                                'HPF',
                                                'HPN',
                                                'NC')
                    THEN
                       'MANUAL'
                    WHEN V2.ORIG_PRICE_CODE = '*E'
                    THEN
                       'OTH/ERROR'
                    WHEN V2.ORIG_PRICE_CODE = 'SKC'
                    THEN
                       'OTH/ERROR'
                    WHEN V2.ORIG_PRICE_CODE IN ('%',
                                                '$',
                                                'N',
                                                'F',
                                                'B',
                                                'PO')
                    THEN
                       'TOOLS'
                    WHEN V2.ORIG_PRICE_CODE IS NULL
                    THEN
                       'MANUAL'
                    ELSE
                       'MANUAL'
                 END
              ELSE
                 COALESCE (V2.PRICE_CATEGORY_OVR_PR,
                           V2.PRICE_CATEGORY_OVR_GR,
                           V2.PRICE_CATEGORY)
           END
              PRICE_CATEGORY_FINAL,
           V2.PROCESS_DATE,
           V2.PRICE_FORMULA
    FROM AAA6863.PR_VICT2_CUST_201808 V2);