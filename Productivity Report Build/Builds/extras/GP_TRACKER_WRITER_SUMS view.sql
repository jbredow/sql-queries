
CREATE OR REPLACE FORCE VIEW AAE0376.GP_TRACKER_WRITER_SUMS

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
       SUM (GP_DATA.SLS_FREIGHT - GP_DATA.AVG_COST_FREIGHT)
          "Freight Profit (Loss)",
       COUNT (GP_DATA.INVOICE_NUMBER_NK) "Total # Invoices",
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
             THEN
                (GP_DATA.EXT_SALES_AMOUNT)
             ELSE
                0
          END)
          "Outbound Sales"
  FROM AAE0376.PR_VICT2_CUST_12MO GP_DATA,
       (SELECT  WD.REGION_NAME, WD.ACCOUNT_NAME, WD.ACCOUNT_NUMBER_NK, WD.WAREHOUSE_NUMBER_NK
          FROM SALES_MART.SALES_WAREHOUSE_DIM WD
        GROUP BY WD.ACCOUNT_NAME,
                 WD.ACCOUNT_NUMBER_NK,
                 WD.WAREHOUSE_NUMBER_NK) ACCT                               --
 WHERE     GP_DATA.WAREHOUSE_NUMBER = ACCT.WAREHOUSE_NUMBER_NK(+)
       AND GP_DATA.WRITER IS NOT NULL

GROUP BY GP_DATA.YEARMONTH,
         CASE
            WHEN ACCT.REGION_NAME IS NULL THEN ACCT.ACCOUNT_NAME
               WHEN ACCT.REGION_NAME = '%EAST%' THEN 'EASTERN'
               WHEN ACCT.REGION_NAME = '%WEST%' THEN 'WESTERN'
               ELSE ACCT.REGION_NAME
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
               WHEN ACCT.REGION_NAME IS NULL THEN ACCT.ACCOUNT_NAME
               WHEN ACCT.REGION_NAME = '%EAST%' THEN 'EASTERN'
               WHEN ACCT.REGION_NAME = '%WEST%' THEN 'WESTERN'
               ELSE ACCT.REGION_NAME
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