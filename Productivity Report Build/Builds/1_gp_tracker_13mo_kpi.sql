TRUNCATE TABLE AAA6863.GP_TRACKER_KPI_12MO;
DROP TABLE AAA6863.GP_TRACKER_KPI_12MO;

CREATE TABLE AAA6863.GP_TRACKER_KPI_12MO
NOLOGGING
--24 Month KPI Reporting
AS
   (SELECT SUBSTR (IHF.YEARMONTH, 0, 4)
              YYYY,
           IHF.YEARMONTH,
           IHF.YEARMONTH AS ROLLING_QTR,
           PS.DIVISION_NAME AS REGION,
           PS.ACCOUNT_NUMBER_NK AS ACCOUNT_NUMBER,
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
           --TO_CHAR((0) PRICE_CODE) PRICE_CODE,
           (0) INVOICE_LINES,
           SUM (NVL (IHF.AVG_COST_SUBTOTAL_AMOUNT, '0'))
              AVG_COGS,
           SUM (NVL (IHF.COST_SUBTOTAL_AMOUNT, '0'))
              ACTUAL_COGS,
           SUM (IHF.SALES_SUBTOTAL_AMOUNT)
              EXT_SALES,
           'Total'
              AS PRICE_CATEGORY,
           'Total'
              AS ROLLUP,
           SUM (IHF.TOTAL_SALES_AMOUNT)
              SLS_TOTAL,
           SUM (NVL (IHF.SALES_SUBTOTAL_AMOUNT, '0'))
              SLS_SUBTOTAL,
           SUM (NVL (IHF.FREIGHT_SALES_AMOUNT, '0'))
              SLS_FREIGHT,
           SUM (NVL (IHF.MISC_SALES_AMOUNT, '0'))
              SLS_MISC,
           SUM (NVL (IHF.RESTOCKING_SALES_AMOUNT, '0'))
              SLS_RESTOCK,
           SUM (NVL (IHF.AVG_COST_SUBTOTAL_AMOUNT, '0'))
              AVG_COST_SUBTOTAL,
           SUM (NVL (IHF.FREIGHT_COST_AMOUNT, '0'))
              AVG_COST_FREIGHT,
           SUM (NVL (IHF.MISC_COST_AMOUNT, '0'))
              AVG_COST_MISC
    FROM DW_FEI.INVOICE_HEADER_FACT IHF,
         DW_FEI.CUSTOMER_DIMENSION CUST,
         SALES_MART.SALES_WAREHOUSE_DIM PS
    WHERE     IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
          AND TO_CHAR (IHF.WAREHOUSE_NUMBER) =
              TO_CHAR (PS.WAREHOUSE_NUMBER_NK)
          AND IHF.IC_FLAG = 0
          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
          AND NVL (IHF.CONSIGN_TYPE, 'N') <> 'R'
          --AND IHF.YEARMONTH BETWEEN '201508' AND '201804'
          AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                       TRUNC (
                                            SYSDATE
                                          - NUMTOYMINTERVAL (24, 'MONTH'),
                                          'MONTH'),
                                       'YYYYMM')
                                AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                             'YYYYMM')
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
                      1) <>
              0
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

GRANT SELECT ON AAA6863.GP_TRACKER_KPI_12MO TO PUBLIC;