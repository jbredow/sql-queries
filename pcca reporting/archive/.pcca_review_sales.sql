/* 
	sales by customer with channel sales broken out 
	horizontal view
*/
SELECT
	X.ACCOUNT_NUMBER_NK BRANCH,
	NVL ( X.SELL_ALIAS_NAME, NULL ) BRANCH, 
	X.MAIN_CUSTOMER_NK MAIN_NO,
	X.MAIN_CUSTOMER_NAME MAIN_CUST_NAME,
	CUST.CUSTOMER_ALPHA ALPHA,
	X.CUSTOMER_NK CUST_NO,
	X.CUSTOMER_NAME,
	 CASE
	 	WHEN X.MAIN_CUSTOMER_NK = X.CUSTOMER_NK THEN
			'M'
		ELSE CUST.JOB_YN
	END
		JOB,
	CUST.GSA_LINK,
	CUST.CITY,
	CUST.ZIP,
	CUST.CREDIT_LIMIT CR_LIMIT,
	CUST.CREDIT_CODE,
	CUST.BRANCH_WAREHOUSE_NUMBER WHSE,
	CUST.INSERT_TIMESTAMP CREATED,
	X.CUSTOMER_TYPE C_TYPE,
	X.PRICE_COLUMN PC,
	X.SALESMAN_CODE SLSM,
	X.SALESREP_NAME, 
	--X.DISCOUNT_GROUP_NK DG_NO,
	--DG.DISCOUNT_GROUP_NAME DISCOUNT_GROUP,
	--X.CHANNEL_TYPE,
	SUM ( X.EXT_SALES_AMOUNT ) SALES,
	SUM ( X.EXT_AVG_COGS_AMOUNT ) AVG_COST,
  ROUND (
    (SUM ( X.EXT_SALES_AMOUNT ) - SUM ( X.EXT_AVG_COGS_AMOUNT ))
		/ CASE
        WHEN SUM ( X.EXT_SALES_AMOUNT ) > 0
        THEN SUM ( X.EXT_SALES_AMOUNT )
        ELSE
          1
      END
        , 3 )
     "GP %",
	-- Channel Sales
	SUM (
		CASE
			WHEN  X.CHANNEL_TYPE = 'COUNTER'
			THEN X.EXT_SALES_AMOUNT  
			ELSE
				0
		END )
		COUNTER,
	SUM (
		CASE
			WHEN  X.CHANNEL_TYPE = 'SHOWROOM'
			THEN X.EXT_SALES_AMOUNT  
			ELSE
				0
		END )
		SHOWROOM,
	
     
	-- MATRIX SALES  
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MATRIX'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			"Matrix Sales",
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MATRIX'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
				0
		END )
			"Matrix AC",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'MATRIX'
				THEN
					( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END)
	/ SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MATRIX'
			THEN
			CASE
				WHEN X.EXT_SALES_AMOUNT > 0
				THEN
					(X.EXT_SALES_AMOUNT)
				ELSE
					1
			END
			ELSE
				1
		END),
		3 )
			"Matrix GP%",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'MATRIX'
				THEN
					(X.EXT_SALES_AMOUNT)
				ELSE
				0
			END)
		/ SUM (
			CASE
				WHEN X.EXT_SALES_AMOUNT > 0
				THEN
					X.EXT_SALES_AMOUNT
				ELSE
					1
			END),
			3)
				"Matrix Use%$",
	-- CCOR SALES 
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
			0
		END )
			"CCOR Sales",
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
			0
		END )
			"CCOR AC",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
				THEN
					( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END)
		/ SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
				THEN
					CASE
						WHEN X.EXT_SALES_AMOUNT > 0
						THEN
							(X.EXT_SALES_AMOUNT)
						ELSE
							1
					END
				ELSE
					1
				END),
			3)
				"CCOR GP%",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
				THEN
					(X.EXT_SALES_AMOUNT)
				ELSE
					0
			END)
			/ SUM (
				CASE
					WHEN X.EXT_SALES_AMOUNT > 0
					THEN
						X.EXT_SALES_AMOUNT
					ELSE
						1
				END),
			3)
				"CCOR Use%$",
		
	-- MANUAL SALES  
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MANUAL'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			"Manual Sales",
		SUM (
			CASE
			WHEN X.PRICE_CATEGORY IN 'MANUAL'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
				0
		END )
			"Manual AC",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'MANUAL'
				THEN
					( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END)
		/ SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'MANUAL'
				THEN
					CASE
						WHEN X.EXT_SALES_AMOUNT > 0
						THEN
							(X.EXT_SALES_AMOUNT)
						ELSE
							1
					END
				ELSE
					1
			END),
		3)
			"Manual GP%",
	ROUND (
		SUM (
			CASE
			WHEN X.PRICE_CATEGORY IN 'MANUAL'
			THEN
				(X.EXT_SALES_AMOUNT)
			ELSE
				0
		END)
		/ SUM (
			CASE
			WHEN X.EXT_SALES_AMOUNT > 0
			THEN
				X.EXT_SALES_AMOUNT
			ELSE
				1
		END),
		3)
			"Manual Use%$",
			
	-- SPECIAL SALES  
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'SPECIAL'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			"SP- Sales",
		SUM (
			CASE
			WHEN X.PRICE_CATEGORY IN 'SPECIAL'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
				0
		END )
			"SP- AC",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'SPECIAL'
				THEN
					( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END)
		/ SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'SPECIAL'
				THEN
					CASE
					WHEN X.EXT_SALES_AMOUNT > 0
					THEN
						(X.EXT_SALES_AMOUNT)
					ELSE
						1
					END
				ELSE
					1
			END),
		3)
		"SP- GP%",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'SPECIAL'
				THEN
					(X.EXT_SALES_AMOUNT)
				ELSE
					0
			END)
		/ SUM (
			CASE
				WHEN X.EXT_SALES_AMOUNT > 0
				THEN
					X.EXT_SALES_AMOUNT
				ELSE
					1
			END ),
		3 )
		"SP- Use%$",
		
	-- CREDIT SALES  
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'CREDITS'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			"Credits Sales",
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'CREDITS'
				THEN 
					( X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END )
				"Credits AC",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'CREDITS'
				THEN
					( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END)
		/ SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'CREDITS'
				THEN
				CASE
					WHEN X.EXT_SALES_AMOUNT > 0
					THEN
						(X.EXT_SALES_AMOUNT)
					ELSE
						1
				END
				ELSE
					1
			END),
		3)
			"Credits GP%",
	ROUND (
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'CREDITS'
				THEN
					(X.EXT_SALES_AMOUNT)
				ELSE
					0
			END)
			/ SUM (
				CASE
					WHEN X.EXT_SALES_AMOUNT > 0
					THEN
						X.EXT_SALES_AMOUNT
					ELSE
						1
				END),
			3)
			"CR Use%$"
		
FROM SALES_MART.PRICE_MGMT_DATA_DET X
  
	INNER JOIN
		DW_FEI.CUSTOMER_DIMENSION CUST
			ON ( X.ACCOUNT_NUMBER_NK = CUST.ACCOUNT_NUMBER_NK )
				AND ( X.CUSTOMER_GK = CUST.CUSTOMER_GK )
	INNER JOIN
		SALES_MART.TIME_PERIOD_DIMENSION TPD
			ON ( TPD.YEARMONTH = X.YEARMONTH )

WHERE X.IC_FLAG = 'REGULAR'
	AND X.ACCOUNT_NUMBER_NK IN ( 	'226'	)
	-- AND X.YEARMONTH BETWEEN  '201501' AND '201512'
	-- AND X.CHANNEL_TYPE
	-- AND X.SALES_TYPE
	-- AND X.MAIN_CUSTOMER_NK IN ( '7405', '7127', '36704' )
	AND ( TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS' )
	
	
GROUP BY 
	X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	X.MAIN_CUSTOMER_NK,
	X.MAIN_CUSTOMER_NAME,
	CUST.CUSTOMER_ALPHA,
	CASE
	 	WHEN X.MAIN_CUSTOMER_NK = X.CUSTOMER_NK THEN
			'M'
		ELSE CUST.JOB_YN
	END,
	CUST.GSA_LINK,
	CUST.CITY,
	CUST.ZIP,
	CUST.CREDIT_LIMIT,
	CUST.CREDIT_CODE,
	CUST.BRANCH_WAREHOUSE_NUMBER,
	CUST.INSERT_TIMESTAMP,
	X.CUSTOMER_NK,
	X.CUSTOMER_NAME,
	X.CUSTOMER_TYPE,
	X.PRICE_COLUMN,
	X.SALESMAN_CODE,
	X.SALESREP_NAME
	--X.DISCOUNT_GROUP_NK DG_NO,
	--DG.DISCOUNT_GROUP_NAME DISCOUNT_GROUP,
	--X.CHANNEL_TYPE
  
ORDER BY X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	X.PRICE_COLUMN,
	X.MAIN_CUSTOMER_NK,
	--X.MAIN_CUSTOMER_NAME,
	X.CUSTOMER_NK
	--X.CUSTOMER_NAME,
	--X.CUSTOMER_TYPE,
	--X.DISCOUNT_GROUP_NK,
	--DG.DISCOUNT_GROUP_NAME
;