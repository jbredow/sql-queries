TRUNCATE TABLE AAA6863.GP_TRACKER_FY16_17_KPI;
DROP TABLE AAA6863.GP_TRACKER_FY16_17_KPI;

CREATE TABLE AAA6863.GP_TRACKER_FY16_17_KPI
NOLOGGING
--2016
AS
   (SELECT SUBSTR (IHF.YEARMONTH, 0, 4) YYYY,
           IHF.YEARMONTH,
           IHF.YEARMONTH ROLLING_QTR,
           PS.DIVISION_NAME REGION,
           PS.ACCOUNT_NUMBER_NK ACCOUNT_NUMBER,
           PS.WAREHOUSE_NUMBER_NK,
           DECODE (PS.DIVISION_NAME,
                   'EAST REGION', 'BLENDED',
                   'WEST REGION', 'BLENDED',
                   'NORTH CENTRAL REGION', 'BLENDED',
                   'SOUTH CENTRAL REGION', 'BLENDED',
                   'INDUSTRIAL REGION', 'INDUSTRIAL',
                   'WATERWORKS REGION', 'WW',
                   'HVAC REGION', 'HVAC',
                   PS.DIVISION_NAME)
              KOB,
           DECODE (IHF.SALE_TYPE,
                   '1', 'Our Truck',
                   '2', 'Counter',
                   '3', 'Direct',
                   '4', 'Counter',
                   '5', 'Credit Memo',
                   '6', 'Showroom',
                   '7', 'Showroom Direct',
                   '8', 'eBusiness')
              TYPE_OF_SALE,
           --TO_CHAR((0) PRICE_CODE) PRICE_cODE,
           (0) invoice_lines,
           SUM (NVL (IHF.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cogs,
           SUM (NVL (IHF.COST_SUBTOTAL_AMOUNT, '0')) actual_cogs,
           SUM (IHF.SALES_SUBTOTAL_AMOUNT) ext_sales,
           'Total' AS PRICE_CATEGORY,
           'Total' AS ROLLUP,
           SUM (IHF.TOTAL_SALES_AMOUNT) sls_total,
           SUM (NVL (IHF.SALES_SUBTOTAL_AMOUNT, '0')) sls_subtotal,
           SUM (NVL (IHF.FREIGHT_SALES_AMOUNT, '0')) sls_freight,
           SUM (NVL (IHF.MISC_SALES_AMOUNT, '0')) sls_misc,
           SUM (NVL (IHF.RESTOCKING_SALES_AMOUNT, '0')) sls_restock,
           SUM (NVL (IHF.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cost_subtotal,
           SUM (NVL (IHF.FREIGHT_COST_AMOUNT, '0')) avg_cost_freight,
           SUM (NVL (IHF.MISC_COST_AMOUNT, '0')) avg_cost_misc
      FROM DW_FEI.INVOICE_HEADER_FACT IHF,
           DW_FEI.CUSTOMER_DIMENSION CUST,
           SALES_MART.SALES_WAREHOUSE_DIM PS
     WHERE     IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
           AND TO_CHAR (IHF.WAREHOUSE_NUMBER) =
                  TO_CHAR (PS.WAREHOUSE_NUMBER_NK)
           AND IHF.IC_FLAG = 0
           AND IHF.PO_WAREHOUSE_NUMBER IS NULL
           AND NVL (IHF.CONSIGN_TYPE, 'N') <> 'R'
           AND IHF.YEARMONTH BETWEEN '201508' AND '201804'
           /*AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                        TRUNC (
                                             SYSDATE
                                           - NUMTOYMINTERVAL (12, 'MONTH'),
                                           'MONTH'),
                                        'YYYYMM')
                                 AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                              'YYYYMM')*/
           AND DECODE (NVL (CUST.ar_gl_number, '9999'),
                       '1320', 0,
                       '1360', 0,
                       '1380', 0,
                       '1400', 0,
                       '1401', 0,
                       '1500', 0,
                       '4000', 0,
                       '7100', 0,
                       '9999', 0,
                       1) <> 0
    GROUP BY SUBSTR (IHF.YEARMONTH, 0, 4),
             IHF.YEARMONTH,
             IHF.YEARMONTH,
             PS.division_name,
             PS.ACCOUNT_NUMBER_NK,
             PS.WAREHOUSE_NUMBER_NK,
             DECODE (PS.DIVISION_NAME,
                     'EAST REGION', 'BLENDED',
                     'WEST REGION', 'BLENDED',
                     'NORTH CENTRAL REGION', 'BLENDED',
                     'SOUTH CENTRAL REGION', 'BLENDED',
                     'INDUSTRIAL REGION', 'INDUSTRIAL',
                     'WATERWORKS REGION', 'WW',
                     'HVAC REGION', 'HVAC',
                     PS.DIVISION_NAME),
             DECODE (IHF.SALE_TYPE,
                     '1', 'Our Truck',
                     '2', 'Counter',
                     '3', 'Direct',
                     '4', 'Counter',
                     '5', 'Credit Memo',
                     '6', 'Showroom',
                     '7', 'Showroom Direct',
                     '8', 'eBusiness'));
                 
GRANT SELECT ON AAA6863.GP_TRACKER_FY16_17_KPI TO PUBLIC;