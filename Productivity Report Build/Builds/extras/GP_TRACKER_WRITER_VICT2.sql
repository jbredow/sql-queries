CREATE OR REPLACE FORCE VIEW "AAD9606"."GP_TRACKER_WRITER_VICT2"
(
   "YEARMONTH",
   "CHANNEL",
   "MM",
   "REGION",
   "ACCOUNT_NUMBER",
   "ACCOUNT_NAME",
   "WRITER_INIT",
   "GPTRACK_KEY",
   "Total Sales",
   "Sales, Sub-Total",
   "Sales, Freight",
   "Sales, Misc",
   "Sales, Restock",
   "Total Cost",
   "Cost, Sub-Total",
   "Cost, Freight",
   "Cost, Misc",
   "Total GP$",
   "Total # Lines",
   "Price Matrix Sales",
   "Price Matrix Cost",
   "Price Matrix GP$",
   "Price Matrix # Lines",
   "Contract Sales",
   "Contract Cost",
   "Contract GP$",
   "Contract # Lines",
   "Manual Sales",
   "Manual Cost",
   "Manual GP$",
   "Manual # Invoices",
   "Other Sales",
   "Other Cost",
   "Other GP$",
   "Other # Lines",
   "Credits $",
   "Credits Lines",
   "Freight Profit (Loss)",
   "Total # Invoices",
   "Outbound Sales"
)
AS
   SELECT GP_DATA.YEARMONTH,
          CASE
             WHEN GP_DATA.TYPE_OF_SALE IN ('Showroom', 'Showroom Direct')
             THEN
                'Showroom'
             ELSE
                GP_DATA.TYPE_OF_SALE
          END
             AS CHANNEL,
          DENSE_RANK () OVER (ORDER BY GP_DATA.YEARMONTH ASC) AS MM,
          CASE
             WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
             WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
             WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
             ELSE GP_DATA.REGION
          END
             REGION,
          GP_DATA.ACCOUNT_NUMBER,
          ACCT.ACCOUNT_NAME,
          --NVL(BRCH.REG_ACCT_NAME, ACCT.ACCOUNT_NAME) AS BRANCH,
          NVL (GP_DATA.WRITER, '#N/A') WRITER_INIT,
             CASE
                WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
                WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
                WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
                ELSE GP_DATA.REGION
             END
          || '*'
          || GP_DATA.ACCOUNT_NUMBER
          || '*'
          || NVL (GP_DATA.WRITER, '#N/A')
          || CASE
                WHEN GP_DATA.TYPE_OF_SALE IN ('Showroom', 'Showroom Direct')
                THEN
                   'Showroom'
                ELSE
                   GP_DATA.TYPE_OF_SALE
             END
             AS GPTRACK_KEY,
          SUM (
               GP_DATA.EXT_SALES)
             "Total Sales",
          SUM (GP_DATA.EXT_SALES) "Sales, Sub-Total",
          0 "Sales, Freight",
          0 "Sales, Misc",
          0 "Sales, Restock",
          SUM (
               GP_DATA.AVG_COGS)
             "Total Cost",
          SUM (GP_DATA.AVG_COGS) "Cost, Sub-Total",
          0 "Cost, Freight",
          0 "Cost, Misc",
          SUM 
               (  GP_DATA.EXT_SALES
             -   GP_DATA.AVG_COGS)
             "Total GP$",
          SUM (GP_DATA.INVOICE_LINES) "Total # Lines",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
             "Price Matrix Sales",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
             "Price Matrix Cost",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
             "Price Matrix GP$",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
             "Price Matrix # Lines",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
             "Contract Sales",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
             "Contract Cost",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
             "Contract GP$",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
             "Contract # Lines",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
             "Manual Sales",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
             "Manual Cost",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
             "Manual GP$",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.INVOICE_CNT)
                ELSE
                   0
             END)
             "Manual # Invoices",
          SUM (CASE
                  WHEN GP_DATA.PRICE_CATEGORY NOT IN ('MATRIX',
                                                      'OVERRIDE',
                                                      'MANUAL',
                                                      'CREDITS',
                                                      'TOOLS',
                                                      'QUOTE',
                                                      'MATRIX_BID',
                                                      'Total')
                  THEN
                     (GP_DATA.EXT_SALES)
                  ELSE
                     0
               END)
             "Other Sales",
          SUM (CASE
                  WHEN GP_DATA.PRICE_CATEGORY NOT IN ('MATRIX',
                                                      'OVERRIDE',
                                                      'MANUAL',
                                                      'CREDITS',
                                                      'TOOLS',
                                                      'QUOTE',
                                                      'MATRIX_BID',
                                                      'Total')
                  THEN
                     (GP_DATA.AVG_COGS)
                  ELSE
                     0
               END)
             "Other Cost",
          SUM (CASE
                  WHEN GP_DATA.PRICE_CATEGORY NOT IN ('MATRIX',
                                                      'OVERRIDE',
                                                      'MANUAL',
                                                      'CREDITS',
                                                      'TOOLS',
                                                      'QUOTE',
                                                      'MATRIX_BID',
                                                      'Total')
                  THEN
                     (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                  ELSE
                     0
               END)
             "Other GP$",
          SUM (CASE
                  WHEN GP_DATA.PRICE_CATEGORY NOT IN ('MATRIX',
                                                      'OVERRIDE',
                                                      'MANUAL',
                                                      'CREDITS',
                                                      'TOOLS',
                                                      'QUOTE',
                                                      'MATRIX_BID',
                                                      'Total')
                  THEN
                     (GP_DATA.INVOICE_LINES)
                  ELSE
                     0
               END)
             "Other # Lines",
          ROUND (
             SUM (
                CASE
                   WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                   THEN
                      (GP_DATA.EXT_SALES)
                   ELSE
                      0
                END),
             3)
             "Credits $",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
             "Credits Lines",
          0
             "Freight Profit (Loss)",
          SUM ( GP_DATA.INVOICE_CNT) "Total # Invoices",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
             "Outbound Sales"
     FROM AAD9606.PR_WRITER_UTIL_SUMMARY GP_DATA,
          (SELECT WD.ACCOUNT_NAME,
                  WD.ACCOUNT_NUMBER_NK,
                  WD.WAREHOUSE_NUMBER_NK
             FROM SALES_MART.SALES_WAREHOUSE_DIM WD
           GROUP BY WD.ACCOUNT_NAME,
                    WD.ACCOUNT_NUMBER_NK,
                    WD.WAREHOUSE_NUMBER_NK) ACCT                            --
    --AAE0376.MEGA_BRANCHES BRCH
    WHERE     GP_DATA.WAREHOUSE_NUMBER = ACCT.WAREHOUSE_NUMBER_NK(+)
          AND GP_DATA.WRITER IS NOT NULL
   --AND GP_DATA.WAREHOUSE_NUMBER = BRCH.WHSE(+)

   GROUP BY GP_DATA.YEARMONTH,
            CASE
               WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
               WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
               WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
               ELSE GP_DATA.REGION
            END,
            GP_DATA.ACCOUNT_NUMBER,
            ACCT.ACCOUNT_NAME,
            --.REG_ACCT_NAME,
            GP_DATA.WRITER,
            CASE
               WHEN GP_DATA.TYPE_OF_SALE IN ('Showroom', 'Showroom Direct')
               THEN
                  'Showroom'
               ELSE
                  GP_DATA.TYPE_OF_SALE
            END
   ORDER BY    CASE
                  WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
                  WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
                  WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
                  ELSE GP_DATA.REGION
               END
            || '*'
            || GP_DATA.ACCOUNT_NUMBER
            || '*'
            || NVL (GP_DATA.WRITER, '#N/A')
            || CASE
                  WHEN GP_DATA.TYPE_OF_SALE IN ('Showroom', 'Showroom Direct')
                  THEN
                     'Showroom'
                  ELSE
                     GP_DATA.TYPE_OF_SALE
               END
  