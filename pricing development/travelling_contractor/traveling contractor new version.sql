SELECT TPD.YEARMONTH,
       SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DISTRICT,
       SWD.REGION_NAME AS DISTRICT2,
       SWD.WAREHOUSE_NUM_NAME,
       X.ALT1_CODE_AND_PRODUCT_NAME ALT1_DESC,
       X.PRODUCT_NK,
       X.WRITER,
       X.WRITER AS WRITER2,
       X.PRICE_CATEGORY,
       SUM (X.SHIPPED_QTY) AS SHIPPED,
       SUM (X.EXT_SALES_AMOUNT) AS EXT_SALES,
       SUM (X.EXT_ACTUAL_COGS_AMOUNT) AS EXT_REP_COGS
  FROM (SALES_MART.PRICE_MGMT_DATA_DET X
        INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
           ON (X.YEARMONTH = TPD.YEARMONTH))
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (X.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
 WHERE     (X.IC_FLAG = 'REGULAR')
       AND (TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE')
       AND (X.DISCOUNT_GROUP_NK = '9181')
 GROUP BY TPD.YEARMONTH,
       SWD.DIVISION_NAME,
       SWD.REGION_NAME,
       SWD.REGION_NAME,
       SWD.WAREHOUSE_NUM_NAME,
       X.ALT1_CODE_AND_PRODUCT_NAME,
       X.PRODUCT_NK,
       X.WRITER,
       X.WRITER,
       X.PRICE_CATEGORY
       ;