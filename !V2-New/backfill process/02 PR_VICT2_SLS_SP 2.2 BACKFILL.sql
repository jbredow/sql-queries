INSERT INTO PRICE_MGMT.PR_VICT2_SLS
   SELECT IHF.YEARMONTH,
          IHF.EOM_YEARMONTH,
          IHF.ACCOUNT_NUMBER,
          CUST.ACCOUNT_NAME,
          IHF.WAREHOUSE_NUMBER,
          IHF.INVOICE_NUMBER_NK,
          IHF.INVOICE_NUMBER_GK,
          IHF.JOB_NAME,
          IHF.CONTRACT_DESCRIPTION,
          IHF.CONTRACT_NUMBER,
          IHF.OML_ASSOC_NAME,
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
          IHF.CHANNEL_TYPE,
          CHAN.ORDER_CHANNEL,
          CHAN.DELIVERY_CHANNEL,
          IHF.SHIP_VIA_NAME,
          NVL (IHF.WRITER, IHF.OML_ASSOC_INI)
             WRITER,
             SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), 0, 1)
          || SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), -1)
             WR_FL_INI,
          IHF.OML_ASSOC_INI,
          SUBSTR (IHF.OML_ASSOC_INI, 0, 1) || SUBSTR (IHF.OML_ASSOC_INI, -1)
             OML_FL_INI,
          CASE
             WHEN NVL (IHF.WRITER, IHF.OML_ASSOC_INI) = IHF.OML_ASSOC_INI
             THEN
                IHF.OML_ASSOC_NAME
             WHEN    SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), 0, 1)
                  || SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), -1) =
                     SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
                  || SUBSTR (IHF.OML_ASSOC_INI, -1)
             THEN
                IHF.OML_ASSOC_NAME
             ELSE
                NULL
          END
             ASSOC_NAME,
          ILF.INVOICE_LINE_NUMBER,
          SP_PROD.PRIMARY_VNDR
             AS MANUFACTURER,
          SP_PROD.SPECIAL_PRODUCT_NK
             AS PRODUCT_NK,
          SP_PROD.ALT_CODE
             AS ALT1_CODE,
          SP_PROD.SPECIAL_DISC_GROUP
             AS DISCOUNT_GROUP_NK,
          SP_PROD.SPECIAL_LINE
             AS LINEBUY_NK,
          SP_PROD.SPECIAL_PRODUCT_NAME
             AS PRODUCT_NAME,
          'SP-'
             AS STATUS,
          CASE WHEN ILF.EXT_SALES_AMOUNT <= 1500 THEN 'Y' ELSE 'N' END
             "<1500",
          SP_PROD.UNIT_OF_MEASURE
             UM,
          SP_PROD.SELL_PACKAGE_QTY
             SELL_MULT,
          SP_PROD.SELL_PACKAGE_QTY
             PACK_QTY,
          ILF.SHIPPED_QTY,
          ILF.EXT_AVG_COGS_AMOUNT,
          ILF.CORE_ADJ_AVG_COST,
          ILF.EXT_SALES_AMOUNT,
          ILF.EXT_WEIGHT_LB,
          ILF.EXT_ACTUAL_COGS_AMOUNT,
          CASE WHEN ihf.order_code = 'IC' THEN 'CREDITS' ELSE 'SPECIALS' END
             AS PRICE_CATEGORY,
          ILF.PRICE_CODE,
          ILF.ORIG_PRICE_CODE,
          ILF.PRICE_FORMULA,
          ILF.UNIT_NET_PRICE_AMOUNT,
          ILF.UNIT_INV_COST,
          ILF.REPLACEMENT_COST,
          ILF.LIST_PRICE,
          --ILCF.COST_CODE_IND,
          ILF.ORDER_ENTRY_DATE,
          ILF.PO_COST,
          ILF.PO_DATE,
          ILF.PO_NUMBER_NK,
          ILF.PROCESS_DATE,
          ILF.PRODUCT_STATUS,
          ILF.MATRIX,
          ILF.MATRIX_PRICE
             OG_MATRIX,
          NVL (ILF.MATRIX_PRICE, ILF.MATRIX)
             MATRIX_PRICE,
          IHF.CONSIGN_TYPE,
          IHF.ORDER_CODE,
          IHF.CREDIT_CODE,
          IHF.CREDIT_MEMO_TYPE,
          IHF.PO_NUMBER,
          IHF.REF_BID_NUMBER,
          IHF.SOURCE_ORDER,
          IHF.COPY_SOURCE_HIST,
          IHF.SOURCE_SYSTEM,
          IHF.CUSTOMER_ACCOUNT_GK,
          ILF.BUILDER_REBATE,
          ILF.COST_REBATE,
          CUST.MAIN_CUSTOMER_NK,
          CUST.JOB_YN,
          CUST.CUSTOMER_NK,
          CUST.CUSTOMER_NAME,
          CUST.PRICE_COLUMN,
          CUST.CUSTOMER_TYPE,
          IHF.INVOICE_DATE,
          ILF.PRODUCT_GK,
          ILF.SPECIAL_PRODUCT_GK,
          REPS.SALESREP_NK,
          REPS.SALESREP_NAME,
          IHF.INSERT_TIMESTAMP    --,
          --IHF.PROCESS_DATE,
          --ILF.ORIG_PRICE_CODE
   FROM DW_FEI.INVOICE_HEADER_FACT IHF,
        DW_FEI.INVOICE_LINE_FACT ILF,
        --DW_FEI.PRODUCT_DIMENSION PROD,
        DW_FEI.CUSTOMER_DIMENSION CUST,
        DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD,
        SALES_MART.SALES_WAREHOUSE_DIM SWD,
        DW_FEI.SALESREP_DIMENSION REPS,
        SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN,
        PRICE_MGMT.MISSING_INVOICES MI
   --DW_FEI.INVOICE_LINE_CORE_FACT ILCF
   WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
         AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
         AND SWD.WAREHOUSE_NUMBER_NK = IHF.WAREHOUSE_NUMBER
         AND IHF.SALESREP_GK = REPS.SALESREP_GK
         AND IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK
          AND IHF.INVOICE_NUMBER_GK = MI.INVOICE_NUMBER_GK
         AND ILF.INVOICE_LINE_NUMBER = MI.INVOICE_LINE_NUMBER
         AND (DECODE (NVL (cust.ar_gl_number, '9999'),
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
              0)
         AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
         --AND ILF.PRODUCT_GK = PROD.PRODUCT_GK
         AND ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK
         AND IHF.IC_FLAG = 0
         AND IHF.PO_WAREHOUSE_NUMBER IS NULL
         --AND IHF.ACCOUNT_NUMBER = 5
         --AND IHF.WAREHOUSE_NUMBER = 4
         --AND (TRUNC (IHF.INVOICE_DATE) >= (SYSDATE - 8))
;

--COMMIT;