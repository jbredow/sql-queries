SELECT 
       SELL_REGION_NAME,
			 SUBSTR (SELL_DISTRICT, 1, 3 ) DIST,
			 SELL_ACCOUNT_NAME,
			 WRITER,
       BUSINESS_GROUP,
       --CUSTOMER_GROUP,
       FYTD,
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

  FROM ( SELECT SLS.SELL_DISTRICT,
                SLS.SELL_REGION_NAME,
                SLS.SELL_ACCOUNT_NAME,
								SLS.WRITER,
                COALESCE ( XREF.BUSINESS_GROUP,
                          'OTHER'
                )
                  BUSINESS_GROUP,
                TPD.FISCAL_YEAR_TO_DATE FYTD,
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

          WHERE TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
                AND SLS.IC_FLAG = 'REGULAR'
         --AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
         --AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
         AND SLS.SELL_ACCOUNT_NAME IN ('DALLAS')
         --AND SLS.SALESMAN_CODE = 'OWC'
         GROUP BY SLS.SELL_DISTRICT,
                  SLS.SELL_REGION_NAME,
                  SLS.SELL_ACCOUNT_NAME,
									SLS.WRITER,
                  XREF.BUSINESS_GROUP,
                  --XREF.CUSTOMER_GROUP,
                  TPD.FISCAL_YEAR_TO_DATE )
ORDER BY  SELL_DISTRICT ASC, 
								SELL_ACCOUNT_NAME ASC, 
								BUSINESS_GROUP, 
								--CUSTOMER_GROUP,
								FYTD DESC
;