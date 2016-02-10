SELECT SUBSTR (ihf.YEARMONTH, 0, 4) YYYY,
           --ihf.YEARMONTH,
           ps.REGION,
           ps.ACCOUNT_NUMBER_NK ACCOUNT_NUMBER,
           --cust.MAIN_CUSTOMER_NK,
           --cust.CUSTOMER_NAME,
           --MIN (ihf.YEARMONTH) BEGIN_MM,
           --MAX (ihf.YEARMONTH) END_MM,
           DECODE (ps.KIND_OF_BUSINESS,
                   'PLB', 'PLBG',
                   'HFMB', 'PLBG',
                   ps.KIND_OF_BUSINESS)
              KOB,
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
           (0) invoice_lines,
           SUM (NVL (ihf.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cogs,
           SUM (NVL (ihf.COST_SUBTOTAL_AMOUNT, '0')) actual_cogs,
           SUM (ihf.SALES_SUBTOTAL_AMOUNT) ext_sales,
           'Total' AS PRICE_CATEGORY,
           'Total' AS ROLLUP,
           SUM (ihf.TOTAL_SALES_AMOUNT) sls_total,
           SUM (NVL (ihf.SALES_SUBTOTAL_AMOUNT, '0')) sls_subtotal,
           SUM (NVL (ihf.FREIGHT_SALES_AMOUNT, '0')) sls_freight,
           SUM (NVL (ihf.MISC_SALES_AMOUNT, '0')) sls_misc,
           SUM (NVL (ihf.RESTOCKING_SALES_AMOUNT, '0')) sls_restock,
           SUM (NVL (ihf.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cost_subtotal,
           SUM (NVL (ihf.FREIGHT_COST_AMOUNT, '0')) avg_cost_freight,
           SUM (NVL (ihf.MISC_COST_AMOUNT, '0')) avg_cost_misc
      FROM DW_FEI.INVOICE_HEADER_FACT ihf,
           DW_FEI.CUSTOMER_DIMENSION cust,
           SCORECARD1.PS_HIERARCHY ps
		
	
	
	where sale type = 2 or 4