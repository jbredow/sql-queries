/*CREATE OR REPLACE FORCE VIEW "AAD9606"."PR_SHOW_WEEKLY_SUMMARY"

AS*/

SELECT --DTL.YEARMONTH,
       SWD.DIVISION_NAME
          AS REGION,
       SWD.REGION_NAME
          AS DISTRICT,
       DTL.ACCOUNT_NUMBER,
       DTL.ACCOUNT_NAME,
       SWD.ALIAS_NAME,
       DTL.TYPE_OF_SALE,
       CASE
          WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
               AND DTL.PRICE_COLUMN IN ('020', '024', '025')
          THEN
             'Consumer'
          WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
               AND DTL.PRICE_COLUMN NOT IN ('020', '024', '025')
          THEN
             'Associated Consumer'
          WHEN BG.CUSTOMER_GROUP IN ('Plumbing', 'Builder', 'Designers')
          THEN
             BG.CUSTOMER_GROUP
          ELSE
             'Other'
       END
          AS PILOT_CUSTOMER_GROUP,
       HIER.DET1,
       CASE
          WHEN HIER.DET1 IN ('FAUCETS - BRASS PRODUCT',
                             'FIXTURES',
                             'BATHING PRODUCTS',
                             'PARTS & ACCY',
                             'KITCHEN SINKS')
          THEN
             'FINISHED_PLUMBING'
          WHEN HIER.DET1 IN ('APPLIANCES',
                             'LIGHTING',
                             'CABINETS AND VANITIES',
                             'HOME AMENITIES',
                             'HARDWARE',
                             'COUNTER SURFACES')
          THEN
             'OTHER_SHOWROOM'
          ELSE
             'OTHER'
       END
          SHOW_PROD_GRP,
       CASE
          WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017' THEN '2017AVG'
          ELSE TO_CHAR (DTL.PROCESS_DATE, 'YYYYWW')
       END
          YYYYWW,
       CASE
          WHEN     DTL.ACCOUNT_NAME IN ('ORL', 'PHOENIX')
               AND DTL.PROCESS_DATE > '02/13/2018'
          THEN
             'Y'
          WHEN     DTL.ACCOUNT_NAME IN ('PLYMOUTH')
               AND DTL.PROCESS_DATE >= '03/01/2018'
          THEN
             'Y'
          ELSE
             'N'
       END
          AS PILOT_LIVE,
       COUNT (
          DISTINCT CASE
                      WHEN DTL.INVOICE_NUMBER_NK NOT LIKE '%-%'
                      THEN
                         DTL.INVOICE_NUMBER_NK
                      ELSE
                         NULL
                   END)
          AS INVOICE_CNT,
       COUNT (DTL.INVOICE_LINE_NUMBER)
          AS INVOICE_LINES,
       SUM (
          CASE
             WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
             THEN
                ROUND (DTL.EXT_AVG_COGS_AMOUNT / 52, 2)
             ELSE
                DTL.EXT_AVG_COGS_AMOUNT
          END)
          AS OLD_AVG_COGS,
       SUM (
          CASE
             WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
             THEN
                ROUND (DTL.CORE_ADJ_AVG_COST / 52, 2)
             ELSE
                DTL.CORE_ADJ_AVG_COST
          END)
          AS AVG_COGS,
       SUM (
          CASE
             WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
             THEN
                ROUND (DTL.EXT_SALES_AMOUNT / 52, 2)
             ELSE
                DTL.EXT_SALES_AMOUNT
          END)
          AS EXT_SALES,
       DECODE (DTL.PRICE_CATEGORY,
               'CREDITS', 'CREDITS',
               'MANUAL', 'MANUAL',
               'MATRIX', 'MATRIX',
               'MATRIX_BID', 'MATRIX',
               'NDP', 'MATRIX',
               'OTH/ERROR', 'MANUAL',
               'OVERRIDE', 'OVERRIDE',
               'QUOTE', 'MANUAL',
               'SPECIALS', 'SPECIALS',
               'TOOLS', 'MANUAL',
               'MANUAL')
          RPT_PRICE_CATEGORY
FROM AAK9658.PR_VICT2_CUST_SHWRM DTL
     INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
        ON (DTL.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK)
     INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
        ON DTL.CUSTOMER_TYPE = BG.CUSTOMER_TYPE
     LEFT OUTER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
        ON DTL.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK
GROUP BY DTL.WAREHOUSE_NUMBER,
         DTL.ACCOUNT_NAME,
         DTL.ACCOUNT_NUMBER,
         SWD.ALIAS_NAME,
         SWD.REGION_NAME,
         SWD.DIVISION_NAME,
         DTL.YEARMONTH,
         DTL.TYPE_OF_SALE,
         CASE
            WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
                 AND DTL.PRICE_COLUMN IN ('020', '024', '025')
            THEN
               'Consumer'
            WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
                 AND DTL.PRICE_COLUMN NOT IN ('020', '024', '025')
            THEN
               'Associated Consumer'
            WHEN BG.CUSTOMER_GROUP IN ('Plumbing', 'Builder', 'Designers')
            THEN
               BG.CUSTOMER_GROUP
            ELSE
               'Other'
         END,
         CASE
            WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017' THEN '2017AVG'
            ELSE TO_CHAR (DTL.PROCESS_DATE, 'YYYYWW')
         END,
         CASE
            WHEN     DTL.ACCOUNT_NAME IN ('ORL', 'PHOENIX')
                 AND DTL.PROCESS_DATE > '02/13/2018'
            THEN
               'Y'
            WHEN     DTL.ACCOUNT_NAME IN ('PLYMOUTH')
                 AND DTL.PROCESS_DATE >= '03/01/2018'
            THEN
               'Y'
            ELSE
               'N'
         END,
         HIER.DET1,
         CASE
            WHEN HIER.DET1 IN ('FAUCETS - BRASS PRODUCT',
                               'FIXTURES',
                               'BATHING PRODUCTS',
                               'PARTS & ACCY',
                               'KITCHEN SINKS')
            THEN
               'FINISHED_PLUMBING'
            WHEN HIER.DET1 IN ('APPLIANCES',
                               'LIGHTING',
                               'CABINETS AND VANITIES',
                               'HOME AMENITIES',
                               'HARDWARE',
                               'COUNTER SURFACES')
            THEN
               'OTHER_SHOWROOM'
            ELSE
               'OTHER'
         END,
         DECODE (DTL.PRICE_CATEGORY,
                 'CREDITS', 'CREDITS',
                 'MANUAL', 'MANUAL',
                 'MATRIX', 'MATRIX',
                 'MATRIX_BID', 'MATRIX',
                 'NDP', 'MATRIX',
                 'OTH/ERROR', 'MANUAL',
                 'OVERRIDE', 'OVERRIDE',
                 'QUOTE', 'MANUAL',
                 'SPECIALS', 'SPECIALS',
                 'TOOLS', 'MANUAL',
                 'MANUAL')