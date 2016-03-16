/* 
	sales by customer with channel sales broken out 
	horizontal view
*/
SELECT
	X.ACCOUNT_NUMBER_NK BRANCH,
	NVL ( X.SELL_ALIAS_NAME, NULL ) LOGON_NAME, 
	X.SELL_WAREHOUSE_NUMBER_NK WH_NO,
	X.SELL_WAREHOUSE_NAME SELL_WAREHOUSE,
	X.CHANNEL_TYPE CHANNEL,
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
     
	-- MATRIX SALES
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MATRIX'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			MTX_SALES,
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MATRIX'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
				0
		END )
			MTX_AC,
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
			"MTX GP%",
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
				"PM Use%$",
	-- CCOR SALES
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
			0
		END )
			CCOR_SALES,
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
			0
		END )
			CCOR_AC,
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
				"MAN GP%",
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
				"Ovr Use%$",
		
	-- MANUAL SALES
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'MANUAL'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			CCOR_SALES,
		SUM (
			CASE
			WHEN X.PRICE_CATEGORY IN 'MANUAL'
			THEN 
				( X.EXT_AVG_COGS_AMOUNT )
			ELSE
				0
		END )
			MAN_AC,
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
			"MAN GP%",
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
			"Man Use%$",
			
	-- SPECIAL SALES
	SUM (
		CASE
			WHEN X.PRICE_CATEGORY IN 'SPECIAL'
			THEN 
				( X.EXT_SALES_AMOUNT )
			ELSE
				0
		END )
			"SP- SALES",
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
			CREDITS_SALES,
		SUM (
			CASE
				WHEN X.PRICE_CATEGORY IN 'CREDITS'
				THEN 
					( X.EXT_AVG_COGS_AMOUNT )
				ELSE
					0
			END )
				CREDITS_AC,
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
			"CR GP%",
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
  LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
    ON DG.DISCOUNT_GROUP_NK = X.DISCOUNT_GROUP_NK

WHERE X.YEARMONTH BETWEEN  '201403' AND '201406'
	AND X.ACCOUNT_NUMBER_NK IN ( '13' )
	AND X.IC_FLAG = 'REGULAR'
	-- AND X.CHANNEL_TYPE
	-- AND X.SALES_TYPE

GROUP BY 
	X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	X.SELL_WAREHOUSE_NUMBER_NK,
	X.SELL_WAREHOUSE_NAME,
	X.CHANNEL_TYPE
  
ORDER BY X.ACCOUNT_NUMBER_NK ASC,
	X.MAIN_CUSTOMER_NK ASC,
  X.CUSTOMER_NAME ASC,
  X.DISCOUNT_GROUP_NK ASC
;