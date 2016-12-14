/*
	run after month end updates
*/
SELECT PM_DET.ACCOUNT_NUMBER_NK WHSE,
       PM_DET.SELL_WAREHOUSE_NUMBER_NK WHSE,
       SUM ( PM_DET.EXT_SALES_AMOUNT ) AS EX_SALES,
       SUM ( PM_DET.EXT_AVG_COGS_AMOUNT ) AS EX_AVG_COST,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'MATRIX'
                       THEN
                           PM_DET.EXT_SALES_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           MATRIX_SALES,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'MATRIX'
                       THEN
                           PM_DET.EXT_AVG_COGS_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           MATRIX_AC,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'OVERRIDE'
                       THEN
                           PM_DET.EXT_SALES_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           OVERRIDE_SALES,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'OVERRIDE'
                       THEN
                           PM_DET.EXT_AVG_COGS_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           OVERRIDE_AC,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'MANUAL'
                       THEN
                           PM_DET.EXT_SALES_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           MANUAL_SALES,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'MANUAL'
                       THEN
                           PM_DET.EXT_AVG_COGS_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           MANUAL_AC,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'SPECIAL'
                       THEN
                           PM_DET.EXT_SALES_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           SPECIAL_SALES,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'SPECIAL'
                       THEN
                           PM_DET.EXT_AVG_COGS_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           SPECIAL_AC,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'CREDITS'
                       THEN
                           PM_DET.EXT_SALES_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           CREDITS_SALES,
       ROUND ( SUM(CASE
                       WHEN PM_DET.PRICE_CATEGORY = 'CREDITS'
                       THEN
                           PM_DET.EXT_AVG_COGS_AMOUNT
                       ELSE
                           0
                   END),
              3
       )
           CREDITS_AC
  FROM SALES_MART.PRICE_MGMT_DATA_DET PM_DET
 WHERE ( PM_DET.ACCOUNT_NUMBER_NK IN
                ('1869', '116', '61', '190', '480', '454', '230', '88') )
       AND ( PM_DET.YEARMONTH BETWEEN 201508 AND 201601 )
       AND ( PM_DET.IC_FLAG = 'REGULAR' )
			 AND PM_DET.SALES_TYPE LIKE 'COUNT%'
GROUP BY PM_DET.ACCOUNT_NUMBER_NK,
         PM_DET.SELL_WAREHOUSE_NUMBER_NK
ORDER BY PM_DET.ACCOUNT_NUMBER_NK ASC,
         PM_DET.SELL_WAREHOUSE_NUMBER_NK ASC
;