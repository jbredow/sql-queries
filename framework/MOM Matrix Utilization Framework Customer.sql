SELECT REGION,
       DISTRICT,
       ACCOUNT_NAME,
       --SUP_FRST_NM || ' ' || SUP_LST_NM
       --   SUP_NAME,
       --SUP_JOB_TITL_DESC,
       WHSE,
       CUST_BUS_GRP,
       MAIN_CUSTOMER_NK,
       CUSTOMER_NAME,
       -- ORDER_CHANNEL,
       -- DISC_GRP,
       REP_INIT,
       SALESREP_NAME,
       --REP_TITLE,
       -- CUST_BUS_GRP,
       -- ORDER_CHANNEL,
       -- DISC_GRP,
       -- REP_INIT,
       -- SALESREP_NAME,
       NVL (
          SUM (
             CASE
                WHEN PERIOD = 'THIS MONTH LAST YEAR'
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
                WHEN PERIOD = 'THIS MONTH LAST YEAR'
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
                WHEN PERIOD = 'THIS MONTH LAST YEAR' THEN SLS.TOTAL_LINES
                ELSE 0
             END),
          0)
          EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MATRIX_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('OVERRIDE')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          OVERRIDE_LINES,
       /* MANUAL */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MANUAL_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MANUAL_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          SP_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          SP_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          CREDITS_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND PERIOD = 'THIS MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          OUTBOUND_LINES,
       NVL (
          SUM (
             CASE
                WHEN PERIOD = 'LAST MONTH LAST YEAR'
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
                WHEN PERIOD = 'LAST MONTH LAST YEAR'
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
                WHEN PERIOD = 'LAST MONTH LAST YEAR' THEN SLS.TOTAL_LINES
                ELSE 0
             END),
          0)
          LY_EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_MATRIX_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_MATRIX_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('OVERRIDE')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_OVERRIDE_LINES,
       /* MANUAL */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_MANUAL_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_MANUAL_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_SP_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_SP_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_CREDITS_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_CREDITS_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          LY_OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND PERIOD = 'LAST MONTH LAST YEAR'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          LY_OUTBOUND_LINES
FROM (SELECT TPD.ROLLING_MONTH
                PERIOD,
             SWD.DIVISION_NAME
                REGION,
             SWD.REGION_NAME
                DISTRICT,
             SWD.ACCOUNT_NAME,
             -- WORKDAY.SUP_FRST_NM,
             -- WORKDAY.SUP_LST_NM,
             -- WORKDAY.SUP_JOB_TITL_DESC,
             IHF.WAREHOUSE_NUMBER WHSE,
             NVL (BG.BUSINESS_GROUP, 'OTHER')
                CUST_BUS_GRP,
             -- CHAN.ORDER_CHANNEL,
             -- NVL (PROD.DISCOUNT_GROUP_NK, 'SP-') DISC_GRP,
             CUST.SALESMAN_CODE
                REP_INIT,
             NVL (REPS.SALESREP_NAME, 'UNKNOWN')
                SALESREP_NAME,
             CUST.MAIN_CUSTOMER_NK,
             CUST.CUSTOMER_NAME,
             -- EMPL.TITLE_DESC
             --    REP_TITLE,
             CASE
                WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                   HIST.PRICE_CATEGORY_OVR_GR,
                                   HIST.PRICE_CATEGORY) IN
                            ('MANUAL', 'QUOTE', 'MATRIX_BID')
                     AND HIST.ORIG_PRICE_CODE IS NOT NULL
                THEN
                   CASE
                      WHEN REGEXP_LIKE (HIST.orig_price_code,
                                        '[0-9]?[0-9]?[0-9]')
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
           INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
              ON IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
           -- USE FOR ROLL12MONTH AND FYTD GROUPINGS
           INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
              ON HIST.YEARMONTH = TPD.YEARMONTH
           -- USE FOR CUSTOMER BUS GRP SALESREP REPORTING
           INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
              ON IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
           INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
              ON CUST.CUSTOMER_TYPE = BG.CUSTOMER_TYPE
           -- USE FOR SALESREP REPORTING
           INNER JOIN PRICE_MGMT.CURRENT_SALESREP REPS
              ON (    CUST.ACCOUNT_NAME = REPS.ACCOUNT_NAME
                  AND CUST.SALESMAN_CODE = REPS.SALESREP_NK)
      -- INNER JOIN DW_FEI.EMPLOYEE_DIMENSION EMPL
      --    ON REPS.EMPLOYEE_NUMBER_NK = EMPL.EMPLOYEE_TRILOGIE_NK
      -- INNER JOIN HR_FEI.WORKDAY_EMP_DATA WORKDAY
      --    ON EMPL.USER_LOGON = WORKDAY.EMP_LOGON_ID
      -- USE FOR CHANNEL TYPE ANALYSIS
      /*   INNER JOIN SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN
            ON IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK */
      -- USE FOR PRODUCT AND DISCOUNT GROUP
      /*   LEFT OUTER JOIN DW_FEI.PRODUCT_DIMENSION PROD
            ON HIST.PRODUCT_GK = PROD.PRODUCT_GK */
      WHERE TPD.ROLLING_MONTH IS NOT NULL
        AND ( SUBSTR ( SWD.REGION_NAME, 1, 3 ) = 'D24'
        /*AND ( SUBSTR ( SWD.REGION_NAME, 1, 3 ) IN ( 'D20',
                                                    'D21',
                                                    'D22',
                                                    'D23',
                                                    'D24',
                                                    'D25',
                                                    'D26' ) )*/

      -- FILTER TO INCLUDE ONLY O/S REPS
      /*  AND (   EMPL.TITLE_DESC LIKE '%O/S%'
             OR EMPL.TITLE_DESC LIKE 'Out Sales%'
             OR EMPL.TITLE_DESC LIKE 'Sales Rep%')*/
      GROUP BY TPD.ROLLING_MONTH,
               SWD.REGION_NAME,
               SWD.DIVISION_NAME,
               SWD.ACCOUNT_NAME,
               IHF.WAREHOUSE_NUMBER,
               --WORKDAY.SUP_FRST_NM,    
               --WORKDAY.SUP_LST_NM,
               --WORKDAY.SUP_JOB_TITL_DESC,
               --IHF.WAREHOUSE_NUMBER,
               NVL (BG.BUSINESS_GROUP, 'OTHER'),
               -- CHAN.ORDER_CHANNEL,
               -- NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
               CUST.SALESMAN_CODE,
               NVL (REPS.SALESREP_NAME, 'UNKNOWN'),
               CUST.MAIN_CUSTOMER_NK,
               CUST.CUSTOMER_NAME,
               --EMPL.TITLE_DESC,
               CASE
                  WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                     HIST.PRICE_CATEGORY_OVR_GR,
                                     HIST.PRICE_CATEGORY) IN
                              ('MANUAL', 'QUOTE', 'MATRIX_BID')
                       AND HIST.ORIG_PRICE_CODE IS NOT NULL
                  THEN
                     CASE
                        WHEN REGEXP_LIKE (HIST.orig_price_code,
                                          '[0-9]?[0-9]?[0-9]')
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
         DISTRICT,
         ACCOUNT_NAME,
         --SUP_FRST_NM || ' ' || SUP_LST_NM,
         --SUP_JOB_TITL_DESC,
         WHSE,
         CUST_BUS_GRP,
         -- ORDER_CHANNEL,
         -- DISC_GRP,
         REP_INIT,
         SALESREP_NAME,
         MAIN_CUSTOMER_NK,
         CUSTOMER_NAME
--REP_TITLE