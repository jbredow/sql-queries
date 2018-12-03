/*
CREATE TABLE AAA6863.PR_PRICE_CAT_CCOR
NOLOGGING
AS
*/
--      day 1 auto monthly 

INSERT INTO PRICE_MGMT.PR_PRICE_CAT_HISTORY
   (SELECT IHF.YEARMONTH,
           ILF.INVOICE_NUMBER_GK,
           ILF.PRICE_CODE,
           ILF.ORIG_PRICE_CODE,
           ILF.INVOICE_LINE_NUMBER,
           ILF.PRODUCT_GK,
           ILF.SPECIAL_PRODUCT_GK,
           ILF.EXT_AVG_COGS_AMOUNT,
           ILF.CORE_ADJ_AVG_COST,
           ILF.EXT_ACTUAL_COGS_AMOUNT,
           ILF.EXT_SALES_AMOUNT,
           CASE
              WHEN IHF.order_code = 'IC'
              THEN
                 'CREDITS'
              WHEN ILF.special_product_gk IS NOT NULL
              THEN
                 'SPECIALS'
              WHEN ILF.price_code = 'Q'
              THEN
                 CASE
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX_PRICE
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         ROUND (ILF.MATRIX_PRICE, 2)
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = ROUND (ILF.MATRIX, 2)
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX_PRICE, 2) + .01)
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX, 2) + .01)
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX_PRICE, 1) + .1)
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX, 1) + .1)
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         FLOOR (ILF.MATRIX_PRICE) + 1
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = FLOOR (ILF.MATRIX) + 1
                    THEN
                       'MATRIX_BID'
                    ELSE
                       'QUOTE'
                 END
              WHEN REGEXP_LIKE (ILF.price_code, '[0-9]?[0-9]?[0-9]')
              THEN
                 'MATRIX'
              WHEN ILF.price_code IN ('FC', 'PM')
              THEN
                 'MATRIX'
              WHEN ILF.price_code LIKE 'M%'
              THEN
                 'MATRIX'
              WHEN ILF.price_formula IN ('CPA', 'CPO')
              THEN
                 'OVERRIDE'
              WHEN ILF.price_code IN ('PR',
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
              WHEN ILF.price_code IN ('GI',
                                      'GPC',
                                      'HPF',
                                      'HPN',
                                      'NC')
              THEN
                 'MANUAL'
              WHEN ILF.price_code = '*E'
              THEN
                 'OTH/ERROR'
              WHEN ILF.price_code = 'SKC'
              THEN
                 'OTH/ERROR'
              WHEN ILF.price_code IN ('%',
                                      '$',
                                      'N',
                                      'F',
                                      'B',
                                      'PO')
              THEN
                 'TOOLS'
              WHEN ILF.price_code IS NULL
              THEN
                 'MANUAL'
              WHEN ILF.price_code IN ('R', 'N/A')
              THEN
                 CASE
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX_PRICE
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         ROUND (ILF.MATRIX_PRICE, 2)
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = ROUND (ILF.MATRIX, 2)
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX_PRICE, 2) + .01)
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX, 2) + .01)
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX_PRICE, 1) + .1)
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         (TRUNC (ILF.MATRIX, 1) + .1)
                    THEN
                       'MATRIX_BID'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                         FLOOR (ILF.MATRIX_PRICE) + 1
                    THEN
                       'MATRIX'
                    WHEN ILF.UNIT_NET_PRICE_AMOUNT = FLOOR (ILF.MATRIX) + 1
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
    FROM DW_FEI.INVOICE_LINE_FACT ILF,
         DW_FEI.INVOICE_HEADER_FACT IHF,
         DW_FEI.CUSTOMER_DIMENSION cust,
         SALES_MART.SALES_WAREHOUSE_DIM ps
    WHERE     IHF.CUSTOMER_ACCOUNT_GK = cust.CUSTOMER_GK
          AND (ILF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK)
          AND TO_CHAR (IHF.WAREHOUSE_NUMBER) =
              TO_CHAR (ps.WAREHOUSE_NUMBER_NK)
          AND IHF.IC_FLAG = 0
          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
          AND NVL (IHF.CONSIGN_TYPE, 'N') <> 'R'
          AND DECODE (NVL (ILF.PRICE_CODE, 'N/A'),
                      'R', 0,
                      'Q', 0,
                      'N/A', 0,
                      'N', 0,
                      1) <>
              0
          AND ILF.YEARMONTH = /*BETWEEN TO_CHAR (
                                       TRUNC (
                                            SYSDATE
                                          - NUMTOYMINTERVAL (24, 'MONTH'),
                                          'MONTH'),
                                       'YYYYMM')
                                AND */
                              TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
          AND IHF.YEARMONTH = /*BETWEEN TO_CHAR (
                                       TRUNC (
                                            SYSDATE
                                          - NUMTOYMINTERVAL (24, 'MONTH'),
                                          'MONTH'),
                                       'YYYYMM')
                                AND */
                              TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
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
    GROUP BY IHF.YEARMONTH,
             ILF.INVOICE_NUMBER_GK,
             ILF.PRICE_CODE,
             ILF.ORIG_PRICE_CODE,
             ILF.INVOICE_LINE_NUMBER,
             ILF.PRODUCT_GK,
             ILF.SPECIAL_PRODUCT_GK,
             ILF.EXT_AVG_COGS_AMOUNT,
             ILF.CORE_ADJ_AVG_COST,
             ILF.EXT_ACTUAL_COGS_AMOUNT,
             ILF.EXT_SALES_AMOUNT,
             CASE
                WHEN IHF.order_code = 'IC'
                THEN
                   'CREDITS'
                WHEN ILF.special_product_gk IS NOT NULL
                THEN
                   'SPECIALS'
                WHEN ILF.price_code = 'Q'
                THEN
                   CASE
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX_PRICE
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           ROUND (ILF.MATRIX_PRICE, 2)
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = ROUND (ILF.MATRIX, 2)
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX_PRICE, 2) + .01)
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX, 2) + .01)
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX_PRICE, 1) + .1)
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX, 1) + .1)
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           FLOOR (ILF.MATRIX_PRICE) + 1
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = FLOOR (ILF.MATRIX) + 1
                      THEN
                         'MATRIX_BID'
                      ELSE
                         'QUOTE'
                   END
                WHEN REGEXP_LIKE (ILF.price_code, '[0-9]?[0-9]?[0-9]')
                THEN
                   'MATRIX'
                WHEN ILF.price_code IN ('FC', 'PM')
                THEN
                   'MATRIX'
                WHEN ILF.price_code LIKE 'M%'
                THEN
                   'MATRIX'
                WHEN ILF.price_formula IN ('CPA', 'CPO')
                THEN
                   'OVERRIDE'
                WHEN ILF.price_code IN ('PR',
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
                WHEN ILF.price_code IN ('GI',
                                        'GPC',
                                        'HPF',
                                        'HPN',
                                        'NC')
                THEN
                   'MANUAL'
                WHEN ILF.price_code = '*E'
                THEN
                   'OTH/ERROR'
                WHEN ILF.price_code = 'SKC'
                THEN
                   'OTH/ERROR'
                WHEN ILF.price_code IN ('%',
                                        '$',
                                        'N',
                                        'F',
                                        'B',
                                        'PO')
                THEN
                   'TOOLS'
                WHEN ILF.price_code IS NULL
                THEN
                   'MANUAL'
                WHEN ILF.price_code IN ('R', 'N/A')
                THEN
                   CASE
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX_PRICE
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           ROUND (ILF.MATRIX_PRICE, 2)
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = ROUND (ILF.MATRIX, 2)
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX_PRICE, 2) + .01)
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX, 2) + .01)
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX_PRICE, 1) + .1)
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           (TRUNC (ILF.MATRIX, 1) + .1)
                      THEN
                         'MATRIX_BID'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                           FLOOR (ILF.MATRIX_PRICE) + 1
                      THEN
                         'MATRIX'
                      WHEN ILF.UNIT_NET_PRICE_AMOUNT = FLOOR (ILF.MATRIX) + 1
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

    --GRANT SELECT ON PRICE_MGMT.PR_PRICE_CAT_NOT_CCOR TO PUBLIC;