/*
    Use for both FYTD and YOY tables
    jb
*/
SELECT X.TPD,
       X.REGION,
       X.DISTRICT,
       X.ACCOUNT_NAME,
       X.YEARMONTH,
       X.HOUSE_FLAG,
       --X.TITLE_DESC,
       --X.SALESREP_NK,
       --X.SALESREP_NAME,
       --HIER.BUSCAT2,
       x.DISCOUNT_GROUP_NK DG,
       NVL (HIER.HILEV, 'SP-'),
       HIER.DET1,
       HIER.DET2,
       HIER.DET6,
       SUM (X.LINES) LINES,
       SUM (X.AVG_COGS) AVG_COGS,
       SUM (X.INVOICE_COGS) INVOICE_COGS,
       SUM (X.SALES) SALES,
       SUM (X.CORE_COST_SUBTOTAL) CORE_COST_SUBTOTAL,
       SUM (X.CORE_ADJ_AVG_COGS) CORE_ADJ_AVG_COGS,
       SUM (X.WEIGHT) WEIGHT
  FROM AAA6863.PR_CORE_YOY2_CS X
       LEFT OUTER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
          ON (x.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK)
	-- WHERE PR_CORE_YTD.ACCOUNT_NAME = 'LAKEWOOD'
  WHERE HIER.DET2 = 'CARBON STEEL'
  AND HIER.DET1 = 'PIPE & TUBE'
GROUP BY x.TPD,
       X.REGION,
       X.DISTRICT,
       X.ACCOUNT_NAME,
       X.YEARMONTH,
       X.HOUSE_FLAG,
       --X.TITLE_DESC,
       --X.SALESREP_NK,
       --X.SALESREP_NAME,
       --HIER.BUSCAT2,
       X.DISCOUNT_GROUP_NK,
       NVL (HIER.HILEV, 'SP-'),
       HIER.DET1,
       HIER.DET2,
       HIER.DET6
         --PR_CORE_YTD.DISCOUNT_GROUP_NK,
         --HIER.DESCRIPTION
	;
	
	--remove region
	