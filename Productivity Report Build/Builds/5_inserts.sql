/*
		run in order
*/

ALTER TABLE PRICE_MGMT.GP_TRACKER_13MO MODIFY (PRICE_CATEGORY VARCHAR2(35));
ALTER TABLE PRICE_MGMT.GP_TRACKER_13MO MODIFY (ROLLUP VARCHAR2(35));


INSERT INTO PRICE_MGMT.GP_TRACKER_13MO (SELECT * FROM PRICE_MGMT.GP_TRACKER_13MO_NOT_CCOR); 

INSERT INTO PRICE_MGMT.GP_TRACKER_13MO
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
           SUM (A.CORE_AVG_COGS) CORE_AVG_COGS,
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
      FROM PRICE_MGMT.GP_TRACKER_13MO_CCOR A
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

