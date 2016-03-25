SELECT MAIN.*,
						LY_SALES.EX_SALES,
						LY_SALES.EX_AC,
						LY_SALES.GP_PCT

FROM (

SELECT CUST.ACCOUNT_NUMBER_NK,
       CUST.MAIN_CUSTOMER_NK,
       --CUST.CUSTOMER_NAME,
       --CUST.SALESMAN_CODE,
       --CUST.PRICE_COLUMN,
       --CUST.CUSTOMER_TYPE,
       SUM ( PM_DET.EXT_SALES_AMOUNT ) TOTAL_SALES,
       SUM ( PM_DET.EXT_AVG_COGS_AMOUNT ) TOTAL_AVG_COST,
       ROUND ( ( SUM ( PM_DET.EXT_SALES_AMOUNT )
                - SUM ( PM_DET.EXT_AVG_COGS_AMOUNT ) )
              / CASE
                  WHEN SUM ( PM_DET.EXT_SALES_AMOUNT ) > 0
                  THEN
                    SUM ( PM_DET.EXT_SALES_AMOUNT )
                  ELSE
                    1
                END,
              3
       )
         TOTAL_GP_PCT,
       -- Channel Sales
       SUM(CASE
             WHEN PM_DET.CHANNEL_TYPE = 'COUNTER' THEN PM_DET.EXT_SALES_AMOUNT
             ELSE 0
           END)
         COUNTER,
       SUM(CASE
             WHEN PM_DET.CHANNEL_TYPE = 'SHOWROOM'
             THEN
               PM_DET.EXT_SALES_AMOUNT
             ELSE
               0
           END)
         SHOWROOM,
       -- MATRIX SALES
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'MATRIX'
             THEN
               ( PM_DET.EXT_SALES_AMOUNT )
             ELSE
               0
           END)
         MATRIX_SALES,
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'MATRIX'
             THEN
               ( PM_DET.EXT_AVG_COGS_AMOUNT )
             ELSE
               0
           END)
         MATRIX_AC,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'MATRIX'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT - PM_DET.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.PRICE_CATEGORY IN 'MATRIX'
                      THEN
                        CASE
                          WHEN PM_DET.EXT_SALES_AMOUNT > 0
                          THEN
                            ( PM_DET.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         MATRIX_GP_PCT,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'MATRIX'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.EXT_SALES_AMOUNT > 0
                      THEN
                        PM_DET.EXT_SALES_AMOUNT
                      ELSE
                        1
                    END),
              3
       )
         MATRIX_USAGE,
       -- CCOR SALES
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'OVERRIDE'
             THEN
               ( PM_DET.EXT_SALES_AMOUNT )
             ELSE
               0
           END)
         CCOR_SALES,
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'OVERRIDE'
             THEN
               ( PM_DET.EXT_AVG_COGS_AMOUNT )
             ELSE
               0
           END)
         CCOR_AC,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT - PM_DET.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.PRICE_CATEGORY IN 'OVERRIDE'
                      THEN
                        CASE
                          WHEN PM_DET.EXT_SALES_AMOUNT > 0
                          THEN
                            ( PM_DET.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         CCOR_GP_PCT,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.EXT_SALES_AMOUNT > 0
                      THEN
                        PM_DET.EXT_SALES_AMOUNT
                      ELSE
                        1
                    END),
              3
       )
         CCOR_USAGE,
       -- MANUAL SALES
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'MANUAL'
             THEN
               ( PM_DET.EXT_SALES_AMOUNT )
             ELSE
               0
           END)
         MANUAL_SALES,
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'MANUAL'
             THEN
               ( PM_DET.EXT_AVG_COGS_AMOUNT )
             ELSE
               0
           END)
         MANUAL_AC,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'MANUAL'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT - PM_DET.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.PRICE_CATEGORY IN 'MANUAL'
                      THEN
                        CASE
                          WHEN PM_DET.EXT_SALES_AMOUNT > 0
                          THEN
                            ( PM_DET.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         MANUAL_GP_PCT,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'MANUAL'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.EXT_SALES_AMOUNT > 0
                      THEN
                        PM_DET.EXT_SALES_AMOUNT
                      ELSE
                        1
                    END),
              3
       )
         MANUAL_USAGE,
       -- SPECIAL SALES
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'SPECIAL'
             THEN
               ( PM_DET.EXT_SALES_AMOUNT )
             ELSE
               0
           END)
         SP_SALES,
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'SPECIAL'
             THEN
               ( PM_DET.EXT_AVG_COGS_AMOUNT )
             ELSE
               0
           END)
         SP_AC,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'SPECIAL'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT - PM_DET.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.PRICE_CATEGORY IN 'SPECIAL'
                      THEN
                        CASE
                          WHEN PM_DET.EXT_SALES_AMOUNT > 0
                          THEN
                            ( PM_DET.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         SP_GP_PCT,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'SPECIAL'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.EXT_SALES_AMOUNT > 0
                      THEN
                        PM_DET.EXT_SALES_AMOUNT
                      ELSE
                        1
                    END),
              3
       )
         SP_USAGE,
       -- CREDIT SALES
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'CREDITS'
             THEN
               ( PM_DET.EXT_SALES_AMOUNT )
             ELSE
               0
           END)
         CREDIT_SALES,
       SUM(CASE
             WHEN PM_DET.PRICE_CATEGORY IN 'CREDITS'
             THEN
               ( PM_DET.EXT_AVG_COGS_AMOUNT )
             ELSE
               0
           END)
         CREDIT_AC,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'CREDITS'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT - PM_DET.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.PRICE_CATEGORY IN 'CREDITS'
                      THEN
                        CASE
                          WHEN PM_DET.EXT_SALES_AMOUNT > 0
                          THEN
                            ( PM_DET.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         CREDIT_GP_PCT,
       ROUND ( SUM(CASE
                     WHEN PM_DET.PRICE_CATEGORY IN 'CREDITS'
                     THEN
                       ( PM_DET.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN PM_DET.EXT_SALES_AMOUNT > 0
                      THEN
                        PM_DET.EXT_SALES_AMOUNT
                      ELSE
                        1
                    END),
              3
       )
         CREDIT_USAGE
  FROM     SALES_MART.PRICE_MGMT_DATA_DET PM_DET
         RIGHT OUTER JOIN
           DW_FEI.CUSTOMER_DIMENSION CUST
         ON ( PM_DET.CUSTOMER_GK = CUST.CUSTOMER_GK )
            AND ( PM_DET.ACCOUNT_NUMBER_NK = CUST.ACCOUNT_NUMBER_NK )
       RIGHT OUTER JOIN
         SALES_MART.TIME_PERIOD_DIMENSION TPD
       ON ( TPD.YEARMONTH = PM_DET.YEARMONTH )
 WHERE     ( CUST.DELETE_DATE IS NULL )
       AND ( CUST.ACCOUNT_NUMBER_NK = '226' )
       AND ( CUST.CUSTOMER_TYPE <> 'O_INTRBRNCH' )
       AND ( LENGTH ( CUST.MAIN_CUSTOMER_NK ) < 7 )
       -- AND ( CUST.CUSTOMER_TYPE <> 'UNAVAILABLE' AND PM_DET.EXT_SALES_AMOUNT <> 0 )
       AND ( TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS' )
GROUP BY CUST.ACCOUNT_NUMBER_NK, CUST.MAIN_CUSTOMER_NK
--CUST.CUSTOMER_NAME,
--CUST.SALESMAN_CODE,
--CUST.PRICE_COLUMN,
--CUST.CUSTOMER_TYPE
) MAIN

LEFT OUTER JOIN
										( SELECT PM_DET.ACCOUNT_NUMBER_NK,
											--PM_DET.CUSTOMER_GK,
											PM_DET.MAIN_CUSTOMER_NK,
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
									AND ( PM_DET.ACCOUNT_NUMBER_NK = '226' )
								GROUP BY PM_DET.ACCOUNT_NUMBER_NK, TPD.ROLL12MONTHS, PM_DET.MAIN_CUSTOMER_NK
				) LY_SALES
				ON LY_SALES.ACCOUNT_NUMBER_NK = MAIN.ACCOUNT_NUMBER_NK
					AND LY_SALES.MAIN_CUSTOMER_NK = MAIN.MAIN_CUSTOMER_NK
	;