SELECT GP_DATA.YEARMONTH,
       DENSE_RANK () OVER (ORDER BY GP_DATA.YEARMONTH ASC) AS MM,
       GP_DATA.REGION,
       GP_DATA.ACCOUNT_NUMBER,
       ACCT.ACCOUNT_NAME,
       NVL(BRCH.REG_ACCT_NAME, ACCT.ACCOUNT_NAME) AS BRANCH,
       NVL (GP_DATA.WRITER, '#N/A') WRITER_INIT,
       GP_DATA.REGION
       || '*'
       || GP_DATA.ACCOUNT_NUMBER
       || '*'
       || NVL (GP_DATA.WRITER, '#N/A')
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
       ROUND (
          SUM (
             (  GP_DATA.SLS_SUBTOTAL
              + GP_DATA.SLS_FREIGHT
              + GP_DATA.SLS_MISC
              + GP_DATA.SLS_RESTOCK)
             - (  GP_DATA.AVG_COST_SUBTOTAL
                + GP_DATA.AVG_COST_FREIGHT
                + GP_DATA.AVG_COST_MISC))
          / SUM (
                 GP_DATA.SLS_SUBTOTAL
               + GP_DATA.SLS_FREIGHT
               + GP_DATA.SLS_MISC
               + GP_DATA.SLS_RESTOCK),
          6)
          "Total GP%",
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
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                  THEN
                     CASE
                        WHEN GP_DATA.EXT_SALES > 0 THEN (GP_DATA.EXT_SALES)
                        ELSE 1
                     END
                  ELSE
                     1
               END),
          6)
          "Price Matrix GP%",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
                  ELSE 1
               END),
          6)
          "Price Matrix Use%$",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.INVOICE_LINES > 0 THEN GP_DATA.INVOICE_LINES
                  ELSE 1
               END),
          6)
          "Price Matrix Use%#",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.ROLLUP = 'Total'
                  THEN
                     CASE
                        WHEN (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) > 0
                        THEN
                           (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                        ELSE
                           1
                     END
                  ELSE
                     1
               END),
          6)
          "Price Matrix Profit%$",
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
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                  THEN
                     CASE
                        WHEN GP_DATA.EXT_SALES > 0 THEN (GP_DATA.EXT_SALES)
                        ELSE 1
                     END
                  ELSE
                     1
               END),
          6)
          "Contract GP%",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
                  ELSE 1
               END),
          6)
          "Contract Use%$",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.INVOICE_LINES > 0 THEN GP_DATA.INVOICE_LINES
                  ELSE 1
               END),
          6)
          "Contract Use%#",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.ROLLUP = 'Total'
                  THEN
                     CASE
                        WHEN (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) > 0
                        THEN
                           (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                        ELSE
                           1
                     END
                  ELSE
                     1
               END),
          6)
          "Contract Profit%$",
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
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                  THEN
                     CASE
                        WHEN GP_DATA.EXT_SALES > 0 THEN (GP_DATA.EXT_SALES)
                        ELSE 1
                     END
                  ELSE
                     1
               END),
          6)
          "Manual GP%",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
                  ELSE 1
               END),
          6)
          "Manual Use%$",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.INVOICE_LINES > 0 THEN GP_DATA.INVOICE_LINES
                  ELSE 1
               END),
          6)
          "Manual Use%#",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                THEN
                   (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.ROLLUP = 'Total'
                  THEN
                     CASE
                        WHEN (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) > 0
                        THEN
                           (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                        ELSE
                           1
                     END
                  ELSE
                     1
               END),
          6)
          "Manual Profit%$",
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
             THEN
                (GP_DATA.INVOICE_LINES)
             ELSE
                0
          END)
          "Manual # Lines",
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY NOT IN
                     ('MATRIX',
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
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY NOT IN
                     ('MATRIX',
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
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY NOT IN
                     ('MATRIX',
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
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN
                        ('MATRIX',
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
          / SUM (
               CASE
                  WHEN GP_DATA.PRICE_CATEGORY NOT IN
                          ('MATRIX',
                           'OVERRIDE',
                           'MANUAL',
                           'CREDITS',
                           'TOOLS',
                           'QUOTE',
                           'MATRIX_BID',
                           'Total')
                  THEN
                     CASE
                        WHEN GP_DATA.EXT_SALES > 0 THEN (GP_DATA.EXT_SALES)
                        ELSE 1
                     END
                  ELSE
                     1
               END),
          6)
          "Other GP%",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN
                        ('MATRIX',
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
          / SUM (
               CASE
                  WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
                  ELSE 1
               END),
          6)
          "Other Use%$",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN
                        ('MATRIX',
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
          / SUM (
               CASE
                  WHEN GP_DATA.INVOICE_LINES > 0 THEN GP_DATA.INVOICE_LINES
                  ELSE 1
               END),
          6)
          "Other Use%#",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN
                        ('MATRIX',
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
          / SUM (
               CASE
                  WHEN GP_DATA.ROLLUP = 'Total'
                  THEN
                     CASE
                        WHEN (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) > 0
                        THEN
                           (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                        ELSE
                           1
                     END
                  ELSE
                     1
               END),
          6)
          "Other Profit%$",
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY NOT IN
                     ('MATRIX',
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
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
                  ELSE 1
               END),
          6)
          "Credits Use%$",
       ROUND (
          SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                THEN
                   (GP_DATA.INVOICE_LINES)
                ELSE
                   0
             END)
          / SUM (
               CASE
                  WHEN GP_DATA.INVOICE_LINES > 0 THEN GP_DATA.INVOICE_LINES
                  ELSE 1
               END),
          6)
          "Credits Use%#",
       SUM (GP_DATA.SLS_FREIGHT - GP_DATA.AVG_COST_FREIGHT)
          "Freight Profit (Loss)",
       SUM (
          CASE
             WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
             THEN
                (GP_DATA.EXT_SALES)
             ELSE
                0
          END)
          "Credit Sales",
       SUM (
          CASE
             WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
             ELSE 1
          END)
          "Outbound Sales"
  FROM AAE0376.GP_TRACKER_WRITER GP_DATA,
       SALES_MART.SALES_WAREHOUSE_DIM ACCT,
       AAE0376.MEGA_BRANCHES BRCH
  WHERE GP_DATA.WAREHOUSE_NUMBER = ACCT.WAREHOUSE_NUMBER_NK(+)
        AND GP_DATA.WAREHOUSE_NUMBER = BRCH.WHSE(+)
        AND GP_DATA.YEARMONTH = TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
										'YYYYMM')
       
HAVING SUM ( 
GP_DATA.SLS_SUBTOTAL 
+ GP_DATA.SLS_FREIGHT 
+ GP_DATA.SLS_MISC 
+ GP_DATA.SLS_RESTOCK) > 0 
AND SUM ( 
CASE 
WHEN GP_DATA.ROLLUP = 'Total' 
THEN 
(GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) 
ELSE 
0 
END) > 0

GROUP BY GP_DATA.YEARMONTH,
         GP_DATA.REGION,
         GP_DATA.ACCOUNT_NUMBER,
         ACCT.ACCOUNT_NAME,
         BRCH.REG_ACCT_NAME,
         ACCT.ACCOUNT_NAME,
         --ACCT.WAREHOUSE_NUMBER_NK,
         GP_DATA.WRITER
ORDER BY GP_DATA.REGION
         || '*'
         || GP_DATA.ACCOUNT_NUMBER
         || '*'
         || NVL (GP_DATA.WRITER, '#N/A')