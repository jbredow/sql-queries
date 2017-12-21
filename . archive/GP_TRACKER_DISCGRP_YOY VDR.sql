SELECT SELL_DISTRICT,
       SELL_REGION_NAME,
       SELL_ACCOUNT_NAME,
       FYTD,
       VDR,
       DET1,
       DET2,
       DGRP,
       DGRP_NK_NAME,
       --BUSINESS_GROUP,
       --PRICE_COLUMN,
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
               --SLS.PRICE_COLUMN,
               SLS.DISCOUNT_GROUP_NK DGRP,
               SLS.DISCOUNT_GROUP_NK_NAME DGRP_NK_NAME,
               --SLS.PRODUCT_NK,
               --SLS.ALT1_CODE_AND_PRODUCT_NAME,
               HIER.DET1,
               HIER.DET2,
               HIER.DET6 VDR,
               TPD.FISCAL_YEAR_TO_DATE FYTD,
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
         WHERE     TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
               AND SLS.IC_FLAG = 'REGULAR'
               --AND SLS.SELL_ACCOUNT_NAME = 'LENZ'
               -- AND HIER.DET6 IN ('ELKAY', 'ELKAY - EXCL')
               -- AND HIER.DET1 = 'WATER HEATERS'
               -- AND HIER.DET2 LIKE 'RESIDENTIAL%'
               AND SLS.DISCOUNT_GROUP_NK IN ('3451',
                                             '1272',
                                             '1148',
                                             '1149',
                                             '1151',
                                             '1153',
                                             '1154',
                                             '1159',
                                             '1186',
                                             '1208',
                                             '1211',
                                             '1402',
                                             '2533',
                                             '2687',
                                             '2688',
                                             '2689',
                                             '2690',
                                             '2691',
                                             '3450',
                                             '1637',
                                             '1054',
                                             '1874',
                                             '2180',
                                             '1138',
                                             '1139',
                                             '1065',
                                             '1071',
                                             '1117',
                                             '1118',
                                             '1119',
                                             '1120',
                                             '1121',
                                             '1123',
                                             '1124',
                                             '1126',
                                             '1128',
                                             '1135',
                                             '1142',
                                             '1156',
                                             '1157',
                                             '1160',
                                             '1161',
                                             '1162',
                                             '1163',
                                             '1164',
                                             '1187',
                                             '1206',
                                             '1207',
                                             '3845',
                                             '1125',
                                             '1843',
                                             '2545',
                                             '2762',
                                             '2776',
                                             '2778',
                                             '2780',
                                             '2782',
                                             '2784',
                                             '2785',
                                             '2880',
                                             '3447',
                                             '3448',
                                             '3449',
                                             '6090',
                                             '5538',
                                             '5585',
                                             '5587',
                                             '7019',
                                             '7021',
                                             '7057',
                                             '7058',
                                             '7069',
                                             '7071',
                                             '7072',
                                             '7073',
                                             '7082',
                                             '7933',
                                             '7934',
                                             '582',
                                             '2642',
                                             '2643',
                                             '583',
                                             '597',
                                             '598',
                                             '2535',
                                             '2536',
                                             '2540',
                                             '2541',
                                             '2544',
                                             '7055',
                                             '581',
                                             '610',
                                             '611',
                                             '613',
                                             '614',
                                             '573',
                                             '709',
                                             '2744',
                                             '2745',
                                             '2746',
                                             '9281',
                                             '9286',
                                             '9287',
                                             '9294',
                                             '9295') --,'1080','1081','0540','0545')
        -- AND SLS.PRICE_COLUMN IN ('001','002','003','004','006','007','008','009','070','071','072','073')
        --AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
        --AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
        --AND SLS.SELL_ACCOUNT_NAME IN ('DALLAS')
        --AND SLS.SALESMAN_CODE = 'OWC'
        GROUP BY SLS.SELL_DISTRICT,
                 SLS.SELL_REGION_NAME,
                 SLS.SELL_ACCOUNT_NAME,
                 SLS.DISCOUNT_GROUP_NK,
                 TPD.FISCAL_YEAR_TO_DATE,
                 SLS.DISCOUNT_GROUP_NK_NAME,
                 --SLS.PRODUCT_NK,
                 --SLS.ALT1_CODE_AND_PRODUCT_NAME,
                 HIER.DET1,
                 HIER.DET2,
                 HIER.DET6--XREF.BUSINESS_GROUP,
                          --SLS.PRICE_COLUMN
                          --XREF.CUSTOMER_GROUP
       )
ORDER BY SELL_DISTRICT ASC,
         SELL_ACCOUNT_NAME ASC,
         --BUSINESS_GROUP,
         DGRP,
         DGRP_NK_NAME,
         FYTD