SELECT GP_DATA.REGION,
       GP_DATA.DISTRICT,
       GP_DATA.ACCOUNT_NUMBER,
       GP_DATA.ACCOUNT_NAME,
       DECODE (GP_DATA.ALIAS_NAME,
               'UPPER_MIDWEST', 'UPPER MIDWEST',
               GP_DATA.ALIAS_NAME)
          ALIAS_NAME,
       GP_DATA.PILOT_CUSTOMER_GROUP,
       GP_DATA.SHOW_PROD_GRP,
       GP_DATA.YYYYWW,
       GP_DATA.PILOT_LIVE,
       GP_DATA.PILOT_PROD,
       SUM (GP_DATA.EXT_SALES)
          "Total Sales",
       SUM (GP_DATA.EXT_SALES)
          "Sales, Sub-Total",
       SUM (GP_DATA.AVG_COGS)
          "Total Cost",
       SUM (GP_DATA.OLD_AVG_COGS)
          "Cost, Old",
       SUM (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
          "Total GP$",
       SUM (GP_DATA.INVOICE_LINES)
          "Total # Lines",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                (GP_DATA.EXT_SALES)
             ELSE
                0
          END)
          "Price Matrix Sales",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                (GP_DATA.AVG_COGS)
             ELSE
                0
          END)
          "Price Matrix Cost",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
             ELSE
                0
          END)
          "Price Matrix GP$",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                (GP_DATA.INVOICE_LINES)
             ELSE
                0
          END)
          "Price Matrix # Lines",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN 'OVERRIDE'
             THEN
                (GP_DATA.EXT_SALES)
             ELSE
                0
          END)
          "Contract Sales",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN 'OVERRIDE'
             THEN
                (GP_DATA.AVG_COGS)
             ELSE
                0
          END)
          "Contract Cost",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN 'OVERRIDE'
             THEN
                (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
             ELSE
                0
          END)
          "Contract GP$",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN 'OVERRIDE'
             THEN
                (GP_DATA.INVOICE_LINES)
             ELSE
                0
          END)
          "Contract # Lines",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
             THEN
                (GP_DATA.EXT_SALES)
             ELSE
                0
          END)
          "Manual Sales",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
             THEN
                (GP_DATA.AVG_COGS)
             ELSE
                0
          END)
          "Manual Cost",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
             THEN
                (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
             ELSE
                0
          END)
          "Manual GP$",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
             THEN
                (GP_DATA.INVOICE_LINES)
             ELSE
                0
          END)
          "Manual # Lines",
       SUM (CASE
               WHEN GP_DATA.RPT_PRICE_CATEGORY NOT IN ('MATRIX',
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
               WHEN GP_DATA.RPT_PRICE_CATEGORY NOT IN ('MATRIX',
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
               WHEN GP_DATA.RPT_PRICE_CATEGORY NOT IN ('MATRIX',
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
               WHEN GP_DATA.RPT_PRICE_CATEGORY NOT IN ('MATRIX',
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
                WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('CREDITS')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END),
          3)
          "Credits $",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY IN ('CREDITS')
             THEN
                (GP_DATA.INVOICE_LINES)
             ELSE
                0
          END)
          "Credits Lines",
       0
          "Freight Profit (Loss)",
       SUM (GP_DATA.INVOICE_CNT)
          "Total # Invoices",
       SUM (
          CASE
             WHEN GP_DATA.RPT_PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
             THEN
                (GP_DATA.EXT_SALES)
             ELSE
                0
          END)
          "Outbound Sales"
FROM AAD9606.PR_SHOW_WEEKLY_SUMMARY GP_DATA                                 --
GROUP BY GP_DATA.REGION,
         GP_DATA.DISTRICT,
         GP_DATA.ACCOUNT_NUMBER,
         GP_DATA.ACCOUNT_NAME,
         DECODE (GP_DATA.ALIAS_NAME,
                 'UPPER_MIDWEST', 'UPPER MIDWEST',
                 GP_DATA.ALIAS_NAME),
         GP_DATA.PILOT_CUSTOMER_GROUP,
         GP_DATA.SHOW_PROD_GRP,
         GP_DATA.YYYYWW,
         GP_DATA.PILOT_LIVE,
         GP_DATA.PILOT_PROD