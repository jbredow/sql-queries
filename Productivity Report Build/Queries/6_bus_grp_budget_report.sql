SELECT SWD.DIVISION_NAME, 
       SWD.REGION_NAME,
       SUBSTR ( SWD.REGION_NAME, 1, 3 ) D_NK,
       TPD.FISCAL_YEAR_TO_DATE,
       VICT2.YEARMONTH,
       BG_XREF.BUSINESS_GROUP,
       CASE
            WHEN BG_XREF.BUSINESS_GROUP = 'Residential - Trade'
            THEN 
                'RESIDENTIAL - TRADE'
            WHEN BG_XREF.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
            THEN
                'RESIDENTIAL - BUILDER'
            WHEN BG_XREF.BUSINESS_GROUP = 'Commercial MRO'
            THEN 
                'COMMERCIAL MRO'
            WHEN BG_XREF.BUSINESS_GROUP = 'Commercial'
            THEN
                'COMMERCIAL'
            WHEN BG_XREF.BUSINESS_GROUP = 'Fire/Fabrication'
            THEN 
                'FIRE/FABRICATION'
            WHEN BG_XREF.BUSINESS_GROUP = 'HVAC'
            THEN
                'HVAC'
            WHEN BG_XREF.BUSINESS_GROUP = 'Industrial'
            THEN
                'INDUSTRIAL'
            WHEN BG_XREF.BUSINESS_GROUP = 'Waterworks'
            THEN
                'WATERWORKS'
            WHEN BG_XREF.BUSINESS_GROUP = 'FEI Internal'
            THEN
                'FEI INTERNAL'
            ELSE
                'OTHER'
       END
         AS BG,
       --TPD.ROLL12MONTHS TPD,
       --VICT2.CORE_ADJ_AVG_COGS,
       --VICT2.REP_COGS,
       --VICT2.PRICE_CATEGORY,
       --VICT2.ORIG_PRICE_CATEGORY,
       --VICT2.CUSTOMER_TYPE,
       SUM (VICT2.EXT_SALES) EXT_SALES,
       SUM (VICT2.EXT_AVG_COGS) EX_AVG_COGS,
       SUM (VICT2.CORE_ADJ_AVG_COGS) CORE_COGS,
       SUM (VICT2.LINES) EXT_LINES,
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
                VICT2.EXT_AVG_COGS
             ELSE
                0
          END)
          MATRIX_AVG_COGS,
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
                VICT2.EXT_AVG_COGS
             ELSE
                0
          END)
          OVERRIDE_AVG_COGS,
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
                VICT2.EXT_AVG_COGS
             ELSE
                0
          END)
          MANUAL_AVG_COGS,
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
             WHEN VICT2.PRICE_CATEGORY IN ('SPECIALS') THEN VICT2.EXT_AVG_COGS
             ELSE 0
          END)
          SPECIALS_AVG_COGS,
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
             WHEN VICT2.PRICE_CATEGORY IN ('CREDITS') THEN VICT2.EXT_AVG_COGS
             ELSE 0
          END)
          CREDITS_AVG_COGS,
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
             WHEN VICT2.PRICE_CATEGORY <> 'CREDITS' THEN VICT2.EXT_AVG_COGS
             ELSE 0
          END)
          OUTBOUND_COGS,
       SUM (
          CASE
             WHEN VICT2.PRICE_CATEGORY <> 'CREDITS' THEN VICT2.LINES
             ELSE 0
          END)
          OUTBOUND_CLINES
          
  FROM (AAA6863.PR_VICT2_BG_12MO VICT2
        INNER JOIN AAD9606.PR_SLS_WHSE_DIM SWD
           ON (VICT2.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK))
       INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG_XREF
          ON (VICT2.CUSTOMER_TYPE = BG_XREF.CUSTOMER_TYPE)
       INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
         ON ( VICT2.YEARMONTH = TPD.YEARMONTH )


 WHERE TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
      --AND VICT2.ACCOUNT_NUMBER = '20'


GROUP BY SWD.DIVISION_NAME, 
       SWD.REGION_NAME,
       SUBSTR ( SWD.REGION_NAME, 1, 3 ),
       TPD.FISCAL_YEAR_TO_DATE,
       VICT2.YEARMONTH,
       BG_XREF.BUSINESS_GROUP,
       CASE
            WHEN BG_XREF.BUSINESS_GROUP = 'Residential - Trade'
            THEN 
                'RESIDENTIAL - TRADE'
            WHEN BG_XREF.BUSINESS_GROUP = 'Residential - Build/Rem/Consumer'
            THEN
                'RESIDENTIAL - BUILDER'
            WHEN BG_XREF.BUSINESS_GROUP = 'Commercial MRO'
            THEN 
                'COMMERCIAL MRO'
            WHEN BG_XREF.BUSINESS_GROUP = 'Commercial'
            THEN
                'COMMERCIAL'
            WHEN BG_XREF.BUSINESS_GROUP = 'Fire/Fabrication'
            THEN 
                'FIRE/FABRICATION'
            WHEN BG_XREF.BUSINESS_GROUP = 'HVAC'
            THEN
                'HVAC'
            WHEN BG_XREF.BUSINESS_GROUP = 'Industrial'
            THEN
                'INDUSTRIAL'
            WHEN BG_XREF.BUSINESS_GROUP = 'Waterworks'
            THEN
                'WATERWORKS'
            WHEN BG_XREF.BUSINESS_GROUP = 'FEI Internal'
            THEN
                'FEI INTERNAL'
            ELSE
                'OTHER'
       END
     