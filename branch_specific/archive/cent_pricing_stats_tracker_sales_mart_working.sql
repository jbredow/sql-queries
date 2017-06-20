SELECT SUB.DIVISION_NAME REGION,
       SUBSTR ( SUB.REGION_NAME, 1, 3 ) DIST,
       SUB.ACCOUNT_NUMBER_NK ACCT_NK,
       SUB.ALIAS_NAME BRANCH,
			 SUB.REG_ACCT_NAME LOC_BRANCH,
       SUM ( SUB.EXT_SLS ) EX_SALES,
       SUM ( SUB.EXT_AC ) EXT_AC,
       ROUND ( SUM ( SUB.EXT_SLS - SUB.EXT_AC ) 
       / NVL ( SUM(CASE WHEN ( SUB.EXT_SLS ) > 0 THEN ( SUB.EXT_SLS ) ELSE 1 END), 3 ), 3 )
         GPP,
       SUM ( SUB.MATRIX_SALES ) MATRIX_SALES,
       SUM ( SUB.MATRIX_AC ) MATRIX_AC,
			 ROUND ( SUM ( SUB.MATRIX_SALES - SUB.MATRIX_AC ) 
       / NVL ( SUM(CASE WHEN ( SUB.MATRIX_SALES ) > 0 THEN ( SUB.MATRIX_SALES ) ELSE 1 END), 3 ), 3 )
         GPP,
			 ROUND ( SUM ( SUB.MATRIX_SALES )
              / NVL ( SUM(SUB.MATRIX_SALES + SUB.CCOR_SALES + SUB.MANUAL_SALES + SUB.SPECIAL_SALES), 1 ),
              3
       )
         USAGE,
       SUM ( SUB.CCOR_SALES ) CCOR_SALES,
       SUM ( SUB.CCOR_AC ) CCOR_AC,
       
			 ROUND ( SUM ( SUB.CCOR_SALES - SUB.CCOR_AC )
       / NVL ( SUM(CASE WHEN ( SUB.CCOR_SALES ) > 0 THEN ( SUB.CCOR_SALES ) ELSE 1 END), 3 ), 3  )
         GPP,
       ROUND ( SUM ( SUB.CCOR_SALES )
              / NVL ( SUM(SUB.MATRIX_SALES + SUB.CCOR_SALES + SUB.MANUAL_SALES + SUB.SPECIAL_SALES), 1 ),
              3
       )
         USAGE,
       SUM ( SUB.MANUAL_SALES ) MANUAL_SALES,
       SUM ( SUB.MANUAL_AC ) MANUAL_AC,
       ROUND ( SUM ( SUB.MANUAL_SALES - SUB.MATRIX_AC ) 
       / NVL ( SUM(CASE WHEN ( SUB.MANUAL_SALES ) > 0 THEN ( SUB.MANUAL_SALES ) ELSE 1 END), 3 ), 3  )
         GPP,
       ROUND ( SUM ( SUB.MANUAL_SALES )
              / NVL ( SUM(SUB.MATRIX_SALES + SUB.CCOR_SALES + SUB.MANUAL_SALES + SUB.SPECIAL_SALES), 1 ),
              3
       )
         USAGE,
       SUM ( SUB.SPECIAL_SALES ) SPECIAL_SALES,
       SUM ( SUB.SPECIAL_AC ) SPECIAL_AC,
       ROUND ( SUM ( SUB.SPECIAL_SALES - SUB.SPECIAL_AC ) 
       / NVL ( SUM(CASE WHEN ( SUB.SPECIAL_SALES ) > 0 THEN ( SUB.SPECIAL_SALES ) ELSE 1 END), 3 ), 3  )
         GPP,
       ROUND ( SUM ( SUB.SPECIAL_SALES )
              / NVL ( SUM(SUB.MATRIX_SALES + SUB.CCOR_SALES + SUB.MANUAL_SALES + SUB.SPECIAL_SALES), 1 ),
              3
       )
         USAGE,
       SUM ( SUB.CREDIT_SALES ) CREDIT_SALES,
       SUM ( SUB.CREDIT_AC ) CREDIT_AC,
       ROUND ( SUM ( SUB.CREDIT_SALES - SUB.CREDIT_AC ) 
       / NVL ( SUM(CASE WHEN ( SUB.CREDIT_SALES ) > 0 THEN ( SUB.CREDIT_SALES ) ELSE 1 END), 3 ), 3  )
         GPP,
       ROUND ( SUM ( SUB.CREDIT_SALES )
              / NVL ( SUM(SUB.MATRIX_SALES + SUB.CCOR_SALES + SUB.MANUAL_SALES + SUB.SPECIAL_SALES), 1 ),
              3
       )
         USAGE,
       SUM ( SUB.SP1500_SALES ) SP1500_SALES,
       SUM ( SUB.SP1500_AVG_COGS ) SP1500_AC,
       ROUND ( SUM ( SUB.SP1500_SALES - SUB.SP1500_AVG_COGS ) 
       / NVL ( SUM(CASE WHEN ( SUB.SP1500_SALES ) > 0 THEN ( SUB.SP1500_SALES ) ELSE 1 END), 3 ), 3  )
         GPP
				 
				 from (
				 
				SELECT 
						SWD.DIVISION_NAME,
						SWD.REGION_NAME,
						SWD.ACCOUNT_NUMBER_NK,
						SWD.ALIAS_NAME,
						MEGA.REG_ACCT_NAME,
						--PM_DET.PRICE_CATEGORY,
						SUM ( PM_DET.EXT_SALES_AMOUNT ) EXT_SLS,
						SUM ( PM_DET.EXT_AVG_COGS_AMOUNT ) EXT_AC,
						SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'MATRIX'
														THEN
															PM_DET.EXT_SALES_AMOUNT
														ELSE
															0
													END)
								MATRIX_SALES,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'MATRIX'
														THEN
															PM_DET.EXT_AVG_COGS_AMOUNT
														ELSE
															0
													END)
									MATRIX_AC,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'OVERRIDE'
														THEN
															PM_DET.EXT_SALES_AMOUNT
														ELSE
															0
													END)
								CCOR_SALES,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'OVERRIDE'
														THEN
															PM_DET.EXT_AVG_COGS_AMOUNT
														ELSE
															0
													END)
									CCOR_AC,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'MANUAL'
														THEN
															PM_DET.EXT_SALES_AMOUNT
														ELSE
															0
													END)
								MANUAL_SALES,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'MANUAL'
														THEN
															PM_DET.EXT_AVG_COGS_AMOUNT
														ELSE
															0
													END)
									MANUAL_AC,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'SPECIAL'
														THEN
															PM_DET.EXT_SALES_AMOUNT
														ELSE
															0
													END)
								SPECIAL_SALES,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'SPECIAL'
														THEN
															PM_DET.EXT_AVG_COGS_AMOUNT
														ELSE
															0
													END)
									SPECIAL_AC,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'CREDIT'
														THEN
															PM_DET.EXT_SALES_AMOUNT
														ELSE
															0
													END)
								CREDIT_SALES,
							SUM(CASE
														WHEN PM_DET.PRICE_CATEGORY = 'CREDIT'
														THEN
															PM_DET.EXT_AVG_COGS_AMOUNT
														ELSE
															0
													END)
									CREDIT_AC,
							NULL AS SP1500_SALES,
              NULL AS SP1500_AVG_COGS
									
				FROM   (  (  SALES_MART.PRICE_MGMT_DATA_DET PM_DET
									INNER JOIN
										AAE0376.MEGA_BRANCHES MEGA
									ON ( PM_DET.SELL_WAREHOUSE_NUMBER_NK = MEGA.WHSE ))
								INNER JOIN
									SALES_MART.SALES_WAREHOUSE_DIM SWD
								ON ( PM_DET.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK ))
						INNER JOIN
							SALES_MART.TIME_PERIOD_DIMENSION TPD
						ON ( PM_DET.YEARMONTH = TPD.YEARMONTH )
			WHERE ( TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE' )
						--AND ( SWD.ACCOUNT_NUMBER_NK = '1480' )
			GROUP BY SWD.DIVISION_NAME,
						SWD.REGION_NAME,
						SWD.ACCOUNT_NUMBER_NK,
						SWD.ALIAS_NAME,
						MEGA.REG_ACCT_NAME
									
									
         UNION
				 
				 
         SELECT SWD.DIVISION_NAME,
                SWD.REGION_NAME,
                SWD.ACCOUNT_NUMBER_NK,
                SWD.ALIAS_NAME,
								MEGA.REG_ACCT_NAME,
                NULL AS SALES,
                NULL AS AC,
                NULL AS MATRIX_SALES,
                NULL AS MATRIX_AC,
                NULL AS CCOR_SALES,
                NULL AS CCOR_AC,
                NULL AS MANUAL_SALES,
                NULL AS MANUAL_AC,
                NULL AS SPECIAL_SALES,
                NULL AS SPECIAL_AC,
                NULL AS CREDIT_SALES,
                NULL AS CREDIT_AC,
                SUM ( ILF.EXT_SALES_AMOUNT ) AS SP1500_SALES,
                SUM ( ILF.EXT_AVG_COGS_AMOUNT ) AS SP1500_AVG_COGS
								-- 19 columns
           FROM       DW_FEI.INVOICE_HEADER_FACT IHF
                    INNER JOIN
                      SALES_MART.SALES_WAREHOUSE_DIM SWD
                    ON ( IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK )
                  INNER JOIN
                    DW_FEI.INVOICE_LINE_FACT ILF
                  ON ( IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK )
                INNER JOIN
                  SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON ( IHF.YEARMONTH = TPD.YEARMONTH )
								INNER JOIN
										AAE0376.MEGA_BRANCHES MEGA
									ON IHF.WAREHOUSE_NUMBER = MEGA.ACCT_NUM
									
          WHERE     TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
                AND ILF.PRODUCT_STATUS = 'SP'
                AND ILF.EXT_SALES_AMOUNT < 1500
                AND IHF.IC_FLAG = 0
                AND IHF.ORDER_CODE <> 'IC'
                AND TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
                -- AND SWD.ACCOUNT_NUMBER_NK = '61'                         --xxx
                AND ( SUBSTR ( SWD.REGION_NAME,
                              1,
                              3
                     ) IN ('D10', 'D11', 'D12', 'D14', 'D30', 'D31', 'D32') )
         GROUP BY SWD.DIVISION_NAME,
                  SWD.REGION_NAME,
                  SWD.ACCOUNT_NUMBER_NK,
                  SWD.ALIAS_NAME,
									MEGA.REG_ACCT_NAME) SUB
GROUP BY SUB.DIVISION_NAME,
         SUB.REGION_NAME,
         SUB.ACCOUNT_NUMBER_NK,
         SUB.ALIAS_NAME,
				 SUB.REG_ACCT_NAME
ORDER BY SUB.DIVISION_NAME,
         SUB.REGION_NAME,
         --SUB.ACCOUNT_NUMBER_NK,
         SUB.ALIAS_NAME,
				 SUB.REG_ACCT_NAME
					;