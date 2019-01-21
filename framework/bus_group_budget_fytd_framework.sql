/*
    use for monthly business group / budget report 
*/

SELECT DTL.REGION,
          SUBSTR (DTL.DISTRICT, 1, 3)
       || '^'
       || CASE
             WHEN DTL.BUSINESS_GROUP = 'Residential - Trade'
             THEN
                'RESIDENTIAL - TRADE'
             WHEN DTL.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
             THEN
                'RESIDENTIAL - BUILDER'
             WHEN DTL.BUSINESS_GROUP = 'Commercial MRO'
             THEN
                'COMMERCIAL MRO'
             WHEN DTL.BUSINESS_GROUP = 'Commercial'
             THEN
                'COMMERCIAL'
             WHEN DTL.BUSINESS_GROUP = 'Fire/Fabrication'
             THEN
                'FIRE/FABRICATION'
             WHEN DTL.BUSINESS_GROUP = 'HVAC'
             THEN
                'HVAC'
             WHEN DTL.BUSINESS_GROUP = 'Industrial'
             THEN
                'INDUSTRIAL'
             WHEN DTL.BUSINESS_GROUP = 'Waterworks'
             THEN
                'WATERWORKS'
             WHEN DTL.BUSINESS_GROUP = 'FEI Internal'
             THEN
                'FEI INTERNAL'
             ELSE
                'OTHER'
          END
          AS CAT,
       DTL.DISTRICT,
       SUBSTR (DTL.DISTRICT, 1, 3)
          D_NK,
       DTL.YEARMONTH,
       DTL.BUSINESS_GROUP,
       CASE
          WHEN DTL.BUSINESS_GROUP = 'Residential - Trade'
          THEN
             'RESIDENTIAL - TRADE'
          WHEN DTL.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
          THEN
             'RESIDENTIAL - BUILDER'
          WHEN DTL.BUSINESS_GROUP = 'Commercial MRO'
          THEN
             'COMMERCIAL MRO'
          WHEN DTL.BUSINESS_GROUP = 'Commercial'
          THEN
             'COMMERCIAL'
          WHEN DTL.BUSINESS_GROUP = 'Fire/Fabrication'
          THEN
             'FIRE/FABRICATION'
          WHEN DTL.BUSINESS_GROUP = 'HVAC'
          THEN
             'HVAC'
          WHEN DTL.BUSINESS_GROUP = 'Industrial'
          THEN
             'INDUSTRIAL'
          WHEN DTL.BUSINESS_GROUP = 'Waterworks'
          THEN
             'WATERWORKS'
          WHEN DTL.BUSINESS_GROUP = 'FEI Internal'
          THEN
             'FEI INTERNAL'
          ELSE
             'OTHER'
       END
          AS BG,
       SUM (DTL.EXT_SALES_AMOUNT) AS EX_SALES,
       SUM (DTL.CORE_ADJ_AVG_COST) AS EX_COGS,
       SUM (DTL.INVOICE_LINES) AS EX_LINES,
       /* MATRIX */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
            AS MATRIX_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
            AS MATRIX_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN
                         ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
            AS MATRIX_LINES,
       /* CONTRACT */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
            AS OVERRIDE_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
            AS OVERRIDE_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'OVERRIDE'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
            AS OVERRIDE_LINES,
       /* MANUAL */
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
               THEN
                  DTL.EXT_SALES_AMOUNT
               ELSE
                  0
            END)
            AS MANUAL_SALES,
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
               THEN
                  DTL.CORE_ADJ_AVG_COST
               ELSE
                  0
            END)
            AS MANUAL_COGS,
       SUM (CASE
               WHEN     DTL.PRICE_CATEGORY_FINAL IN ('MANUAL',
                                                     'QUOTE',
                                                     'TOOLS',
                                                     'OTH/ERROR')
               THEN
                  DTL.INVOICE_LINES
               ELSE
                  0
            END)
            AS MANUAL_LINES,
       /* SPECIALS */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'SPECIALS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
            AS SP_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'SPECIALS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
            AS SP_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL IN ('SPECIALS')
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
            AS SP_LINES,
       /* CREDITS */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
            AS CREDITS_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
            AS CREDITS_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL = 'CREDITS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END)
            AS CREDIT_LINES,
       /* OUTBOUND */
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
             THEN
                DTL.EXT_SALES_AMOUNT
             ELSE
                0
          END)
            AS OUTBOUND_SALES,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
             THEN
                DTL.CORE_ADJ_AVG_COST
             ELSE
                0
          END)
            AS OUTBOUND_COGS,
       SUM (
          CASE
             WHEN     DTL.PRICE_CATEGORY_FINAL <> 'CREDITS'
             THEN
                DTL.INVOICE_LINES
             ELSE
                0
          END) 
            AS OUTBOUND_LINES

FROM (SELECT SWD.DIVISION_NAME AS REGION,
             SWD.REGION_NAME AS DISTRICT,
             DTL.BUSINESS_GROUP,
             TPD.FISCAL_YEAR_TO_DATE,
             PR_CAT.YEARMONTH,
             PR_CAT.PRICE_CATEGORY_FINAL,
             CASE WHEN ILF.SHIPPED_QTY > 0 THEN 1 ELSE 0 END INVOICE_LINES,
             ILF.EXT_SALES_AMOUNT,
             ILF.CORE_ADJ_AVG_COST
      FROM (((((PRICE_MGMT.PR_PRICE_CAT_HISTORY_TEMP PR_CAT
                INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                   ON (PR_CAT.YEARMONTH = TPD.YEARMONTH))
               INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
                  ON     (IHF.INVOICE_NUMBER_GK = PR_CAT.INVOICE_NUMBER_GK)
                     AND (IHF.YEARMONTH = PR_CAT.YEARMONTH))
              INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                 ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK))
             INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF DTL
                ON (CUST.CUSTOMER_TYPE = DTL.CUSTOMER_TYPE))
            INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
               ON     (ILF.YEARMONTH = PR_CAT.YEARMONTH)
                  AND (ILF.INVOICE_NUMBER_GK = PR_CAT.INVOICE_NUMBER_GK))
           INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
              ON (ILF.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
      WHERE     (TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE')
            AND (IHF.IC_FLAG = 0)
            AND (ILF.SHIPPED_QTY <> 0)
            AND (IHF.PO_WAREHOUSE_NUMBER IS NULL)
             AND (SWD.ACCOUNT_NUMBER_NK = '2000')
             -- AND (PR_CAT.YEARMONTH = 201810)
     ) DTL
GROUP BY DTL.REGION,
          SUBSTR ( DTL.DISTRICT, 1, 3 ) ||
          '^' ||
          CASE
            WHEN DTL.BUSINESS_GROUP = 'Residential - Trade'
            THEN
                'RESIDENTIAL - TRADE'
            WHEN DTL.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
            THEN
                'RESIDENTIAL - BUILDER'
            WHEN DTL.BUSINESS_GROUP = 'Commercial MRO'
            THEN
                'COMMERCIAL MRO'
            WHEN DTL.BUSINESS_GROUP = 'Commercial'
            THEN
                'COMMERCIAL'
            WHEN DTL.BUSINESS_GROUP = 'Fire/Fabrication'
            THEN
                'FIRE/FABRICATION'
            WHEN DTL.BUSINESS_GROUP = 'HVAC'
            THEN
                'HVAC'
            WHEN DTL.BUSINESS_GROUP = 'Industrial'
            THEN
                'INDUSTRIAL'
            WHEN DTL.BUSINESS_GROUP = 'Waterworks'
            THEN
                'WATERWORKS'
            WHEN DTL.BUSINESS_GROUP = 'FEI Internal'
            THEN
                'FEI INTERNAL'
            ELSE
                'OTHER'
       END,
       DTL.DISTRICT,
       SUBSTR ( DTL.DISTRICT, 1, 3 ),
       DTL.YEARMONTH,
       DTL.BUSINESS_GROUP,
       CASE
            WHEN DTL.BUSINESS_GROUP = 'Residential - Trade'
            THEN
                'RESIDENTIAL - TRADE'
            WHEN DTL.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
            THEN
                'RESIDENTIAL - BUILDER'
            WHEN DTL.BUSINESS_GROUP = 'Commercial MRO'
            THEN
                'COMMERCIAL MRO'
            WHEN DTL.BUSINESS_GROUP = 'Commercial'
            THEN
                'COMMERCIAL'
            WHEN DTL.BUSINESS_GROUP = 'Fire/Fabrication'
            THEN
                'FIRE/FABRICATION'
            WHEN DTL.BUSINESS_GROUP = 'HVAC'
            THEN
                'HVAC'
            WHEN DTL.BUSINESS_GROUP = 'Industrial'
            THEN
                'INDUSTRIAL'
            WHEN DTL.BUSINESS_GROUP = 'Waterworks'
            THEN
                'WATERWORKS'
            WHEN DTL.BUSINESS_GROUP = 'FEI Internal'
            THEN
                'FEI INTERNAL'
            ELSE
                'OTHER'
       END
ORDER BY DTL.REGION,
          SUBSTR ( DTL.DISTRICT, 1, 3 ) ||
          '^' ||
          CASE
            WHEN DTL.BUSINESS_GROUP = 'Residential - Trade'
            THEN
                'RESIDENTIAL - TRADE'
            WHEN DTL.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
            THEN
                'RESIDENTIAL - BUILDER'
            WHEN DTL.BUSINESS_GROUP = 'Commercial MRO'
            THEN
                'COMMERCIAL MRO'
            WHEN DTL.BUSINESS_GROUP = 'Commercial'
            THEN
                'COMMERCIAL'
            WHEN DTL.BUSINESS_GROUP = 'Fire/Fabrication'
            THEN
                'FIRE/FABRICATION'
            WHEN DTL.BUSINESS_GROUP = 'HVAC'
            THEN
                'HVAC'
            WHEN DTL.BUSINESS_GROUP = 'Industrial'
            THEN
                'INDUSTRIAL'
            WHEN DTL.BUSINESS_GROUP = 'Waterworks'
            THEN
                'WATERWORKS'
            WHEN DTL.BUSINESS_GROUP = 'FEI Internal'
            THEN
                'FEI INTERNAL'
            ELSE
                'OTHER'
       END,
       DTL.DISTRICT,
       SUBSTR ( DTL.DISTRICT, 1, 3 ),
       DTL.YEARMONTH,
       DTL.BUSINESS_GROUP,
       CASE
            WHEN DTL.BUSINESS_GROUP = 'Residential - Trade'
            THEN
                'RESIDENTIAL - TRADE'
            WHEN DTL.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
            THEN
                'RESIDENTIAL - BUILDER'
            WHEN DTL.BUSINESS_GROUP = 'Commercial MRO'
            THEN
                'COMMERCIAL MRO'
            WHEN DTL.BUSINESS_GROUP = 'Commercial'
            THEN
                'COMMERCIAL'
            WHEN DTL.BUSINESS_GROUP = 'Fire/Fabrication'
            THEN
                'FIRE/FABRICATION'
            WHEN DTL.BUSINESS_GROUP = 'HVAC'
            THEN
                'HVAC'
            WHEN DTL.BUSINESS_GROUP = 'Industrial'
            THEN
                'INDUSTRIAL'
            WHEN DTL.BUSINESS_GROUP = 'Waterworks'
            THEN
                'WATERWORKS'
            WHEN DTL.BUSINESS_GROUP = 'FEI Internal'
            THEN
                'FEI INTERNAL'
            ELSE
                'OTHER'
       END;