--5350 writer report - December17 jlo

SELECT "YEARMONTH",
       "CHANNEL",
       "MM",
       "REGION",
       "ACCOUNT_NUMBER",
       "ACCOUNT_NAME",
       "WRITER_INIT",
       "GPTRACK_KEY",
       "Total Sales",
       "Total Cost",
       "Total GP$",
       ROUND ( (CASE
                   WHEN "Total Sales" > 0 THEN "Total GP$" / "Total Sales"
                   ELSE 0
                END),
              3
       )
          "Total GP%",
       "Total # Lines",
       "Total Invoice Count",
       "Outbound Sales",
       "Price Matrix Sales",
       "Price Matrix Cost",
       "Price Matrix GP$",
       ROUND ( (CASE
                   WHEN "Price Matrix Sales" > 0
                   THEN
                      "Price Matrix GP$" / "Price Matrix Sales"
                   ELSE
                      0
                END),
              3
       )
          "Price Matrix GP%",
       ROUND ( (CASE
                   WHEN "Outbound Sales" > 0
                   THEN
                      "Price Matrix Sales" / "Outbound Sales"
                   ELSE
                      0
                END),
              3
       )
          "Price Matrix Use%$",
       ROUND ( (CASE
                   WHEN "Total # Lines" > 0
                   THEN
                      "Price Matrix # Lines" / "Total # Lines"
                   ELSE
                      0
                END),
              3
       )
          "Price Matrix Use%#",
       ROUND ( (CASE
                   WHEN "Total GP$" > 0 THEN "Price Matrix GP$" / "Total GP$"
                   ELSE 0
                END),
              3
       )
          "Price Matrix Profit%$",
       "Price Matrix # Lines",
       "Price Matrix Invoice Cnt",
       "Contract Sales",
       "Contract Cost",
       "Contract GP$",
       ROUND ( (CASE
                   WHEN "Contract Sales" > 0
                   THEN
                      "Contract GP$" / "Contract Sales"
                   ELSE
                      0
                END),
              3
       )
          "Contract GP%",
       ROUND ( (CASE
                   WHEN "Outbound Sales" > 0
                   THEN
                      "Contract Sales" / "Outbound Sales"
                   ELSE
                      0
                END),
              3
       )
          "Contract Use%$",
       ROUND ( (CASE
                   WHEN "Total # Lines" > 0
                   THEN
                      "Contract # Lines" / "Total # Lines"
                   ELSE
                      0
                END),
              3
       )
          "Contract Use%#",
       ROUND ( (CASE
                   WHEN "Total GP$" > 0 THEN "Contract GP$" / "Total GP$"
                   ELSE 0
                END),
              3
       )
          "Contract Profit%$",
       "Contract # Lines",
       "Contract Invoice Cnt",
       "Manual Sales",
       "Manual Cost",
       "Manual GP$",
       ROUND ( (CASE
                   WHEN "Manual Sales" > 0 THEN "Manual GP$" / "Manual Sales"
                   ELSE 0
                END),
              3
       )
          "Manual GP%",
       ROUND ( (CASE
                   WHEN "Outbound Sales" > 0
                   THEN
                      "Manual Sales" / "Outbound Sales"
                   ELSE
                      0
                END),
              3
       )
          "Manual Use%$",
       ROUND ( (CASE
                   WHEN "Total # Lines" > 0
                   THEN
                      "Manual # Lines" / "Total # Lines"
                   ELSE
                      0
                END),
              3
       )
          "Manual Use%#",
       ROUND ( (CASE
                   WHEN "Total GP$" > 0 THEN "Manual GP$" / "Total GP$"
                   ELSE 0
                END),
              3
       )
          "Manual Profit%$",
       "Manual # Lines",
       "Manual Invoice Cnt",
       "Other Sales",
       "Other Cost",
       "Other GP$",
       ROUND ( (CASE
                   WHEN "Other Sales" > 0 THEN "Other GP$" / "Other Sales"
                   ELSE 0
                END),
              3
       )
          "Other GP%",
       ROUND ( (CASE
                   WHEN "Outbound Sales" > 0
                   THEN
                      "Other Sales" / "Outbound Sales"
                   ELSE
                      0
                END),
              3
       )
          "Other Use%$",
       ROUND ( (CASE
                   WHEN "Total # Lines" > 0
                   THEN
                      "Other # Lines" / "Total # Lines"
                   ELSE
                      0
                END),
              3
       )
          "Other Use%#",
       ROUND ( (CASE
                   WHEN "Total GP$" > 0 THEN "Other GP$" / "Total GP$"
                   ELSE 0
                END),
              3
       )
          "Other Profit%$",
       "Other # Lines",
       "Other Invoice Cnt",
       "Credits $" "Credit Sales",
       ROUND ( (CASE
                   WHEN "Outbound Sales" > 0
                   THEN
                      "Credits $" / "Outbound Sales"
                   ELSE
                      0
                END),
              3
       )
          "Credits Use%$",
       ROUND ( (CASE
                   WHEN "Total # Lines" > 0
                   THEN
                      "Credits Lines" / "Total # Lines"
                   ELSE
                      0
                END),
              3
       )
          "Credits Use%#"
  FROM (SELECT GP_DATA.YEARMONTH,
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
                  WHEN ACCT.REGION_NAME IS NULL THEN ACCT.ACCOUNT_NAME
                  WHEN ACCT.REGION_NAME = 'EAST' THEN 'EASTERN'
                  WHEN ACCT.REGION_NAME = 'WEST' THEN 'WESTERN'
                  ELSE ACCT.REGION_NAME
               END
                  REGION,
               GP_DATA.ACCOUNT_NUMBER,
               ACCT.ACCOUNT_NAME,
               GP_DATA.WAREHOUSE_NUMBER,
               NVL (GP_DATA.WRITER, '#N/A') WRITER_INIT,
                  CASE
                     WHEN ACCT.REGION_NAME IS NULL THEN ACCT.ACCOUNT_NAME
                     WHEN ACCT.REGION_NAME = 'EAST' THEN 'EASTERN'
                     WHEN ACCT.REGION_NAME = 'WEST' THEN 'WESTERN'
                     ELSE ACCT.REGION_NAME
                  END
               || '*'
               || GP_DATA.ACCOUNT_NUMBER
               || '*'
               || NVL (GP_DATA.WRITER, '#N/A')
               || CASE
                     WHEN GP_DATA.TYPE_OF_SALE IN
                                ('Showroom', 'Showroom Direct')
                     THEN
                        'Showroom'
                     ELSE
                        GP_DATA.TYPE_OF_SALE
                  END
                  AS GPTRACK_KEY,
               SUM (GP_DATA.EXT_SALES_AMOUNT) "Total Sales",
               SUM (EXT_AVG_COGS_AMOUNT) "Total Cost",
               SUM (GP_DATA.EXT_SALES_AMOUNT - EXT_AVG_COGS_AMOUNT)
                  "Total GP$",
               COUNT (GP_DATA.INVOICE_LINE_NUMBER) "Total # Lines",
               COUNT (DISTINCT CASE
                                  WHEN GP_DATA.INVOICE_NUMBER_NK NOT IN
                                             ('CM%', '%-%')
                                  THEN
                                     GP_DATA.INVOICE_NUMBER_NK
                                  ELSE
                                     NULL
                               END
               )
                  "Total Invoice Count",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN
                                 ('MATRIX', 'MATRIX_BID', 'NDP')
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT)
                      ELSE
                         0
                   END)
                  "Price Matrix Sales",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN
                                 ('MATRIX', 'MATRIX_BID', 'NDP')
                      THEN
                         (GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Price Matrix Cost",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN
                                 ('MATRIX', 'MATRIX_BID', 'NDP')
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT
                          - GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Price Matrix GP$",
               COUNT(CASE
                        WHEN (GP_DATA.PRICE_CATEGORY IN
                                    ('MATRIX', 'MATRIX_BID', 'NDP')
                              AND (GP_DATA.EXT_SALES_AMOUNT > 0))
                        THEN
                           (GP_DATA.INVOICE_LINE_NUMBER)
                        ELSE
                           NULL
                     END)
                  "Price Matrix # Lines",
               COUNT (DISTINCT CASE
                                  WHEN (GP_DATA.PRICE_CATEGORY IN
                                              ('MATRIX', 'MATRIX_BID', 'NDP')
                                        AND (GP_DATA.INVOICE_NUMBER_NK) NOT IN
                                                 ('CM%', '%-%'))
                                  THEN
                                     (GP_DATA.INVOICE_NUMBER_NK)
                                  ELSE
                                     NULL
                               END
               )
                  "Price Matrix Invoice Cnt",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT)
                      ELSE
                         0
                   END)
                  "Contract Sales",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                      THEN
                         (GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Contract Cost",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT
                          - GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Contract GP$",
               COUNT(CASE
                        WHEN (GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                              AND GP_DATA.EXT_SALES_AMOUNT > 0)
                        THEN
                           (GP_DATA.INVOICE_LINE_NUMBER)
                        ELSE
                           NULL
                     END)
                  "Contract # Lines",
               COUNT (DISTINCT CASE
                                  WHEN (GP_DATA.PRICE_CATEGORY IN ('OVERRIDE')
                                        AND (GP_DATA.INVOICE_NUMBER_NK) NOT IN
                                                 ('CM%', '%-%'))
                                  THEN
                                     (GP_DATA.INVOICE_NUMBER_NK)
                                  ELSE
                                     NULL
                               END
               )
                  "Contract Invoice Cnt",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN
                                 ('MANUAL', 'TOOLS', 'QUOTE')
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT)
                      ELSE
                         0
                   END)
                  "Manual Sales",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN
                                 ('MANUAL', 'TOOLS', 'QUOTE')
                      THEN
                         (GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Manual Cost",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY IN
                                 ('MANUAL', 'TOOLS', 'QUOTE')
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT
                          - GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Manual GP$",
               COUNT(CASE
                        WHEN (GP_DATA.PRICE_CATEGORY IN
                                    ('MANUAL', 'TOOLS', 'QUOTE')
                              AND GP_DATA.EXT_SALES_AMOUNT > 0)
                        THEN
                           (GP_DATA.INVOICE_LINE_NUMBER)
                        ELSE
                           NULL
                     END)
                  "Manual # Lines",
               COUNT (DISTINCT CASE
                                  WHEN (GP_DATA.PRICE_CATEGORY IN
                                              ('MANUAL', 'TOOLS', 'QUOTE')
                                        AND (GP_DATA.INVOICE_NUMBER_NK) NOT IN
                                                 ('CM%', '%-%'))
                                  THEN
                                     (GP_DATA.INVOICE_NUMBER_NK)
                                  ELSE
                                     NULL
                               END
               )
                  "Manual Invoice Cnt",
               SUM(CASE
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
                         (GP_DATA.EXT_SALES_AMOUNT)
                      ELSE
                         0
                   END)
                  "Other Sales",
               SUM(CASE
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
                         (GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Other Cost",
               SUM(CASE
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
                         (GP_DATA.EXT_SALES_AMOUNT
                          - GP_DATA.EXT_AVG_COGS_AMOUNT)
                      ELSE
                         0
                   END)
                  "Other GP$",
               COUNT(CASE
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
                           (GP_DATA.INVOICE_LINE_NUMBER)
                        ELSE
                           NULL
                     END)
                  "Other # Lines",
               COUNT (DISTINCT CASE
                                  WHEN (GP_DATA.PRICE_CATEGORY NOT IN
                                              ('MATRIX',
                                               'OVERRIDE',
                                               'MANUAL',
                                               'CREDITS',
                                               'TOOLS',
                                               'NDP',
                                               'QUOTE',
                                               'MATRIX_BID',
                                               'Total')
                                        AND (GP_DATA.INVOICE_NUMBER_NK) NOT IN
                                                 ('CM%', '%-%'))
                                  THEN
                                     (GP_DATA.INVOICE_NUMBER_NK)
                                  ELSE
                                     NULL
                               END
               )
                  "Other Invoice Cnt",
               ROUND (SUM(CASE
                             WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                             THEN
                                (GP_DATA.EXT_SALES_AMOUNT)
                             ELSE
                                0
                          END),
                      3
               )
                  "Credits $",
               COUNT(CASE
                        WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
                        THEN
                           (GP_DATA.INVOICE_LINE_NUMBER)
                        ELSE
                           NULL
                     END)
                  "Credits Lines",
               SUM(CASE
                      WHEN GP_DATA.PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
                      THEN
                         (GP_DATA.EXT_SALES_AMOUNT)
                      ELSE
                         0
                   END)
                  "Outbound Sales"
          FROM AAE0376.PR_VICT2_CUST_12MO GP_DATA,
               (SELECT WD.REGION_NAME,
                       WD.ACCOUNT_NAME,
                       WD.ACCOUNT_NUMBER_NK,
                       WD.WAREHOUSE_NUMBER_NK
                  FROM SALES_MART.SALES_WAREHOUSE_DIM WD
                GROUP BY WD.REGION_NAME,
                         WD.ACCOUNT_NAME,
                         WD.ACCOUNT_NUMBER_NK,
                         WD.WAREHOUSE_NUMBER_NK) ACCT                       --
         WHERE     GP_DATA.WAREHOUSE_NUMBER = ACCT.WAREHOUSE_NUMBER_NK(+)
               AND GP_DATA.ACCOUNT_NUMBER = '39'
               AND GP_DATA.WAREHOUSE_NUMBER = '5350'
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
                 GP_DATA.WAREHOUSE_NUMBER,
                 ACCT.REGION_NAME,
                 GP_DATA.WRITER,
                 CASE
                    WHEN GP_DATA.TYPE_OF_SALE IN
                               ('Showroom', 'Showroom Direct')
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
                       WHEN GP_DATA.TYPE_OF_SALE IN
                                  ('Showroom', 'Showroom Direct')
                       THEN
                          'Showroom'
                       ELSE
                          GP_DATA.TYPE_OF_SALE
                    END) GP_TRACKER_WRITER_SUMS