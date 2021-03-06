/* 
	sales by customer with channel sales broken out 
	horizontal view
*/
SELECT
	SUBSTR ( SWD.REGION_NAME, 1 ,3 ) DIST,
	PM_DET.ACCOUNT_NUMBER_NK BRANCH,
	NVL ( PM_DET.SELL_ALIAS_NAME, NULL ) ALIAS, 
	PM_DET.SALESMAN_CODE, 
	PM_DET.SALESREP_NAME,
	PM_DET.ALT1_CODE_AND_PRODUCT_NAME,
	PM_DET.EXT_SALES_AMOUNT SALES,
	PM_DET.EXT_ACTUAL_COGS_AMOUNT ACTUAL_COST,
	PM_DET.PRICE_CATEGORY
	
		
FROM SALES_MART.PRICE_MGMT_DATA_DET PM_DET
		INNER JOIN
          EBUSINESS.SALES_DIVISIONS SWD
       ON (SWD.ACCOUNT_NUMBER_NK = PM_DET.ACCOUNT_NUMBER_NK)

WHERE (PM_DET.YEARMONTH  = '201508' ) --BETWEEN '201409' AND '201508')
	--AND (PM_DET.ACCOUNT_NUMBER_NK IN ( '527' ))
	--AND (PM_DET.SELL_ALIAS_NAME = '1221')
	AND PM_DET.ACTIVE_ACCOUNT_NUMBER_NK = '1480'
	AND (PM_DET.IC_FLAG = 'REGULAR')
	/*AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
			 	 'D50', 'D51', 'D52', 'D53', 'D54'
				 ) )*/
	AND PM_DET.EXT_ACTUAL_COGS_AMOUNT > PM_DET.EXT_SALES_AMOUNT
	AND PM_DET.DISCOUNT_GROUP_NK IN (	'1072',
																		'1076',
																		'1077',
																		'1080',
																		'1082',
																		'1084',
																		'1104',
																		'1107',
																		'1113')
	AND PM_DET.SALES_TYPE = 'DIRECTS SHIP'
	-- AND PM_DET.PRICE_CATEGORY
	-- AND PM_DET.PRICE_SUB_CATEGORY
	-- AND PM_DET.CHANNEL_TYPE
	-- AND PM_DET.SALES_TYPE
  
ORDER BY 
		PM_DET.SALESREP_NAME
;