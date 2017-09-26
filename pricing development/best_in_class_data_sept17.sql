/*
    measure single branch/district against average of 6 best in class
    LN added logic to include count of sales reps within each category/group
    
*/

SELECT 
       SELL_REGION_NAME REGION,
       SELL_DISTRICT DISTRICT,
       NULL AS NULL_ACCT,
       BUSINESS_GROUP,
       CUSTOMER_TYPE,
       SALES_TYPE,
       SALESREP_NAME,
       SALESMAN_CODE,
       FISCAL_YEAR,
       EX_SALES,
       EX_AVGCOGS,
       EX_ACTCOGS,
       EX_LINES,
/* MATRIX */
       MATRIX_SALES,
       MATRIX_AVGCOGS,
       MATRIX_ACTCOGS,
       MATRIX_LINES,
/* CONTRACT */
       OVERRIDE_SALES,
       OVERRIDE_AVGCOGS,
       OVERRIDE_ACTCOGS,
       OVERRIDE_LINES,
/* MANUAL */
       MANUAL_SALES,
       MANUAL_AVGCOGS,
       MANUAL_ACTCOGS,
       MANUAL_LINES,
/* SPECIALS */
       SP_SALES,
       SP_AVGCOGS,
       SP_ACTCOGS,
       SPECIAL_LINES,
/* CREDITS */
       CREDITS_SALES,
       CREDITS_AVGCOGS,
       CREDITS_ACTCOGS,
       CREDIT_LINES,
/* OUTBOUND */
       OUTBOUND_SALES,
       OUTBOUND_AVGCOGS,
       OUTBOUND_ACTCOGS,
       OUTBOUND_LINES,
			 HOUSE_FLAG,
			 CUSTOMERS

  FROM ( SELECT SLS.SELL_DISTRICT,
                SLS.SELL_REGION_NAME,
                SLS.SELL_ACCOUNT_NAME,
                COALESCE ( XREF.BUSINESS_GROUP,
                          'OTHER'
                )
                BUSINESS_GROUP,
                SLS.CUSTOMER_TYPE,
                SLS.SALES_TYPE,
                SLS.SALESREP_NAME,
                SLS.SALESMAN_CODE,
                TPD.FISCAL_YEAR,
								CASE
										WHEN G.EMPLOYEE_NUMBER_NK IS NULL
										THEN
												'H/U'
										WHEN ( L.TITLE_DESC LIKE '%O/S%'
												OR L.TITLE_DESC LIKE 'Out Sales%'
												OR L.TITLE_DESC LIKE 'Sales Rep%')
										THEN
												'O/S'
										ELSE
												'H/A'
								END
									AS HOUSE_FLAG,
                COUNT(DISTINCT SLS.MAIN_CUSTOMER_NK) CUSTOMERS,
                NVL ( SUM ( SLS.EXT_SALES_AMOUNT ), 0 ) EX_SALES,
                NVL ( SUM ( SLS.EXT_AVG_COGS_AMOUNT ), 0 ) EX_AVGCOGS,
                NVL ( SUM ( SLS.EXT_ACTUAL_COGS_AMOUNT),0) EX_ACTCOGS,
                NVL ( SUM ( SLS.LINES_FILLED ), 0 ) EX_LINES,
                /* MATRIX */
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MATRIX', 'MATRIX_BID')
                      THEN
                        SLS.EXT_SALES_AMOUNT
                      ELSE
                        0
                    END)
                  MATRIX_SALES,
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MATRIX', 'MATRIX_BID')
                      THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  MATRIX_AVGCOGS,
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MATRIX', 'MATRIX_BID')
                      THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  MATRIX_ACTCOGS,  
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MATRIX', 'MATRIX_BID')
                      THEN
                        SLS.TOTAL_LINES
                      ELSE
                        0
                    END)
                  MATRIX_LINES,
                /* CONTRACT */
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) =
                             'OVERRIDE'
                      THEN
                        SLS.EXT_SALES_AMOUNT
                      ELSE
                        0
                    END)
                  OVERRIDE_SALES,
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) =
                             'OVERRIDE'
                      THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  OVERRIDE_AVGCOGS,
                  SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) =
                               'OVERRIDE'
                      THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  OVERRIDE_ACTCOGS, 
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('OVERRIDE')
                      THEN
                        SLS.TOTAL_LINES
                      ELSE
                        0
                    END)
                  OVERRIDE_LINES,
                /* MANUAL */
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MANUAL', 'QUOTE', 'TOOLS')
                      THEN
                        SLS.EXT_SALES_AMOUNT
                      ELSE
                        0
                    END)
                  MANUAL_SALES,
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MANUAL', 'QUOTE', 'TOOLS')
                      THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  MANUAL_AVGCOGS,
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MANUAL', 'QUOTE', 'TOOLS')
                      THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  MANUAL_ACTCOGS,  
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('MANUAL', 'QUOTE', 'TOOLS')
                      THEN
                        SLS.TOTAL_LINES
                      ELSE
                        0
                    END)
                  MANUAL_LINES,
                /* SPECIALS */
                SUM(CASE
                      WHEN PRICE_CATEGORY = 'SPECIAL'
                      THEN
                        SLS.EXT_SALES_AMOUNT
                      ELSE
                        0
                    END)
                  SP_SALES,
                SUM(CASE
                      WHEN PRICE_CATEGORY = 'SPECIAL'
                      THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  SP_AVGCOGS,
                SUM(CASE
                      WHEN PRICE_CATEGORY = 'SPECIAL'
                      THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  SP_ACTCOGS,
                SUM(CASE
                      WHEN NVL ( PRICE_SUB_CATEGORY, PRICE_CATEGORY ) IN
                               ('SPECIAL')
                      THEN
                        SLS.TOTAL_LINES
                      ELSE
                        0
                    END)
                  SPECIAL_LINES,
                /* CREDITS */
                SUM(CASE
                      WHEN PRICE_CATEGORY = 'CREDITS'
                      THEN
                        SLS.EXT_SALES_AMOUNT
                      ELSE
                        0
                    END)
                  CREDITS_SALES,
                SUM(CASE
                      WHEN PRICE_CATEGORY = 'CREDITS'
                      THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  CREDITS_AVGCOGS,
                  SUM(CASE
                      WHEN PRICE_CATEGORY = 'CREDITS'
                      THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  CREDITS_ACTCOGS, 
                SUM(CASE
                      WHEN PRICE_CATEGORY = 'CREDITS' THEN SLS.TOTAL_LINES
                      ELSE 0
                    END)
                  CREDIT_LINES,
                /* OUTBOUND */
                SUM(CASE
                      WHEN PRICE_CATEGORY <> 'CREDITS'
                      THEN
                        SLS.EXT_SALES_AMOUNT
                      ELSE
                        0
                    END)
                  OUTBOUND_SALES,
                SUM(CASE
                      WHEN PRICE_CATEGORY <> 'CREDITS'
                      THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  OUTBOUND_AVGCOGS,
                SUM(CASE
                      WHEN PRICE_CATEGORY <> 'CREDITS'
                      THEN
                        SLS.EXT_ACTUAL_COGS_AMOUNT
                      ELSE
                        0
                    END)
                  OUTBOUND_ACTCOGS,
                SUM(CASE
                      WHEN PRICE_CATEGORY <> 'CREDITS' THEN SLS.TOTAL_LINES
                      ELSE 0
                    END)
                  OUTBOUND_LINES
           
					 FROM     SALES_MART.PRICE_MGMT_DATA_DET SLS
                  
									INNER JOIN
                    SALES_MART.TIME_PERIOD_DIMENSION TPD
                  ON SLS.YEARMONTH = TPD.YEARMONTH
                
								LEFT OUTER JOIN
                  USER_SHARED.BG_CUSTTYPE_XREF XREF
                ON SLS.CUSTOMER_TYPE = XREF.CUSTOMER_TYPE
							
							INNER JOIN
								DW_FEI.SALESREP_DIMENSION G
							ON SLS.ACCOUNT_NUMBER_NK = G. ACCOUNT_NUMBER_NK
								AND SLS.SALESMAN_CODE = G.SALESREP_NK
								
						LEFT OUTER JOIN
							DW_FEI.EMPLOYEE_DIMENSION L
						ON L.EMPLOYEE_TRILOGIE_NK = G.EMPLOYEE_NUMBER_NK
						

          WHERE TPD.ROLL12MONTHS IS NOT NULL
                AND SLS.IC_FLAG = 'REGULAR'
								
                AND TPD.FISCAL_YEAR IN ('2016', '2017')
                AND SUBSTR ( SLS.SELL_DISTRICT, 1, 3 ) IN ( 
			 	 						'D01', 'D11', 'D14', 'D20', 
				    				'D21', 'D23', 'D30')
								
								--AND SUBSTR ( SLS.SELL_DISTRICT, 1, 3 ) = 'D10'
								
								/*AND SLS.ACCOUNT_NUMBER_NK IN ('1245',
																							'1205',
																							'2783',
																							'52',
																							'1598',
																							'1225',
																							'34',
																							'1888',
																							'1300',
																							'1550',
																							'2000',
																							'20',
																							'1350',
																							'3014',
																							'3370'
																							)*/
               --AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
               --AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
               --AND SLS.SELL_ACCOUNT_NAME IN ('DALLAS')
               --AND SLS.SALESMAN_CODE = 'OWC'

               --AND SUBSTR (SLS.SELL_DISTRICT, 1, 1) = 'D'
         GROUP BY SLS.SELL_DISTRICT,
                  SLS.SELL_REGION_NAME,
                  SLS.SELL_ACCOUNT_NAME,
                  XREF.BUSINESS_GROUP,
                  SLS.CUSTOMER_TYPE,
                  SLS.SALES_TYPE,
                  SLS.SALESREP_NAME,
                  SLS.SALESMAN_CODE,
                  TPD.FISCAL_YEAR,
									CASE
											WHEN G.EMPLOYEE_NUMBER_NK IS NULL
											THEN
													'H/U'
											WHEN ( L.TITLE_DESC LIKE '%O/S%'
													OR L.TITLE_DESC LIKE 'Out Sales%'
													OR L.TITLE_DESC LIKE 'Sales Rep%')
											THEN
													'O/S'
										ELSE
													'H/A'
									END)
GROUP BY SELL_REGION_NAME,
					SELL_DISTRICT,
					--NULL AS NULL_ACCT,
					BUSINESS_GROUP,
					CUSTOMER_TYPE,
					SALES_TYPE,
					SALESREP_NAME,
					SALESMAN_CODE,
					FISCAL_YEAR,
					EX_SALES,
					EX_AVGCOGS,
					EX_ACTCOGS,
					EX_LINES,
		/* MATRIX */
					MATRIX_SALES,
					MATRIX_AVGCOGS,
					MATRIX_ACTCOGS,
					MATRIX_LINES,
		/* CONTRACT */
					OVERRIDE_SALES,
					OVERRIDE_AVGCOGS,
					OVERRIDE_ACTCOGS,
					OVERRIDE_LINES,
		/* MANUAL */
					MANUAL_SALES,
					MANUAL_AVGCOGS,
					MANUAL_ACTCOGS,
					MANUAL_LINES,
		/* SPECIALS */
					SP_SALES,
					SP_AVGCOGS,
					SP_ACTCOGS,
					SPECIAL_LINES,
		/* CREDITS */
					CREDITS_SALES,
					CREDITS_AVGCOGS,
					CREDITS_ACTCOGS,
					CREDIT_LINES,
		/* OUTBOUND */
					OUTBOUND_SALES,
					OUTBOUND_AVGCOGS,
					OUTBOUND_ACTCOGS,
					OUTBOUND_LINES,
					HOUSE_FLAG,
          CUSTOMERS
ORDER BY  SELL_REGION_NAME,
					SELL_DISTRICT,
					BUSINESS_GROUP,
					CUSTOMER_TYPE,
					FISCAL_YEAR
;