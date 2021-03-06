SELECT TO_DATE(PM_DET.YEARMONTH, 'YYYYMM') "MONTH",
       SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DISTRICT,
       SWD.ACCOUNT_NAME AS BRANCH,
       SWD.ACCOUNT_NUMBER_NK AS BR_NK,
       SWD.WAREHOUSE_NAME AS WAREHOUSE,
       SWD.WAREHOUSE_NUMBER_NK AS WH_NK,
       PM_DET.PRICE_CATEGORY,
       SUM (PM_DET.EXT_SALES_AMOUNT) AS EXT_SALES,
       SUM (PM_DET.EXT_AVG_COGS_AMOUNT) AS EXT_AVG_COGS
  FROM (SALES_MART.PRICE_MGMT_DATA_DET PM_DET
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON (PM_DET.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK))
       INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
          ON (PM_DET.YEARMONTH = TPD.YEARMONTH)
 WHERE     (PM_DET.IC_FLAG = 'REGULAR')
       AND (TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS')
       --AND (SWD.ACCOUNT_NUMBER_NK = '2000')
GROUP BY PM_DET.IC_FLAG,
         TPD.ROLL12MONTHS,
         PM_DET.YEARMONTH,
         SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.WAREHOUSE_NAME,
         SWD.WAREHOUSE_NUMBER_NK,
         PM_DET.PRICE_CATEGORY
  ;