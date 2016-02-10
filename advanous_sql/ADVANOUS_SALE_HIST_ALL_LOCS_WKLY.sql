SELECT /*+PARALLEL */
    warehouse_dimension.account_number_nk,
    warehouse_dimension.warehouse_number_nk,
    customer_dimension.customer_nk,
    invoice_dimension.invoice_number_nk,
    invoice_line_fact.process_date,
    invoice_line_fact.invoice_line_number,
    invoice_header_fact.sale_type,
    product_dimension.product_nk,
    invoice_line_fact.shipped_qty,
    product_dimension.unit_of_measure,
    invoice_line_fact.unit_net_price_amount*invoice_line_fact.shipped_qty ext_sales_amt,
    invoice_line_fact.ext_sales_amount,
    invoice_line_fact.ext_avg_cogs_amount,
    invoice_line_fact.price_code,
    invoice_line_fact.price_formula,
    invoice_header_fact.writer,
    invoice_header_fact.CREDIT_MEMO_TYPE,
    invoice_line_fact.ext_actual_cogs_amount,
    invoice_header_fact.ref_bid_number,
    invoice_header_fact.channel_type,
    invoice_header_fact.ic_flag,
    invoice_header_fact.order_code,
    invoice_header_fact.contract_number,
    invoice_header_fact.contract_description,
    invoice_header_fact.restocking_sales_amount,
    invoice_header_fact.warehouse_number

FROM     dw_fei.invoice_header_fact invoice_header_fact,
       dw_fei.invoice_dimension ,
       dw_fei.invoice_line_fact,
       dw_fei.product_dimension ,
       dw_fei.special_product_dimension special_prod_dim,
       dw_fei.warehouse_dimension ,
       dw_fei.customer_dimension

/* Old Approach */
 --WHERE invoice_header_fact.yearmonth = (TO_NUMBER (TO_CHAR (TRUNC (SYSDATE), 'YYYYMM')))
 --AND invoice_header_fact.insert_timestamp BETWEEN  '2011-07-24 00:00:00' AND '2011-07-30 23:59:59'

/* Old commented constraints */
   --invoice_header_fact.YEARMONTH IN ('201106', '201107')
   --AND invoice_header_fact.PROCESS_DATE BETWEEN '2011-06-26 00:00:00' AND '2011-07-02 23:59:59'
   --invoice_header_fact.insert_timestamp BETWEEN  '2011-07-21 00:00:00' AND '2011-07-27 00:00:00'

/* New Approach - July 2011 */

Where invoice_header_fact.insert_timestamp >= trunc(sysdate - 21)

AND  invoice_header_fact.insert_timestamp < trunc(sysdate)

/*
Where invoice_header_fact.insert_timestamp >= '01/08/2012'
and invoice_header_fact.insert_timestamp < '01/15/2012'*/

 and ( invoice_header_fact.yearmonth = (select max_yearmonth from sales_mart.time_dim)
     or invoice_header_fact.yearmonth = (select prior_yearmonth from sales_mart.time_dim))

   AND invoice_dimension.invoice_number_gk = invoice_header_fact.invoice_number_gk
   AND invoice_dimension.invoice_number_gk = invoice_line_fact.invoice_number_gk
   AND invoice_line_fact.product_gk=product_dimension.product_gk (+)
   AND invoice_line_fact.special_product_gk = special_prod_dim.special_product_gk (+)
   AND customer_dimension.customer_gk = invoice_header_fact.customer_account_gk
   AND invoice_header_fact.ship_from_warehouse_gk = warehouse_dimension.warehouse_gk

--AND invoice_header_fact.insert_timestamp BETWEEN (TO_DATE (TO_CHAR (TRUNC (SYSDATE, 'DD') - 7, 'YYYY-MM-DD'))) AND (TO_DATE (TO_CHAR (TRUNC (SYSDATE, 'DD') - 1, 'YYYY-MM-DD')))
--AND warehouse_dimension.account_number_nk not in ('180', '209', '218', '39') --not needed
ORDER BY warehouse_dimension.account_number_nk,
         warehouse_dimension.warehouse_number_nk