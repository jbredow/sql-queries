SELECT DTL.REGION,
       DTL.DISTRICT,
       DTL.BUSINESS_GROUP,
       NVL (
          SUM (
             CASE
                WHEN DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
                THEN
                   DTL.EXT_SALES_AMOUNT
                ELSE
                   0
             END),
          0)
          EX_SALES,
       NVL (
          SUM (
             CASE
                WHEN DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
                THEN
                   DTL.CORE_ADJ_AVG_COST
                ELSE
                   0
             END),
          0)
          EX_COGS,
       NVL (
          SUM (
             CASE
                WHEN DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
                THEN
                   DTL.INVOICE_LINES
                ELSE
                   0
             END),
          0)
          EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          MATRIX_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          OVERRIDE_LINES,
       /* MANUAL */
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
                    AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
               THEN
                  DTL.EXT_SALES_AMOUNT
               ELSE
                  0
            END)
          MANUAL_SALES,
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
                    AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
               THEN
                  DTL.CORE_ADJ_AVG_COST
               ELSE
                  0
            END)
          MANUAL_COGS,
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
                    AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
               THEN
                  DTL.INVOICE_LINES
               ELSE
                  0
            END)
          MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          SP_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          SP_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          CREDITS_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          OUTBOUND_LINES,
       NVL (
          SUM (
             CASE
                WHEN DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
                THEN
                   DTL.EXT_SALES_AMOUNT
                ELSE
                   0
             END),
          0)
          LY_EX_SALES,
       NVL (
          SUM (
             CASE
                WHEN DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
                THEN
                   DTL.CORE_ADJ_AVG_COST
                ELSE
                   0
             END),
          0)
          LY_EX_COGS,
       NVL (
          SUM (
             CASE
                WHEN DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
                THEN
                   DTL.INVOICE_LINES
                ELSE
                   0
             END),
          0)
          LY_EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_MATRIX_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          LY_MATRIX_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          LY_MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          LY_OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          LY_OVERRIDE_LINES,
       /* MANUAL */
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
                    AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
               THEN
                  DTL.EXT_SALES_AMOUNT
               ELSE
                  0
            END)
          LY_MANUAL_SALES,
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
                    AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
               THEN
                  DTL.CORE_ADJ_AVG_COST
               ELSE
                  0
            END)
          LY_MANUAL_COGS,
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
                    AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
               THEN
                  DTL.INVOICE_LINES
               ELSE
                  0
            END)
          LY_MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_SP_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'SPECIALS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          LY_SP_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN ('SPECIALS')
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          LY_SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_CREDITS_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          LY_CREDITS_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          LY_CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
          LY_OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
          LY_OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
                  AND DTL.ROLL12MONTHS IN 'LAST TWELVE MONTHS LAST YEAR'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
          LY_OUTBOUND_LINES
FROM (SELECT SWD.DIVISION_NAME AS REGION,
             SWD.REGION_NAME AS DISTRICT,
             BG_XREF.BUSINESS_GROUP,
             TPD.ROLL12MONTHS,
             PR_CAT.PRICE_CATEGORY_FINAL,
             CASE WHEN ILF.SHIPPED_QTY > 0 THEN 1 ELSE 0 END INVOICE_LINES,
             PR_CAT.EXT_SALES_AMOUNT,
             PR_CAT.CORE_ADJ_AVG_COST
      FROM (((((PRICE_MGMT.PR_PRICE_CAT_HISTORY_TEMP PR_CAT
                INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                   ON (PR_CAT.YEARMONTH = TPD.YEARMONTH))
               INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
                  ON     (IHF.INVOICE_NUMBER_GK = PR_CAT.INVOICE_NUMBER_GK)
                     AND (IHF.YEARMONTH = PR_CAT.YEARMONTH))
              INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                 ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK))
             INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG_XREF
                ON (CUST.CUSTOMER_TYPE = BG_XREF.CUSTOMER_TYPE))
            INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
               ON     (ILF.YEARMONTH = PR_CAT.YEARMONTH)
                  AND (ILF.INVOICE_NUMBER_GK = PR_CAT.INVOICE_NUMBER_GK))
           INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
              ON (ILF.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
      WHERE     (TPD.ROLL12MONTHS IS NOT NULL)
            AND (IHF.IC_FLAG = 0)
            AND (ILF.SHIPPED_QTY <> 0)
            AND (IHF.PO_WAREHOUSE_NUMBER IS NULL) 
            -- AND (SWD.ACCOUNT_NUMBER_NK = '2000')
            -- AND (PR_CAT.YEARMONTH = 201810)
     ) DTL
GROUP BY DTL.REGION, DTL.DISTRICT, DTL.BUSINESS_GROUP
ORDER BY DTL.REGION, DTL.DISTRICT, DTL.BUSINESS_GROUP;