SELECT SELL_DISTRICT,
       SELL_REGION_NAME,
       SELL_ACCOUNT_NAME,
       ALT1_CODE_AND_PRODUCT_NAME,
       DET1,
       DET2,
       DGRP,
       DGRP_NK_NAME,
       --BUSINESS_GROUP,
       PRICE_COLUMN,
       --CUSTOMER_GROUP,
       EX_SALES,
       EX_COGS,
       (EX_SALES - EX_COGS) EX_GP_AMT,
       /* MATRIX */
       MATRIX_SALES,
       MATRIX_COGS,
       (MATRIX_SALES - MATRIX_COGS) MATRIX_GP_AMT,
       /* CONTRACT */
       OVERRIDE_SALES,
       OVERRIDE_COGS,
       (OVERRIDE_SALES - OVERRIDE_COGS) CCOR_GP_AMT,
       /* MANUAL */
       MANUAL_SALES,
       MANUAL_COGS,
       (MANUAL_SALES - MANUAL_COGS) MANUAL_GP_AMT,
       /* SPECIALS */
       SP_SALES,
       SP_COGS,
       (SP_SALES - SP_COGS) SP_GP_AMT,
       /* CREDITS */
       CREDITS_SALES,
       CREDITS_COGS,
       /* OUTBOUND */
       OUTBOUND_SALES,
       OUTBOUND_COGS,
       (OUTBOUND_SALES - OUTBOUND_COGS) OUTBOUND_GP_AMT,
       SHIPPED_QTY,
       LINES
  FROM (SELECT SLS.SELL_DISTRICT,
               SLS.SELL_REGION_NAME,
               SLS.SELL_ACCOUNT_NAME,
               SLS.PRICE_COLUMN,
               SLS.DISCOUNT_GROUP_NK DGRP,
               SLS.DISCOUNT_GROUP_NK_NAME DGRP_NK_NAME,
              SLS.PRODUCT_NK,
              SLS.ALT1_CODE_AND_PRODUCT_NAME,
               HIER.DET1,
               HIER.DET2,
               --COALESCE(XREF.BUSINESS_GROUP,'OTHER') BUSINESS_GROUP,
               --XREF.CUSTOMER_GROUP,
               /* CASE
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
                SLS.SALESREP_NAME,*/
               NVL (SUM (SLS.EXT_SALES_AMOUNT), 0) EX_SALES,
               NVL (SUM (SLS.EXT_ACTUAL_COGS_AMOUNT), 0) EX_COGS,
               NVL (SUM (SLS.TOTAL_LINES), 0) LINES,
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
                  OUTBOUND_COGS,
               SUM (SLS.SHIPPED_QTY) SHIPPED_QTY
          FROM SALES_MART.PRICE_MGMT_DATA_DET SLS
               INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                  ON SLS.YEARMONTH = TPD.YEARMONTH
               INNER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
                  ON SLS.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK
         -- LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_X REF XREF
         --  ON SLS.CUSTOMER_TYPE = XREF.CUSTOMER_TYPE
         --INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
         --ON SLS.PRODUCT_NK = PROD.PRODUCT_NK
         --INNER JOIN DW_FEI.MASTER_VENDOR_DIMENSION VEND
         --ON PROD.MANUFACTURER = VEND.MASTER_VENDOR_NK
         --INNER JOIN AAD9606.PR_AVAIL_COMP_S COMP
         --ON PROD.DISCOUNT_GROUP_NK = COMP.DGRP
         WHERE     TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
               AND SLS.IC_FLAG = 'REGULAR'
               --AND SLS.SELL_ACCOUNT_NAME = 'LENZ'
              -- AND HIER.DET6 IN ('ELKAY', 'ELKAY - EXCL')
               -- AND HIER.DET1 = 'WATER HEATERS'
               -- AND HIER.DET2 LIKE 'RESIDENTIAL%'
               AND SLS.DISCOUNT_GROUP_NK IN ('1072', '1076','1080','1084') --,'1080','1081','0540','0545')
        AND SLS.PRICE_COLUMN IN ('001','002','003','004','006','007','008','009','070','071','072','073')
        --AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
        --AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
        --AND SLS.SELL_ACCOUNT_NAME IN ('DALLAS')
        --AND SLS.SALESMAN_CODE = 'OWC'
        GROUP BY SLS.SELL_DISTRICT,
                 SLS.SELL_REGION_NAME,
                 SLS.SELL_ACCOUNT_NAME,
                 SLS.DISCOUNT_GROUP_NK,
                 SLS.DISCOUNT_GROUP_NK_NAME,
                 SLS.PRODUCT_NK,
                 SLS.ALT1_CODE_AND_PRODUCT_NAME,
                 HIER.DET1,
                 HIER.DET2,
                 --XREF.BUSINESS_GROUP,
                 SLS.PRICE_COLUMN
                 --XREF.CUSTOMER_GROUP
                 )
ORDER BY SELL_DISTRICT ASC,
         SELL_ACCOUNT_NAME ASC,
         --BUSINESS_GROUP,
         DGRP,
         DGRP_NK_NAME,
         PRICE_COLUMN
         