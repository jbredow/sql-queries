-- move to price_mgmt
CREATE TABLE PRICE_MGMT.PR_PRICE_CAT_NOT_CCOR
NOLOGGING
AS
   (SELECT ihf.YEARMONTH,
           ilf.INVOICE_NUMBER_GK,
           ilf.PRICE_CODE,
           ilf.ORIG_PRICE_CODE,
           ilf.INVOICE_LINE_NUMBER,
           ilf.PRODUCT_GK,
           ilf.SPECIAL_PRODUCT_GK,
           ilf.EXT_AVG_COGS_AMOUNT,
           ilf.CORE_ADJ_AVG_COST,
           ilf.EXT_ACTUAL_COGS_AMOUNT,
           ilf.EXT_SALES_AMOUNT,
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
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         ROUND (ilf.MATRIX_PRICE, 2)
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT = ROUND (ilf.MATRIX, 2)
                    THEN
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX, 2) + .01)
                    THEN
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX, 1) + .1)
                    THEN
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         FLOOR (ilf.MATRIX_PRICE) + 1
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX) + 1
                    THEN
                       'MATRIX_BID'
                    ELSE
                       'QUOTE'
                 END
              WHEN REGEXP_LIKE (ilf.price_code, '[0-9]?[0-9]?[0-9]')
              THEN
                 'MATRIX'
              WHEN ilf.price_code IN ('FC', 'PM')
              THEN
                 'MATRIX'
              WHEN ilf.price_code LIKE 'M%'
              THEN
                 'MATRIX'
              WHEN ilf.price_formula IN ('CPA', 'CPO')
              THEN
                 'OVERRIDE'
              WHEN ilf.price_code IN ('PR',
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
              WHEN ilf.price_code IN ('GI',
                                      'GPC',
                                      'HPF',
                                      'HPN',
                                      'NC')
              THEN
                 'MANUAL'
              WHEN ilf.price_code = '*E'
              THEN
                 'OTH/ERROR'
              WHEN ilf.price_code = 'SKC'
              THEN
                 'OTH/ERROR'
              WHEN ilf.price_code IN ('%',
                                      '$',
                                      'N',
                                      'F',
                                      'B',
                                      'PO')
              THEN
                 'TOOLS'
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
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         ROUND (ilf.MATRIX_PRICE, 2)
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT = ROUND (ilf.MATRIX, 2)
                    THEN
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX, 2) + .01)
                    THEN
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ilf.MATRIX, 1) + .1)
                    THEN
                       'MATRIX_BID'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                         FLOOR (ilf.MATRIX_PRICE) + 1
                    THEN
                       'MATRIX'
                    WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX) + 1
                    THEN
                       'MATRIX_BID'
                    WHEN     ILF.MATRIX_PRICE IS NULL
                         AND ILF.PRICE_FORMULA LIKE 'L-0.%'
                    THEN
                       'NDP'
                    ELSE
                       'MANUAL'
                 END
              ELSE
                 'MANUAL'
           END
              AS PRICE_CATEGORY
    FROM DW_FEI.INVOICE_LINE_FACT ilf,
         DW_FEI.INVOICE_HEADER_FACT ihf,
         DW_FEI.CUSTOMER_DIMENSION cust,
         SALES_MART.SALES_WAREHOUSE_DIM ps
    WHERE     ihf.CUSTOMER_ACCOUNT_GK = cust.CUSTOMER_GK
          AND (ilf.INVOICE_NUMBER_GK = ihf.INVOICE_NUMBER_GK)
          AND TO_CHAR (ihf.WAREHOUSE_NUMBER) =
              TO_CHAR (ps.WAREHOUSE_NUMBER_NK)
          AND ihf.IC_FLAG = 0
          AND ihf.PO_WAREHOUSE_NUMBER IS NULL
          AND NVL (ihf.CONSIGN_TYPE, 'N') <> 'R'
          AND DECODE (NVL (ilf.PRICE_CODE, 'N/A'),
                      'R', 0,
                      'Q', 0,
                      'N/A', 0,
                      'N', 0,
                      1) <>
              0
          AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                       TRUNC (
                                            SYSDATE
                                          - NUMTOYMINTERVAL (24, 'MONTH'),
                                          'MONTH'),
                                       'YYYYMM')
                                AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                             'YYYYMM')
          AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                       TRUNC (
                                            SYSDATE
                                          - NUMTOYMINTERVAL (24, 'MONTH'),
                                          'MONTH'),
                                       'YYYYMM')
                                AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                             'YYYYMM')
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
                      1) <>
              0
    GROUP BY ihf.YEARMONTH,
           ilf.INVOICE_NUMBER_GK,
           ilf.PRICE_CODE,
           ilf.ORIG_PRICE_CODE,
           ilf.INVOICE_LINE_NUMBER,
           ilf.PRODUCT_GK,
           ilf.SPECIAL_PRODUCT_GK,
           ilf.EXT_AVG_COGS_AMOUNT,
           ilf.CORE_ADJ_AVG_COST,
           ilf.EXT_ACTUAL_COGS_AMOUNT,
           ilf.EXT_SALES_AMOUNT,
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
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           ROUND (ilf.MATRIX_PRICE, 2)
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = ROUND (ilf.MATRIX, 2)
                      THEN
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX, 2) + .01)
                      THEN
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX, 1) + .1)
                      THEN
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           FLOOR (ilf.MATRIX_PRICE) + 1
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX) + 1
                      THEN
                         'MATRIX_BID'
                      ELSE
                         'QUOTE'
                   END
                WHEN REGEXP_LIKE (ilf.price_code, '[0-9]?[0-9]?[0-9]')
                THEN
                   'MATRIX'
                WHEN ilf.price_code IN ('FC', 'PM')
                THEN
                   'MATRIX'
                WHEN ilf.price_code LIKE 'M%'
                THEN
                   'MATRIX'
                WHEN ilf.price_formula IN ('CPA', 'CPO')
                THEN
                   'OVERRIDE'
                WHEN ilf.price_code IN ('PR',
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
                WHEN ilf.price_code IN ('GI',
                                        'GPC',
                                        'HPF',
                                        'HPN',
                                        'NC')
                THEN
                   'MANUAL'
                WHEN ilf.price_code = '*E'
                THEN
                   'OTH/ERROR'
                WHEN ilf.price_code = 'SKC'
                THEN
                   'OTH/ERROR'
                WHEN ilf.price_code IN ('%',
                                        '$',
                                        'N',
                                        'F',
                                        'B',
                                        'PO')
                THEN
                   'TOOLS'
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
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           ROUND (ilf.MATRIX_PRICE, 2)
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = ROUND (ilf.MATRIX, 2)
                      THEN
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX, 2) + .01)
                      THEN
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ilf.MATRIX, 1) + .1)
                      THEN
                         'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                           FLOOR (ilf.MATRIX_PRICE) + 1
                      THEN
                         'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = FLOOR (ilf.MATRIX) + 1
                      THEN
                         'MATRIX_BID'
                      WHEN     ILF.MATRIX_PRICE IS NULL
                           AND ILF.PRICE_FORMULA LIKE 'L-0.%'
                      THEN
                         'NDP'
                      ELSE
                         'MANUAL'
                   END
                ELSE
                   'MANUAL'
             END);
             
    GRANT SELECT ON PRICE_MGMT.PR_PRICE_CAT_NOT_CCOR TO PUBLIC;