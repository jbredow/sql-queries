SELECT REGION,
       SELL_ACCOUNT_NAME,
       ACCOUNT_NUMBER_NK,
       SALESMAN_CODE,
       SALESREP_NAME SALES_REP,
       FYTD,
       EX_SALES,
       EX_COGS,
       MATRIX_SALES,
       MATRIX_COGS,
       OVERRIDE_SALES,
       OVERRIDE_COGS,
       MANUAL_SALES,
       MANUAL_COGS,
       CREDITS_SALES,
       CREDITS_COGS,
       SP_SALES,
       SP_COGS
  FROM (
			SELECT  SLS.SELL_DISTRICT REGION,
							SLS.SELL_ACCOUNT_NAME,
							SLS.ACCOUNT_NUMBER_NK,
							SLS.SALESMAN_CODE,
							SLS.SALESREP_NAME,
							TPD.FISCAL_YEAR_TO_DATE FYTD,
							NVL (SUM (SLS.EXT_SALES_AMOUNT), 0) EX_SALES,
							NVL (SUM (SLS.EXT_AVG_COGS_AMOUNT), 0) EX_COGS,
							/* MATRIX */
							SUM (
									CASE
										WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
														('MATRIX', 'MATRIX_BID')
										THEN
												SLS.EXT_SALES_AMOUNT
										ELSE
												0
									END)
								MATRIX_SALES,
							SUM (
									CASE
										WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
														('MATRIX', 'MATRIX_BID')
										THEN
												SLS.EXT_AVG_COGS_AMOUNT
										ELSE
												0
									END)
								MATRIX_COGS,
							/* CONTRACT */
							SUM (
									CASE
										WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
														'OVERRIDE'
										THEN
												SLS.EXT_SALES_AMOUNT
										ELSE
												0
									END)
								OVERRIDE_SALES,
							SUM (
									CASE
										WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
														'OVERRIDE'
										THEN
												SLS.EXT_AVG_COGS_AMOUNT
										ELSE
												0
									END)
								OVERRIDE_COGS,
							/* MANUAL */
							SUM (
									CASE
										WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
														('MANUAL', 'QUOTE', 'TOOLS')
										THEN
												SLS.EXT_SALES_AMOUNT
										ELSE
												0
									END)
								MANUAL_SALES,
							SUM (
									CASE
										WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
														('MANUAL', 'QUOTE', 'TOOLS')
										THEN
												SLS.EXT_AVG_COGS_AMOUNT
										ELSE
												0
									END)
								MANUAL_COGS,
							/* SPECIALS */
							SUM (
									CASE
										WHEN PRICE_CATEGORY = 'SPECIAL'
										THEN
												SLS.EXT_SALES_AMOUNT
										ELSE
												0
									END)
								SP_SALES,
							SUM (
									CASE
										WHEN PRICE_CATEGORY = 'SPECIAL'
										THEN
												SLS.EXT_AVG_COGS_AMOUNT
										ELSE
												0
									END)
								SP_COGS,
							/* CREDITS */
							SUM (
									CASE
										WHEN PRICE_CATEGORY = 'CREDITS'
										THEN
												SLS.EXT_SALES_AMOUNT
										ELSE
												0
									END)
								CREDITS_SALES,
							SUM (
									CASE
										WHEN PRICE_CATEGORY = 'CREDITS'
										THEN
												SLS.EXT_AVG_COGS_AMOUNT
										ELSE
												0
									END)
								CREDITS_COGS,
							/* CREDITS */
							SUM (
									CASE
										WHEN PRICE_CATEGORY <> 'CREDITS'
										THEN
												SLS.EXT_SALES_AMOUNT
										ELSE
												0
									END)
								OUTBOUND_SALES,
							SUM (
									CASE
										WHEN PRICE_CATEGORY <> 'CREDITS'
										THEN
												SLS.EXT_AVG_COGS_AMOUNT
										ELSE
												0
									END)
   			OUTBOUND_COGS
    
FROM SALES_MART.PRICE_MGMT_DATA_DET SLS
      INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
         ON SLS.YEARMONTH = TPD.YEARMONTH
WHERE     TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
      AND SLS.IC_FLAG = 'REGULAR'
			AND ACCOUNT_NUMBER_NK = '39'
      AND SLS.SALESREP_NAME NOT LIKE ('%HOUSE%')
      AND SLS.SALESREP_NAME NOT LIKE ('%COSTING%')
      AND SLS.SALESMAN_CODE NOT IN ( '%1%', 
																		 '%2%', 
																		 '%3%', 
																		 '%4%', 
																		 '%5%', 
																		 '%6%', 
																		 '%7%', 
																		 '%8%', 
																		 '%9%'
																	  )
GROUP BY SLS.SELL_DISTRICT,
        SLS. SELL_ACCOUNT_NAME,
        SLS.ACCOUNT_NUMBER_NK,
        SLS.SALESMAN_CODE,
        SLS.SALESREP_NAME,
        TPD.FISCAL_YEAR_TO_DATE)
;