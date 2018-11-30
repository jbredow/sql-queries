/*
    Use for both FYTD and YOY tables
    jb 
*/

SELECT PR_CORE_YTD.REGION,
       PR_CORE_YTD.DISTRICT,
       PR_CORE_YTD.ACCOUNT_NAME,
       TPD.FISCAL_YEAR_TO_DATE
          AS FYTD,
       --PR_CORE_YTD.YEARMONTH,
       PR_CORE_YTD.HOUSE_FLAG,
       --PR_CORE_YTD.SALESMAN_CODE REP_CODE,
       --PR_CORE_YTD.SALESREP_NAME,
       --HIER.BUSCAT2,
       NVL (HIER.HILEV, 'SP-')
          HILEV,
       HIER.DET1,
       HIER.DET2,
       HIER.DET6
          VDR,
          NVL (PR_CORE_YTD.DISCOUNT_GROUP_NK, 'SP-')
       || ' - '
       || HIER.DESCRIPTION
          DG_DESCRIPTION,
       SUM (PR_CORE_YTD.LINES)
          LINES,
       SUM (PR_CORE_YTD.AVG_COGS)
          AVG_COGS,
       SUM (PR_CORE_YTD.INVOICE_COGS)
          INVOICE_COGS,
       SUM (PR_CORE_YTD.SALES)
          SALES,
       SUM (PR_CORE_YTD.CORE_COST_SUBTOTAL)
          CORE_COST_SUBTOTAL,
       SUM (PR_CORE_YTD.CORE_ADJ_AVG_COGS)
          CORE_ADJ_AVG_COGS
FROM AAA6863.PR_CORE_YOY2 PR_CORE_YTD
     INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
        ON PR_CORE_YTD.YEARMONTH = TPD.YEARMONTH
     LEFT OUTER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
        ON (PR_CORE_YTD.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK)
WHERE HIER.FAB5_CAT = 'PVC & ABS PIPE'
GROUP BY PR_CORE_YTD.REGION,
         PR_CORE_YTD.DISTRICT,
         PR_CORE_YTD.ACCOUNT_NAME,
         TPD.FISCAL_YEAR_TO_DATE,
         --PR_CORE_YTD.YEARMONTH,
         --PR_CORE_YTD.SALESMAN_CODE,
         --PR_CORE_YTD.SALESREP_NAME,
         PR_CORE_YTD.HOUSE_FLAG,
         --HIER.BUSCAT2,
         NVL (HIER.HILEV, 'SP-'),
         HIER.DET1,
         HIER.DET2,
         HIER.DET6,
            NVL (PR_CORE_YTD.DISCOUNT_GROUP_NK, 'SP-')
         || ' - '
         || HIER.DESCRIPTION