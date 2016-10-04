/* 
	sales by customer with channel sales broken out 
	horizontal view
*/
SELECT
	CASE
		WHEN X.YEARMONTH BETWEEN  '201408' AND '201507' THEN
			'FY_15'
		ELSE
			'FY_16'
	END
		TPD,
	X.ACCOUNT_NUMBER_NK BRANCH,
	NVL ( X.SELL_ALIAS_NAME, NULL ) LOGON_NAME, 
	X.CUSTOMER_NK CUST_NO,
	X.CUSTOMER_NAME,
	X.CUSTOMER_NK,
	X.CUSTOMER_NK,
	X.CUSTOMER_TYPE C_TYPE,
	X.PRICE_COLUMN PC,
	X.MAIN_CUSTOMER_NK MAIN_NO,
	--X.MAIN_CUSTOMER_NAME MAIN_CUST_NAME,
	X.DISCOUNT_GROUP_NK DG_NO,
	DG.DISCOUNT_GROUP_NAME DISCOUNT_GROUP,
	X.PRICE_CATEGORY,
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

WHERE X.YEARMONTH BETWEEN  '201408' AND '201607'
	AND X.ACCOUNT_NUMBER_NK = 	'1550'
																
	AND X.IC_FLAG = 'REGULAR'
	-- AND X.CHANNEL_TYPE
	-- AND X.SALES_TYPE
	AND X.MAIN_CUSTOMER_NK IN ( '16855',
																								'17113',
																								'23660',
																								'23930',
																								'24162',
																								'26999',
																								'31371',
																								'31606',
																								'37331',
																								'37332',
																								'37333',
																								'37406',
																								'37407',
																								'37408',
																								'37409',
																								'37410',
																								'38164',
																								'42535',
																								'43050',
																								'43052',
																								'43055',
																								'43784',
																								'44306',
																								'45410',
																								'45481',
																								'46053',
																								'46204',
																								'49407',
																								'108462',
																								'108464',
																								'108465',
																								'108466',
																								'108467',
																								'108469',
																								'108799',
																								'108800',
																								'108801',
																								'108802',
																								'108803',
																								'108804',
																								'108805',
																								'108806',
																								'108807',
																								'108808',
																								'108809',
																								'108810',
																								'108811',
																								'108812',
																								'108813',
																								'136669'
																								)

GROUP BY 
	CASE
		WHEN X.YEARMONTH BETWEEN  '201408' AND '201507' THEN
			'FY_15'
		ELSE
			'FY_16'
	END,
	X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	X.CUSTOMER_NK,
	X.CUSTOMER_NAME,
	X.CUSTOMER_NK,
	X.CUSTOMER_NK,
	X.CUSTOMER_TYPE,
	X.PRICE_COLUMN,
	X.MAIN_CUSTOMER_NK,
	X.PRICE_CATEGORY,
	--X.MAIN_CUSTOMER_NAME MAIN_CUST_NAME,
	X.DISCOUNT_GROUP_NK,
	DG.DISCOUNT_GROUP_NAME
	--X.CHANNEL_TYPE,
  
ORDER BY X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	--X.CUSTOMER_NK,
	--X.CUSTOMER_NAME,
	--X.CUSTOMER_TYPE,
	--X.PRICE_COLUMN,
	X.MAIN_CUSTOMER_NK,
	--X.MAIN_CUSTOMER_NAME,
	X.DISCOUNT_GROUP_NK,
	DG.DISCOUNT_GROUP_NAME
;