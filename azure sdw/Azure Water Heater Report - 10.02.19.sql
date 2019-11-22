/*
	Water Heater dataflow query
	updated 10/1/19
   
*/
SELECT p_cat.YEARMONTH,
       tpd.ROLL12MONTHS,
	    tpd.FISCAL_YEAR_TO_DATE,
	    tpd.YEAR_TO_DATE,
	    tpd.FISCAL_YEAR,
	    tpd.ROLLING_QTR,
       tpd.ROLLING_MONTH,
       wh.REGION_NAME,
       SUBSTRING (wh.DISTRICT, 1, 3)
          DIST,
       wh.ACCOUNT_NAME,
       h.HILEV,
       h.DET1,
       h.DET2,
       h.DET6,
       CONCAT (h.DISCOUNT_GROUP_NK, ' - ', h.DESCRIPTION)
          DG_NUM_NAME,
       h.DISCOUNT_GROUP_NK,
       h.DESCRIPTION,
       CASE
          WHEN h.DET2 LIKE '%TANKLESS' THEN 'TKLS'
          WHEN h.DET2 LIKE '%POINT%' THEN 'TKLS'
          WHEN h.DET2 LIKE 'COMM%' THEN 'COMM'
          WHEN h.DET2 LIKE 'RES%' THEN 'RES'
          ELSE 'OTHER'
       END
          HIER_CAT,
       SUM (p_cat.EXT_SALES_AMOUNT)
          AS SUM_EXT_SALES_AMOUNT,
       SUM (p_cat.CORE_ADJ_AVG_COST)
          AS SUM_CORE_ADJ_AVG_COST,
       SUM (p_cat.SHIPPED_QTY)
          AS SUM_SHIPPED_QTY
FROM [DWFEI_STG].[TIME_PERIOD_DIMENSION] tpd
  INNER JOIN [DWFEI_STG].[PR_PRICE_CAT_HIST] p_cat
    ON (tpd.YEARMONTH = p_cat.YEARMONTH)
  INNER JOIN [DWFEI_STG].[WHSE_RPT_AREA_VW] wh
    ON  (CONVERT(VARCHAR(8),p_cat.WAREHOUSE_NUMBER) = CONVERT(VARCHAR(8),wh.WAREHOUSE_NUMBER_NK))
  INNER JOIN [DWFEI_STG].[PRODUCT_DIMENSION] prod
    ON (p_cat.PRODUCT_GK = prod.PRODUCT_GK)
  INNER JOIN [DWFEI_STG].[BUSGRP_PROD_HIERARCHY] h
    ON (prod.DISCOUNT_GROUP_GK = h.DISCOUNT_GROUP_GK)

WHERE h.DET1 = 'WATER HEATERS'
  AND h.DET6 <> 'OTHER MANUFACTURERS'
  AND (SUBSTRING (wh.REGION_NAME, 1, 4) IN ('EAST', 'CENT', 'WEST'))
GROUP BY p_cat.YEARMONTH,
       tpd.ROLL12MONTHS,
	    tpd.FISCAL_YEAR_TO_DATE,
	    tpd.YEAR_TO_DATE,
	    tpd.FISCAL_YEAR,
	    tpd.ROLLING_QTR,
       tpd.ROLLING_MONTH,
       wh.REGION_NAME,
       SUBSTRING (wh.DISTRICT, 1, 3),
       wh.ACCOUNT_NAME,
       h.HILEV, h.DET1,
       h.DET2, h.DET6,
       CONCAT(h.DISCOUNT_GROUP_NK, ' - ', h.DESCRIPTION),
       h.DISCOUNT_GROUP_NK,
       h.DESCRIPTION,
       CASE
          WHEN h.DET2 LIKE '%TANKLESS'
          THEN 'TKLS'
          WHEN h.DET2 LIKE '%POINT%'
          THEN 'TKLS'
          WHEN h.DET2 LIKE 'COMM%'
          THEN 'COMM'
          WHEN h.DET2 LIKE 'RES%'
          THEN 'RES' ELSE 'OTHER'
      END;