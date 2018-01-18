CREATE OR REPLACE FORCE VIEW AAD9606.GP_TRACKER_SUMS_WHSE
AS
   SELECT GP_DATA.YEARMONTH,
          CASE
             WHEN UPPER (GP_DATA.TYPE_OF_SALE) = 'SHOWROOM DIRECT'
             THEN
                'Showroom'
             ELSE
                GP_DATA.TYPE_OF_SALE
          END
             "Sale Type",
          CASE
             WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
             WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
             WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
             ELSE GP_DATA.REGION
          END
             "Region",
          ACCT.ACCOUNT_NAME,
          GP_DATA.WAREHOUSE_NUMBER_NK WHSE,
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
    WHERE     GP_DATA.WAREHOUSE_NUMBER_NK = ACCT.WAREHOUSE_NUMBER_NK(+)
          AND GP_DATA.YEARMONTH =
                 TO_CHAR (
                    TRUNC (SYSDATE - NUMTOYMINTERVAL (1, 'MONTH'), 'MONTH'),
                    'YYYYMM')
   GROUP BY GP_DATA.YEARMONTH,
            CASE
               WHEN UPPER (GP_DATA.TYPE_OF_SALE) = 'SHOWROOM DIRECT'
               THEN
                  'Showroom'
               ELSE
                  GP_DATA.TYPE_OF_SALE
            END,
            CASE
               WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
               WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
               WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
               ELSE GP_DATA.REGION
            END,
            ACCT.ACCOUNT_NAME,
            GP_DATA.WAREHOUSE_NUMBER_NK