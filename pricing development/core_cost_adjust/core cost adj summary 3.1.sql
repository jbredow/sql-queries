SELECT PR_CORE_YTD.REGION,
       PR_CORE_YTD.DISTRICT,
       PR_CORE_YTD.ACCOUNT_NAME,
       PR_CORE_YTD.TPD,
       --PR_CORE_YTD.YEARMONTH,
       CASE
          WHEN HOUSE_FLAG = 'O/S' THEN PR_CORE_YTD.TITLE_DESC
          WHEN HOUSE_FLAG = 'H/A' THEN 'Other Salesrep'
          ELSE 'Unassigned'
       END
          TITLE_ROLLUP,
       PR_CORE_YTD.TITLE_DESC,
       CASE
          WHEN HOUSE_FLAG IN ('O/S', 'H/A') THEN PR_CORE_YTD.SALESREP_NK
          ELSE 'HOUSE'
       END
          REP_CODE,
       CASE
          WHEN HOUSE_FLAG IN ('O/S', 'H/A') THEN PR_CORE_YTD.SALESREP_NAME
          ELSE 'HOUSE UNASSIGNED'
       END
          SALESREP_NAME,
       --HIER.BUSCAT2,
       NVL (HIER.HILEV, 'SP-')
          HILEV,
       HIER.DET1,
       HIER.FAB5_CAT,
       CASE
          WHEN (PR_CORE_YTD.AVG_COGS - PR_CORE_YTD.CORE_ADJ_AVG_COGS) + PR_CORE_YTD.COST_ONLY_ADJ > 0 
          THEN
             HIER.DET6
          ELSE
             'OTHER'
       END
          AS VENDOR,
       SUM (PR_CORE_YTD.LINES)
          LINES,
       SUM (PR_CORE_YTD.AVG_COGS)
          AVG_COGS,
       SUM (PR_CORE_YTD.INVOICE_COGS)
          INVOICE_COGS,
       SUM (PR_CORE_YTD.SALES)
          SALES,
       SUM (PR_CORE_YTD.CORE_ADJ_AVG_COGS)
          CORE_ADJ_AVG_COGS,
       SUM (PR_CORE_YTD.AVG_COGS - PR_CORE_YTD.CORE_ADJ_AVG_COGS)
          EXT_CLAIM_AMOUNT,
       SUM (PR_CORE_YTD.COST_ONLY_ADJ)
          COST_ONLY_ADJ,
       SUM (PR_CORE_YTD.AVG_COGS - PR_CORE_YTD.CORE_ADJ_AVG_COGS)
          CORE_COST_DELTA
FROM PRICE_MGMT.PR_VICT2_CUST_R2MO PR_CORE_YTD
     LEFT OUTER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
        ON (PR_CORE_YTD.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK)
     LEFT OUTER_JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
        ON PR_CORE_YTD.YEARMONTH = TPD.YEARMONTH
--WHERE PR_CORE_YTD.ACCOUNT_NAME IN ('DETROIT','LAKEWOOD','DALLAS')
GROUP BY PR_CORE_YTD.TPD,
         PR_CORE_YTD.REGION,
         PR_CORE_YTD.DISTRICT,
         PR_CORE_YTD.ACCOUNT_NAME,
         --PR_CORE_YTD.YEARMONTH,
         PR_CORE_YTD.TITLE_DESC,
         CASE
            WHEN HOUSE_FLAG = 'O/S' THEN PR_CORE_YTD.TITLE_DESC
            WHEN HOUSE_FLAG = 'H/A' THEN 'Other Salesrep'
            ELSE 'Unassigned'
         END,
         CASE
            WHEN HOUSE_FLAG IN ('O/S', 'H/A') THEN PR_CORE_YTD.SALESREP_NK
            ELSE 'HOUSE'
         END,
         CASE
            WHEN HOUSE_FLAG IN ('O/S', 'H/A') THEN PR_CORE_YTD.SALESREP_NAME
            ELSE 'HOUSE UNASSIGNED'
         END,
         --HIER.BUSCAT2,
         NVL (HIER.HILEV, 'SP-'),
         HIER.DET1,
         HIER.FAB5_CAT,
         CASE
            WHEN (PR_CORE_YTD.AVG_COGS - PR_CORE_YTD.CORE_ADJ_AVG_COGS)  + PR_CORE_YTD.COST_ONLY_ADJ > 0
            THEN
               HIER.DET6
            ELSE
               'OTHER'
         END

--HIER.DET2,
--PR_CORE_YTD.DISCOUNT_GROUP_NK,
--HIER.DESCRIPTION