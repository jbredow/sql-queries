SELECT S.*,
-- OPERATION MEASURE DOES NOT INCLUDE CREDITS IN THE DENOMINATOR
CASE WHEN S.OUTBOUND_SALES>0
THEN (S.MATRIX_SALES + S.OVERRIDE_SALES)/S.OUTBOUND_SALES
ELSE 0
END
MNG_PRIC_UTIL

FROM

(SELECT SLS.REGION,
       SLS.DISTRICT,
       SLS.ACCOUNT_NUMBER_NK,
       SLS.FYTD
          ROLL12MO,
       MAX (SLS.YEARMONTH)
          MAX_YM,
       SLS.WHSE,
       SLS.MAIN_CUSTOMER_NK,
       SUM (SLS.EXT_SALES_AMOUNT)
          EX_SALES,
       SUM (SLS.EXT_AVG_COGS_AMOUNT)
          EX_COGS,
       SUM (SLS.TOTAL_LINES)
          EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MATRIX_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'OVERRIDE' THEN SLS.EXT_SALES_AMOUNT
             ELSE 0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'OVERRIDE'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('OVERRIDE') THEN SLS.TOTAL_LINES
             ELSE 0
          END)
          OVERRIDE_LINES,
       /* MANUAL */
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                SLS.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MANUAL_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          MANUAL_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                SLS.TOTAL_LINES
             ELSE
                0
          END)
          MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'SPECIALS' THEN SLS.EXT_SALES_AMOUNT
             ELSE 0
          END)
          SP_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'SPECIALS'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          SP_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL IN ('SPECIALS') THEN SLS.TOTAL_LINES
             ELSE 0
          END)
          SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'CREDITS' THEN SLS.EXT_SALES_AMOUNT
             ELSE 0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'CREDITS'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          CREDITS_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL = 'CREDITS' THEN SLS.TOTAL_LINES
             ELSE 0
          END)
          CREDIT_LINES,
       /* OUTBOUND */
       -- USE OUTBOUND SALES AS YOUR DENOMINATOR FOR UTIL %
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL <> 'CREDITS' THEN SLS.EXT_SALES_AMOUNT
             ELSE 0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL <> 'CREDITS'
             THEN
                SLS.EXT_AVG_COGS_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN PRICE_CATEGORY_FINAL <> 'CREDITS' THEN SLS.TOTAL_LINES
             ELSE 0
          END)
          OUTBOUND_LINES
FROM (SELECT TPD.ROLL12MONTHS
                FYTD,
             SWD.DIVISION_NAME
                REGION,
             SWD.REGION_NAME
                DISTRICT,
             SWD.ACCOUNT_NAME,
             SWD.ACCOUNT_NUMBER_NK,
             HIST.WAREHOUSE_NUMBER
                WHSE,
			CUST.MAIN_CUSTOMER_NK,	            
			HIST.YEARMONTH,
             CASE
				WHEN HIST.PRICE_CATEGORY_FINAL IN ('MATRIX_BID', 'NDP')
				THEN
					'MATRIX'
				WHEN HIST.PRICE_CATEGORY_FINAL IN
                     ('QUOTE', 'TOOLS', 'OTH/ERROR')
				THEN
					'MANUAL'
				ELSE
					HIST.PRICE_CATEGORY_FINAL
				END
                PRICE_CATEGORY_FINAL,
             SUM (HIST.EXT_SALES_AMOUNT)
                EXT_SALES_AMOUNT,
             COUNT (HIST.INVOICE_LINE_NUMBER)
                TOTAL_LINES,
             SUM (HIST.EXT_AVG_COGS_AMOUNT)
                AVG_COGS,
             SUM (HIST.CORE_ADJ_AVG_COST)
                EXT_AVG_COGS_AMOUNT
      FROM DWFEI_STG. [PR_PRICE_CAT_HIST] HIST
           /*   INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
                 ON (    HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
                     AND HIST.YEARMONTH = IHF.YEARMONTH)*/
           INNER JOIN DWFEI_STG.[SALES_WAREHOUSE_DIM] SWD
              ON HIST.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
           -- USE FOR ROLL12MONTH AND FYTD GROUPINGS
           INNER JOIN DWFEI_STG.[TIME_PERIOD_DIMENSION] TPD
              ON HIST.YEARMONTH = TPD.YEARMONTH
           -- USE FOR CUSTOMER REPORTING
           INNER JOIN DWFEI_STG.[CUSTOMER_DIMENSION] CUST
              ON HIST.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK



      WHERE     TPD.[ROLL12MONTHS] = 'LAST TWELVE MONTHS'
            GROUP BY TPD.[ROLL12MONTHS],
               SWD.REGION_NAME,
               SWD.DIVISION_NAME,
               SWD.ACCOUNT_NAME,
      SWD.ACCOUNT_NUMBER_NK,
               HIST.WAREHOUSE_NUMBER,
               HIST.YEARMONTH,
               CUST.MAIN_CUSTOMER_NK,
               CASE
				WHEN HIST.PRICE_CATEGORY_FINAL IN ('MATRIX_BID', 'NDP')
				THEN
					'MATRIX'
				WHEN HIST.PRICE_CATEGORY_FINAL IN
                     ('QUOTE', 'TOOLS', 'OTH/ERROR')
				THEN
					'MANUAL'
				ELSE
					HIST.PRICE_CATEGORY_FINAL
				END) SLS

GROUP BY SLS.REGION,
         SLS.ACCOUNT_NUMBER_NK,
         SLS.DISTRICT,
         SLS.FYTD,
         SLS.YEARMONTH,
         SLS.WHSE,
         SLS.MAIN_CUSTOMER_NK) S;