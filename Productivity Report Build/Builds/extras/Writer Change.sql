CREATE TABLE AAE0376.GP_TRACKER_WRITER_ROUNND
AS
(SELECT YEARMONTH,
REGION,
ACCOUNT_NUMBER,
WAREHOUSE_NUMBER,
KOB,
WRITER,
TYPE_OF_SALE,
INVOICE_LINES,
AVG_COGS,
ACTUAL_COGS,
EXT_SALES,
CASE
          WHEN PRICE_CATEGORY IN
                  ('MATRIX', 'MATRIX_BID', 'QUOTE', 'MANUAL')
          THEN
             COALESCE (PRICE_CATEGORY_OVR_PR,
                       PRICE_CATEGORY_OVR_GR,
                       PRICE_CATEGORY)
          ELSE
             PRICE_CATEGORY
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
 
 FROM GP_TRACKER_WRITER);