SELECT
	SUBSTR ( SLS.REGION_NAME, 1, 3 ) DIST,
	SLS.ACCOUNT_NUMBER_NK BR_NO,
	SLS.ALIAS_NAME,	
	/*CASE
		WHEN SLS.SALES_TYPE IN ('COUNTER CASH', 'COUNTER CASH PICK UP')
		THEN 'COUNTER'
		WHEN SLS.SALES_TYPE IN ('SHOWROOM', 'SHOWROOM DIRECT')
		THEN 'SHOWROOM'
		WHEN SLS.SALES_TYPE = 'N/A'
		THEN 'OTHER'
		ELSE SLS.SALES_TYPE
	END
		SALE_TYPE,*/
	-- total sales
	SUM ( SLS.EX_SALES ) TOTAL_SALES,
	SUM ( SLS.EX_AC ) TOTAL_AC,
	ROUND (
		( SUM (	SLS.EX_SALES ) - SUM ( SLS.EX_AC ) )
				/ SUM (SLS.EX_SALES)
				, 3 )
			TOTAL_GP,
	-- matrix sales
	SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'MATRIX'
      THEN 
        ( SLS.EX_SALES )
      ELSE
        0
    END )
      MTX_SALES,
  SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'MATRIX'
      THEN 
        ( SLS.EX_AC )
      ELSE
        0
    END )
      MTX_AC,
ROUND (
		SUM ( 
			CASE 
				WHEN SLS.PRICE_CATEGORY IN 'MATRIX'
				THEN 
					( SLS.EX_SALES ) -  ( SLS.EX_AC )
				ELSE
					0
			END )
	/	SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'MATRIX'
				THEN
					CASE
						WHEN SLS.EX_SALES > 0
						THEN
							( SLS.EX_SALES )
						ELSE
							1
					END
				ELSE
					1
			END ),
		3 )
		MTX_GP,
		
	ROUND (
		SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'MATRIX'
				THEN 
					( SLS.EX_SALES )
				ELSE
					0
			END )
		/ SUM (
				CASE
					WHEN SLS.EX_SALES > 0
					THEN SLS.EX_SALES
				END ),
		3 ) MTX_USAGE,
		-- contract sales
	SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'OVERRIDE'
      THEN 
        ( SLS.EX_SALES )
      ELSE
        0
    END )
      CCOR_SALES,
  SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'OVERRIDE'
      THEN 
        ( SLS.EX_AC )
      ELSE
        0
    END )
      CCOR_AC,
	ROUND (
		SUM ( 
			CASE 
				WHEN SLS.PRICE_CATEGORY IN 'OVERRIDE'
				THEN 
					( SLS.EX_SALES ) -  ( SLS.EX_AC )
				ELSE
					0
			END )
	/	SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'OVERRIDE'
				THEN
					CASE
						WHEN SLS.EX_SALES > 0
						THEN
							( SLS.EX_SALES )
						ELSE
							1
					END
				ELSE
					1
			END ),
		3 )
		CCOR_GP,
	ROUND (
		SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'OVERRIDE'
				THEN 
					( SLS.EX_SALES )
				ELSE
					0
			END )
		/ SUM (
				CASE
					WHEN SLS.EX_SALES > 0
					THEN SLS.EX_SALES
				END ),
		3 ) CCOR_USAGE,
	-- manual sales
	SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'MANUAL'
      THEN 
        ( SLS.EX_SALES )
      ELSE
        0
    END )
      MAN_SALES,
  SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'MANUAL'
      THEN 
        ( SLS.EX_AC )
      ELSE
        0
    END )
      MAN_AC,
	ROUND (
		SUM ( 
			CASE 
				WHEN SLS.PRICE_CATEGORY IN 'MANUAL'
				THEN 
					( SLS.EX_SALES ) - ( SLS.EX_AC )
				ELSE
					0
			END )
	/	SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'MANUAL'
				THEN
					CASE
						WHEN SLS.EX_SALES > 0
						THEN
							( SLS.EX_SALES )
						ELSE
							1
					END
				ELSE
					1
			END ),
		3 )
		MAN_GP,
	ROUND (
		SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'MANUAL'
				THEN 
					( SLS.EX_SALES )
				ELSE
					0
			END )
		/ SUM (
				CASE
					WHEN SLS.EX_SALES > 0
					THEN SLS.EX_SALES
				END ),
		3 ) MAN_USAGE,
	
	-- sp- sales
	SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'SPECIAL'
      THEN 
        ( SLS.EX_SALES )
      ELSE
        0
    END )
      SP_SALES,
  SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'SPECIAL'
      THEN 
        ( SLS.EX_AC )
      ELSE
        0
    END )
      SP_AC,
	ROUND (
		SUM ( 
			CASE 
				WHEN SLS.PRICE_CATEGORY IN 'SPECIAL'
				THEN 
					( SLS.EX_SALES ) -  ( SLS.EX_AC )
				ELSE
					0
			END )
	/	SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'SPECIAL'
				THEN
					CASE
						WHEN SLS.EX_SALES > 0
						THEN
							( SLS.EX_SALES )
						ELSE
							1
					END
				ELSE
					1
			END ),
		3 )
		SP_GP,
	ROUND (
		SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'SPECIAL'
				THEN 
					( SLS.EX_SALES )
				ELSE
					0
			END )
		/ SUM (
				CASE
					WHEN SLS.EX_SALES > 0
					THEN SLS.EX_SALES
				END ),
		3 ) SP_USAGE,
	-- credit sales
	SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'CREDITS'
      THEN 
        ( SLS.EX_SALES )
      ELSE
        0
    END )
      CR_SALES,
  SUM (
    CASE
      WHEN SLS.PRICE_CATEGORY IN 'CREDITS'
      THEN 
        ( SLS.EX_AC )
      ELSE
        0
    END )
      CR_AC,
	ROUND (
		SUM ( 
			CASE 
				WHEN SLS.PRICE_CATEGORY IN 'CREDITS'
				THEN 
					( SLS.EX_SALES ) -  ( SLS.EX_AC )
				ELSE
					0
			END )
	/	SUM (
			CASE
				WHEN SLS.PRICE_CATEGORY IN 'CREDITS'
				THEN
					CASE
						WHEN SLS.EX_SALES > 0
						THEN
							( SLS.EX_SALES )
						ELSE
							1
					END
				ELSE
					1
			END ),
		3 )
		CR_GP

FROM 
	( SELECT SWD.REGION_NAME,
					SWD.ACCOUNT_NUMBER_NK,
					SWD.ALIAS_NAME,
					PMS.SALES_TYPE,
					PMS.PRICE_CATEGORY,
					SUM ( PMS.EXT_SALES_AMOUNT ) AS EX_SALES,
					SUM ( PMS.EXT_AVG_COGS_AMOUNT ) AS EX_AC
			FROM     EBUSINESS.SALES_DIVISIONS SWD
					INNER JOIN
							SALES_MART.PRICE_MGMT_DATA_DET PMS
					ON ( SWD.ACCOUNT_NUMBER_NK = PMS.ACCOUNT_NUMBER_NK )
		WHERE ( PMS.YEARMONTH BETWEEN 201408 AND 201503 )
					AND ( SWD.ACCOUNT_NUMBER_NK IN ( '216', '226' ) )
					AND ( SUBSTR ( SWD.REGION_NAME,
												1,
												3
								) IN
											( 'D10',
												'D11',
												'D12',
												'D13',
												'D14',
												'D30',
												'D31',
												'D32',
												'D50',
												'D51',
												'D53' ) )
					AND IC_FLAG = 'REGULAR'
		GROUP BY SWD.REGION_NAME,
						SWD.ACCOUNT_NUMBER_NK,
						SWD.ALIAS_NAME,
						PMS.SALES_TYPE,
						PMS.PRICE_CATEGORY,
						PMS.YEARMONTH 
			) SLS
	
	--WHERE SLS.SALES_TYPE IN ('COUNTER CASH', 'COUNTER CASH PICK UP')
	--SLS.SALES_TYPE IN ('SHOWROOM', 'SHOWROOM DIRECT')
	
	GROUP BY 
		SUBSTR ( SLS.REGION_NAME, 1, 3 ),
	SLS.ACCOUNT_NUMBER_NK,
	SLS.ALIAS_NAME /*,	
	CASE
		WHEN SLS.SALES_TYPE IN ('COUNTER CASH', 'COUNTER CASH PICK UP')
		THEN 'COUNTER'
		WHEN SLS.SALES_TYPE IN ('SHOWROOM', 'SHOWROOM DIRECT')
		THEN 'SHOWROOM'
		WHEN SLS.SALES_TYPE = 'N/A'
		THEN 'OTHER'
		ELSE SLS.SALES_TYPE
	END*/
	ORDER BY 
		SUBSTR ( SLS.REGION_NAME, 1, 3 ),
	SLS.ACCOUNT_NUMBER_NK,
	SLS.ALIAS_NAME /*,	
	CASE
		WHEN SLS.SALES_TYPE IN ('COUNTER CASH', 'COUNTER CASH PICK UP')
		THEN 'COUNTER'
		WHEN SLS.SALES_TYPE IN ('SHOWROOM', 'SHOWROOM DIRECT')
		THEN 'SHOWROOM'
		WHEN SLS.SALES_TYPE = 'N/A'
		THEN 'OTHER'
		ELSE SLS.SALES_TYPE
	END*/
		;