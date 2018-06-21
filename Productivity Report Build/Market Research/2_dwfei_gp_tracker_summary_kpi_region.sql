--FROM AAA6863.GP_TRACKER_WRITER_YTD
SELECT YEARMONTH,
       CHANNEL,
       REGION,
       --ACCOUNT_NAME,
       --ACCOUNT_NUMBER,
       --WAREHOUSE_NUMBER WHSE,
       --WRITER_INIT WRITER,
       --MM,
       --'YTD' YEARMONTH,
       ROUND ("Price Matrix Use%$" + "Contract Use%$", 4)
          "Managed Price Use%$",
       "Price Matrix Use%$",
       "Contract Use%$"
  FROM (
SELECT GP_SUMS.YEARMONTH,
       --GP_SUMS.MM,
       GP_SUMS.REGION,
       --GP_SUMS.ACCOUNT_NUMBER,
       --GP_SUMS.ACCOUNT_NAME,
       GP_SUMS.CHANNEL,
       --GP_SUMS.WRITER_INIT,
       --GP_SUMS.WAREHOUSE_NUMBER,
       GP_SUMS.GPTRACK_KEY,
       GP_SUMS.TOTAL_SALES "Total Sales",
       GP_SUMS.SLS_SUBTOTAL "Sales, Sub-Total",
       GP_SUMS.SLS_OUTBOUND - GP_SUMS.SLS_SUBTOTAL "Outbound Diff",
       GP_SUMS.SLS_FREIGHT "Sales, Freight",
       GP_SUMS.SLS_MISC "Sales, Misc",
       GP_SUMS.SLS_RESTOCK "Sales, Restock",
       GP_SUMS.TOTAL_COST "Total Cost",
       GP_SUMS.COST_SUBTOTAL "Cost, Sub-Total",
       GP_SUMS.COST_FREIGHT "Cost, Freight",
       GP_SUMS.COST_MISC "Cost, Misc",
       GP_SUMS.TOTAL_GP "Total GP$",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_SALES > 0
             THEN
                GP_SUMS.TOTAL_GP / GP_SUMS.TOTAL_SALES
             ELSE
                0
          END,
          6)
          "Total GP%",
       GP_SUMS.TOTAL_LINES "Total # Lines",
       GP_SUMS.MATRIX_SALES "Price Matrix Sales",
       GP_SUMS.MATRIX_COST "Price Matrix Cost",
       GP_SUMS.MATRIX_GP "Price Matrix GP$",
       ROUND (
          CASE
             WHEN GP_SUMS.MATRIX_SALES > 0
             THEN
                GP_SUMS.MATRIX_GP / GP_SUMS.MATRIX_SALES
             ELSE
                0
          END,
          6)
          "Price Matrix GP%",
       ROUND (
          CASE
             WHEN GP_SUMS.SLS_OUTBOUND > 0
             THEN
                GP_SUMS.MATRIX_SALES / GP_SUMS.SLS_OUTBOUND
             ELSE
                0
          END,
          6)
          "Price Matrix Use%$",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_LINES > 0
             THEN
                GP_SUMS.MATRIX_LINES / GP_SUMS.TOTAL_LINES
             ELSE
                0
          END,
          6)
          "Price Matrix Use%#",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_GP > 0
             THEN
                GP_SUMS.MATRIX_GP / GP_SUMS.TOTAL_GP
             ELSE
                0
          END,
          6)
          "Price Matrix Profit%$",
       GP_SUMS.MATRIX_LINES "Price Matrix # Lines",
       GP_SUMS.CONTRACT_SALES "Contract Sales",
       GP_SUMS.CONTRACT_COST "Contract Cost",
       GP_SUMS.CONTRACT_GP "Contract GP$",
       ROUND (
          CASE
             WHEN GP_SUMS.CONTRACT_SALES > 0
             THEN
                GP_SUMS.CONTRACT_GP / GP_SUMS.CONTRACT_SALES
             ELSE
                0
          END,
          6)
          "Contract GP%",
       ROUND (
          CASE
             WHEN GP_SUMS.SLS_OUTBOUND > 0
             THEN
                GP_SUMS.CONTRACT_SALES / GP_SUMS.SLS_OUTBOUND
             ELSE
                0
          END,
          6)
          "Contract Use%$",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_LINES > 0
             THEN
                GP_SUMS.CONTRACT_LINES / GP_SUMS.TOTAL_LINES
             ELSE
                0
          END,
          6)
          "Contract Use%#",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_GP > 0
             THEN
                GP_SUMS.CONTRACT_GP / GP_SUMS.TOTAL_GP
             ELSE
                0
          END,
          6)
          "Contract Profit%$",
       GP_SUMS.CONTRACT_LINES "Contract # Lines",
       GP_SUMS.MANUAL_SALES "Manual Sales",
       GP_SUMS.MANUAL_COST "Manual Cost",
       GP_SUMS.MANUAL_GP "Manual GP$",
       ROUND (
          CASE
             WHEN GP_SUMS.MANUAL_SALES > 0
             THEN
                GP_SUMS.MANUAL_GP / GP_SUMS.MANUAL_SALES
             ELSE
                0
          END,
          6)
          "Manual GP%",
       ROUND (
          CASE
             WHEN GP_SUMS.SLS_OUTBOUND > 0
             THEN
                GP_SUMS.MANUAL_SALES / GP_SUMS.SLS_OUTBOUND
             ELSE
                0
          END,
          6)
          "Manual Use%$",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_LINES > 0
             THEN
                GP_SUMS.MANUAL_LINES / GP_SUMS.TOTAL_LINES
             ELSE
                0
          END,
          6)
          "Manual Use%#",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_GP > 0
             THEN
                GP_SUMS.MANUAL_GP / GP_SUMS.TOTAL_GP
             ELSE
                0
          END,
          6)
          "Manual Profit%$",
       GP_SUMS.MANUAL_LINES "Manual # Lines",
       GP_SUMS.OTHER_SALES "Other Sales",
       GP_SUMS.OTHER_COST "Other Cost",
       GP_SUMS.OTHER_GP "Other GP$",
       ROUND (
          CASE
             WHEN GP_SUMS.OTHER_SALES > 0
             THEN
                GP_SUMS.OTHER_GP / GP_SUMS.OTHER_SALES
             ELSE
                0
          END,
          6)
          "Other GP%",
       ROUND (
          CASE
             WHEN GP_SUMS.SLS_OUTBOUND > 0
             THEN
                GP_SUMS.OTHER_SALES / GP_SUMS.SLS_OUTBOUND
             ELSE
                0
          END,
          6)
          "Other Use%$",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_LINES > 0
             THEN
                GP_SUMS.OTHER_LINES / GP_SUMS.TOTAL_LINES
             ELSE
                0
          END,
          6)
          "Other Use%#",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_GP > 0
             THEN
                GP_SUMS.OTHER_GP / GP_SUMS.TOTAL_GP
             ELSE
                0
          END,
          6)
          "Other Profit%$",
       GP_SUMS.OTHER_LINES "Other # Lines",
       GP_SUMS.CREDIT_SALES "Credit Sales$",
       ROUND (
          CASE
             WHEN GP_SUMS.SLS_OUTBOUND > 0
             THEN
                GP_SUMS.CREDIT_SALES / GP_SUMS.SLS_OUTBOUND
             ELSE
                0
          END,
          6)
          "Credits Use%$",
       ROUND (
          CASE
             WHEN GP_SUMS.TOTAL_LINES > 0
             THEN
                GP_SUMS.CREDIT_LINES / GP_SUMS.TOTAL_LINES
             ELSE
                0
          END,
          6)
          "Credits Use%#",
       GP_SUMS.FREIGHT_PROFIT_LOSS "Freight Profit (Loss)",
       GP_SUMS.SLS_OUTBOUND "Outbound Sales"
  FROM (SELECT ' YTD' YEARMONTH,
               CASE
                  WHEN GP_DATA.TYPE_OF_SALE IN
                          ('Showroom', 'Showroom Direct')
                  THEN
                     'Showroom'
                  ELSE
                     GP_DATA.TYPE_OF_SALE
               END
                  AS CHANNEL,
               --DENSE_RANK () OVER (ORDER BY GP_DATA.YEARMONTH ASC) AS MM,
               CASE
                  --WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
                  WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
                  WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
                  --WHEN GP_DATA.REGION IN ('NO CENTRAL', 'SO CENTRAL') THEN 'CENTRAL'
                  ELSE GP_DATA.REGION
               END
                  REGION,
               --GP_DATA.ACCOUNT_NUMBER,
               --GP_DATA.WAREHOUSE_NUMBER,
               --ACCT.ACCOUNT_NAME,
               --NVL (GP_DATA.WRITER, '#N/A') WRITER_INIT,
                  --NVL(REPS.ASSOC_NAME,'#N/A') WRITER_NAME,
                  CASE
                     --WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
                     WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
                     WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
                     --WHEN GP_DATA.REGION IN ('NO CENTRAL', 'SO CENTRAL') THEN 'CENTRAL'
                     ELSE GP_DATA.REGION
                  END
               || '*'
               --|| GP_DATA.ACCOUNT_NUMBER
               || '*'
               --|| GP_DATA.WAREHOUSE_NUMBER
               || '*'
               --|| NVL (GP_DATA.WRITER, '#N/A')
                  AS GPTRACK_KEY,
               SUM (
                    GP_DATA.SLS_SUBTOTAL
                  + GP_DATA.SLS_FREIGHT
                  + GP_DATA.SLS_MISC
                  + GP_DATA.SLS_RESTOCK)
                  TOTAL_SALES,
               SUM (GP_DATA.SLS_SUBTOTAL) SLS_SUBTOTAL,
               SUM (
                  CASE
                     WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
                     ELSE 0
                  END)
                  SLS_OUTBOUND1,
               SUM (
                  CASE
                     WHEN (GP_DATA.PRICE_CATEGORY NOT IN ('Total', 'CREDITS')
                           AND GP_DATA.TYPE_OF_SALE NOT IN 'Credit Memo'
                           AND GP_DATA.EXT_SALES > 0)
                     THEN
                        GP_DATA.EXT_SALES
                     ELSE
                        0
                  END)
                  SLS_OUTBOUND,
               SUM (GP_DATA.SLS_FREIGHT) SLS_FREIGHT,
               SUM (GP_DATA.SLS_MISC) SLS_MISC,
               SUM (GP_DATA.SLS_RESTOCK) SLS_RESTOCK,
               SUM (
                    GP_DATA.AVG_COST_SUBTOTAL
                  + GP_DATA.AVG_COST_FREIGHT
                  + GP_DATA.AVG_COST_MISC)
                  TOTAL_COST,
               SUM (GP_DATA.AVG_COST_SUBTOTAL) COST_SUBTOTAL,
               SUM (GP_DATA.AVG_COST_FREIGHT) COST_FREIGHT,
               SUM (GP_DATA.AVG_COST_MISC) COST_MISC,
               SUM (
                  (  GP_DATA.SLS_SUBTOTAL
                   + GP_DATA.SLS_FREIGHT
                   + GP_DATA.SLS_MISC
                   + GP_DATA.SLS_RESTOCK)
                  - (  GP_DATA.AVG_COST_SUBTOTAL
                     + GP_DATA.AVG_COST_FREIGHT
                     + GP_DATA.AVG_COST_MISC))
                  TOTAL_GP,
               SUM (GP_DATA.INVOICE_LINES) TOTAL_LINES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  MATRIX_SALES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
                     THEN
                        (GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  MATRIX_COST,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
                     THEN
                        (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  MATRIX_GP,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
                     THEN
                        (GP_DATA.INVOICE_LINES)
                     ELSE
                        0
                  END)
                  MATRIX_LINES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  CONTRACT_SALES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                        (GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  CONTRACT_COST,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                        (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  CONTRACT_GP,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                        (GP_DATA.INVOICE_LINES)
                     ELSE
                        0
                  END)
                  CONTRACT_LINES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN
                             ('MANUAL', 'TOOLS', 'QUOTE')
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  MANUAL_SALES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN
                             ('MANUAL', 'TOOLS', 'QUOTE')
                     THEN
                        (GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  MANUAL_COST,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN
                             ('MANUAL', 'TOOLS', 'QUOTE')
                     THEN
                        (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  MANUAL_GP,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN
                             ('MANUAL', 'TOOLS', 'QUOTE')
                     THEN
                        (GP_DATA.INVOICE_LINES)
                     ELSE
                        0
                  END)
                  MANUAL_LINES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY NOT IN
                             ('MATRIX',
                              'OVERRIDE',
                              'MANUAL',
                              'CREDITS',
                              'TOOLS',
                              'NDP', 
                              'QUOTE',
                              'MATRIX_BID',
                              'Total')
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  OTHER_SALES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY NOT IN
                             ('MATRIX',
                              'OVERRIDE',
                              'MANUAL',
                              'CREDITS',
                              'TOOLS',
                              'NDP', 
                              'QUOTE',
                              'MATRIX_BID',
                              'Total')
                     THEN
                        (GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  OTHER_COST,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY NOT IN
                             ('MATRIX',
                              'OVERRIDE',
                              'MANUAL',
                              'CREDITS',
                              'TOOLS',
                              'NDP', 
                              'QUOTE',
                              'MATRIX_BID',
                              'Total')
                     THEN
                        (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  OTHER_GP,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY NOT IN
                             ('MATRIX',
                              'OVERRIDE',
                              'MANUAL',
                              'CREDITS',
                              'TOOLS',
                              'NDP', 
                              'QUOTE',
                              'MATRIX_BID',
                              'Total')
                     THEN
                        (GP_DATA.INVOICE_LINES)
                     ELSE
                        0
                  END)
                  OTHER_LINES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  CREDIT_SALES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                     THEN
                        (GP_DATA.INVOICE_LINES)
                     ELSE
                        0
                  END)
                  CREDIT_LINES,
               SUM (GP_DATA.SLS_FREIGHT - GP_DATA.AVG_COST_FREIGHT)
                  AS FREIGHT_PROFIT_LOSS
                  
          FROM AAA6863.GP_TRACKER_WRITER_YTD GP_DATA
          
        WHERE GP_DATA.YEARMONTH BETWEEN TO_CHAR (
                                               TRUNC (
                                                  SYSDATE
                                                  - NUMTOYMINTERVAL (12, 'MONTH'),
                                                  'MONTH'),
                                               'YYYYMM')
                                        AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                                     'YYYYMM')
              --AND GP_DATA.YEARMONTH = (SELECT MAX (GP_DATA.YEARMONTH)
              

        GROUP BY --GP_DATA.YEARMONTH,
                 CASE
                    WHEN GP_DATA.TYPE_OF_SALE IN
                            ('Showroom', 'Showroom Direct')
                    THEN
                       'Showroom'
                    ELSE
                       GP_DATA.TYPE_OF_SALE
                 END,
                 --GP_DATA.WAREHOUSE_NUMBER,
                 GP_DATA.REGION
                 --GP_DATA.ACCOUNT_NUMBER--,
                 --ACCT.ACCOUNT_NAME--,
                 --GP_DATA.WRITER
                 ) GP_SUMS
 --WHERE WRITER_INIT NOT IN '#N/A'
ORDER BY GPTRACK_KEY ASC)
WHERE CHANNEL IN ('Showroom', 'Counter')
AND REGION IN ('WEST REGION','EAST REGION','HVAC REGION','WATERWORKS REGION', 'SOUTH CENTRAL REGION', 'NORTH CENTRAL REGION')
ORDER BY CHANNEL ASC,
         REGION ASC--,
         --ACCOUNT_NAME ASC