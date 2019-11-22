Sql.Database("feieimazsrv1.database.windows.net,1433", "feieimazsdw1", 
    [Query=
    "SELECT SLS.REGION,
       CONCAT (
          SUBSTRING (SLS.DISTRICT, 1, 3),
          '^',
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
          END,
          '^',
          SLS.YEARMONTH)
          AS CAT,
       SLS.DISTRICT,
       SUBSTRING (SLS.DISTRICT, 1, 3)
          D_NK,
       FISCAL_YEAR_TO_DATE,
       SLS.YEARMONTH,
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
       PRICE_CATEGORY_FINAL,
       SLS.EXT_SALES_AMOUNT
          AS EX_SALES,
       SLS.EXT_AVG_COGS_AMOUNT
          AS EX_COGS,
       SLS.TOTAL_LINES
          AS EX_LINES
FROM (SELECT TPD.FISCAL_YEAR_TO_DATE,
             TPD.ROLL12MONTHS,
             SWD.DIVISION_NAME
                AS REGION,
             SWD.REGION_NAME
                AS DISTRICT,
             SWD.ACCOUNT_NAME,
             TPD.YEARMONTH,
             ISNULL (BG_BUDG.BUSINESS_GROUP, 'OTHER')
                AS BUDG_BUS_GRP,
             CASE HIST.PRICE_CATEGORY_FINAL
                WHEN 'MATRIX' THEN 'MATRIX'
                WHEN 'MATRIX_BID' THEN 'MATRIX'
                WHEN 'NDP' THEN 'MATRIX'
                WHEN 'MANUAL' THEN 'MANUAL'
                WHEN 'QUOTE' THEN 'MANUAL'
                WHEN 'TOOLS' THEN 'MANUAL'
                WHEN 'OVERRIDE' THEN 'OVERRIDE'
                WHEN 'SPECIALS' THEN 'SPECIALS'
                ELSE 'UNKNOWN'
             END
                AS PRICE_CATEGORY_FINAL,
             SUM (HIST.EXT_SALES_AMOUNT)
                AS EXT_SALES_AMOUNT,
             COUNT (HIST.INVOICE_LINE_NUMBER)
                AS TOTAL_LINES,
             SUM (HIST.EXT_AVG_COGS_AMOUNT)
                AS AVG_COGS,
             SUM (HIST.CORE_ADJ_AVG_COST)
                AS EXT_AVG_COGS_AMOUNT
      FROM                [DWFEI_STG].[PR_PRICE_CAT_HIST] HIST
           INNER JOIN [DWFEI_STG].[SALES_WAREHOUSE_DIM] SWD
              ON HIST.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
           INNER JOIN [DWFEI_STG].[TIME_PERIOD_DIMENSION] TPD
              ON HIST.YEARMONTH = TPD.YEARMONTH
           INNER JOIN [DWFEI_STG].[CUSTOMER_DIMENSION] CUST
              ON HIST.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
           LEFT OUTER JOIN [DWFEI_STG].[BG_CUSTTYPE_XREF] BG_BUDG
              ON COALESCE (CUST.BMI_BUDGET_CUST_TYPE,
                           CUST.BMI_REPORT_CUST_TYPE,
                           CUST.CUSTOMER_TYPE) =
                 BG_BUDG.CUSTOMER_TYPE
  WHERE  TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
  GROUP BY TPD.FISCAL_YEAR_TO_DATE,
      TPD.ROLL12MONTHS,
               SWD.REGION_NAME,
               SWD.DIVISION_NAME,
               SWD.ACCOUNT_NAME,
               TPD.YEARMONTH,
               ISNULL (BG_BUDG.BUSINESS_GROUP, 'OTHER'),
               HIST.PRICE_CATEGORY_FINAL
    ) SLS"
    ])