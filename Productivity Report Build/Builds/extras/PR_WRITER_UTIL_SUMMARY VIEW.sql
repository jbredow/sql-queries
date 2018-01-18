CREATE OR REPLACE FORCE VIEW AAD9606.PR_WRITER_UTIL_SUMMARY
AS
   SELECT DTL.YEARMONTH,
          SWD.DIVISION_NAME AS REGION,
          SWD.REGION_NAME AS DISTRICT,
          DTL.ACCOUNT_NUMBER,
          DTL.ACCOUNT_NAME,
          DTL.WAREHOUSE_NUMBER,
          DTL.TYPE_OF_SALE,
          DTL.WRITER,
          COUNT (
             DISTINCT CASE
                         WHEN DTL.INVOICE_NUMBER_NK NOT LIKE '%-%'
                         THEN
                            DTL.INVOICE_NUMBER_NK
                         ELSE
                            NULL
                      END)
             AS INVOICE_CNT,
          COUNT (DTL.INVOICE_LINE_NUMBER) AS INVOICE_LINES,
          SUM (DTL.EXT_AVG_COGS_AMOUNT) AS AVG_COGS,
          SUM (DTL.EXT_SALES_AMOUNT) AS EXT_SALES,
          DECODE (
             COALESCE (DTL.PRICE_CATEGORY_OVR_PR,
                       DTL.PRICE_CATEGORY_OVR_GR,
                       DTL.PRICE_CATEGORY),
             'CREDITS', 'CREDITS',
             'MANUAL', 'MANUAL',
             'MATRIX', 'MATRIX',
             'MATRIX_BID', 'MATRIX',
             'OTH/ERROR', 'MANUAL',
             'OVERRIDE', 'OVERRIDE',
             'QUOTE', 'MANUAL',
             'SPECIALS', 'SPECIALS',
             'TOOLS', 'MANUAL',
             'MANUAL')
             RPT_PRICE_CATEGORY,
          COALESCE (DTL.PRICE_CATEGORY_OVR_PR,
                    DTL.PRICE_CATEGORY_OVR_GR,
                    DTL.PRICE_CATEGORY)
             PRICE_CATEGORY
     FROM AAE0376.PR_VICT2_CUST_12MO DTL
          INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
             ON (DTL.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK)
   GROUP BY DTL.WAREHOUSE_NUMBER,
            DTL.ACCOUNT_NAME,
            DTL.ACCOUNT_NUMBER,
            SWD.REGION_NAME,
            SWD.DIVISION_NAME,
            DTL.YEARMONTH,
            DTL.TYPE_OF_SALE,
            DTL.WRITER,
            DECODE (
               COALESCE (DTL.PRICE_CATEGORY_OVR_PR,
                         DTL.PRICE_CATEGORY_OVR_GR,
                         DTL.PRICE_CATEGORY),
               'CREDITS', 'CREDITS',
               'MANUAL', 'MANUAL',
               'MATRIX', 'MATRIX',
               'MATRIX_BID', 'MATRIX',
               'OTH/ERROR', 'MANUAL',
               'OVERRIDE', 'OVERRIDE',
               'QUOTE', 'MANUAL',
               'SPECIALS', 'SPECIALS',
               'TOOLS', 'MANUAL',
               'MANUAL'),
            COALESCE (DTL.PRICE_CATEGORY_OVR_PR,
                      DTL.PRICE_CATEGORY_OVR_GR,
                      DTL.PRICE_CATEGORY)