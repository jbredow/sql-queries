SELECT PR_CORE_YTD.DIVISION_NAME AS REGION,
       PR_CORE_YTD.REGION_NAME AS DISTRICT,
       PR_CORE_YTD.ACCOUNT_NAME,
       --PR_CORE_YTD.YEARMONTH,
       PR_CORE_YTD.TITLE_DESC,
       PR_CORE_YTD.SALESMAN_CODE REP_CODE,
       PR_CORE_YTD.SALESREP_NAME,
       --HIER.BUSCAT2,
       NVL (HIER.HILEV, 'SP-') HILEV,
       HIER.DET1,
       --HIER.DET2,
      -- NVL (PR_CORE_YTD.DISCOUNT_GROUP_NK, 'SP-') AS DISC_GRP,
      -- HIER.DESCRIPTION,
       SUM (PR_CORE_YTD.LINES) LINES,
       SUM (PR_CORE_YTD.AVG_COGS) AVG_COGS,
       SUM (PR_CORE_YTD.INVOICE_COGS) INVOICE_COGS,
       SUM (PR_CORE_YTD.SALES) SALES,
       SUM (PR_CORE_YTD.CORE_COST_SUBTOTAL) CORE_COST_SUBTOTAL,
       SUM (PR_CORE_YTD.CORE_ADJ_AVG_COGS) CORE_ADJ_AVG_COGS
  FROM AAA6863.PR_CORE_YTD2_SEHVAC PR_CORE_YTD
       LEFT OUTER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
          ON (PR_CORE_YTD.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK)
GROUP BY PR_CORE_YTD.DIVISION_NAME,
         PR_CORE_YTD.REGION_NAME,
         PR_CORE_YTD.ACCOUNT_NAME,
         --PR_CORE_YTD.YEARMONTH,
         PR_CORE_YTD.SALESMAN_CODE,
         PR_CORE_YTD.SALESREP_NAME,
         PR_CORE_YTD.TITLE_DESC,
         --HIER.BUSCAT2,
         NVL (HIER.HILEV, 'SP-'),
         HIER.DET1--,
         --HIER.DET2,
         --PR_CORE_YTD.DISCOUNT_GROUP_NK,
         --HIER.DESCRIPTION
	;