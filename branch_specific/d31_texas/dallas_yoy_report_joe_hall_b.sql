SELECT TPD.ROLL12MONTHS,
       PM_DET.ACCOUNT_NUMBER_NK,
       PM_DET.DISCOUNT_GROUP_NK,
       PM_DET.DISCOUNT_GROUP_NK_NAME,
       PM_DET.PRICE_COLUMN,
       PM_DET.MAIN_CUSTOMER_NK,
       PM_DET.CUSTOMER_NK,
       PM_DET.CUSTOMER_NAME,
       PM_DET.PRICE_CATEGORY,
       SUM ( PM_DET.EXT_SALES_AMOUNT ),
       SUM ( PM_DET.EXT_AVG_COGS_AMOUNT )
  FROM   SALES_MART.TIME_PERIOD_DIMENSION TPD
       INNER JOIN
         SALES_MART.PRICE_MGMT_DATA_DET PM_DET
       ON ( TPD.YEARMONTH = PM_DET.YEARMONTH )
 WHERE     ( PM_DET.ACCOUNT_NUMBER_NK = '61' )
       AND ( PM_DET.IC_FLAG = 'REGULAR' )
       AND ( PM_DET.SELL_WAREHOUSE_NUMBER_NK IN ('170',
																																						'1171',
																																						'903',
																																						'904',
																																						'526',
																																						'5828',
																																						'61',
																																						'62',
																																						'63',
																																						'68',
																																						'77',
																																						'8061',
																																						'86',
																																						'861',
																																						'2353',
																																						'2938',
																																						'3111',
																																						'1569'
																																						) )
			 AND TPD.ROLL12MONTHS IS NOT NULL
GROUP BY TPD.ROLL12MONTHS,
         PM_DET.ACCOUNT_NUMBER_NK,
         PM_DET.DISCOUNT_GROUP_NK,
         PM_DET.DISCOUNT_GROUP_NK_NAME,
         PM_DET.PRICE_COLUMN,
         PM_DET.MAIN_CUSTOMER_NK,
         PM_DET.CUSTOMER_NK,
         PM_DET.CUSTOMER_NAME,
         PM_DET.IC_FLAG,
         PM_DET.PRICE_CATEGORY,
         PM_DET.SELL_WAREHOUSE_NUMBER_NK;