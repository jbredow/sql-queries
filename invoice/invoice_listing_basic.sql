SELECT ihf.YEARMONTH,
       swd.ACCOUNT_NAME,
       ihf.WAREHOUSE_NUMBER,
       ihf.ACCOUNT_NUMBER,
       ihf.ORDER_ENTRY_DATE,
       ihf.REF_BID_NUMBER,
       ihf.ORDER_CODE,
       ihf.MEMO,
       ihf.OML_ASSOC_NAME,
       ihf.APPROVER_NAME,
       ihf.SOURCE_ORDER,
       ihf.SALE_TYPE,
       ihf.PO_NUMBER,
       ihf.CHANNEL_TYPE,
       ihf.SHIP_VIA_NAME,
       ihf.IC_FLAG,
       ihf.EDI_FLAG,
       ihf.CREDIT_MEMO_TYPE,
       ihf.MISC_SALES_AMOUNT,
       ihf.MISC_COST_AMOUNT,
       ihf.SALES_SUBTOTAL_AMOUNT,
       ihf.TOTAL_SALES_AMOUNT,
       ihf.PROCESS_DATE,
       ihf.WRITER,
       ihf.SOURCE_SYSTEM,
       ihf.INVOICE_NUMBER_NK,
       ihf.CUSTOMER_NUMBER_NK
FROM   DW_FEI.INVOICE_HEADER_FACT ihf
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM swd
       ON (ihf.WAREHOUSE_NUMBER = swd.WAREHOUSE_NUMBER_NK)
WHERE     (ihf.YEARMONTH = 201308)
       AND (swd.ACCOUNT_NAME = 'VEGASWW')
       AND (ihf.MISC_SALES_AMOUNT <> 0)
