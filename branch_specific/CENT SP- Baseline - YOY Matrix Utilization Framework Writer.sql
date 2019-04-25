SELECT SLS.REGION,
       SLS.DISTRICT,
       SLS.ACCOUNT_NAME,
       -- SLS.WHSE,
       -- SLS.CUST_BUS_GRP,
       SLS.WRITER,
       -- SLS.REP_INIT,
       -- SLS.SALESREP_NAME
       -- SLS.CUST_BUS_GRP,
       --SLS.ORDER_CHANNEL,
       -- SLS.DISC_GRP,
       -- SLS.REP_INIT,
       -- SLS.SALESREP_NAME,
       NVL (
          SUM (
             CASE
                WHEN SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
                THEN
                   SLS.EXT_SALES_AMOUNT
                ELSE
                   0
             END),
          0)
          EX_SALES,
       NVL (
          SUM (
             CASE
                WHEN SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
                THEN
                   SLS.EXT_AVG_COGS_AMOUNT
                ELSE
                   0
             END),
          0)
          EX_COGS,
       NVL (
          SUM (
             CASE
                WHEN SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
                THEN
                   SLS.TOTAL_LINES
                ELSE
                   0
             END),
          0)
          EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MATRIX_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN ('OVERRIDE')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          OVERRIDE_LINES,
       /* MANUAL */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MANUAL', 'QUOTE', 'TOOLS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MANUAL_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MANUAL', 'QUOTE', 'TOOLS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MANUAL_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MANUAL', 'QUOTE', 'TOOLS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          SP_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          SP_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          CREDITS_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          OUTBOUND_LINES,
       NVL (
          SUM (
             CASE
                WHEN SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
                THEN
                   SLS.EXT_SALES_AMOUNT
                ELSE
                   0
             END),
          0)
          LY_EX_SALES,
       NVL (
          SUM (
             CASE
                WHEN SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
                THEN
                   SLS.EXT_AVG_COGS_AMOUNT
                ELSE
                   0
             END),
          0)
          LY_EX_COGS,
       NVL (
          SUM (
             CASE
                WHEN SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
                THEN
                   SLS.TOTAL_LINES
                ELSE
                   0
             END),
          0)
          LY_EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_MATRIX_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_MATRIX_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN ('OVERRIDE')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_OVERRIDE_LINES,
       /* MANUAL */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MANUAL', 'QUOTE', 'TOOLS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_MANUAL_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MANUAL', 'QUOTE', 'TOOLS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_MANUAL_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN
                         ('MANUAL', 'QUOTE', 'TOOLS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_SP_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_SP_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_CREDITS_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_CREDITS_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     SLS.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND SLS.FISCAL_YEAR_TO_DATE IN 'LAST YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_OUTBOUND_LINES
FROM (SELECT TPD.FISCAL_YEAR_TO_DATE,
             SWD.DIVISION_NAME
                REGION,
             SWD.REGION_NAME
                DISTRICT,
             SWD.ACCOUNT_NAME,
             IHF.WRITER,
             ILF.PRODUCT_STATUS,
             --IHF.WAREHOUSE_NUMBER WHSE,
             -- NVL(BG.BUSINESS_GROUP,'OTHER') CUST_BUS_GRP,
             CHAN.ORDER_CHANNEL,
             -- NVL (PROD.DISCOUNT_GROUP_NK, 'SP-') DISC_GRP,
             -- CUST.SALESMAN_CODE REP_INIT,
             -- NVL(REPS.SALESREP_NAME, 'UNKNOWN') SALESREP_NAME,
             CASE
                WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                   HIST.PRICE_CATEGORY_OVR_GR,
                                   HIST.PRICE_CATEGORY) IN
                            ('MANUAL', 'QUOTE', 'MATRIX_BID')
                     AND HIST.ORIG_PRICE_CODE IS NOT NULL
                THEN
                   CASE
                      WHEN     REGEXP_LIKE (HIST.orig_price_code,
                                            '[0-9]?[0-9]?[0-9]')
                           AND LENGTH (HIST.PRICE_FORMULA) = 7
                      THEN
                         'MATRIX'
                      WHEN HIST.orig_price_code IN ('FC', 'PM', 'spec')
                      THEN
                         'MATRIX'
                      WHEN HIST.orig_price_code LIKE 'M%'
                      THEN
                         'NDP'
                      WHEN HIST.orig_price_code IN ('CPA', 'CPO')
                      THEN
                         'OVERRIDE'
                      WHEN HIST.orig_price_code IN ('PR',
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
                      WHEN HIST.orig_price_code IN ('GI',
                                                    'GPC',
                                                    'HPF',
                                                    'HPN',
                                                    'NC')
                      THEN
                         'MANUAL'
                      WHEN HIST.orig_price_code = '*E'
                      THEN
                         'OTH/ERROR'
                      WHEN HIST.orig_price_code = 'SKC'
                      THEN
                         'OTH/ERROR'
                      WHEN HIST.orig_price_code IN ('%',
                                                    '$',
                                                    'N',
                                                    'F',
                                                    'B',
                                                    'PO')
                      THEN
                         'TOOLS'
                      WHEN HIST.orig_price_code IS NULL
                      THEN
                         'MANUAL'
                      ELSE
                         'MANUAL'
                   END
                ELSE
                   COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                             HIST.PRICE_CATEGORY_OVR_GR,
                             HIST.PRICE_CATEGORY)
             END
                PRICE_CATEGORY_FINAL,
             SUM (HIST.EXT_SALES_AMOUNT)
                EXT_SALES_AMOUNT,
             COUNT (HIST.INVOICE_LINE_NUMBER)
                TOTAL_LINES,
             SUM (HIST.EXT_AVG_COGS_AMOUNT)
                AVG_COGS,
             SUM (HIST.CORE_ADJ_AVG_COST)
                EXT_AVG_COGS_AMOUNT
      FROM PRICE_MGMT.PR_PRICE_CAT_HIST HIST
           INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
              ON (    HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
                  AND HIST.YEARMONTH = IHF.YEARMONTH)
           INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
              ON (    HIST.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                  AND HIST.YEARMONTH = ILF.YEARMONTH)
                  
           INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
              ON IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
           -- USE FOR ROLL12MONTH AND FYTD GROUPINGS
           INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
              ON HIST.YEARMONTH = TPD.YEARMONTH
           -- USE FOR CUSTOMER BUS GRP SALESREP REPORTING
           /*   INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                 ON IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
                LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
                 ON CUST.CUSTOMER_TYPE = BG.CUSTOMER_TYPE
                LEFT OUTER JOIN PRICE_MGMT.CURRENT_SALESREP REPS
                 ON CUST.ACCCOUNT_NAME = REPS.ACCOUNT_NAME
                   AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
                 */
           -- USE FOR CHANNEL TYPE ANALYSIS
           INNER JOIN SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN
              ON IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK
      -- USE FOR PRODUCT AND DISCOUNT GROUP
      -- INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
      --    ON HIST.PRODUCT_GK = PROD.PRODUCT_GK
      WHERE     TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
            --AND SWD.ACCOUNT_NAME = 'DETROIT'
            --AND ILF.PRODUCT_STATUS = 'SP-'
            --   AND IHF.YEARMONTH = '201810'
            AND SUBSTR (SWD.DIVISION_NAME, 0, 4) = 'CENT'  --IN ('NORT', 'SOUT')
            --   AND ILF.PRODUCT_NK IN ('7638645', '4592952')
      GROUP BY TPD.FISCAL_YEAR_TO_DATE,
               SWD.REGION_NAME,
               SWD.DIVISION_NAME,
               SWD.ACCOUNT_NAME,
               IHF.WRITER,
               ILF.PRODUCT_STATUS,
               --IHF.WAREHOUSE_NUMBER,
               -- NVL(BG.BUSINESS_GROUP,'OTHER'),
               CHAN.ORDER_CHANNEL,
               -- NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
               -- CUST.SALESMAN_CODE,
               -- NVL(REPS.SALESREP_NAME, 'UNKNOWN'),
               CASE
                  WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                     HIST.PRICE_CATEGORY_OVR_GR,
                                     HIST.PRICE_CATEGORY) IN
                              ('MANUAL', 'QUOTE', 'MATRIX_BID')
                       AND HIST.ORIG_PRICE_CODE IS NOT NULL
                  THEN
                     CASE
                        WHEN     REGEXP_LIKE (HIST.orig_price_code,
                                              '[0-9]?[0-9]?[0-9]')
                             AND LENGTH (HIST.PRICE_FORMULA) = 7
                        THEN
                           'MATRIX'
                        WHEN HIST.orig_price_code IN ('FC', 'PM', 'spec')
                        THEN
                           'MATRIX'
                        WHEN HIST.orig_price_code LIKE 'M%'
                        THEN
                           'NDP'
                        WHEN HIST.orig_price_code IN ('CPA', 'CPO')
                        THEN
                           'OVERRIDE'
                        WHEN HIST.orig_price_code IN ('PR',
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
                        WHEN HIST.orig_price_code IN ('GI',
                                                      'GPC',
                                                      'HPF',
                                                      'HPN',
                                                      'NC')
                        THEN
                           'MANUAL'
                        WHEN HIST.orig_price_code = '*E'
                        THEN
                           'OTH/ERROR'
                        WHEN HIST.orig_price_code = 'SKC'
                        THEN
                           'OTH/ERROR'
                        WHEN HIST.orig_price_code IN ('%',
                                                      '$',
                                                      'N',
                                                      'F',
                                                      'B',
                                                      'PO')
                        THEN
                           'TOOLS'
                        WHEN HIST.orig_price_code IS NULL
                        THEN
                           'MANUAL'
                        ELSE
                           'MANUAL'
                     END
                  ELSE
                     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                               HIST.PRICE_CATEGORY_OVR_GR,
                               HIST.PRICE_CATEGORY)
               END) SLS
GROUP BY REGION,
         SLS.DISTRICT,
         SLS.ACCOUNT_NAME,
         -- SLS.WHSE,
         -- SLS.CUST_BUS_GRP,
         --SLS.ORDER_CHANNEL,
         SLS.WRITER
-- SLS.REP_INIT,
-- SLS.SALESREP_NAME
;