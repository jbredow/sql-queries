SELECT SWD.DIVISION_NAME REGION,
       IHF.YEARMONTH,
       SWD.REGION_NAME DISTRICT,
       IHF.ACCOUNT_NUMBER ACCT_NO,
       CUST.ACCOUNT_NAME ACCT_NAME,
       IHF.WAREHOUSE_NUMBER WH_NO,
       IHF.INVOICE_NUMBER_NK INV_NO,
       DECODE (ihf.SALE_TYPE,
               '1',
               'Our Truck',
               '2',
               'Counter',
               '3',
               'Direct',
               '4',
               'Counter',
               '5',
               'Credit Memo',
               '6',
               'Showroom',
               '7',
               'Showroom Direct',
               '8',
               'eBusiness'
       )
          TYPE_OF_SALE,
       NVL (IHF.WRITER, IHF.OML_ASSOC_INI) WRITER,
       CASE
          WHEN NVL (IHF.WRITER, IHF.OML_ASSOC_INI) = IHF.OML_ASSOC_INI
          THEN
             IHF.OML_ASSOC_NAME
          WHEN SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), 0, 1)
               || SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), -1) =
                  SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
                  || SUBSTR (IHF.OML_ASSOC_INI, -1)
          THEN
             IHF.OML_ASSOC_NAME
          ELSE
             NULL
       END
          ASSOC_NAME,
       CASE
          WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.PRODUCT_NK
          ELSE SP_PROD.SPECIAL_PRODUCT_NK
       END
          AS PRODUCT_NK,
       CASE
          WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.ALT1_CODE
          ELSE SP_PROD.ALT_CODE
       END
          AS ALT1_CODE,
       CASE
          WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.DISCOUNT_GROUP_NK
          ELSE SP_PROD.SPECIAL_DISC_GROUP
       END
          AS DISCOUNT_GROUP_NK DG,
       CASE
          WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.PRODUCT_NAME
          ELSE SP_PROD.SPECIAL_PRODUCT_NAME
       END
          AS PRODUCT_NAME,
       CASE
          WHEN ILF.PRODUCT_GK IS NOT NULL
          THEN
             NVL (ILF.PRODUCT_STATUS, 'STOCK')
          ELSE
             'SP-'
       END
          AS ST,
       CASE WHEN ILF.EXT_SALES_AMOUNT <= 1500 THEN 'Y' ELSE 'N' END "<1500",
       PROD.UNIT_OF_MEASURE UM,
       ILF.SHIPPED_QTY,
       ILF.EXT_AVG_COGS_AMOUNT,
       ILF.EXT_SALES_AMOUNT,
       
      (ILF.EXT_SALES_AMOUNT-ILF.EXT_AVG_COGS_AMOUNT)
      / CASE
          WHEN ILF.EXT_SALES_AMOUNT > 0
          THEN ILF.EXT_SALES_AMOUNT
          ELSE
            1
        END
           GPP,
       
       CASE
          WHEN ihf.order_code = 'IC'
          THEN
             'CREDITS'
          WHEN ilf.special_product_gk IS NOT NULL
          THEN
             'SPECIALS'
          WHEN ilf.price_code = 'Q'
          THEN
             CASE
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX_PRICE
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                        (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC (ilf.MATRIX, 2) + .01)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND (ilf.MATRIX_PRICE, 2))
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND (ilf.MATRIX, 2))
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                        (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC (ilf.MATRIX, 1) + .1)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX_PRICE) + 1
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX) + 1
                THEN
                   'MATRIX'
                ELSE
                   'MANUAL'
             END
          WHEN REGEXP_LIKE (ilf.price_code, '[0-9]?[0-9]?[0-9]')
          THEN
             'MATRIX'
          WHEN ilf.price_code IN ('FC', 'PM', 'spec')
          THEN
             'MATRIX'
          WHEN ilf.price_code = 'T'
          THEN
             'MATRIX'
          WHEN ilf.price_code LIKE 'M%'
          THEN
             'MATRIX'
          WHEN ilf.price_formula IN ('CPA', 'CPO')
          THEN
             'OVERRIDE'
          WHEN ilf.price_code IN
                     ('PR',
                      'GR',
                      'CB',
                      'GJ',
                      'PJ',
                      '*G',
                      '*P',
                      'G*',
                      'P*',
                      'G',
                      'GJ',
                      'P')
          THEN
             'OVERRIDE'
          WHEN ilf.price_code IN ('GI', 'GPC', 'HPF', 'HPN', 'NC')
          THEN
             'MANUAL'
          WHEN ilf.price_code = '*E'
          THEN
             'MANUAL'
          WHEN ilf.price_code = 'SKC'
          THEN
             'MANUAL'
          WHEN ilf.price_code IN ('%', '$', 'N', 'F', 'B', 'PO')
          THEN
             'MANUAL'
          WHEN ilf.price_code IS NULL
          THEN
             'MANUAL'
          WHEN ilf.price_code IN ('R', 'N/A')
          THEN
             CASE
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX_PRICE
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                        (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC (ilf.MATRIX, 2) + .01)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND (ilf.MATRIX_PRICE, 2))
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND (ilf.MATRIX, 2))
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                        (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC (ilf.MATRIX, 1) + .1)
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX_PRICE) + 1
                THEN
                   'MATRIX'
                WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX) + 1
                THEN
                   'MATRIX'
                ELSE
                   'MANUAL'
             END
          ELSE
             'MANUAL'
       END
          AS PRICE_CATEGORY,
       ILF.PRICE_CODE,
       ILF.PRICE_FORMULA,
       --ILF.ORDER_ENTRY_DATE,
       IHF.INVOICE_DATE,
       --IHF.APPROVAL_DATE,
       --IHF.CAP_DATE_TIME,
       --IHF.ENTRY_DATE,
       --IHF.ORDER_ENTRY_DATE,
       IHF.PROCESS_DATE,
       --IHF.UPDATE_TIMESTAMP,
       ILF.PRODUCT_STATUS,
       CUST.MAIN_CUSTOMER_NK,
       CUST.JOB_YN,
       CUST.CUSTOMER_NK,
       CUST.CUSTOMER_NAME,
       CUST.PRICE_COLUMN,
       CUST.CUSTOMER_TYPE
  FROM DW_FEI.INVOICE_HEADER_FACT IHF,
       DW_FEI.INVOICE_LINE_FACT ILF,
       DW_FEI.PRODUCT_DIMENSION PROD,
       DW_FEI.CUSTOMER_DIMENSION CUST,
       DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD,
       EBUSINESS.SALES_DIVISIONS SWD
 WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
       AND ILF.PRODUCT_STATUS = 'SP'
       AND IHF.ACCOUNT_NUMBER = '107'
       AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
       AND DECODE (NVL (cust.ar_gl_number, '9999'),
             '1320', 0,
             '1360', 0,
             '1380', 0,
             '1400', 0,
             '1401', 0,
             '1500', 0,
             '4000', 0,
             '7100', 0,
             '9999', 0,
             1) <> 0
       AND IHF.ACCOUNT_NUMBER = SWD.ACCOUNT_NUMBER_NK
       AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
       AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
       AND ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK(+)
       AND IHF.IC_FLAG = 0
       AND ILF.SHIPPED_QTY <> 0
       AND IHF.PO_WAREHOUSE_NUMBER IS NULL
       /*AND IHF.YEARMONTH = '201712'
                AND ILF.YEARMONTH = '201712'*/

        AND IHF.PROCESS_DATE BETWEEN TRUNC (TO_DATE ('01-AUG-17'), 'DDD')
                                AND  TRUNC (TO_DATE ('31-JUL-18'), 'DDD')
        
        AND IHF.PROCESS_DATE BETWEEN TRUNC (TO_DATE ('01-AUG-17'), 'DDD')
                                AND  TRUNC (TO_DATE ('31-JUL-18'), 'DDD')

;