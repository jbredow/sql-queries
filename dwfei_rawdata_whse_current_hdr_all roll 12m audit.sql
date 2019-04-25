SELECT PS.DIVISION_NAME REGION,
       PS.REGION_NAME DISTRICT,
       PS.ACCOUNT_NUMBER_NK ACCT_NK,
       PS.ACCOUNT_NAME ACCT_NAME,
       ihf.WAREHOUSE_NUMBER WHSE,
       PS.WAREHOUSE_NAME WHSE_NAME,
       --MKT.AREA,
       --MKT.MARKET,
       BG_BUDG.BUSINESS_GROUP,
       SUM (ihf.SALES_SUBTOTAL_AMOUNT) ext_sales,             -- PRODUCT SALES
       SUM (ihf.TOTAL_SALES_AMOUNT) sls_total,           -- TOTAL HEADER SALES
       SUM (ihf.CORE_ADJ_AVG_COST) core_cost,
       SUM (ihf.AVG_COST_SUBTOTAL_AMOUNT) avg_cogs1,
       SUM (NVL (ihf.COST_SUBTOTAL_AMOUNT, '0')) actual_cogs,
       SUM (NVL (ihf.SALES_SUBTOTAL_AMOUNT, '0')) sls_subtotal,
       SUM (NVL (ihf.FREIGHT_SALES_AMOUNT, '0')) sls_freight,
       SUM (NVL (ihf.MISC_SALES_AMOUNT, '0')) sls_misc,
       SUM (NVL (ihf.RESTOCKING_SALES_AMOUNT, '0')) sls_restock,
       SUM (NVL (ihf.AVG_COST_SUBTOTAL_AMOUNT, '0')) avg_cost_subtotal,
       SUM (NVL (ihf.FREIGHT_COST_AMOUNT, '0')) avg_cost_freight,
       SUM (NVL (ihf.MISC_COST_AMOUNT, '0')) avg_cost_misc
FROM DW_FEI.INVOICE_HEADER_FACT ihf,
     DW_FEI.CUSTOMER_DIMENSION cust,
     SALES_MART.SALES_WAREHOUSE_DIM PS,
     SALES_MART.TIME_PERIOD_DIMENSION TPD,
     
     USER_SHARED.BG_CUSTTYPE_XREF BG_BUDG,
     PRICE_MGMT.LAKEWOOD_GKS
WHERE     ihf.CUSTOMER_ACCOUNT_GK = cust.CUSTOMER_GK
      AND TO_CHAR (ihf.WAREHOUSE_NUMBER) = TO_CHAR (ps.WAREHOUSE_NUMBER_NK)
      AND ihf.INVOICE_NUMBER_GK = LAKEWOOD_GKS.INVOICE_NUMBER_GK(+)
      AND ihf.YEARMONTH = TPD.YEARMONTH
     -- AND PS.ACCOUNT_NUMBER_NK = MKT.ACCOUNT_NUMBER_NK(+)
      AND TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
      -- EXCLUDES INTERCOMPANY
      AND ihf.IC_FLAG = 0
      AND ihf.PO_WAREHOUSE_NUMBER IS NULL
      -- EXCLUDE REPLENISHMENT CONSIGNMENT
      AND NVL (ihf.CONSIGN_TYPE, 'N') <> 'R'
      -- END USER CUSTOMERS ONLY
      AND (    cust.ar_gl_number NOT IN ('1320',
                                         '1360',
                                         '1380',
                                         '1400',
                                         '1401',
                                         '1500',
                                         '4000',
                                         
                                         '7100')
           AND cust.ar_gl_number IS NOT NULL)
      AND COALESCE (cust.BMI_BUDGET_CUST_TYPE,
                    cust.BMI_REPORT_CUST_TYPE,
                    cust.CUSTOMER_TYPE) =
          BG_BUDG.CUSTOMER_TYPE(+)
      AND LAKEWOOD_GKS.INVOICE_NUMBER_GK IS NULL
GROUP BY PS.DIVISION_NAME,
         PS.REGION_NAME,
         PS.ACCOUNT_NUMBER_NK,
         PS.ACCOUNT_NAME,
         ihf.WAREHOUSE_NUMBER,
         PS.WAREHOUSE_NAME,
         BG_BUDG.BUSINESS_GROUP--,
         --MKT.AREA,
         --MKT.MARKET