/* Formatted on 3/31/2015 12:58:47 PM (QP5 v5.139.911.3011) 
 Sends data to Advanous for last 12 months */

  SELECT account_number account_number_nk,
         SUM (sales_subtotal_amount - NVL (restocking_sales_amount, 0))
            ext_sales_amt,
         SUM (cost_subtotal_amount) ext_actual_cogs_amount,
         SUM (avg_cost_subtotal_amount) ext_avg_cogs_amount
    FROM dw_fei.invoice_header_fact invoice_header_fact
   WHERE invoice_header_fact.yearmonth BETWEEN (TO_NUMBER (
                                                   TO_CHAR (
                                                      TRUNC (SYSDATE - 366),
                                                      'YYYYMM')))
                                           AND (TO_NUMBER (
                                                   TO_CHAR (
                                                      TRUNC (SYSDATE, 'MM') - 1,
                                                      'YYYYMM')))
GROUP BY account_number
ORDER BY account_number



/*
SELECT   account_number_nk,
         SUM (ext_sales_amount) ext_sales_amt,
         SUM (ext_actual_cogs_amount) ext_actual_cogs_amount,
         SUM (ext_avg_cogs_amount) ext_avg_cogs_amount
FROM (SELECT /*+PARALLEL */ /*
         warehouse_dimension.account_number_nk,
         warehouse_dimension.warehouse_number_nk,
         customer_dimension.customer_nk,
         invoice_dimension.invoice_number_nk,
         invoice_line_fact.process_date,
         invoice_line_fact.invoice_line_number,
         invoice_header_fact.sale_type,
      product_dimension.product_nk,
         special_prod_dim.special_product_nk,
         invoice_line_fact.shipped_qty,
         product_dimension.unit_of_measure,
         product_dimension.sell_package_qty,
         invoice_line_fact.unit_net_price_amount,
         invoice_line_fact.ext_sales_amount,
         invoice_line_fact.ext_avg_cogs_amount,
         invoice_line_fact.ext_actual_cogs_amount,
         invoice_line_fact.price_code,
         invoice_line_fact.price_formula,
      invoice_header_fact.writer,
         invoice_header_fact.credit_memo_type,
      invoice_header_fact.sales_tax_amount,
      invoice_header_fact.freight_sales_amount,
      invoice_header_fact.freight_cost_amount,
      invoice_header_fact.handling_sales_amount,
      invoice_header_fact.misc_sales_amount,
      invoice_header_fact.misc_cost_amount,
      invoice_header_fact.lost_sales_amount,
      invoice_header_fact.restocking_sales_amount
    FROM dw_fei.invoice_header_fact invoice_header_fact,
         dw_fei.invoice_dimension,
            dw_fei.invoice_line_fact,
            dw_fei.product_dimension,
            dw_fei.special_product_dimension special_prod_dim,
            dw_fei.warehouse_dimension,
            dw_fei.customer_dimension
       WHERE invoice_header_fact.yearmonth BETWEEN (TO_NUMBER(TO_CHAR(TRUNC(SYSDATE - 366), 'YYYYMM'))) AND (TO_NUMBER (TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')))
             AND invoice_dimension.invoice_number_gk = invoice_header_fact.invoice_number_gk
             AND invoice_dimension.invoice_number_gk = invoice_line_fact.invoice_number_gk
             AND invoice_line_fact.product_gk = product_dimension.product_gk(+)
             AND invoice_line_fact.special_product_gk = special_prod_dim.special_product_gk(+)
             AND customer_dimension.customer_gk = invoice_header_fact.customer_account_gk
             AND invoice_header_fact.ship_from_warehouse_gk = warehouse_dimension.warehouse_gk)
GROUP BY account_number_nk
ORDER BY account_number_nk

*/