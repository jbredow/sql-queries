/* Formatted on 3/31/2015 2:45:21 PM (QP5 v5.139.911.3011) */
  SELECT                                                         /*PARALLEL */
        swd.WAREHOUSE_NUMBER_NK,
         swd.WAREHOUSE_NAME,
         swd.ACCOUNT_NUMBER_NK,
         swd.ACCOUNT_NAME,
         swd.REGION_NAME
    FROM SALES_MART.SALES_WAREHOUSE_DIM swd,
         (  SELECT                                                /*PARALLEL*/
                  a.WAREHOUSE_NUMBER_NK, COUNT (invoice_number_gk)
              FROM DW_FEI.INVOICE_HEADER_FACT, DW_FEI.WAREHOUSE_DIMENSION a
             WHERE SHIP_FROM_WAREHOUSE_GK = WAREHOUSE_GK
                   AND (invoice_header_fact.yearmonth =
                           (  SELECT max_yearmonth FROM sales_mart.time_dim)
                        OR invoice_header_fact.yearmonth =
                              (  SELECT prior_yearmonth FROM sales_mart.time_dim))
                   AND IC_FLAG = 0
          GROUP BY a.warehouse_number_nk) sub1
   WHERE swd.warehouse_number_nk = sub1.warehouse_number_nk
ORDER BY WAREHOUSE_NUMBER_NK, ACCOUNT_NUMBER_NK