CREATE OR REPLACE FORCE VIEW "AAD9606"."GP_TRACKER_SUMS"
(
   "CHANNEL",
   "ROLLING_QTR",
   "MM",
   "REGION",
   "ACCOUNT_NUMBER",
   "BU_NAME",
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
   "Manual # Lines",
   "Other Sales",
   "Other Cost",
   "Other GP$",
   "Other # Lines",
   "Credits $",
   "Credits Lines",
   "Freight Profit (Loss)",
   "Outbound Sales"
)
AS
   SELECT CASE
             WHEN GP_DATA.TYPE_OF_SALE IN ('Showroom', 'Showroom Direct')
             THEN
                'Showroom'
             ELSE
                GP_DATA.TYPE_OF_SALE
          END
             AS CHANNEL,
          --GP_DATA.YEARMONTH,
          GP_DATA.ROLLING_QTR,
          DENSE_RANK () OVER (ORDER BY GP_DATA.ROLLING_QTR ASC) AS MM,
          GP_DATA.REGION,
          GP_DATA.ACCOUNT_NUMBER,
          ACCT.ACCOUNT_NAME BU_NAME,
             GP_DATA.REGION
          || '*'
          || GP_DATA.ACCOUNT_NUMBER
          || '*'
          || 'MM'
          || TO_CHAR (DENSE_RANK () OVER (ORDER BY GP_DATA.ROLLING_QTR ASC),
                      'FM00')
             AS GPTRACK_KEY,
          SUM (
               GP_DATA.SLS_SUBTOTAL
             + GP_DATA.SLS_FREIGHT
             + GP_DATA.SLS_MISC
             + GP_DATA.SLS_RESTOCK)
             "Total Sales",
          SUM (GP_DATA.SLS_SUBTOTAL) "Sales, Sub-Total",
          SUM (GP_DATA.SLS_FREIGHT) "Sales, Freight",
          SUM (GP_DATA.SLS_MISC) "Sales, Misc",
          SUM (GP_DATA.SLS_RESTOCK) "Sales, Restock",
          SUM (
               GP_DATA.AVG_COST_SUBTOTAL
             + GP_DATA.AVG_COST_FREIGHT
             + GP_DATA.AVG_COST_MISC)
             "Total Cost",
          SUM (GP_DATA.AVG_COST_SUBTOTAL) "Cost, Sub-Total",
          SUM (GP_DATA.AVG_COST_FREIGHT) "Cost, Freight",
          SUM (GP_DATA.AVG_COST_MISC) "Cost, Misc",
          SUM (
               (  GP_DATA.SLS_SUBTOTAL
                + GP_DATA.SLS_FREIGHT
                + GP_DATA.SLS_MISC
                + GP_DATA.SLS_RESTOCK)
             - (  GP_DATA.AVG_COST_SUBTOTAL
                + GP_DATA.AVG_COST_FREIGHT
                + GP_DATA.AVG_COST_MISC))
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
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
             "Manual # Lines",
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
          SUM (GP_DATA.SLS_FREIGHT - GP_DATA.AVG_COST_FREIGHT)
             "Freight Profit (Loss)",
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
             "Outbound Sales"
     FROM AAE0376.GP_TRACKER_13MO GP_DATA,
          (SELECT WD.ACCOUNT_NAME,
                  WD.ACCOUNT_NUMBER_NK,
                  WD.WAREHOUSE_NUMBER_NK
             FROM SALES_MART.SALES_WAREHOUSE_DIM WD
           GROUP BY WD.ACCOUNT_NAME,
                    WD.ACCOUNT_NUMBER_NK,
                    WD.WAREHOUSE_NUMBER_NK) ACCT                            --
    --AAE0376.MEGA_BRANCHES BRCH
    WHERE GP_DATA.WAREHOUSE_NUMBER_NK = ACCT.WAREHOUSE_NUMBER_NK(+)
   --AND GP_DATA.WAREHOUSE_NUMBER = BRCH.WHSE(+)

   GROUP BY CASE
               WHEN GP_DATA.TYPE_OF_SALE IN ('Showroom', 'Showroom Direct')
               THEN
                  'Showroom'
               ELSE
                  GP_DATA.TYPE_OF_SALE
            END,
            GP_DATA.ROLLING_QTR,
            GP_DATA.REGION,
            GP_DATA.ACCOUNT_NUMBER,
            ACCT.ACCOUNT_NAME
  GRANT SELECT ON "AAD9606"."GP_TRACKER_SUMS" TO PUBLIC