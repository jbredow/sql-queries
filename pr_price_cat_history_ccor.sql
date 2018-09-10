/*
    MONTHLY PR_PRICE_CAT_HISTORY_CCOR BUILD
*/
TRUNCATE TABLE PRICE_MGMT.PR_PRICE_CAT_HISTORY_CCOR;
DROP TABLE PRICE_MGMT.PR_PRICE_CAT_HISTORY_CCOR;

CREATE TABLE PRICE_MGMT.PR_PRICE_CAT_HISTORY_CCOR
AS
   SELECT X.YEARMONTH,
          X.INVOICE_NUMBER_GK,
          X.PRICE_CODE,
          X.ORIG_PRICE_CODE,
          X.INVOICE_LINE_NUMBER,
          X.PRODUCT_GK,
          X.SPECIAL_PRODUCT_GK,
          X.EXT_ACTUAL_COGS_AMOUNT,
          X.EXT_AVG_COGS_AMOUNT,
          X.EXT_SALES_AMOUNT,
          X.PRICE_CATEGORY,
          X.ORIG_PRICE_CATEGORY,
          X.PRICE_CATEGORY_OVR_GR,
          X.PRICE_CATEGORY_OVR_PR,
          X.INSERT_TIMESTAMP,
          X.PROCESS_DATE,
          X.PRICE_FORMULA,
          CASE
             WHEN     COALESCE (X.PRICE_CATEGORY_OVR_PR,
                                X.PRICE_CATEGORY_OVR_GR,
                                X.PRICE_CATEGORY) IN
                         ('MANUAL', 'QUOTE', 'MATRIX_BID')
                  AND X.ORIG_PRICE_CODE IS NOT NULL
             THEN
                CASE
                   WHEN REGEXP_LIKE (X.ORIG_PRICE_CODE, '[0-9]?[0-9]?[0-9]')
                   THEN
                      'MATRIX'
                   WHEN X.ORIG_PRICE_CODE IN ('FC', 'PM', 'SPEC')
                   THEN
                      'MATRIX'
                   WHEN X.ORIG_PRICE_CODE LIKE 'M%'
                   THEN
                      'NDP'
                   WHEN X.ORIG_PRICE_CODE IN ('CPA', 'CPO')
                   THEN
                      'OVERRIDE'
                   WHEN X.ORIG_PRICE_CODE IN ('PR',
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
                   WHEN X.ORIG_PRICE_CODE IN ('GI',
                                              'GPC',
                                              'HPF',
                                              'HPN',
                                              'NC')
                   THEN
                      'MANUAL'
                   WHEN X.ORIG_PRICE_CODE = '*E'
                   THEN
                      'OTH/ERROR'
                   WHEN X.ORIG_PRICE_CODE = 'SKC'
                   THEN
                      'OTH/ERROR'
                   WHEN X.ORIG_PRICE_CODE IN ('%',
                                              '$',
                                              'N',
                                              'F',
                                              'B',
                                              'PO')
                   THEN
                      'TOOLS'
                   WHEN X.ORIG_PRICE_CODE IS NULL
                   THEN
                      'MANUAL'
                   ELSE
                      'MANUAL'
                END
             ELSE
                COALESCE (X.PRICE_CATEGORY_OVR_PR,
                          X.PRICE_CATEGORY_OVR_GR,
                          X.PRICE_CATEGORY)
          END
             PRICE_CATEGORY_FINAL
   FROM (SELECT LINE_HIST.YEARMONTH,
                LINE_HIST.INVOICE_NUMBER_GK,
                LINE_HIST.PRICE_CODE,
                LINE_HIST.ORIG_PRICE_CODE,
                LINE_HIST.INVOICE_LINE_NUMBER,
                LINE_HIST.PRODUCT_GK,
                LINE_HIST.SPECIAL_PRODUCT_GK,
                LINE_HIST.EXT_ACTUAL_COGS_AMOUNT,
                LINE_HIST.EXT_AVG_COGS_AMOUNT,
                LINE_HIST.EXT_SALES_AMOUNT,
                LINE_HIST.PRICE_CATEGORY,
                LINE_HIST.ORIG_PRICE_CATEGORY,
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
                              COALESCE (PR_OVR_JOB.MULTIPLIER,
                                        PR_OVR_BASE.MULTIPLIER)
                         THEN
                            'OVERRIDE'
                         WHEN TO_CHAR (LINE_HIST.UNIT_NET_PRICE_AMOUNT) =
                              COALESCE (PR_OVR_JOB.FORMULA,
                                        PR_OVR_BASE.FORMULA)
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
                                 COALESCE (PR_OVR_JOB.FORMULA,
                                           PR_OVR_BASE.FORMULA),
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
                                 COALESCE (GR_OVR_JOB.FORMULA,
                                           GR_OVR_BASE.FORMULA),
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
                LINE_HIST.UNIT_NET_PRICE_AMOUNT,
                LINE_HIST.PRICE_FORMULA
         FROM (SELECT SUBSTR (IHF.YEARMONTH, 0, 4)
                         YYYY,
                      IHF.YEARMONTH,
                      /*DECODE (
                         IHF.YEARMONTH,
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (12, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q1',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (11, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q1',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (10, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q1',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (9, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q2',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (8, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q2',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (7, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q2',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (6, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q3',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (5, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q3',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (4, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q3',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (3, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q4',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (2, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q4',
                         TO_CHAR (
                            TRUNC (SYSDATE - NUMTOYMINTERVAL (1, 'MONTH'),
                                   'MONTH'),
                            'YYYYMM'), 'ROLL_Q4')
                         ROLLING_QTR,*/
                      PS.DIVISION_NAME
                         REGION,
                      PS.ACCOUNT_NUMBER_NK
                         ACCOUNT_NUMBER,
                      PS.WAREHOUSE_NUMBER_NK
                         WAREHOUSE_NUMBER,
                      ILF.ORIG_PRICE_CODE,
                      IHF.ORDER_ENTRY_DATE,
                      IHF.INSERT_TIMESTAMP,
                      IHF.PROCESS_DATE,
                      IHF.INVOICE_NUMBER_GK,
                      IHF.INVOICE_NUMBER_NK,
                      IHF.CUSTOMER_ACCOUNT_GK,
                      CUST.MAIN_CUSTOMER_NK,
                      ILF.PRODUCT_GK,
                      ILF.SPECIAL_PRODUCT_GK,
                      ILF.INVOICE_LINE_NUMBER,
                      IHF.CONTRACT_NUMBER,
                      PROD.DISCOUNT_GROUP_NK,
                      ILF.PRODUCT_NUMBER_NK,
                      ILF.PRICE_CODE,
                      ILF.UNIT_NET_PRICE_AMOUNT,
                      ILF.PRICE_FORMULA,
                      DECODE (PS.DIVISION_NAME,
                              'EAST REGION', 'BLENDED',
                              'WEST REGION', 'BLENDED',
                              'NORTH CENTRAL REGION', 'BLENDED',
                              'SOUTH CENTRAL REGION', 'BLENDED',
                              'INDUSTRIAL REGION', 'INDUSTRIAL',
                              'WATERWORKS REGION', 'WW',
                              'HVAC REGION', 'HVAC',
                              PS.DIVISION_NAME)
                         KOB,
                      DECODE (IHF.SALE_TYPE,
                              '1', 'OUR TRUCK',
                              '2', 'COUNTER',
                              '3', 'DIRECT',
                              '4', 'COUNTER',
                              '5', 'CREDIT MEMO',
                              '6', 'SHOWROOM',
                              '7', 'SHOWROOM DIRECT',
                              '8', 'EBUSINESS')
                         TYPE_OF_SALE,
                      CASE WHEN ILF.SHIPPED_QTY > 0 THEN 1 ELSE 0 END
                         INVOICE_LINES,
                      ILF.EXT_AVG_COGS_AMOUNT,
                      ILF.EXT_ACTUAL_COGS_AMOUNT,
                      ILF.EXT_SALES_AMOUNT,
                      CASE
                         WHEN IHF.ORDER_CODE = 'IC'
                         THEN
                            'CREDITS'
                         WHEN ILF.SPECIAL_PRODUCT_GK IS NOT NULL
                         THEN
                            'SPECIALS'
                         WHEN ILF.PRICE_CODE = 'Q'
                         THEN
                            CASE
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ILF.MATRIX_PRICE
                               THEN
                                  'MATRIX'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
                               THEN
                                  'MATRIX_BID'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ROUND (ILF.MATRIX_PRICE, 2)
                               THEN
                                  'MATRIX'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ROUND (ILF.MATRIX, 2)
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
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    FLOOR (ILF.MATRIX) + 1
                               THEN
                                  'MATRIX_BID'
                               ELSE
                                  'QUOTE'
                            END
                         WHEN ILF.PRICE_CODE IS NULL
                         THEN
                            'MANUAL'
                         WHEN ILF.PRICE_CODE IN ('R', 'N/A', 'N')
                         THEN
                            CASE
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ILF.MATRIX_PRICE
                               THEN
                                  'MATRIX'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
                               THEN
                                  'MATRIX_BID'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ROUND (ILF.MATRIX_PRICE, 2)
                               THEN
                                  'MATRIX'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ROUND (ILF.MATRIX, 2)
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
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    FLOOR (ILF.MATRIX) + 1
                               THEN
                                  'MATRIX_BID'
                               ELSE
                                  'MANUAL'
                            END
                         ELSE
                            'MANUAL'
                      END
                         AS PRICE_CATEGORY,
                      CASE
                         WHEN IHF.ORDER_CODE = 'IC'
                         THEN
                            'CREDITS'
                         WHEN ILF.SPECIAL_PRODUCT_GK IS NOT NULL
                         THEN
                            'SPECIALS'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) = 'Q'
                         THEN
                            CASE
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    ILF.MATRIX_PRICE
                               THEN
                                  'MATRIX'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT = ILF.MATRIX
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
                                    (ROUND (ILF.MATRIX_PRICE, 2))
                               THEN
                                  'MATRIX'
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    (ROUND (ILF.MATRIX, 2))
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
                               WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                    FLOOR (ILF.MATRIX) + 1
                               THEN
                                  'MATRIX_BID'
                               ELSE
                                  'QUOTE'
                            END
                         WHEN REGEXP_LIKE (
                                 NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE),
                                 '[0-9]?[0-9]?[0-9]')
                         THEN
                            'MATRIX'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN
                                 ('FC', 'PM', 'SPEC')
                         THEN
                            'MATRIX'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) LIKE
                                 'M%'
                         THEN
                            'NDP'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN
                                 ('CPA', 'CPO')
                         THEN
                            'OVERRIDE'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN
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
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN
                                 ('GI',
                                  'GPC',
                                  'HPF',
                                  'HPN',
                                  'NC')
                         THEN
                            'MANUAL'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) =
                              '*E'
                         THEN
                            'OTH/ERROR'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) =
                              'SKC'
                         THEN
                            'OTH/ERROR'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN
                                 ('%',
                                  '$',
                                  'N',
                                  'F',
                                  'B',
                                  'PO')
                         THEN
                            'TOOLS'
                         WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE)
                                 IS NULL
                         THEN
                            'MANUAL'
                         ELSE
                            'MANUAL'
                      END
                         AS ORIG_PRICE_CATEGORY
               FROM DW_FEI.INVOICE_LINE_FACT ILF,
                    DW_FEI.INVOICE_HEADER_FACT IHF,
                    DW_FEI.CUSTOMER_DIMENSION CUST,
                    DW_FEI.PRODUCT_DIMENSION PROD,
                    SALES_MART.SALES_WAREHOUSE_DIM PS
               WHERE     ILF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
                     AND ILF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
                     AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
                     AND TO_CHAR (IHF.WAREHOUSE_NUMBER) =
                         TO_CHAR (PS.WAREHOUSE_NUMBER_NK)
                     AND IHF.IC_FLAG = 0
                     AND IHF.PO_WAREHOUSE_NUMBER IS NULL
                     AND COALESCE (IHF.CONSIGN_TYPE, 'N') <> 'R'
                     AND COALESCE (ILF.PRICE_CODE, 'N/A') IN ('R',
                                                              'Q',
                                                              'N/A',
                                                              'N')
                     AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                                  TRUNC (
                                                       SYSDATE
                                                     - NUMTOYMINTERVAL (
                                                          1,
                                                          'MONTH'),
                                                     'MONTH'),
                                                  'YYYYMM')
                                           AND TO_CHAR (
                                                  TRUNC (SYSDATE, 'MM') - 1,
                                                  'YYYYMM')
                     AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                                  TRUNC (
                                                       SYSDATE
                                                     - NUMTOYMINTERVAL (
                                                          1,
                                                          'MONTH'),
                                                     'MONTH'),
                                                  'YYYYMM')
                                           AND TO_CHAR (
                                                  TRUNC (SYSDATE, 'MM') - 1,
                                                  'YYYYMM')
                     AND DECODE (COALESCE (CUST.AR_GL_NUMBER, '9999'),
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
                      NVL (COD.EXPIRE_DATE, SYSDATE)
                         EXPIRE_DATE,
                      COD.MASTER_PRODUCT,
                      COD.MULTIPLIER,
                      COD.OPERATOR_USED,
                      COD.OVERRIDE_ID_NK,
                      COD.OVERRIDE_TYPE,
                      COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER
                         FORMULA
               FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
                    DW_FEI.CUSTOMER_DIMENSION CUST
               WHERE     COD.OVERRIDE_TYPE = 'G'
                     AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
                     AND COD.DELETE_DATE IS NULL
                     AND CUST.JOB_YN = 'Y'
                     AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >=
                         (SYSDATE - 395)) GR_OVR_JOB
                 ON (    LINE_HIST.DISCOUNT_GROUP_NK = GR_OVR_JOB.DISC_GROUP
                     AND LINE_HIST.ACCOUNT_NUMBER =
                         GR_OVR_JOB.BRANCH_NUMBER_NK
                     AND LINE_HIST.CUSTOMER_ACCOUNT_GK =
                         GR_OVR_JOB.CUSTOMER_GK
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
                      NVL (COD.EXPIRE_DATE, SYSDATE)
                         EXPIRE_DATE,
                      COD.MASTER_PRODUCT,
                      COD.MULTIPLIER,
                      COD.OPERATOR_USED,
                      COD.OVERRIDE_ID_NK,
                      COD.OVERRIDE_TYPE,
                      COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER
                         FORMULA
               FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
                    DW_FEI.CUSTOMER_DIMENSION CUST
               WHERE     COD.OVERRIDE_TYPE = 'G'
                     AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
                     AND COD.DELETE_DATE IS NULL
                     AND CUST.JOB_YN = 'N'
                     AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >=
                         (SYSDATE - 395)) GR_OVR_BASE
                 ON (    LINE_HIST.DISCOUNT_GROUP_NK = GR_OVR_BASE.DISC_GROUP
                     AND LINE_HIST.ACCOUNT_NUMBER =
                         GR_OVR_BASE.BRANCH_NUMBER_NK
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
                               COD.BASIS
                            || COD.OPERATOR_USED
                            || '0'
                            || COD.MULTIPLIER
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
                     AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >=
                         (SYSDATE - 395)) PR_OVR_JOB
                 ON (    LINE_HIST.PRODUCT_NUMBER_NK =
                         PR_OVR_JOB.MASTER_PRODUCT
                     AND LINE_HIST.ACCOUNT_NUMBER =
                         PR_OVR_JOB.BRANCH_NUMBER_NK
                     AND LINE_HIST.CUSTOMER_ACCOUNT_GK =
                         PR_OVR_JOB.CUSTOMER_GK
                     AND COALESCE (LINE_HIST.CONTRACT_NUMBER,
                                   'DEFAULT_MATCH') =
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
                               COD.BASIS
                            || COD.OPERATOR_USED
                            || '0'
                            || COD.MULTIPLIER
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
                     AND COALESCE (COD.EXPIRE_DATE, SYSDATE) >=
                         (SYSDATE - 395)) PR_OVR_BASE
                 ON (    LINE_HIST.PRODUCT_NUMBER_NK =
                         PR_OVR_BASE.MASTER_PRODUCT
                     AND LINE_HIST.ACCOUNT_NUMBER =
                         PR_OVR_BASE.BRANCH_NUMBER_NK
                     AND LINE_HIST.MAIN_CUSTOMER_NK = PR_OVR_BASE.CUSTOMER_NK
                     AND COALESCE (LINE_HIST.CONTRACT_NUMBER,
                                   'DEFAULT_MATCH') =
                         COALESCE (PR_OVR_BASE.CONTRACT_ID, 'DEFAULT_MATCH'))
              /*GROUP BY LINE_HIST.YYYY,
                                                                                    LINE_HIST.YEARMONTH,
                                                                                    --LINE_HIST.ROLLING_QTR,
                                                                                    LINE_HIST.REGION,
                                                                                    LINE_HIST.ACCOUNT_NUMBER,
                                                                                    LINE_HIST.WAREHOUSE_NUMBER,
                                                                                    LINE_HIST.KOB,
                                                                                    LINE_HIST.TYPE_OF_SALE,
                                                                                    LINE_HIST.PRICE_CODE,
                                                                                    --SUM (LINE_HIST.INVOICE_LINES) INVOICE_LINES,
                                                                                    --SUM (LINE_HIST.EXT_AVG_COGS_AMOUNT) AVG_COGS,
                                                                                    --SUM (LINE_HIST.EXT_ACTUAL_COGS_AMOUNT) ACTUAL_COGS,
                                                                                    --SUM (LINE_HIST.EXT_SALES_AMOUNT) EXT_SALES,
                                                                                    LINE_HIST.PRICE_CATEGORY,
                                                                                    LINE_HIST.ORIG_PRICE_CATEGORY,
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
                                                                                                     COALESCE (PR_OVR_JOB.MULTIPLIER,
                                                                                                               PR_OVR_BASE.MULTIPLIER)
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
                                                                                                        COALESCE (PR_OVR_JOB.FORMULA,
                                                                                                                  PR_OVR_BASE.FORMULA),
                                                                                                        '0.',
                                                                                                        '.')
                                                                                             THEN
                                                                                                'OVERRIDE'
                                                                                          END
                                                                                    END,
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
                                                                                                        COALESCE (GR_OVR_JOB.FORMULA,
                                                                                                                  GR_OVR_BASE.FORMULA),
                                                                                                        '0.',
                                                                                                        '.')
                                                                                             THEN
                                                                                                'OVERRIDE'
                                                                                             ELSE
                                                                                                NULL
                                                                                          END
                                                                                    END*/
            )
        X;