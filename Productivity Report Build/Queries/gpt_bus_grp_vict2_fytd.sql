SELECT SWD.DIVISION_NAME, 
       SWD.REGION_NAME, 
       NULL AS EXTRA,
       BG_XREF.BUSINESS_GROUP,
       --VICT2.YEARMONTH,
       TPD.FISCAL_YEAR_TO_DATE TPD,
       --VICT2.CORE_ADJ_AVG_COGS,
       --VICT2.REP_COGS,
       --VICT2.PRICE_CATEGORY,
       --VICT2.ORIG_PRICE_CATEGORY,
       --VICT2.CUSTOMER_TYPE,
       SUM (VICT2.EXT_SALES) EXT_SALES,
       SUM (VICT2.CORE_ADJ_AVG_COGS) EX_AVG_COGS,
       SUM (VICT2.CORE_ADJ_AVG_COGS) CORE_COGS,
       SUM (VICT2.LINES) TOTAL_LINES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                VICT2.EXT_SALES
             ELSE
                0
          END)
          MATRIX_SALES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                VICT2.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          MATRIX_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                VICT2.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          MATRIX_CORE_ADJ_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
             THEN
                VICT2.LINES
             ELSE
                0
          END)
          MATRIX_LINES,
       
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('OVERRIDE') THEN VICT2.EXT_SALES
             ELSE 0
          END)
          OVERRIDE_SALES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('OVERRIDE')
             THEN
                VICT2.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          OVERRIDE_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('OVERRIDE')
             THEN
                VICT2.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          OVERRIDE_CORE_ADJ_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('OVERRIDE')
             THEN
                VICT2.LINES
             ELSE
                0
          END)
          OVERRIDE_LINES,
          
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                VICT2.EXT_SALES
             ELSE
                0
          END)
          MANUAL_SALES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                VICT2.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          MANUAL_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                VICT2.CORE_ADJ_AVG_COGS
             ELSE
                0
          END)
          MANUAL_CORE_ADJ_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'QUOTE', 'TOOLS')
             THEN
                VICT2.LINES
             ELSE
                0
          END)
          MANUAL_LINES,
       
       
       
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('SPECIALS') THEN VICT2.EXT_SALES
             ELSE 0
          END)
          SPECIALS_SALES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('SPECIALS') THEN VICT2.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          SPECIALS_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('SPECIALS') THEN VICT2.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          SPECIALS_CORE_ADJ_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('SPECIALS') THEN VICT2.LINES
             ELSE 0
          END)
          SPECIALS_LINES,
       
       
       
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('CREDITS') THEN VICT2.EXT_SALES
             ELSE 0
          END)
          CREDITS_SALES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('CREDITS') THEN VICT2.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          CREDITS_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('CREDITS') THEN VICT2.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          CREDITS_CORE_ADJ_AVG_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY IN ('CREDITS') THEN VICT2.LINES
             ELSE 0
          END)
          CREDITS_LINES,
       
       
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY <> 'CREDITS' THEN VICT2.EXT_SALES
             ELSE 0
          END)
          OUTBOUND_SALES,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY <> 'CREDITS' THEN VICT2.CORE_ADJ_AVG_COGS
             ELSE 0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY <> 'CREDITS' THEN VICT2.LINES
             ELSE 0
          END)
          OUTBOUND_LINES
          
  FROM (PRICE_MGMT.PR_VICT2_BG_12MO VICT2
        INNER JOIN PRICE_MGMT.PR_SLS_WHSE_DIM SWD
           ON (VICT2.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK))
       INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG_XREF
          ON (VICT2.CUSTOMER_TYPE = BG_XREF.CUSTOMER_TYPE)
       INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
         ON ( VICT2.YEARMONTH = TPD.YEARMONTH )
  WHERE TPD.FISCAL_YEAR_TO_DATE IS NOT NULL

GROUP BY  SWD.DIVISION_NAME, 
          SWD.REGION_NAME, 
          BG_XREF.BUSINESS_GROUP, 
          --VICT2.YEARMONTH,
          TPD.FISCAL_YEAR_TO_DATE --,
          --VICT2.CORE_ADJ_AVG_COGS,
          --VICT2.REP_COGS,
          --VICT2.PRICE_CATEGORY,
          --VICT2.ORIG_PRICE_CATEGORY,
          --VICT2.CUSTOMER_TYPE
  ;