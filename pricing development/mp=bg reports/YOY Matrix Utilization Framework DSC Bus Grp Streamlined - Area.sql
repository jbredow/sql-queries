SELECT SLS.REGION,
          SUBSTR (SLS.DISTRICT, 1, 3)
       || '^'
       || CASE
             WHEN SLS.BUDG_BUS_GRP = 'Residential - Trade'
             THEN
                'RESIDENTIAL - TRADE'
             WHEN SLS.BUDG_BUS_GRP = 'Residential - Build/Rem/Consumer'
             THEN
                'RESIDENTIAL - BUILDER'
             WHEN SLS.BUDG_BUS_GRP = 'Commercial MRO'
             THEN
                'COMMERCIAL MRO'
             WHEN SLS.BUDG_BUS_GRP = 'Commercial'
             THEN
                'COMMERCIAL'
             WHEN SLS.BUDG_BUS_GRP = 'Fire/Fabrication'
             THEN
                'FIRE/FABRICATION'
             WHEN SLS.BUDG_BUS_GRP = 'HVAC'
             THEN
                'HVAC'
             WHEN SLS.BUDG_BUS_GRP = 'Industrial'
             THEN
                'INDUSTRIAL'
             WHEN SLS.BUDG_BUS_GRP = 'Waterworks'
             THEN
                'WATERWORKS'
             WHEN SLS.BUDG_BUS_GRP = 'FEI Internal'
             THEN
                'FEI INTERNAL'
             ELSE
                'OTHER'
          END
          AS CAT,
       SLS.DISTRICT,
       SUBSTR (SLS.DISTRICT, 1, 3)
          D_NK,
       --FISCAL_YEAR_TO_DATE,
       SLS.YEARMONTH,
       SLS.AREA || ' - ' || SLS.FULL_NAME
          AS AREA,
       CASE
          WHEN SLS.AREA IS NULL THEN 'No Area Set'
          ELSE SLS.AREA || ' - ' || SLS.FULL_NAME
       END
            AREA,
         SLS.BUDG_BUS_GRP,
       SLS.BUDG_BUS_GRP,
       CASE
          WHEN SLS.BUDG_BUS_GRP = 'Residential - Trade'
          THEN
             'RESIDENTIAL - TRADE'
          WHEN SLS.BUDG_BUS_GRP = 'Residential - Build/Rem/Consumer'
          THEN
             'RESIDENTIAL - BUILDER'
          WHEN SLS.BUDG_BUS_GRP = 'Commercial MRO'
          THEN
             'COMMERCIAL MRO'
          WHEN SLS.BUDG_BUS_GRP = 'Commercial'
          THEN
             'COMMERCIAL'
          WHEN SLS.BUDG_BUS_GRP = 'Fire/Fabrication'
          THEN
             'FIRE/FABRICATION'
          WHEN SLS.BUDG_BUS_GRP = 'HVAC'
          THEN
             'HVAC'
          WHEN SLS.BUDG_BUS_GRP = 'Industrial'
          THEN
             'INDUSTRIAL'
          WHEN SLS.BUDG_BUS_GRP = 'Waterworks'
          THEN
             'WATERWORKS'
          WHEN SLS.BUDG_BUS_GRP = 'FEI Internal'
          THEN
             'FEI INTERNAL'
          ELSE
             'OTHER'
       END
          AS BG,
       NVL (
          SUM (
             CASE
                WHEN FYTD IN 'YEAR TO DATE' THEN SLS.EXT_SALES_AMOUNT
                ELSE 0
             END),
          0)
          EX_SALES,
       NVL (
          SUM (
             CASE
                WHEN FYTD IN 'YEAR TO DATE' THEN SLS.EXT_AVG_COGS_AMOUNT
                ELSE 0
             END),
          0)
          EX_COGS,
       NVL (
          SUM (
             CASE WHEN FYTD IN 'YEAR TO DATE' THEN SLS.TOTAL_LINES ELSE 0 END),
          0)
          EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MATRIX_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND FYTD IN 'YEAR TO DATE'
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
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('OVERRIDE')
                  AND FYTD IN 'YEAR TO DATE'
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
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MANUAL_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MANUAL_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
                  AND FYTD IN 'YEAR TO DATE'
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
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          SP_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          SP_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'CREDITS' AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'CREDITS' AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          CREDITS_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'CREDITS' AND FYTD IN 'YEAR TO DATE'
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
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND FYTD IN 'YEAR TO DATE'
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          OUTBOUND_LINES
FROM (SELECT TPD.FISCAL_YEAR_TO_DATE
                FYTD,
             SWD.DIVISION_NAME
                REGION,
             SWD.REGION_NAME
                DISTRICT,
             AREA_NM.AREA,
             AREA_NM.FULL_NAME,
             SWD.ACCOUNT_NAME,
             TPD.YEARMONTH,
             --IHF.WAREHOUSE_NUMBER WHSE,
             -- NVL(BG.BUSINESS_GROUP,'OTHER') CUST_BUS_GRP,
             -- NVL (BG.BUSINESS_GROUP, 'OTHER')
             --    CUST_BUS_GRP,
             NVL (BG_BUDG.BUSINESS_GROUP, 'OTHER')
                BUDG_BUS_GRP,
             -- CHAN.ORDER_CHANNEL,
             -- NVL (PROD.DISCOUNT_GROUP_NK, 'SP-') DISC_GRP,
             -- CUST.SALESMAN_CODE REP_INIT,
             -- NVL(REPS.SALESREP_NAME, 'UNKNOWN') SALESREP_NAME,
             DECODE (HIST.PRICE_CATEGORY_FINAL,
                     'MATRIX', 'MATRIX',
                     'MATRIX_BID', 'MATRIX',
                     'NDP', 'MATRIX',
                     'MANUAL', 'MANUAL',
                     'QUOTE', 'MANUAL',
                     'TOOLS', 'MANUAL',
                     'OVERRIDE', 'OVERRIDE',
                     'SPECIALS', 'SPECIALS',
                     HIST.PRICE_CATEGORY_FINAL)
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
           /*   INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
                 ON (    HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
                     AND HIST.YEARMONTH = IHF.YEARMONTH)*/
           INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
              ON HIST.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
           -- USE FOR ROLL12MONTH AND FYTD GROUPINGS
           INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
              ON HIST.YEARMONTH = TPD.YEARMONTH
           -- USE FOR CUSTOMER REPORTING
           INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
              ON HIST.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
           -- USE FOR REPORT CUSTOMER BUS GRP

           LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG_BUDG
              ON COALESCE (CUST.BMI_BUDGET_CUST_TYPE,
                           CUST.BMI_REPORT_CUST_TYPE,
                           CUST.CUSTOMER_TYPE) =
                 BG_BUDG.CUSTOMER_TYPE
           -- USE FOR CURRENT CUSTOMER BUS GRP

           /*  LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
                ON CUST.CUSTOMER_TYPE = BG.CUSTOMER_TYPE*/

           /* USE FOR FINANCE AREAS*/
           LEFT OUTER JOIN PRICE_MGMT.RPT_AREA_XREF AREA
              ON SWD.WAREHOUSE_NUMBER_NK = AREA.WHSE
           LEFT OUTER JOIN RPT_AREA_NAME AREA_NM ON AREA.AREA = AREA_NM.AREA
      -- USE FOR SALESREP REPORTING
      /*
          LEFT OUTER JOIN PRICE_MGMT.CURRENT_SALESREP REPS
           ON CUST.ACCCOUNT_NAME = REPS.ACCOUNT_NAME
             AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
           */
      -- USE FOR CHANNEL TYPE ANALYSIS
      /*   INNER JOIN SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN
            ON IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK */
      -- USE FOR PRODUCT AND DISCOUNT GROUP
      /* LEFT OUTER JOIN DW_FEI.PRODUCT_DIMENSION PROD
          ON HIST.PRODUCT_GK = PROD.PRODUCT_GK*/
      WHERE TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'             --IS NOT NULL
      --AND TPD.FISCAL_YEAR_TO_DATE = 'LAST YEAR TO DATE', 'YEAR TO DATE'
      --AND SWD.ACCOUNT_NAME = 'LAKEWOOD'
      --AND SUBSTR (SWD.DIVISION_NAME, 0, 4) IN ('NORT', 'SOUT')
      --AND ILF.PRODUCT_NK IN ('3916528', '7345096', '1203376', '1394851', '1899154', '392227', '4087354', '1395295', '4845558', '7606039', '7218785', '7233816', '4421856', '7608980', '3866980', '3755523', '4811170', '4427169', '7574543', '7062812', '7523517', '6206447', '7190521', '7559530', '3910383', '4828363', '5084195', '2437460', '4570551', '7316654', '4937194', '1855808', '7586061', '4570580', '4570558', '7505772', '4915154', '4160134', '2484038', '7043680', '1260111', '1898659', '3809995', '5164422', '4806721', '7628684', '5082066', '7601488', '4272910', '7238821', '7586081', '7252602', '7607120', '7588514', '7545448', '7546030', '7171559', '7541200', '7541208', '7541265', '7115636', '7638645', '4592952')
      GROUP BY TPD.FISCAL_YEAR_TO_DATE,
               SWD.REGION_NAME,
               SWD.DIVISION_NAME,
               SWD.ACCOUNT_NAME,
               AREA_NM.AREA,
               AREA_NM.FULL_NAME,
               TPD.YEARMONTH,
               --IHF.WAREHOUSE_NUMBER,
               --NVL (BG.BUSINESS_GROUP, 'OTHER'),
               NVL (BG_BUDG.BUSINESS_GROUP, 'OTHER'),
               -- CHAN.ORDER_CHANNEL,
               --NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
               -- CUST.SALESMAN_CODE,
               -- NVL(REPS.SALESREP_NAME, 'UNKNOWN'),
               DECODE (HIST.PRICE_CATEGORY_FINAL,
                       'MATRIX', 'MATRIX',
                       'MATRIX_BID', 'MATRIX',
                       'NDP', 'MATRIX',
                       'MANUAL', 'MANUAL',
                       'QUOTE', 'MANUAL',
                       'TOOLS', 'MANUAL',
                       'OVERRIDE', 'OVERRIDE',
                       'SPECIALS', 'SPECIALS',
                       HIST.PRICE_CATEGORY_FINAL)) SLS
GROUP BY SLS.REGION,
            SUBSTR (SLS.DISTRICT, 1, 3)
         || '^'
         || CASE
               WHEN SLS.BUDG_BUS_GRP = 'Residential - Trade'
               THEN
                  'RESIDENTIAL - TRADE'
               WHEN SLS.BUDG_BUS_GRP = 'Residential - Build/Rem/Consumer'
               THEN
                  'RESIDENTIAL - BUILDER'
               WHEN SLS.BUDG_BUS_GRP = 'Commercial MRO'
               THEN
                  'COMMERCIAL MRO'
               WHEN SLS.BUDG_BUS_GRP = 'Commercial'
               THEN
                  'COMMERCIAL'
               WHEN SLS.BUDG_BUS_GRP = 'Fire/Fabrication'
               THEN
                  'FIRE/FABRICATION'
               WHEN SLS.BUDG_BUS_GRP = 'HVAC'
               THEN
                  'HVAC'
               WHEN SLS.BUDG_BUS_GRP = 'Industrial'
               THEN
                  'INDUSTRIAL'
               WHEN SLS.BUDG_BUS_GRP = 'Waterworks'
               THEN
                  'WATERWORKS'
               WHEN SLS.BUDG_BUS_GRP = 'FEI Internal'
               THEN
                  'FEI INTERNAL'
               ELSE
                  'OTHER'
            END,
         SLS.DISTRICT,
         SUBSTR (SLS.DISTRICT, 1, 3),
         --FISCAL_YEAR_TO_DATE,
         SLS.YEARMONTH,
         CASE
              WHEN SLS.AREA IS NULL THEN
                'No Area Set'
              ELSE
                 SLS.AREA || ' - ' || SLS.FULL_NAME
         END,
         SLS.BUDG_BUS_GRP,
         CASE
            WHEN SLS.BUDG_BUS_GRP = 'Residential - Trade'
            THEN
               'RESIDENTIAL - TRADE'
            WHEN SLS.BUDG_BUS_GRP = 'Residential - Build/Rem/Consumer'
            THEN
               'RESIDENTIAL - BUILDER'
            WHEN SLS.BUDG_BUS_GRP = 'Commercial MRO'
            THEN
               'COMMERCIAL MRO'
            WHEN SLS.BUDG_BUS_GRP = 'Commercial'
            THEN
               'COMMERCIAL'
            WHEN SLS.BUDG_BUS_GRP = 'Fire/Fabrication'
            THEN
               'FIRE/FABRICATION'
            WHEN SLS.BUDG_BUS_GRP = 'HVAC'
            THEN
               'HVAC'
            WHEN SLS.BUDG_BUS_GRP = 'Industrial'
            THEN
               'INDUSTRIAL'
            WHEN SLS.BUDG_BUS_GRP = 'Waterworks'
            THEN
               'WATERWORKS'
            WHEN SLS.BUDG_BUS_GRP = 'FEI Internal'
            THEN
               'FEI INTERNAL'
            ELSE
               'OTHER'
         END;