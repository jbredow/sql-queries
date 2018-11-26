SELECT SLS.YEARMONTH,
       SLS.REGION_NAME,
       SLS.ACCOUNT_NUMBER,
       SLS.ACCOUNT_NAME,
       --SLS.PRICE_CATEGORY,
       SUM (SLS.EXT_SALES) EXT_SALES,
       SUM (SLS.CORE_ADJ_AVG_COGS) CORE_COGS,
       SUM (SLS.INVOICE_LINES) INVOICE_LINES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                SLS.EXT_SALES
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                SLS.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          MATRIX_AVG_COGS,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
             THEN
                SLS.INVOICE_LINES
             ELSE
                0
          END)
          MATRIX_INVOICE_LINES,
       
       
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('OVERRIDE') THEN SLS.EXT_SALES
             ELSE 0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('OVERRIDE')
             THEN
                SLS.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          OVERRIDE_AVG_COGS,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('OVERRIDE')
             THEN
                SLS.INVOICE_LINES
             ELSE
                0
          END)
          OVERRIDE_INVOICE_LINES,
          
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS', 'OTH/ERROR')
             THEN
                SLS.EXT_SALES
             ELSE
                0
          END)
          MANUAL_SALES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS', 'OTH/ERROR')
             THEN
                SLS.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          MANUAL_AVG_COGS,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS', 'OTH/ERROR')
             THEN
                SLS.INVOICE_LINES
             ELSE
                0
          END)
          MANUAL_INVOICE_LINES,
       
       
       
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('SPECIALS') THEN SLS.EXT_SALES
             ELSE 0
          END)
          SPECIALS_SALES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('SPECIALS') THEN SLS.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          SPECIALS_AVG_COGS,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('SPECIALS') THEN SLS.INVOICE_LINES
             ELSE 0
          END)
          SPECIALS_INVOICE_LINES,
       
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('CREDITS') THEN SLS.EXT_SALES
             ELSE 0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('CREDITS') THEN SLS.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          CREDITS_AVG_COGS,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY IN ('CREDITS') THEN SLS.INVOICE_LINES
             ELSE 0
          END)
          CREDITS_INVOICE_LINES,
       
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY <> 'CREDITS' THEN SLS.EXT_SALES
             ELSE 0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY <> 'CREDITS' THEN SLS.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN SLS.PRICE_CATEGORY <> 'CREDITS' THEN SLS.INVOICE_LINES
             ELSE 0
          END)
          OUTBOUND_INVOICE_LINES
            
FROM (SELECT VICT2.YEARMONTH,
               SWD.REGION_NAME,
               VICT2.ACCOUNT_NUMBER,
               SWD.ACCOUNT_NAME,
               P_CAT.PRICE_CATEGORY_FINAL PRICE_CATEGORY,
               VICT2.EXT_SALES_AMOUNT EXT_SALES,
               VICT2.CORE_ADJ_AVG_COST CORE_ADJ_AVG_COGS,
               VICT2.INVOICE_LINES
        FROM (PRICE_MGMT.PR_VICT2_CUST_R2MO VICT2
              INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
                 ON (VICT2.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK))
             INNER JOIN PRICE_MGMT.PR_PRICE_CAT_HIST P_CAT
                ON     (VICT2.INVOICE_NUMBER_GK = P_CAT.INVOICE_NUMBER_GK)
                   AND (VICT2.YEARMONTH = P_CAT.YEARMONTH)
        WHERE     (VICT2.SHIPPED_QTY <> 0)
              AND ( VICT2.EXT_SALES_AMOUNT <> 0)
              AND (SWD.DIVISION_NAME = 'WATERWORKS REGION')
              AND (VICT2.YEARMONTH = TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM'))
      ) SLS

GROUP BY SLS.YEARMONTH,
       SLS.REGION_NAME,
       SLS.ACCOUNT_NUMBER,
       SLS.ACCOUNT_NAME  --,
       --SLS.PRICE_CATEGORY
ORDER BY SLS.YEARMONTH,
       SLS.REGION_NAME,
       SLS.ACCOUNT_NAME