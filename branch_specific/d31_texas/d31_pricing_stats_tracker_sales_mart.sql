/*
	pricing stats tracker for Maureen C12
	monthly, after tables update.
*/
SELECT XX.ACCOUNT_NK,
	XX.YEARMONTH,
	SUM ( XX.SALES ) TOT_SALES,
	SUM ( XX.AC ) TOT_AC,
	NVL ( ROUND ((SUM ( XX.SALES ) - SUM ( XX.AC )) / SUM ( XX.SALES ), 3 ), 0) GP_PCT,
/* OUTBOUND */
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'MATRIX' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) +
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'OVERRIDE' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) +
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'MANUAL' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) +
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'SPECIAL' 
			THEN XX.SALES 
			ELSE 0 
		END 
			)
		OUTBOUND_SALES,
/* MATRIX */
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'MATRIX' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) MATRIX_SALES,
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'MATRIX' 
			THEN XX.AC 
			ELSE 0 
		END 
			) MATRIX_AC,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'MATRIX'
				THEN ( XX.SALES - XX.AC )
				ELSE 0
			END )
		/ SUM (
			CASE 
				WHEN PRICE_CAT IN 'MATRIX'
				THEN 
					CASE
						WHEN ( XX.SALES ) > 0 THEN ( XX.SALES )
						ELSE 1
					END
				ELSE
					1
			END ),
		3 )
					MATRIX_GP_PCT,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'MATRIX' 
				THEN (XX.SALES)
				ELSE 0
			END )
		/ ( SUM (
				CASE
					WHEN (XX.SALES) > 0 THEN XX.SALES
					ELSE 1
				END)
				- SUM ( 
						CASE 
							WHEN PRICE_CAT = 'CREDITS' 
							THEN XX.AC 
							ELSE 0 
						END 
							)),
			3)
				MATRIX_USAGE,
/* OVERRIDE */
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'OVERRIDE' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) OVERRIDE_SALES,
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'OVERRIDE' 
			THEN XX.AC 
			ELSE 0 
		END 
			) OVERRIDE_AC,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'OVERRIDE'
				THEN ( XX.SALES - XX.AC )
				ELSE 0
			END )
		/ SUM (
			CASE 
				WHEN PRICE_CAT IN 'OVERRIDE'
				THEN 
					CASE
						WHEN ( XX.SALES ) > 0 THEN ( XX.SALES )
						ELSE 1
					END
				ELSE
					1
			END ),
		3 )
				OVERRIDE_GP_PCT,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'OVERRIDE' 
				THEN (XX.SALES)
				ELSE 0
			END )
		/ ( SUM (
				CASE
					WHEN (XX.SALES) > 0 THEN XX.SALES
					ELSE 1
				END)
				- SUM ( 
		CASE 
			WHEN PRICE_CAT = 'CREDITS' 
			THEN XX.AC 
			ELSE 0 
		END 
			)),
			3)
				OVERRIDE_USAGE,
/* MANUAL */
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'MANUAL' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) MANUAL_SALES,
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'MANUAL' 
			THEN XX.AC 
			ELSE 0 
		END 
			) MANUAL_AC,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'MANUAL'
				THEN ( XX.SALES - XX.AC )
				ELSE 0
			END )
		/ SUM (
			CASE 
				WHEN PRICE_CAT IN 'MANUAL'
				THEN 
					CASE
						WHEN ( XX.SALES ) > 0 THEN ( XX.SALES )
						ELSE 1
					END
				ELSE
					1
			END ),
		3 )
					MANUAL_GP_PCT,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'MANUAL' 
				THEN (XX.SALES)
				ELSE 0
			END )
		/ ( SUM (
				CASE
					WHEN (XX.SALES) > 0 THEN XX.SALES
					ELSE 1
				END)
				- SUM ( 
		CASE 
			WHEN PRICE_CAT = 'CREDITS' 
			THEN XX.AC 
			ELSE 0 
		END 
			)),
			3)
				MANUAL_USAGE,
/* SPECIALS */
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'SPECIAL' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) SPECIAL_SALES,
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'SPECIAL' 
			THEN XX.AC 
			ELSE 0 
		END 
			) SPECIAL_AC,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'SPECIAL'
				THEN ( XX.SALES - XX.AC )
				ELSE 0
			END )
		/ SUM (
			CASE 
				WHEN PRICE_CAT IN 'SPECIAL'
				THEN 
					CASE
						WHEN ( XX.SALES ) > 0 THEN ( XX.SALES )
						ELSE 1
					END
				ELSE
					1
			END ),
		3 )
					SPECIAL_GP_PCT,
	
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'SPECIAL' 
				THEN (XX.SALES)
				ELSE 0
			END )
		/ ( SUM (
				CASE
					WHEN (XX.SALES) > 0 THEN XX.SALES
					ELSE 1
				END )
				- SUM ( 
						CASE 
							WHEN PRICE_CAT = 'CREDITS' 
							THEN XX.AC 
							ELSE 0 
						END 
							)),
			3)
				SPECIAL_USAGE,
				
/* CREDITS */
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'CREDITS' 
			THEN XX.SALES 
			ELSE 0 
		END 
			) CREDITS_SALES,
	SUM ( 
		CASE 
			WHEN PRICE_CAT = 'CREDITS' 
			THEN XX.AC 
			ELSE 0 
		END 
			) CREDITS_AC,
	ROUND (
		SUM (
			CASE
				WHEN PRICE_CAT IN 'CREDITS'
				THEN ( XX.SALES - XX.AC )
				ELSE 0
			END )
		/ SUM (
			CASE 
				WHEN PRICE_CAT IN 'CREDITS'
				THEN  ( XX.SALES )
				ELSE 1
			END ),
		3 )
					CREDITS_GP_PCT,
	SUM ( XX.SP1500_SALES ) "SP-<$1500 SALES",
	SUM ( XX.SP1500_AVG_COGS ) "SP-<$1500 AC",
	NVL ( ROUND ((SUM ( XX.SP1500_SALES )-SUM ( XX.SP1500_AVG_COGS ))
			/SUM ( XX.SP1500_SALES ), 3 ), 0) SP_GP_PCT,
/* MANAGED PRICING */
	ROUND (
		( SUM (
			CASE
				WHEN PRICE_CAT IN 'OVERRIDE' 
				THEN (XX.SALES)
				ELSE 0
			END )
		/ ( SUM (
				CASE
					WHEN (XX.SALES) > 0 THEN XX.SALES
					ELSE 1
				END)
				- SUM ( 
		CASE 
			WHEN PRICE_CAT = 'CREDITS' 
			THEN XX.AC 
			ELSE 0 
		END 
			))) +
		( SUM (
			CASE
				WHEN PRICE_CAT IN 'MATRIX' 
				THEN (XX.SALES)
				ELSE 0
			END )
		/ ( SUM (
				CASE
					WHEN (XX.SALES) > 0 THEN XX.SALES
					ELSE 1
				END)
				- SUM ( 
						CASE 
							WHEN PRICE_CAT = 'CREDITS' 
							THEN XX.AC 
							ELSE 0 
						END 
							))),
			3)	
	
	
			MANAGED_PRICING

FROM (
	SELECT 
			BC.ACCOUNT_NK,
			PM_SUMM.YEARMONTH,
			CASE
				WHEN PRICE_SUB_CATEGORY = 'OVERRIDE'
				THEN 'OVERRIDE'
				ELSE PM_SUMM.PRICE_CATEGORY
			END
				PRICE_CAT,
			SUM ( PM_SUMM.EXT_SALES_AMOUNT ) SALES,
			SUM ( PM_SUMM.EXT_AVG_COGS_AMOUNT ) AC,
			NULL AS SP1500_SALES,
			NULL AS SP1500_AVG_COGS
			
			FROM (  AAF1046.BRANCH_CONTACTS BC
							INNER JOIN SALES_MART.PRICE_MGMT_DATA_SUMM PM_SUMM
									ON ( BC.ACCOUNT_NK = PM_SUMM.ACCOUNT_NUMBER_NK ))
							INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TD
									ON ( TD.YEARMONTH = PM_SUMM.YEARMONTH )
								
								WHERE ( BC.DISTRICT = 'C12' )
								AND TD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
								
			GROUP BY BC.ACCOUNT_NK,
			PM_SUMM.YEARMONTH,
			CASE
				WHEN PRICE_SUB_CATEGORY = 'OVERRIDE'
				THEN 'OVERRIDE'
				ELSE PM_SUMM.PRICE_CATEGORY
			END
	
	UNION		
		
	SELECT SWD.ACCOUNT_NUMBER_NK,
				IHF.YEARMONTH,
				NULL AS SP_DASH,
				NULL AS SALES,
				NULL AS AC,
				SUM (ILF.EXT_SALES_AMOUNT) AS SP1500_SALES,
				SUM (ILF.EXT_AVG_COGS_AMOUNT) AS SP1500_AVG_COGS
		FROM DW_FEI.INVOICE_HEADER_FACT IHF
				INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
						ON (IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK)
				INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
						ON (IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK)
				INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
						ON (IHF.YEARMONTH = TPD.YEARMONTH)
				INNER JOIN AAF1046.BRANCH_CONTACTS BC
						ON BC.ACCOUNT_NK = IHF.ACCOUNT_NUMBER				
	WHERE     ILF.PRODUCT_STATUS = 'SP'
				AND ILF.EXT_SALES_AMOUNT < 1500
				AND IHF.IC_FLAG = 0
				AND IHF.ORDER_CODE <> 'IC'
				AND TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
				AND BC.DISTRICT = 'C12'
	GROUP BY SWD.ACCOUNT_NUMBER_NK,
				IHF.YEARMONTH				
	) XX
	GROUP BY XX.ACCOUNT_NK, XX.YEARMONTH
	ORDER BY XX.ACCOUNT_NK ASC,	XX.YEARMONTH DESC
;
