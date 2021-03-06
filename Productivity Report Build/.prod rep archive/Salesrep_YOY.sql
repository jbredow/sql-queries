SELECT 
	SLS.REGION,
	SLS.SELL_ACCOUNT_NAME,
	SLS.ACCOUNT_NUMBER_NK,
	SLS.SALESMAN_CODE,
	SLS.SALESREP_NAME,
	SLS.FYTD,
	NVL ( SUM ( SLS.SLS ), 0 )EX_SALES,
	NVL ( SUM ( SLS.COGS ), 0 ) EX_COGS,
	/* MATRIX */
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'MATRIX' 
			THEN SLS.SLS
			ELSE 0
		END )
			MATRIX_SALES,
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'MATRIX' 
			THEN SLS.COGS
			ELSE 0
		END )
			MATRIX_COGS,
	/* CONTRACT */
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'OVERRIDE' 
			THEN SLS.SLS
			ELSE 0
		END )
			OVERRIDE_SALES,
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'OVERRIDE' 
			THEN SLS.COGS
			ELSE 0
		END )
			OVERRIDE_COGS,
	/* MANUAL */
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'MANUAL' 
			THEN SLS.SLS
			ELSE 0
		END )
			MANUAL_SALES,
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'MANUAL' 
			THEN SLS.COGS
			ELSE 0
		END )
			MANUAL_COGS,
	/* CREDITS */
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'CREDITS' 
			THEN SLS.SLS
			ELSE 0
		END )
			CREDITS_SALES,
	SUM (
		CASE
			WHEN PRICE_CATEGORY = 'CREDITS' 
			THEN SLS.COGS
			ELSE 0
		END )
			CREDITS_COGS
			
FROM AAE0376.SALES_YOY SLS

GROUP BY
	SLS.REGION,
	SLS.SELL_ACCOUNT_NAME,
	SLS.ACCOUNT_NUMBER_NK,
	SLS.SALESMAN_CODE,
	SLS.SALESREP_NAME,
	SLS.FYTD

ORDER BY
	SLS.REGION ASC,
	SLS.SELL_ACCOUNT_NAME,
	SLS.SALESMAN_CODE,
	SLS.FYTD DESC
;