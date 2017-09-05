SELECT --X.YEARMONTH,
			 TPD.ROLL12MONTHS,
       X.ACCOUNT_NUMBER_NK BR_NO,
       NVL ( X.SELL_ALIAS_NAME, NULL ) BR_NAME,
       X.WRITER,
       X.CUSTOMER_TYPE,
			 X.SALES_TYPE,
       -- X.SELL_WAREHOUSE_NUMBER_NK WHSE,
       -- X.SELL_WAREHOUSE_NAME WH_NAME,
       X.CHANNEL_TYPE CHANNEL,
       SUM ( X.EXT_SALES_AMOUNT ) SALES,
       SUM ( X.EXT_AVG_COGS_AMOUNT ) AVG_COST,
       
  FROM SALES_MART.PRICE_MGMT_DATA_DET X
			INNER JOIN
					 SALES_MART.TIME_PERIOD_DIMENSION TPD
			ON ( X.YEARMONTH = TPD.YEARMONTH )
			INNER JOIN
           SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON ( X.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )

 WHERE   TPD.ROLL12MONTHS IS NOT NULL
 			 AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                    ('D01', 'D11', 'D14', 'D20', 'D21', 'D23', 'D30'))
			 --AND TPD.YEARMONTH BETWEEN 201610 AND 201703 
			 --AND TPD.ROLLING_QTR = 'THIS QUARTER'
       -- AND X.ACCOUNT_NUMBER_NK = '1480' --IN ( '1550', '448', '276', '331', '1020', '2778' )
       AND X.IC_FLAG = 'REGULAR'
			 -- AND X.DISCOUNT_GROUP_NK IN ('4808', '4809', '4813', '4814', '5753' )
			 -- AND X.PRICE_CATEGORY
			 -- AND X.PRICE_SUB_CATEGORY
			 -- AND X.CHANNEL_TYPE
			 -- AND X.SALES_TYPE

GROUP BY TPD.ROLL12MONTHS,
       X.ACCOUNT_NUMBER_NK,
       NVL ( X.SELL_ALIAS_NAME, NULL ),
       X.WRITER,
       X.CUSTOMER_TYPE,
			 X.SALES_TYPE,
       -- X.SELL_WAREHOUSE_NUMBER_NK WHSE,
       -- X.SELL_WAREHOUSE_NAME WH_NAME,
       X.CHANNEL_TYPE
ORDER BY --X.YEARMONTH,
         X.ACCOUNT_NUMBER_NK,
         NVL ( X.SELL_ALIAS_NAME, NULL ),
				 X.SALES_TYPE,
         X.WRITER
		;