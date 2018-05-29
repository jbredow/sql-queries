/*
		run in order
*/

ALTER TABLE AAA6863.GP_TRACKER_13MO_2016 MODIFY (PRICE_CATEGORY VARCHAR2(35));
ALTER TABLE AAA6863.GP_TRACKER_13MO_2016 MODIFY (ROLLUP VARCHAR2(35));


INSERT INTO AAA6863.GP_TRACKER_13MO_2016 (SELECT * FROM AAA6863.GP_TRACKER_13MO_NOT_CCOR); 

INSERT INTO AAA6863.GP_TRACKER_13MO_2016
   (SELECT A.YYYY,
           A.YEARMONTH,
           A.ROLLING_QTR,
           A.REGION,
           A.ACCOUNT_NUMBER,
           A.WAREHOUSE_NUMBER,
           A.KOB,
           A.TYPE_OF_SALE,
           --GP_TRACKER_13MO_CCOR.PRICE_CODE,
           SUM (A.INVOICE_LINES) INVOICE_LINES,
           SUM (A.AVG_COGS) AVG_COGS,
           SUM (A.ACTUAL_COGS) ACTUAL_COGS,
           SUM (A.EXT_SALES) EXT_SALES,
           COALESCE (A.PRICE_CATEGORY_OVR_PR,
                     A.PRICE_CATEGORY_OVR_GR,
                     A.PRICE_CATEGORY)
              PRICE_CATEGORY,
           A.ROLLUP,
           A.SLS_TOTAL,
           A.SLS_SUBTOTAL,
           A.SLS_FREIGHT,
           A.SLS_MISC,
           A.SLS_RESTOCK,
           A.AVG_COST_SUBTOTAL,
           A.AVG_COST_FREIGHT,
           A.AVG_COST_MISC
      FROM AAA6863.GP_TRACKER_13MO_CCOR A
    GROUP BY A.YYYY,
             A.YEARMONTH,
             A.ROLLING_QTR,
             A.REGION,
             A.ACCOUNT_NUMBER,
             A.WAREHOUSE_NUMBER,
             A.KOB,
             A.TYPE_OF_SALE,
             COALESCE (A.PRICE_CATEGORY_OVR_PR,
                       A.PRICE_CATEGORY_OVR_GR,
                       A.PRICE_CATEGORY),
             A.ROLLUP,
             A.SLS_TOTAL,
             A.SLS_SUBTOTAL,
             A.SLS_FREIGHT,
             A.SLS_MISC,
             A.SLS_RESTOCK,
             A.AVG_COST_SUBTOTAL,
             A.AVG_COST_FREIGHT,
             A.AVG_COST_MISC)
		;

