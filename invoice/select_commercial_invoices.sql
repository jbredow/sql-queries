SELECT YEARMONTH,
       ACCOUNT_NUMBER,
       INVOICE_NUMBER_NK,
       SOURCE_SYSTEM,
       --SALES_SUBTOTAL_AMOUNT,
       --COST_SUBTOTAL_AMOUNT,
       --AVG_COST_SUBTOTAL_AMOUNT,
       ACCOUNT_NAME,
       CUSTOMER_NK,
       CUSTOMER_NAME,
       CUSTOMER_TYPE,
       PRICE_COLUMN,
       JOB_YN,
       INVOICE_LINE_NUMBER,
       --COMMENTS.COMMENT_DESCT,
       --COMMENTS.CTYPE,
       PRODUCT_NK,
       ALT1_CODE,
       PRODUCT_NAME,
       --ILF.INVOICE_LINE_NUMBER,
       --ILF.PRODUCT_NUMBER_NK,

       UNIT_INV_COST,
       MATRIX,
       EXT_AVG_COGS_AMOUNT,
       EXT_ACTUAL_COGS_AMOUNT,
       UNIT_NET_PRICE_AMOUNT,
       EXT_SALES_AMOUNT
  FROM (                                                      -- comment lines
         (SELECT IHF.YEARMONTH,
                 IHF.ACCOUNT_NUMBER,
                 IHF.INVOICE_NUMBER_NK,
                 IHF.SOURCE_SYSTEM,
                 --IHF.SALES_SUBTOTAL_AMOUNT,
                 --IHF.COST_SUBTOTAL_AMOUNT,
                 --IHF.AVG_COST_SUBTOTAL_AMOUNT,
                 CUST.ACCOUNT_NAME,
                 CUST.CUSTOMER_NK,
                 CUST.CUSTOMER_NAME,
                 CUST.CUSTOMER_TYPE,
                 CUST.PRICE_COLUMN,
                 CUST.JOB_YN,
                 COMMENTS.INVOICE_LINE_NUMBER,
                 COMMENTS.COMMENT_DESCT PRODUCT_NK,
                 COMMENTS.CTYPE ALT1_CODE,
                 COMMENTS.INVOICE_COMMENT PRODUCT_NAME,
                 --ILF.INVOICE_LINE_NUMBER,
                 --ILF.PRODUCT_NUMBER_NK,
                 NULL UNIT_INV_COST,
                 NULL MATRIX,
                 NULL EXT_AVG_COGS_AMOUNT,
                 NULL EXT_ACTUAL_COGS_AMOUNT,
                 NULL UNIT_NET_PRICE_AMOUNT,
                 NULL EXT_SALES_AMOUNT
            FROM DW_FEI.INVOICE_HEADER_FACT IHF
                 --INNER JOIN DW_FEI.INVOICE_LINE_FACT INVOICE_LINE_FACT
                 --ON (IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK))
                 INNER JOIN DW_FEI.INVOICE_COMMENTS COMMENTS
                    ON (IHF.INVOICE_NUMBER_GK = COMMENTS.INVOICE_NUMBER_GK)
                 INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                    ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK)
           WHERE     IHF.YEARMONTH = 201412
                 AND IHF.ACCOUNT_NUMBER = '20'
                 AND COMMENTS.INVOICE_COMMENT LIKE '%-%'
                 AND REGEXP_LIKE ( COMMENTS.INVOICE_COMMENT, '[A-Z]-[1-9]' )
                 AND COMMENTS.COMMENT_DESCT <> 'OEA'
                 AND COMMENTS.INVOICE_COMMENT NOT LIKE '%PO%'
                 AND COMMENTS.INVOICE_COMMENT NOT LIKE '%PH%'
                 AND CUST.PRICE_COLUMN IN ('070', '071', '073'))
        UNION
        -- invoice lines
        (SELECT DISTINCT IHF.YEARMONTH,
                         IHF.ACCOUNT_NUMBER,
                         IHF.INVOICE_NUMBER_NK,
                         IHF.SOURCE_SYSTEM,
                         --IHF.SALES_SUBTOTAL_AMOUNT,
                         --IHF.COST_SUBTOTAL_AMOUNT,
                         --IHF.AVG_COST_SUBTOTAL_AMOUNT,
                         CUST.ACCOUNT_NAME,
                         CUST.CUSTOMER_NK,
                         CUST.CUSTOMER_NAME,
                         CUST.CUSTOMER_TYPE,
                         CUST.PRICE_COLUMN,
                         CUST.JOB_YN,
                         --COMMENTS.INVOICE_LINE_NUMBER,
                         --COMMENTS.COMMENT_DESCT,
                         --COMMENTS.CTYPE,
                         --COMMENTS.INVOICE_COMMENT,
                         ILF.INVOICE_LINE_NUMBER,
                         ILF.PRODUCT_NUMBER_NK PRODUCT_NK,
                         PROD.ALT1_CODE,
                         PROD.PRODUCT_NAME,
                         ILF.UNIT_INV_COST,
                         ILF.MATRIX,
                         ILF.EXT_AVG_COGS_AMOUNT,
                         ILF.EXT_ACTUAL_COGS_AMOUNT,
                         ILF.UNIT_NET_PRICE_AMOUNT,
                         ILF.EXT_SALES_AMOUNT
           FROM DW_FEI.INVOICE_HEADER_FACT IHF
                INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
                   ON (IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK)
                INNER JOIN DW_FEI.INVOICE_COMMENTS COMMENTS
                   ON (IHF.INVOICE_NUMBER_GK = COMMENTS.INVOICE_NUMBER_GK)
                INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                   ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK)
                INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
                   ON (ILF.PRODUCT_GK = PROD.PRODUCT_GK)
          WHERE     IHF.YEARMONTH = 201412
                AND IHF.ACCOUNT_NUMBER = '20'
                AND COMMENTS.INVOICE_COMMENT LIKE '%-%'
                AND REGEXP_LIKE ( COMMENTS.INVOICE_COMMENT, '[A-Z]-[1-9]' )
                AND COMMENTS.COMMENT_DESCT <> 'OEA'
                AND COMMENTS.INVOICE_COMMENT NOT LIKE '%PO%'
                AND COMMENTS.INVOICE_COMMENT NOT LIKE '%PH%'
                AND CUST.PRICE_COLUMN IN ('070', '071', '073'))) X
ORDER BY X.INVOICE_NUMBER_NK ASC, X.INVOICE_LINE_NUMBER ASC