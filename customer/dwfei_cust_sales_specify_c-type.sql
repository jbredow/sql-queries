
   (SELECT SUBSTR (ihf.YEARMONTH, 0, 4) YYYY,
           ihf.YEARMONTH,
           ps.REGION_NAME,
           ps.DIVISION_NAME,
           ps.ACCOUNT_NUMBER_NK ACCOUNT_NUMBER,
           ihf.WAREHOUSE_NUMBER,
           cust.MAIN_CUSTOMER_NK,
           cust.CUSTOMER_NK,
           cust.CUSTOMER_NAME,
           cust.PRICE_COLUMN,
           cust.CUSTOMER_TYPE,
		   DECODE (ihf.SALE_TYPE,
                  '1', 'Our Truck',
                  '2', 'Counter',
                  '3', 'Direct',
                  '4', 'Counter',
                  '5', 'Credit Memo',
                  '6', 'Showroom',
                  '7', 'Showroom Direct',
                  '8', 'eBusiness')
             TYPE_OF_SALE,
           SUM (NVL (ihf.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cogs,
           SUM (NVL (ihf.COST_SUBTOTAL_AMOUNT, '0')) actual_cogs,
           SUM (NVL (ihf.SALES_SUBTOTAL_AMOUNT, '0')) ext_sales,
           SUM (NVL (ihf.TOTAL_SALES_AMOUNT, '0')) sls_total/*,
           SUM (NVL (ihf.MISC_SALES_AMOUNT, '0')) sls_misc,
           SUM (NVL (ihf.RESTOCKING_SALES_AMOUNT, '0')) sls_restock,
           SUM (NVL (ihf.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cost_subtotal,
           SUM (NVL (ihf.FREIGHT_COST_AMOUNT, '0')) avg_cost_freight,
           SUM (NVL (ihf.MISC_COST_AMOUNT, '0')) avg_cost_misc*/
      FROM DW_FEI.INVOICE_HEADER_FACT ihf,
           DW_FEI.CUSTOMER_DIMENSION cust,
           SALES_MART.SALES_WAREHOUSE_DIM ps
     WHERE     ihf.CUSTOMER_ACCOUNT_GK = cust.CUSTOMER_GK
           AND ihf.ACCOUNT_NUMBER = 13 
           --specifyy customer types in single quote separated by comma
		   AND cust.CUSTOMER_TYPE LIKE ('B_%') 
           AND (ihf.WAREHOUSE_NUMBER) = (ps.WAREHOUSE_NUMBER_NK)
           AND ihf.IC_FLAG = 0
           AND ihf.PO_WAREHOUSE_NUMBER IS NULL
           AND NVL (ihf.CONSIGN_TYPE, 'N') <> 'R'
           AND IHF.YEARMONTH BETWEEN --201210 and 201309 --set date range
								TO_CHAR (
                                        TRUNC (
                                           SYSDATE
                                           - NUMTOYMINTERVAL (13, 'MONTH'),
                                           'MONTH'),
                                        'YYYYMM')
                                 AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                              'YYYYMM')
           AND (cust.ar_gl_number NOT IN
                   ('1320',
                    '1360',
                    '1380',
                    '1400',
                    '1401',
                    '1500',
                    '4000',
                    '7100')
                AND cust.ar_gl_number IS NOT NULL)
    GROUP BY SUBSTR (ihf.YEARMONTH, 0, 4),
             ihf.YEARMONTH,
             ps.REGION_NAME,
             ps.DIVISION_NAME,
             ps.ACCOUNT_NUMBER_NK,
             ihf.WAREHOUSE_NUMBER,
             cust.MAIN_CUSTOMER_NK,
             cust.CUSTOMER_NK,
             cust.CUSTOMER_NAME,
             cust.PRICE_COLUMN,
             cust.CUSTOMER_TYPE,
			 
             DECODE (ihf.SALE_TYPE,
                      '1', 'Our Truck',
                      '2', 'Counter',
                      '3', 'Direct',
                      '4', 'Counter',
                      '5', 'Credit Memo',
                      '6', 'Showroom',
                      '7', 'Showroom Direct',
                      '8', 'eBusiness'));