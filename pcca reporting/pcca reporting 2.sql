SELECT * FROM (	
				SELECT --CUST.CUSTOMER_GK,
							CUST.ACCOUNT_NUMBER_NK ACCT_NO,
							CUST.ACCOUNT_NAME ACCOUNT,
							CUST.BRANCH_WAREHOUSE_NUMBER WH_NO,
							CUST.CUSTOMER_NK CUST_NK,
							CUST.CUSTOMER_ALPHA CUST_ALPHA,
							CUST.CUSTOMER_NAME,
							CUST.MAIN_CUSTOMER_NK MAIN_NO,
						CASE
								WHEN COUNT (
												CUST.CUSTOMER_NK)
										OVER (
												PARTITION BY CUST.MAIN_CUSTOMER_NK, CUST.ACCOUNT_NUMBER_NK) =
												1
								THEN
									'N'
								WHEN CUST.CUSTOMER_NK = CUST.MAIN_CUSTOMER_NK
							THEN
									'M'
								ELSE
									'J'
						END
								JOB,
							CASE
								WHEN 
									CASE
										WHEN COUNT ( CUST.CUSTOMER_NK) OVER (
														PARTITION BY CUST.MAIN_CUSTOMER_NK, CUST.ACCOUNT_NUMBER_NK) =
														1
										THEN 'N'
										WHEN CUST.CUSTOMER_NK = CUST.MAIN_CUSTOMER_NK THEN 'M'
										ELSE 	'J'
									END = 'N' THEN 2
								ELSE 1
						END
							SORT,
							CUST.SALESMAN_CODE SLSM,
							CUST.CUSTOMER_TYPE C_TYPE,
							CUST.PRICE_COLUMN PC,
							CUST.INSERT_TIMESTAMP CREATED,
							CUST.LAST_SALE,
							CUST.CREDIT_CODE CR_CD,
							CUST.CREDIT_LIMIT CR_LIMIT,
							CUST.CITY,
							CUST.STATE,
							CUST.ZIP,
							CUST.GSA_LINK GSA,
							CUST.CROSS_CUSTOMER_NK X_CUST,
							CUST.CROSS_ACCT X_ACCT,
							CUST.MSTR_CUSTNO MSTR_NO,
							CUST.MSTR_CUST_NAME,
							-- previous 12 months sales w/ PM data
							SALES.TOTAL_SALES,
							SALES.TOTAL_AVG_COST,
							SALES.TOTAL_GP_PCT,
							SALES.COUNTER,
							SALES.SHOWROOM,
							SALES.MATRIX_SALES,
							SALES.MATRIX_AC,
							SALES.MATRIX_GP_PCT,
							SALES.MATRIX_USAGE,
							SALES.CCOR_SALES,
							SALES.CCOR_AC,
							SALES.CCOR_GP_PCT,
							SALES.CCOR_USAGE,
							SALES.MANUAL_SALES,
							SALES.MANUAL_AC,
							SALES.MANUAL_GP_PCT,
							SALES.MANUAL_USAGE,
							SALES.SP_SALES,
							SALES.SP_AC,
							SALES.SP_GP_PCT,
							SALES.SP_USAGE,
							SALES.CREDIT_SALES,
							SALES.CREDIT_AC,
							SALES.CREDIT_GP_PCT,
							SALES.CREDIT_USAGE,
							-- add yoy only total sales,ac, gp%
							LY_SALES.EX_SALES,
							LY_SALES.EX_AC,
							LY_SALES.GP_PCT
									
				FROM DW_FEI.CUSTOMER_DIMENSION CUST
			
			LEFT OUTER JOIN
				(  SELECT
								X.ACCOUNT_NUMBER_NK,
								X.CUSTOMER_GK,
								SUM ( X.EXT_SALES_AMOUNT ) TOTAL_SALES,
								SUM ( X.EXT_AVG_COGS_AMOUNT ) TOTAL_AVG_COST,
								ROUND (
									(SUM ( X.EXT_SALES_AMOUNT ) - SUM ( X.EXT_AVG_COGS_AMOUNT ))
									/ CASE
											WHEN SUM ( X.EXT_SALES_AMOUNT ) > 0
											THEN SUM ( X.EXT_SALES_AMOUNT )
											ELSE
												1
										END
											, 3 )
									TOTAL_GP_PCT,
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
										MATRIX_SALES,
								SUM (
									CASE
										WHEN X.PRICE_CATEGORY IN 'MATRIX'
										THEN 
											( X.EXT_AVG_COGS_AMOUNT )
										ELSE
											0
									END )
										MATRIX_AC,
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
										MATRIX_GP_PCT,
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
											MATRIX_USAGE,
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
											CCOR_GP_PCT,
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
											CCOR_USAGE,
									
								-- MANUAL SALES  
								SUM (
									CASE
										WHEN X.PRICE_CATEGORY IN 'MANUAL'
										THEN 
											( X.EXT_SALES_AMOUNT )
										ELSE
											0
									END )
										MANUAL_SALES,
									SUM (
										CASE
										WHEN X.PRICE_CATEGORY IN 'MANUAL'
										THEN 
											( X.EXT_AVG_COGS_AMOUNT )
										ELSE
											0
									END )
										MANUAL_AC,
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
										MANUAL_GP_PCT,
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
										MANUAL_USAGE,
										
								-- SPECIAL SALES  
								SUM (
									CASE
										WHEN X.PRICE_CATEGORY IN 'SPECIAL'
										THEN 
											( X.EXT_SALES_AMOUNT )
										ELSE
											0
									END )
										SP_SALES,
									SUM (
										CASE
										WHEN X.PRICE_CATEGORY IN 'SPECIAL'
										THEN 
											( X.EXT_AVG_COGS_AMOUNT )
										ELSE
											0
									END )
										SP_AC,
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
									SP_GP_PCT,
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
									SP_USAGE,
									
								-- CREDIT SALES  
								SUM (
									CASE
										WHEN X.PRICE_CATEGORY IN 'CREDITS'
										THEN 
											( X.EXT_SALES_AMOUNT )
										ELSE
											0
									END )
										CREDIT_SALES,
									SUM (
										CASE
											WHEN X.PRICE_CATEGORY IN 'CREDITS'
											THEN 
												( X.EXT_AVG_COGS_AMOUNT )
											ELSE
												0
										END )
											CREDIT_AC,
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
										CREDIT_GP_PCT,
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
										CREDIT_USAGE
									
							FROM SALES_MART.PRICE_MGMT_DATA_DET X
								
								INNER JOIN
									DW_FEI.CUSTOMER_DIMENSION CUST
										ON ( X.ACCOUNT_NUMBER_NK = CUST.ACCOUNT_NUMBER_NK )
											AND ( X.CUSTOMER_GK = CUST.CUSTOMER_GK )
								INNER JOIN
									SALES_MART.TIME_PERIOD_DIMENSION TPD
										ON ( TPD.YEARMONTH = X.YEARMONTH )
							
							WHERE X.IC_FLAG = 'REGULAR'
								--AND X.ACCOUNT_NUMBER_NK IN ( 	'226'	)
								AND ( TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS' )
								
							GROUP BY 
								X.ACCOUNT_NUMBER_NK,
								X.CUSTOMER_GK
								
				) SALES
			
			ON CUST.CUSTOMER_GK = SALES.CUSTOMER_GK
						AND CUST.ACCOUNT_NUMBER_NK = SALES.ACCOUNT_NUMBER_NK
						
	LEFT OUTER JOIN
										( SELECT PM_DET.ACCOUNT_NUMBER_NK,
											PM_DET.CUSTOMER_GK,
											SUM ( PM_DET.EXT_SALES_AMOUNT ) AS EX_SALES,
											SUM ( PM_DET.EXT_AVG_COGS_AMOUNT ) AS EX_AC,
											ROUND (
															(SUM ( PM_DET.EXT_SALES_AMOUNT )  - SUM ( PM_DET.EXT_AVG_COGS_AMOUNT ) )
															/ CASE
																	WHEN SUM ( PM_DET.EXT_SALES_AMOUNT  ) > 0
																	THEN  SUM ( PM_DET.EXT_SALES_AMOUNT  )
																	ELSE
																		1
																END
																	, 3 )
															GP_PCT
									FROM   SALES_MART.TIME_PERIOD_DIMENSION TPD
											INNER JOIN
												SALES_MART.PRICE_MGMT_DATA_DET PM_DET
											ON ( TPD.YEARMONTH = PM_DET.YEARMONTH )
								WHERE  ( TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS LAST YEAR' )
									--AND ( PM_DET.ACCOUNT_NUMBER_NK = '226' )
								GROUP BY PM_DET.ACCOUNT_NUMBER_NK, TPD.ROLL12MONTHS, PM_DET.CUSTOMER_GK
				) LY_SALES
				
	ON CUST.CUSTOMER_GK = LY_SALES.CUSTOMER_GK
			AND CUST.ACCOUNT_NUMBER_NK = LY_SALES.ACCOUNT_NUMBER_NK
						
			WHERE ( CUST.DELETE_DATE IS NULL )
					AND ( CUST.JOB_YN IS NOT NULL ) 
	) PCCA
	
WHERE ( PCCA.ACCT_NO = '226' ) 
		

ORDER BY PCCA.ACCOUNT, PCCA.SORT, PCCA.MAIN_NO, PCCA.CUST_NK
;