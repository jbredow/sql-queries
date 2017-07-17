/* 
	sales by customer with channel sales broken out 
	horizontal view
*/
SELECT
	X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ) ALIAS, 
	--X.CUSTOMER_NK,
	--X.CUSTOMER_NAME,
	X.CUSTOMER_TYPE,
	X.PRICE_COLUMN,
	X.MAIN_CUSTOMER_NK,
	--X.MAIN_CUSTOMER_NAME,
	X.DISCOUNT_GROUP_NK,
	DG.DISCOUNT_GROUP_NAME,
	
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
	INNER JOIN
		SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON ( X.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )
WHERE X.YEARMONTH BETWEEN  '201603' AND '201702'
	AND X.ACCOUNT_NUMBER_NK = 	'61'
	AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
			 	 'D10', 'D11', 'D12', 'D14', 
			   'D30', 'D31', 'D32' 
			   --'D50', 'D51', 'D53'
				 )
			)										
	AND X.DISCOUNT_GROUP_NK IN (
															'0007',
															'0089',
															'0095',
															'0152',
															'0207',
															'0225',
															'0511',
															'0517',
															'0545',
															'0551',
															'0582',
															'0658',
															'0660',
															'0674',
															'0678',
															'0686',
															'0687',
															'1072',
															'1076',
															'1077',
															'1082',
															'1153',
															'1199',
															'1205',
															'1208',
															'1209',
															'1213',
															'1219',
															'1220',
															'1224',
															'1229',
															'1260',
															'1261',
															'1262',
															'1285',
															'1444',
															'2098',
															'2205',
															'2232',
															'2285',
															'2289',
															'2544',
															'2643',
															'3012',
															'3400',
															'3404',
															'3421',
															'4605',
															'4809',
															'7152'
															)
	AND X.IC_FLAG = 'REGULAR'
	-- AND X.CHANNEL_TYPE
	-- AND X.SALES_TYPE
	-- AND X.MAIN_CUSTOMER_NK IN ( '7405', '7127', '36704' )

GROUP BY 
	X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	--X.CUSTOMER_NK,
	--X.CUSTOMER_NAME,
	X.CUSTOMER_TYPE,
	X.PRICE_COLUMN,
	X.MAIN_CUSTOMER_NK,
	--X.MAIN_CUSTOMER_NAME,
	X.DISCOUNT_GROUP_NK,
	DG.DISCOUNT_GROUP_NAME
  
ORDER BY X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	--X.CUSTOMER_NK,
	--X.CUSTOMER_NAME,
	X.CUSTOMER_TYPE,
	X.PRICE_COLUMN,
	X.MAIN_CUSTOMER_NK
;