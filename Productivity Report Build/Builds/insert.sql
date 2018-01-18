/*INSERT INTO AAE0376.GP_TRACKER_13MO
   (SELECT YYYY,
           YEARMONTH,
           ROLLING_QTR,
           REGION,
           ACCOUNT_NUMBER,
           WAREHOUSE_NUMBER,
           KOB,
           TYPE_OF_SALE,
           INVOICE_LINES,
           AVG_COGS,
           ACTUAL_COGS,
           EXT_SALES,
           /*CASE
          WHEN CCOR.PRICE_CATEGORY IN
                  ('MATRIX', 'MATRIX_BID', 'QUOTE', 'MANUAL')
          THEN
             COALESCE (CCOR.PRICE_CATEGORY_OVR_PR,
                       CCOR.PRICE_CATEGORY_OVR_GR,
                       CCOR.PRICE_CATEGORY)
          ELSE
             CCOR.PRICE_CATEGORY
       END*/
          PRICE_CATEGORY,
           ROLLUP,
           SLS_TOTAL,
           SLS_SUBTOTAL,
           SLS_FREIGHT,
           SLS_MISC,
           SLS_RESTOCK,
           AVG_COST_SUBTOTAL,
           AVG_COST_FREIGHT,
           AVG_COST_MISC
      FROM AAE0376.GP_TRACKER_13MO_NOT_CCOR CCOR)*/
      
      INSERT INTO AAE0376.GP_TRACKER_13MO
   (SELECT YYYY,
           YEARMONTH,
           ROLLING_QTR,
           REGION,
           ACCOUNT_NUMBER,
           WAREHOUSE_NUMBER,
           KOB,
           TYPE_OF_SALE,
           INVOICE_LINES,
           AVG_COGS,
           ACTUAL_COGS,
           EXT_SALES,
           CASE
          WHEN CCOR.PRICE_CATEGORY IN
                  ('MATRIX', 'MATRIX_BID', 'QUOTE', 'MANUAL')
          THEN
             COALESCE (CCOR.PRICE_CATEGORY_OVR_PR,
                       CCOR.PRICE_CATEGORY_OVR_GR,
                       CCOR.PRICE_CATEGORY)
          ELSE
             CCOR.PRICE_CATEGORY
       END
          PRICE_CATEGORY,
           ROLLUP,
           SLS_TOTAL,
           SLS_SUBTOTAL,
           SLS_FREIGHT,
           SLS_MISC,
           SLS_RESTOCK,
           AVG_COST_SUBTOTAL,
           AVG_COST_FREIGHT,
           AVG_COST_MISC
      FROM AAE0376.GP_TRACKER_13MO_CCOR CCOR);
      