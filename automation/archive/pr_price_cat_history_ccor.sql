TRUNCATE TABLE AAA6863.PR_PRICE_CAT_HISTORY_CCOR;
DROP TABLE AAA6863.PR_PRICE_CAT_HISTORY_CCOR;

CREATE TABLE AAA6863.PR_PRICE_CAT_HISTORY_CCOR
NOLOGGING
AS

SELECT HIST.*,
    CASE
                WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                   HIST.PRICE_CATEGORY_OVR_GR,
                                   HIST.PRICE_CATEGORY) IN
                            ('MANUAL', 'QUOTE', 'MATRIX_BID')
                     AND HIST.ORIG_PRICE_CODE IS NOT NULL
                THEN
                   CASE
                      WHEN REGEXP_LIKE (HIST.orig_price_code,
                                        '[0-9]?[0-9]?[0-9]')
                      THEN
                         'MATRIX'
                      WHEN HIST.orig_price_code IN ('FC', 'PM', 'spec')
                      THEN
                         'MATRIX'
                      WHEN HIST.orig_price_code LIKE 'M%'
                      THEN
                         'NDP'
                      WHEN HIST.orig_price_code IN ('CPA', 'CPO')
                      THEN
                         'OVERRIDE'
                      WHEN HIST.orig_price_code IN ('PR',
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
                      WHEN HIST.orig_price_code IN ('GI',
                                                    'GPC',
                                                    'HPF',
                                                    'HPN',
                                                    'NC')
                      THEN
                         'MANUAL'
                      WHEN HIST.orig_price_code = '*E'
                      THEN
                         'OTH/ERROR'
                      WHEN HIST.orig_price_code = 'SKC'
                      THEN
                         'OTH/ERROR'
                      WHEN HIST.orig_price_code IN ('%',
                                                    '$',
                                                    'N',
                                                    'F',
                                                    'B',
                                                    'PO')
                      THEN
                         'TOOLS'
                      WHEN HIST.orig_price_code IS NULL
                      THEN
                         'MANUAL'
                      ELSE
                         'MANUAL'
                   END
                ELSE
                   COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                             HIST.PRICE_CATEGORY_OVR_GR,
                             HIST.PRICE_CATEGORY)
             END
                PRICE_CATEGORY_FINAL
                
FROM (

SELECT DISTINCT
       LINE_HIST.YEARMONTH,
       LINE_HIST.INVOICE_NUMBER_GK,
       LINE_HIST.PRICE_CODE,
       LINE_HIST.ORIG_PRICE_CODE,
       LINE_HIST.INVOICE_LINE_NUMBER,
       LINE_HIST.PRODUCT_GK,
       LINE_HIST.SPECIAL_PRODUCT_GK,
       LINE_HIST.EXT_AVG_COGS_AMOUNT,
       LINE_HIST.CORE_ADJ_AVG_COST,
       LINE_HIST.EXT_ACTUAL_COGS_AMOUNT,
       LINE_HIST.EXT_SALES_AMOUNT,
       LINE_HIST.PRICE_CATEGORY,
       CASE
          WHEN LINE_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                   PR_OVR_JOB.INSERT_TIMESTAMP
                                                 - 2,
                                                   PR_OVR_BASE.INSERT_TIMESTAMP
                                                 - 2)
                                          AND COALESCE (
                                                 PR_OVR_JOB.EXPIRE_DATE,
                                                 PR_OVR_BASE.EXPIRE_DATE,
                                                 LINE_HIST.PROCESS_DATE)
          THEN
             CASE
                WHEN LINE_HIST.UNIT_NET_PRICE_AMOUNT =
                     COALESCE (PR_OVR_JOB.MULTIPLIER, PR_OVR_BASE.MULTIPLIER)
                THEN
                   'OVERRIDE'
                WHEN TO_CHAR (LINE_HIST.UNIT_NET_PRICE_AMOUNT) =
                     COALESCE (PR_OVR_JOB.FORMULA, PR_OVR_BASE.FORMULA)
                THEN
                   'OVERRIDE'
                WHEN LINE_HIST.UNIT_NET_PRICE_AMOUNT =
                     (  TRUNC (
                           COALESCE (PR_OVR_JOB.MULTIPLIER,
                                     PR_OVR_BASE.MULTIPLIER),
                           2)
                      + .01)
                THEN
                   'OVERRIDE'
                WHEN LINE_HIST.UNIT_NET_PRICE_AMOUNT =
                     (ROUND (
                         COALESCE (PR_OVR_JOB.MULTIPLIER,
                                   PR_OVR_BASE.MULTIPLIER),
                         2))
                THEN
                   'OVERRIDE'
                WHEN LINE_HIST.UNIT_NET_PRICE_AMOUNT =
                     (  TRUNC (
                           COALESCE (PR_OVR_JOB.MULTIPLIER,
                                     PR_OVR_BASE.MULTIPLIER),
                           1)
                      + .1)
                THEN
                   'OVERRIDE'
                WHEN LINE_HIST.UNIT_NET_PRICE_AMOUNT =
                       FLOOR (
                          COALESCE (PR_OVR_JOB.MULTIPLIER,
                                    PR_OVR_BASE.MULTIPLIER))
                     + 1
                THEN
                   'OVERRIDE'
                WHEN REPLACE (LINE_HIST.PRICE_FORMULA, '0.', '.') =
                     REPLACE (
                        COALESCE (PR_OVR_JOB.FORMULA, PR_OVR_BASE.FORMULA),
                        '0.',
                        '.')
                THEN
                   'OVERRIDE'
             END
       END
          PRICE_CATEGORY_OVR_PR,
       CASE
          WHEN LINE_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                 GR_OVR_JOB.INSERT_TIMESTAMP,
                                                 GR_OVR_BASE.INSERT_TIMESTAMP)
                                          AND COALESCE (
                                                 GR_OVR_JOB.EXPIRE_DATE,
                                                 GR_OVR_BASE.EXPIRE_DATE,
                                                 LINE_HIST.PROCESS_DATE)
          THEN
             CASE
                WHEN REPLACE (LINE_HIST.PRICE_FORMULA, '0.', '.') =
                     REPLACE (
                        COALESCE (GR_OVR_JOB.FORMULA, GR_OVR_BASE.FORMULA),
                        '0.',
                        '.')
                THEN
                   'OVERRIDE'
                ELSE
                   NULL
             END
       END
          PRICE_CATEGORY_OVR_GR,
       
          LINE_HIST.INSERT_TIMESTAMP,
          LINE_HIST.PROCESS_DATE,
          LINE_HIST.PRICE_FORMULA

FROM (SELECT SUBSTR (ihf.YEARMONTH, 0, 4)
                YYYY,
             IHF.YEARMONTH,
             ps.division_name
                REGION,
             ps.ACCOUNT_NUMBER_NK
                ACCOUNT_NUMBER,
             ps.WAREHOUSE_NUMBER_nk
                WAREHOUSE_NUMBER,
             ihf.ORDER_ENTRY_DATE,
             ihf.PROCESS_DATE,
             ihf.INSERT_TIMESTAMP,
             ihf.INVOICE_NUMBER_GK,
             ihf.INVOICE_NUMBER_NK,
             ihf.CUSTOMER_ACCOUNT_GK,
             CUST.MAIN_CUSTOMER_NK,
             ihf.CONTRACT_NUMBER,
             PROD.DISCOUNT_GROUP_NK,
             ilf.PRODUCT_NUMBER_NK,
             ilf.PRODUCT_GK,
             ilf.SPECIAL_PRODUCT_GK,
             ilf.PRICE_CODE,
             ilf.UNIT_NET_PRICE_AMOUNT,
             ilf.PRICE_FORMULA,
             ilf.INVOICE_LINE_NUMBER,
             ilf.ORIG_PRICE_CODE,
             DECODE (ps.DIVISION_NAME,
                     'EAST REGION', 'BLENDED',
                     'WEST REGION', 'BLENDED',
                     'NORTH CENTRAL REGION', 'BLENDED',
                     'SOUTH CENTRAL REGION', 'BLENDED',
                     'INDUSTRIAL REGION', 'INDUSTRIAL',
                     'WATERWORKS REGION', 'WW',
                     'HVAC REGION', 'HVAC',
                     ps.DIVISION_NAME)
                KOB,
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
             CASE WHEN ilf.SHIPPED_QTY > 0 THEN 1 ELSE 0 END
                invoice_lines,
             ilf.EXT_AVG_COGS_AMOUNT,
             ilf.EXT_ACTUAL_COGS_AMOUNT,
             ilf.EXT_SALES_AMOUNT,
             ilf.CORE_ADJ_AVG_COST,
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
                WHEN ilf.price_code IS NULL
                THEN
                   'MANUAL'
                WHEN ilf.price_code IN ('R', 'N/A', 'N')
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
                         'MANUAL'
                   END
                ELSE
                   'MANUAL'
             END
                AS PRICE_CATEGORY
      FROM DW_FEI.INVOICE_LINE_FACT ilf,
           DW_FEI.INVOICE_HEADER_FACT ihf,
           DW_FEI.CUSTOMER_DIMENSION cust,
           DW_FEI.PRODUCT_DIMENSION PROD,
           SALES_MART.SALES_WAREHOUSE_DIM ps
      WHERE     ILF.CUSTOMER_ACCOUNT_GK = cust.CUSTOMER_GK
            AND ILF.INVOICE_NUMBER_GK = ihf.INVOICE_NUMBER_GK
            AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
            AND TO_CHAR (ihf.WAREHOUSE_NUMBER) =
                TO_CHAR (ps.WAREHOUSE_NUMBER_NK)
            AND ihf.IC_FLAG = 0
            AND ihf.PO_WAREHOUSE_NUMBER IS NULL
            AND COALESCE (ihf.CONSIGN_TYPE, 'N') <> 'R'
            AND COALESCE (ilf.PRICE_CODE, 'N/A') IN ('R',
                                                     'Q',
                                                     'N/A',
                                                     'N')
            AND ILF.YEARMONTH = TO_CHAR (
                                  TRUNC (SYSDATE, 'MM') - 1,
                                              'YYYYMM')
            AND IHF.YEARMONTH = TO_CHAR (
                                  TRUNC (SYSDATE, 'MM') - 1,
                                              'YYYYMM')

            /*AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                         TRUNC (
                                              SYSDATE
                                            - NUMTOYMINTERVAL (1, 'MONTH'),
                                            'MONTH'),
                                         'YYYYMM')
                                  AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                               'YYYYMM')
            AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                         TRUNC (
                                              SYSDATE
                                            - NUMTOYMINTERVAL (1, 'MONTH'),
                                            'MONTH'),
                                         'YYYYMM')
                                  AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                               'YYYYMM')*/
            AND DECODE (COALESCE (cust.ar_gl_number, '9999'),
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
                0) LINE_HIST
     LEFT OUTER JOIN
     (SELECT COD.BASIS,
             COD.BRANCH_NUMBER_NK,
             COD.CONTRACT_ID,
             COD.CUSTOMER_GK,
             COD.CUSTOMER_NK,
             COD.DISC_GROUP,
             COD.INSERT_TIMESTAMP,
             NVL (COD.EXPIRE_DATE, SYSDATE) EXPIRE_DATE,
             COD.MASTER_PRODUCT,
             COD.MULTIPLIER,
             COD.OPERATOR_USED,
             COD.OVERRIDE_ID_NK,
             COD.OVERRIDE_TYPE,
             COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER FORMULA
      FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
           DW_FEI.CUSTOMER_DIMENSION CUST
      WHERE     COD.OVERRIDE_TYPE = 'G'
            AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
            AND COD.DELETE_DATE IS NULL
            AND CUST.JOB_YN = 'Y'
            AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 395))
     GR_OVR_JOB
        ON (    LINE_HIST.DISCOUNT_GROUP_NK = GR_OVR_JOB.DISC_GROUP
            AND LINE_HIST.ACCOUNT_NUMBER = GR_OVR_JOB.BRANCH_NUMBER_NK
            AND LINE_HIST.CUSTOMER_ACCOUNT_GK = GR_OVR_JOB.CUSTOMER_GK
            AND NVL (LINE_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                NVL (GR_OVR_JOB.CONTRACT_ID, 'DEFAULT_MATCH'))
     LEFT OUTER JOIN
     (SELECT COD.BASIS,
             COD.BRANCH_NUMBER_NK,
             COD.CONTRACT_ID,
             COD.CUSTOMER_GK,
             COD.CUSTOMER_NK,
             COD.DISC_GROUP,
             COD.INSERT_TIMESTAMP,
             NVL (COD.EXPIRE_DATE, SYSDATE) EXPIRE_DATE,
             COD.MASTER_PRODUCT,
             COD.MULTIPLIER,
             COD.OPERATOR_USED,
             COD.OVERRIDE_ID_NK,
             COD.OVERRIDE_TYPE,
             COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER FORMULA
      FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
           DW_FEI.CUSTOMER_DIMENSION CUST
      WHERE     COD.OVERRIDE_TYPE = 'G'
            AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
            AND COD.DELETE_DATE IS NULL
            AND CUST.JOB_YN = 'N'
            AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 395))
     GR_OVR_BASE
        ON (    LINE_HIST.DISCOUNT_GROUP_NK = GR_OVR_BASE.DISC_GROUP
            AND LINE_HIST.ACCOUNT_NUMBER = GR_OVR_BASE.BRANCH_NUMBER_NK
            AND LINE_HIST.MAIN_CUSTOMER_NK = GR_OVR_BASE.CUSTOMER_NK
            AND NVL (LINE_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                NVL (GR_OVR_BASE.CONTRACT_ID, 'DEFAULT_MATCH'))
     LEFT OUTER JOIN
     (SELECT COD.BASIS,
             COD.BRANCH_NUMBER_NK,
             COD.CONTRACT_ID,
             COD.CUSTOMER_GK,
             COD.CUSTOMER_NK,
             COD.DISC_GROUP,
             COD.INSERT_TIMESTAMP,
             NVL (COD.EXPIRE_DATE, SYSDATE)
                EXPIRE_DATE,
             COD.MASTER_PRODUCT,
             TO_NUMBER (COD.MULTIPLIER)
                MULTIPLIER,
             COD.OPERATOR_USED,
             COD.OVERRIDE_ID_NK,
             COD.OVERRIDE_TYPE,
             CASE
                WHEN COD.OPERATOR_USED <> '$'
                THEN
                   COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER
                ELSE
                   TO_CHAR (COD.MULTIPLIER)
             END
                FORMULA
      FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
           DW_FEI.CUSTOMER_DIMENSION CUST
      WHERE     COD.OVERRIDE_TYPE = 'P'
            AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
            AND COD.DELETE_DATE IS NULL
            AND CUST.JOB_YN = 'Y'
            AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 395))
     PR_OVR_JOB
        ON (    LINE_HIST.PRODUCT_NUMBER_NK = PR_OVR_JOB.MASTER_PRODUCT
            AND LINE_HIST.ACCOUNT_NUMBER = PR_OVR_JOB.BRANCH_NUMBER_NK
            AND LINE_HIST.CUSTOMER_ACCOUNT_GK = PR_OVR_JOB.CUSTOMER_GK
            AND COALESCE (LINE_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                COALESCE (PR_OVR_JOB.CONTRACT_ID, 'DEFAULT_MATCH'))
     LEFT OUTER JOIN
     (SELECT COD.BASIS,
             COD.BRANCH_NUMBER_NK,
             COD.CONTRACT_ID,
             COD.CUSTOMER_GK,
             COD.CUSTOMER_NK,
             COD.DISC_GROUP,
             COD.INSERT_TIMESTAMP,
             NVL (COD.EXPIRE_DATE, SYSDATE)
                EXPIRE_DATE,
             COD.MASTER_PRODUCT,
             TO_NUMBER (COD.MULTIPLIER)
                MULTIPLIER,
             COD.OPERATOR_USED,
             COD.OVERRIDE_ID_NK,
             COD.OVERRIDE_TYPE,
             CASE
                WHEN COD.OPERATOR_USED <> '$'
                THEN
                   COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER
                ELSE
                   TO_CHAR (COD.MULTIPLIER)
             END
                FORMULA
      FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
           DW_FEI.CUSTOMER_DIMENSION CUST
      WHERE     COD.OVERRIDE_TYPE = 'P'
            AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
            AND COD.DELETE_DATE IS NULL
            AND CUST.JOB_YN = 'N'
            AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 395))
     PR_OVR_BASE
        ON (    LINE_HIST.PRODUCT_NUMBER_NK = PR_OVR_BASE.MASTER_PRODUCT
            AND LINE_HIST.ACCOUNT_NUMBER = PR_OVR_BASE.BRANCH_NUMBER_NK
            AND LINE_HIST.MAIN_CUSTOMER_NK = PR_OVR_BASE.CUSTOMER_NK
            AND COALESCE (LINE_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                COALESCE (PR_OVR_BASE.CONTRACT_ID, 'DEFAULT_MATCH'))
   ) HIST   
   ;