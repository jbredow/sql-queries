SELECT SELL_DISTRICT,
       SELL_REGION_NAME,
       SELL_ACCOUNT_NAME,
       BUSINESS_GROUP,
       --CUSTOMER_GROUP,
       FYTD,
       EX_SALES,
       EX_COGS,
       CASE
         WHEN EX_SALES > 0 THEN ( EX_SALES - EX_COGS ) / EX_SALES
         ELSE 0
       END
         EX_GP_PCT,
			 EX_LINES,
/* MATRIX */
       MATRIX_SALES,
       MATRIX_COGS,
       CASE
         WHEN MATRIX_SALES > 0
         THEN
           ( MATRIX_SALES - MATRIX_COGS ) / MATRIX_SALES
         ELSE
           0
       END
         MATRIX_GP_PCT,
       CASE
         WHEN OUTBOUND_SALES > 0 THEN MATRIX_SALES / OUTBOUND_SALES
         ELSE 0
       END
         MATRIX_UTIL,
			 MATRIX_LINES,
			 CASE
         WHEN OUTBOUND_LINES > 0 THEN MATRIX_LINES / OUTBOUND_LINES
         ELSE 0
       END
         MATRIX_LINES_UTIL,

/* CONTRACT */
       OVERRIDE_SALES,
       OVERRIDE_COGS,
       CASE
         WHEN OVERRIDE_SALES > 0
         THEN
           ( OVERRIDE_SALES - OVERRIDE_COGS ) / OVERRIDE_SALES
         ELSE
           0
       END
         OVERRIDE_GP_PCT,
       CASE
         WHEN OUTBOUND_SALES > 0 THEN OVERRIDE_SALES / OUTBOUND_SALES
         ELSE 0
       END
         OVERRIDE_UTIL,
			 OVERRIDE_LINES,
			 CASE
         WHEN OUTBOUND_LINES > 0 THEN OVERRIDE_LINES / OUTBOUND_LINES
         ELSE 0
       END
         OVERRIDE_LINES_UTIL,

/* MANUAL */
       MANUAL_SALES,
			 MANUAL_COGS,
       CASE
         WHEN MANUAL_SALES > 0
         THEN
           ( MANUAL_SALES - MANUAL_COGS ) / MANUAL_SALES
         ELSE
           0
       END
         MANUAL_GP_PCT,
       CASE
         WHEN OUTBOUND_SALES > 0 THEN MANUAL_SALES / OUTBOUND_SALES
         ELSE 0
       END
         MANUAL_UTIL,
				 MANUAL_LINES,
			 CASE
         WHEN OUTBOUND_LINES > 0 THEN MANUAL_LINES / OUTBOUND_LINES
         ELSE 0
       END
         MANUAL_LINES_UTIL,

/* SPECIALS */
       SP_SALES,
			 SP_COGS,
       CASE
         WHEN SP_SALES > 0 THEN ( SP_SALES - SP_COGS ) / SP_SALES
         ELSE 0
       END
         SP_GP_PCT,
       CASE WHEN OUTBOUND_SALES > 0 THEN SP_SALES / OUTBOUND_SALES ELSE 0 END
         SP_UTIL,
				 SPECIAL_LINES,
			 CASE
         WHEN OUTBOUND_LINES > 0 THEN SPECIAL_LINES / OUTBOUND_LINES
         ELSE 0
       END
         SP_LINES_UTIL,

/* CREDITS */
       CREDITS_SALES,
       CREDITS_COGS,

/* OUTBOUND */
       OUTBOUND_SALES,
       CASE
         WHEN OUTBOUND_SALES > 0
         THEN
           ( OUTBOUND_SALES - OUTBOUND_COGS ) / OUTBOUND_SALES
         ELSE
           0
       END
         OUTBOUND_GP_PCT
  FROM ( SELECT SLS.SELL_DISTRICT,
                SLS.SELL_REGION_NAME,
                SLS.SELL_ACCOUNT_NAME,
                COALESCE ( XREF.BUSINESS_GROUP,
                          'OTHER'
                )
                  BUSINESS_GROUP,
                --XREF.CUSTOMER_GROUP,
                /* CASE
                    WHEN     REGEXP_LIKE (SLS.SALESMAN_CODE,
                                          '[0-9]?[0-9]?[0-9]')
                         AND SUBSTR (SLS.SALESREP_NAME, 0, 3) <> 'S16'
                    THEN
                       'HOUSE'
                    ELSE
                       NULL
                 END
                    HOUSE,
                 SLS.SALESMAN_CODE,
                 SLS.SALESREP_NAME,*/
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
          --INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
          --ON SLS.PRODUCT_NK = PROD.PRODUCT_NK
          --INNER JOIN DW_FEI.MASTER_VENDOR_DIMENSION VEND
          --ON PROD.MANUFACTURER = VEND.MASTER_VENDOR_NK
          --INNER JOIN AAD9606.PR_AVAIL_COMP_S COMP
          --ON PROD.DISCOUNT_GROUP_NK = COMP.DGRP
          WHERE TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
                AND SLS.IC_FLAG = 'REGULAR'
         --AND SLS.SALESREP_NAME NOT LIKE '%HOUSE%'
         --AND SLS.SALESREP_NAME NOT LIKE '%COSTING%'
         --AND SLS.SELL_ACCOUNT_NAME IN ('DALLAS')
         --AND SLS.SALESMAN_CODE = 'OWC'
         GROUP BY SLS.SELL_DISTRICT,
                  SLS.SELL_REGION_NAME,
                  SLS.SELL_ACCOUNT_NAME,
                  XREF.BUSINESS_GROUP,
                  --XREF.CUSTOMER_GROUP,
                  TPD.FISCAL_YEAR_TO_DATE )
ORDER BY SELL_DISTRICT ASC, SELL_ACCOUNT_NAME ASC, BUSINESS_GROUP, --CUSTOMER_GROUP,
                                                                   FYTD DESC