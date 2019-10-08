/*
	Specials Report PBI Dataflow query
	Updated 10.02.19
*/
SELECT wh.REGION_NAME,
       wh.DISTRICT,
       sp.ACCOUNT_NAME,
       sp.ACCOUNT_NUMBER,
       wh.RPT_NAME,
       sp.WAREHOUSE_NUMBER SHIP_WH,
	   wh.WAREHOUSE_NAME,
	   CONCAT(sp.WAREHOUSE_NUMBER, ' - ', wh.WAREHOUSE_NAME) WAREHOUSE,
       sp.WRITER,
       sp.OML_ASSOC_NAME ASSOC_NAME,
       sp.INVOICE_NUMBER_NK INV_NK,
       sp.PROCESS_DATE,
       sp.ALT1_CODE ALT_1,
       sp.PRODUCT_NAME PRODUCT,
       sp.STATUS ST,
       sp.UM "U/M",
       sp.DISCOUNT_GROUP_NK DG,
       dg.DESCRIPTION DG_NAME,
       sp.SHIPPED_QTY SHPD,
       sp.EXT_SALES_AMOUNT EXT_NET,
       sp.CORE_ADJ_AVG_COST EXT_AC,
       sp.TYPE_OF_SALE SALE_TYPE,
       sp.ORDER_CODE ORDER_CODE,
       sp.CUSTOMER_NK CUST_#,
       sp.CUSTOMER_NAME CUST_NAME,
       sp.PRICE_FORMULA "FORM",
       sp.PRICE_CODE PRCD,
       dg.DET1 DG_DET1,
       dg.DET2 DG_DET2,
       dg.DET6 VENDOR,
       sp.CUSTOMER_TYPE
FROM        [DWFEI_STG].[PR_VICT2_CUST_R2MO] sp

 INNER JOIN [DWFEI_STG].[WHSE_RPT_AREA_VW] wh
  ON 
	CAST(sp.WAREHOUSE_NUMBER AS varchar) = CAST(wh.WAREHOUSE_NUMBER_NK AS varchar)

 LEFT OUTER JOIN [DWFEI_STG].[BUSGRP_PROD_HIERARCHY] dg
  ON sp.DISCOUNT_GROUP_NK = dg.DISCOUNT_GROUP_NK

 INNER JOIN [DWFEI_STG].[TIME_PERIOD_DIMENSION] tpd
  ON sp.YEARMONTH = tpd.YEARMONTH

 WHERE tpd.ROLLING_QTR = 'THIS QUARTER'
  AND sp.STATUS IN ('SP-', 'SP')
  AND sp.EXT_SALES_AMOUNT >= 0
  AND sp.ACCOUNT_NAME = 'OHVAL';