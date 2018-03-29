SELECT 
			 DIVISION_NAME REGION,
       REGION_NAME DISTRICT,
			 NULL AS NULL_ACCT,
       BUSINESS_GROUP,
       --CUSTOMER_GROUP,
       MO "MONTH",
       EX_SALES,
       EX_COGS,
			 EX_LINES,
/* MATRIX */
       MATRIX_SALES,
       MATRIX_COGS,
       MATRIX_LINES,
/* CONTRACT */
       OVERRIDE_SALES,
       OVERRIDE_COGS,
       OVERRIDE_LINES,
/* MANUAL */
       MANUAL_SALES,
			 MANUAL_COGS,
			 MANUAL_LINES,
/* SPECIALS */
       SP_SALES,
			 SP_COGS,
			 SPECIAL_LINES,
/* CREDITS */
       CREDITS_SALES,
       CREDITS_COGS,
			 CREDIT_LINES,
/* OUTBOUND */
       OUTBOUND_SALES

  FROM ( SELECT WD.DIVISION_NAME,
                WD.REGION_NAME,
                WD.ACCOUNT_NAME,
                COALESCE ( XREF.BUSINESS_GROUP,
                          'OTHER'
                )
                  BUSINESS_GROUP,
                TPD.ROLLING_MONTH MO,
                NVL ( SUM ( SLS.EXT_SALES_AMOUNT ), 0 ) EX_SALES,
                NVL ( SUM ( SLS.EXT_AVG_COGS_AMOUNT ), 0 ) EX_COGS,
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
                  MATRIX_COGS,
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
                  OVERRIDE_COGS,
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
                  MANUAL_COGS,
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
                  SP_COGS,
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
                  CREDITS_COGS,
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
                  OUTBOUND_COGS,
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
									AAD9606.PR_SLS_WHSE_DIM WD
								ON WD.WAREHOUSE_NUMBER_NK = SLS.SELL_WAREHOUSE_NUMBER_NK

          WHERE TPD.ROLLING_MONTH IS NOT NULL
                                 
                AND WD.REGION_NAME = 'D22 E BLENDED SOUTHEAST'
                --AND WD.ACCOUNT_NAME = 'ATLANTA'
								--AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
								--AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
								--AND SLS.SELL_ACCOUNT_NAME IN ('DALLAS')
								--AND SLS.SALESMAN_CODE = 'OWC'
								AND SUBSTR (WD.REGION_NAME, 1, 1) = 'D'
         GROUP BY WD.DIVISION_NAME,
                  WD.REGION_NAME,
                  WD.ACCOUNT_NAME,
                  XREF.BUSINESS_GROUP,
                  --XREF.CUSTOMER_GROUP,
                  TPD.ROLLING_MONTH )
ORDER BY  DIVISION_NAME,
       REGION_NAME,
       BUSINESS_GROUP,
       MO
;