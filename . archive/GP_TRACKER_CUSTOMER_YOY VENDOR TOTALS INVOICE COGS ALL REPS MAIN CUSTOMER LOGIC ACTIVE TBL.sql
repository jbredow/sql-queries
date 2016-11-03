SELECT SELL_DISTRICT,
       SELL_REGION_NAME,
       SELL_ACCOUNT_NAME,
       SALESMAN_CODE,
       HOUSE,
       SALESREP_NAME,
       --MASTER_VENDOR_NAME,
       MAIN_CUSTOMER_NK, -- FROM CUSTOMER ROLLUP
       --CUST_DIM_MAIN,
       CUSTOMER_NAME, -- FROM CUSTOMER ROLLUP
       ACCOUNT_NAME CUST_ACCOUNT, -- FROM CUSTOMER ROLLUP
       --ACTIVE_ACCOUNT_NUMBER_NK,
       --ACTIVE_CUSTOMER_NK,
       --MAIN_CUST_NAME,
       --DISCOUNT_GROUP_NK_NAME,
       FYTD,
       EX_SALES,
       EX_COGS,
       ROUND (
          CASE
             WHEN EX_SALES > 0 THEN (EX_SALES - EX_COGS) / EX_SALES
             ELSE 0
          END,
          3)
          EX_GP_PCT,
       /* MATRIX */
       MATRIX_SALES,
       MATRIX_COGS,
       ROUND (
          CASE
             WHEN MATRIX_SALES > 0
             THEN
                (MATRIX_SALES - MATRIX_COGS) / MATRIX_SALES
             ELSE
                0
          END,
          3)
          MATRIX_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN MATRIX_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          MATRIX_UTIL,
       /* CONTRACT */

       OVERRIDE_SALES,
       OVERRIDE_COGS,
       ROUND (
          CASE
             WHEN OVERRIDE_SALES > 0
             THEN
                (OVERRIDE_SALES - OVERRIDE_COGS) / OVERRIDE_SALES
             ELSE
                0
          END,
          3)
          OVERRIDE_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN OVERRIDE_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          OVERRIDE_UTIL,
       /* MANUAL */

       MANUAL_SALES,
       MANUAL_COGS,
       ROUND (
          CASE
             WHEN MANUAL_SALES > 0
             THEN
                (MANUAL_SALES - MANUAL_COGS) / MANUAL_SALES
             ELSE
                0
          END,
          3)
          MANUAL_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN MANUAL_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          MANUAL_UTIL,
       /* SPECIALS */

       SP_SALES,
       SP_COGS,
       ROUND (
          CASE
             WHEN SP_SALES > 0 THEN (SP_SALES - SP_COGS) / SP_SALES
             ELSE 0
          END,
          3)
          SP_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN SP_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          SP_UTIL,
       /* CREDITS */

       CREDITS_SALES,
       CREDITS_COGS,
       /* OUTBOUND */

       OUTBOUND_SALES,
       OUTBOUND_COGS,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0
             THEN
                (OUTBOUND_SALES - OUTBOUND_COGS) / OUTBOUND_SALES
             ELSE
                0
          END,
          3)
          OUTBOUND_GP_PCT
  FROM (SELECT SLS.SELL_DISTRICT,
               SLS.SELL_REGION_NAME,
               SLS.SELL_ACCOUNT_NAME,
               --SLS.MAIN_CUSTOMER_NK,
               CUST.MAIN_CUSTOMER_NK,
               CUST.ACCOUNT_NAME,
               --SLS.ACTIVE_ACCOUNT_NUMBER_NK,
               --SLS.ACTIVE_CUSTOMER_NK,
               --SLS.CUSTOMER_NAME,
               CUST.CUSTOMER_NAME,
               --SLS.DISCOUNT_GROUP_NK_NAME,
               CASE
                  WHEN     REGEXP_LIKE (SLS.SALESMAN_CODE,
                                        '[0-9]?[0-9]?[0-9]')
                       AND SUBSTR (SLS.SALESREP_NAME, 0, 3) <> 'S16'
                  THEN
                     'HOUSE'
                  ELSE
                     NULL
               END
                  HOUSE,
               SLS.SALESMAN_CODE,
               SLS.SALESREP_NAME,
               TPD.FISCAL_YEAR_TO_DATE FYTD,
               NVL (SUM (SLS.EXT_SALES_AMOUNT), 0) EX_SALES,
               NVL (SUM (SLS.EXT_ACTUAL_COGS_AMOUNT), 0) EX_COGS,
               /* MATRIX */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MATRIX',
                                                                       'MATRIX_BID')
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  MATRIX_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MATRIX',
                                                                       'MATRIX_BID')
                     THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  MATRIX_COGS,
               /* CONTRACT */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
                             'OVERRIDE'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  OVERRIDE_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
                             'OVERRIDE'
                     THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  OVERRIDE_COGS,
               /* MANUAL */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MANUAL',
                                                                       'QUOTE',
                                                                       'TOOLS')
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  MANUAL_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MANUAL',
                                                                       'QUOTE',
                                                                       'TOOLS')
                     THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  MANUAL_COGS,
               /* SPECIALS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'SPECIAL'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  SP_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'SPECIAL'
                     THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  SP_COGS,
               /* CREDITS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'CREDITS'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  CREDITS_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'CREDITS'
                     THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  CREDITS_COGS,
               /* OUTBOUND */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY <> 'CREDITS'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  OUTBOUND_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY <> 'CREDITS'
                     THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  OUTBOUND_COGS
          FROM SALES_MART.PRICE_MGMT_DATA_DET SLS
               INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                  ON SLS.YEARMONTH = TPD.YEARMONTH
               --  INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
               --   ON SLS.PRODUCT_NK = PROD.PRODUCT_NK
               -- INNER JOIN DW_FEI.MASTER_VENDOR_DIMENSION VEND
               --   ON PROD.MANUFACTURER = VEND.MASTER_VENDOR_NK
               INNER JOIN DW_FEI.ACTIVE_CUSTOMER_MVW CUST
                  ON SLS.CUSTOMER_GK = CUST.CUSTOMER_GK
         --INNER JOIN AAD9606.PR_PAIN_CUST_GK PAIN
         -- ON SLS.CUSTOMER_GK = PAIN.CUST_GK
         --INNER JOIN AAD9606.PR_AVAIL_COMP_S COMP
         --  ON PROD.DISCOUNT_GROUP_NK = COMP.DGRP
         WHERE     TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
               AND SLS.IC_FLAG = 'REGULAR'
               --AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
               --AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
               AND SLS.SELL_ACCOUNT_NAME IN ('OHVAL', 'CHICAGO')
        --AND SLS.SALESREP_NAME = 'KIRK FREYTAG'
        GROUP BY SLS.SELL_DISTRICT,
                 SLS.SELL_REGION_NAME,
                 SLS.SELL_ACCOUNT_NAME,
                 --SLS.MAIN_CUSTOMER_NK,
                 CUST.MAIN_CUSTOMER_NK,
                 CUST.ACCOUNT_NAME,
                 --SLS.ACTIVE_ACCOUNT_NUMBER_NK,
                 --SLS.ACTIVE_CUSTOMER_NK,
                 --SLS.CUSTOMER_NAME,
                 CUST.CUSTOMER_NAME,
                 SLS.SALESMAN_CODE,
                 SLS.SALESREP_NAME,
                 TPD.FISCAL_YEAR_TO_DATE)
ORDER BY SELL_DISTRICT ASC,
         SELL_ACCOUNT_NAME ASC,
         SALESMAN_CODE ASC,
         SALESREP_NAME,
         FYTD DESC