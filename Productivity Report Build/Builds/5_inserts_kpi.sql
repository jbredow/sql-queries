/*
		run in order
*/

ALTER TABLE AAA6863.GP_TRACKER_KPI_12MO MODIFY (PRICE_CATEGORY VARCHAR2(35));
ALTER TABLE AAA6863.GP_TRACKER_KPI_12MO MODIFY (ROLLUP VARCHAR2(35));


--INSERT INTO AAA6863.GP_TRACKER_KPI_12MO (SELECT * FROM AAA6863.GP_TRACKER_13MO_NOT_CCOR_2017); 

INSERT INTO AAA6863.GP_TRACKER_KPI_12MO
   (SELECT A.YYYY,
           A.YEARMONTH,
           A.YEARMONTH AS ROLLING_QTR,
           A.REGION,
           A.ACCOUNT_NUMBER,
           A.WAREHOUSE_NUMBER,
           A.KOB,
           A.TYPE_OF_SALE,
           --A.PRICE_CODE,
           SUM (A.INVOICE_LINES) INVOICE_LINES,
           SUM (A.AVG_COGS) AVG_COGS,
           SUM (A.ACTUAL_COGS) ACTUAL_COGS,
           SUM (A.EXT_SALES) EXT_SALES,
           A.PRICE_CATEGORY,
           A.ROLLUP,
           A.SLS_TOTAL,
           A.SLS_SUBTOTAL,
           A.SLS_FREIGHT,
           A.SLS_MISC,
           A.SLS_RESTOCK,
           A.AVG_COST_SUBTOTAL,
           A.AVG_COST_FREIGHT,
           A.AVG_COST_MISC
      FROM AAA6863.GP_TRACKER_KPI_12MO_CCOR A
    GROUP BY A.YYYY,
             A.YEARMONTH,
             A.YEARMONTH,
             A.REGION,
             A.ACCOUNT_NUMBER,
             A.WAREHOUSE_NUMBER,
             A.KOB,
             A.TYPE_OF_SALE,
             PRICE_CATEGORY,
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

INSERT INTO AAA6863.GP_TRACKER_KPI_12MO
   (SELECT A.YYYY,
           A.YEARMONTH,
           A.YEARMONTH AS ROLLING_QTR,
           A.REGION,
           A.ACCOUNT_NUMBER,
           A.WAREHOUSE_NUMBER,
           A.KOB,
           A.TYPE_OF_SALE,
           --A.PRICE_CODE,
           SUM (A.INVOICE_LINES) INVOICE_LINES,
           SUM (A.AVG_COGS) AVG_COGS,
           SUM (A.ACTUAL_COGS) ACTUAL_COGS,
           SUM (A.EXT_SALES) EXT_SALES,
           A.PRICE_CATEGORY,
           A.ROLLUP,
           A.SLS_TOTAL,
           A.SLS_SUBTOTAL,
           A.SLS_FREIGHT,
           A.SLS_MISC,
           A.SLS_RESTOCK,
           A.AVG_COST_SUBTOTAL,
           A.AVG_COST_FREIGHT,
           A.AVG_COST_MISC
      FROM AAA6863.GP_TRACKER_KPI_12MO_NOT_CCOR A
    GROUP BY A.YYYY,
             A.YEARMONTH,
             A.YEARMONTH,
             A.REGION,
             A.ACCOUNT_NUMBER,
             A.WAREHOUSE_NUMBER,
             A.KOB,
             A.TYPE_OF_SALE,
             PRICE_CATEGORY,
             A.ROLLUP,
             A.SLS_TOTAL,
             A.SLS_SUBTOTAL,
             A.SLS_FREIGHT,
             A.SLS_MISC,
             A.SLS_RESTOCK,
             A.AVG_COST_SUBTOTAL,
             A.AVG_COST_FREIGHT,
             A.AVG_COST_MISC);