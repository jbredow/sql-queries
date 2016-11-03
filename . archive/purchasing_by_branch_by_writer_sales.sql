SELECT X.YEARMONTH,
       X.ACCOUNT_NUMBER_NK BR_NO,
       NVL ( X.SELL_ALIAS_NAME, NULL ) BR_NAME,
       X.WRITER,
			 X.SALES_TYPE,
       SUM ( X.EXT_SALES_AMOUNT ) SALES,
       SUM ( X.EXT_AVG_COGS_AMOUNT ) AVG_COST,
			 
			 
			 
			 -- ADD SPECIALS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			 
			 
			 
-- MATRIX SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MATRIX' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         MTX_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MATRIX' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         MTX_AC,
-- CCOR SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'OVERRIDE' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         CCOR_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'OVERRIDE' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         CCOR_AC,
       -- MANUAL SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MANUAL' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         MAN_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MANUAL' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         MAN_AC,
       -- SPECIAL SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'SPECIAL' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         "SP- SALES",
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'SPECIAL' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         "SP- AC",
       -- CREDIT SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'CREDITS' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         CREDITS_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'CREDITS' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         CREDITS_AC,

  FROM SALES_MART.PRICE_MGMT_DATA_DET X
			INNER JOIN
		SALES_MART.TIME_PERIOD_DIMENSION TPD
			ON ( X.YEARMONTH = TPD.YEARMONTH )
			
 WHERE   TPD.ROLLING_QTR = 'THIS QUARTER'
       AND X.ACCOUNT_NUMBER_NK = '1480' --IN ( '1550', '448', '276', '331', '1020', '2778' )
       AND X.IC_FLAG = 'REGULAR'
-- AND X.DISCOUNT_GROUP_NK IN ('4808', '4809', '4813', '4814', '5753' )
-- AND X.PRICE_CATEGORY
-- AND X.PRICE_SUB_CATEGORY
-- AND X.CHANNEL_TYPE
-- AND X.SALES_TYPE

GROUP BY X.YEARMONTH,
         X.ACCOUNT_NUMBER_NK,
         NVL ( X.SELL_ALIAS_NAME, NULL ),
				 X.SALES_TYPE,
         X.WRITER
ORDER BY X.YEARMONTH,
         X.ACCOUNT_NUMBER_NK,
         NVL ( X.SELL_ALIAS_NAME, NULL ),
				 X.SALES_TYPE,
         X.WRITER
		;