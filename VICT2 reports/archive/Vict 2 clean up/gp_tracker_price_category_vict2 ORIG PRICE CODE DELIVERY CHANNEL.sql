TRUNCATE TABLE AAA6863.PR_VICT2_CUST_12MO;
DROP TABLE AAA6863PR_VICT2_CUST_12MO;

CREATE TABLE AAA6863.PR_VICT2_CUST_12MO

AS
   SELECT DISTINCT
          SP_DTL.YEARMONTH,
          SP_DTL.ACCOUNT_NUMBER,
          SP_DTL.ACCOUNT_NAME,
          SP_DTL.WAREHOUSE_NUMBER,
          SP_DTL.INVOICE_NUMBER_NK,
          SP_DTL.TYPE_OF_SALE,
          SP_DTL.SHIP_VIA_NAME,
          SP_DTL.OML_ASSOC_INI,
          SP_DTL.OML_FL_INI,
          SP_DTL.OML_ASSOC_NAME,
          SP_DTL.WRITER,
          SP_DTL.WR_FL_INI,
          SP_DTL.ASSOC_NAME,
          SP_DTL.DISCOUNT_GROUP_NK,
          SP_DTL.DISCOUNT_GROUP_NAME,
          SP_DTL.CHANNEL_TYPE,
          SP_DTL.INVOICE_LINE_NUMBER,
          SP_DTL.MANUFACTURER,
          SP_DTL.PRODUCT_NK,
          SP_DTL.ALT1_CODE,
          SP_DTL.PRODUCT_NAME,
          SP_DTL.INVOICE_LINES,
          SP_DTL.STATUS,
          SP_DTL.SHIPPED_QTY,
          SP_DTL.EXT_SALES_AMOUNT,
          SP_DTL.EXT_AVG_COGS_AMOUNT,
          SP_DTL.CORE_ADJ_AVG_COST,
          SP_DTL.ORDER_CHANNEL,
          SP_DTL.DELIVERY_CHANNEL,
          SP_DTL.REPLACEMENT_COST,
          SP_DTL.UNIT_INV_COST,
          SP_DTL.PRICE_CODE,
          COALESCE (SP_DTL.PRICE_CATEGORY_OVR_PR,
                    SP_DTL.PRICE_CATEGORY_OVR_GR,
                    SP_DTL.PRICE_CATEGORY)
             PRICE_CATEGORY,
          SP_DTL.ORIG_PRICE_CODE,
          COALESCE (SP_DTL.PRICE_CATEGORY_OVR_PR_JOB,
                    SP_DTL.ORIG_PRICE_CATEGORY)
             ORIG_PRICE_CATEGORY,
          SP_DTL.GR_OVR,
          SP_DTL.PR_OVR,
          SP_DTL.PRICE_FORMULA,
          SP_DTL.UNIT_NET_PRICE_AMOUNT,
          SP_DTL.UM,
          SP_DTL.SELL_MULT,
          SP_DTL.PACK_QTY,
          SP_DTL.LIST_PRICE,
          SP_DTL.MATRIX_PRICE,
          SP_DTL.MATRIX,
          CASE
             WHEN SP_DTL.PRICE_CATEGORY_OVR_PR IS NOT NULL THEN SP_DTL.PR_OVR
             ELSE NULL
          END
             PR_TRIM_FORM,
          CASE
             WHEN SP_DTL.PRICE_CATEGORY_OVR_PR IS NOT NULL
             THEN
                SP_DTL.PR_OVR_BASIS
             ELSE
                NULL
          END
             PR_OVR_BASIS,
          CASE
             WHEN SP_DTL.PRICE_CATEGORY_OVR_GR IS NOT NULL THEN SP_DTL.GR_OVR
             ELSE NULL
          END
             GR_TRIM_FORM,
          SP_DTL.ORDER_CODE,
          SP_DTL.SOURCE_SYSTEM,
          SP_DTL.CONSIGN_TYPE,
          SP_DTL.MAIN_CUSTOMER_NK,
          SP_DTL.CUSTOMER_NK,
          SP_DTL.CUSTOMER_NAME,
          SP_DTL.PRICE_COLUMN,
          SP_DTL.CUSTOMER_TYPE,
          SP_DTL.REF_BID_NUMBER,
          SP_DTL.SOURCE_ORDER,
          SP_DTL.ORDER_ENTRY_DATE,
          SP_DTL.COPY_SOURCE_HIST,
          SP_DTL.CONTRACT_DESCRIPTION,
          SP_DTL.CONTRACT_NUMBER
     FROM (SELECT SP_HIST.*, --PROCESS DATE CHANGED TO INCLUDE INVOICE PROCESSING DATE
                  --PRICE CATEGORY CHANGE TO INCLUDE ROUNDING AND NDP
                  CASE
                     WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                     THEN
                        CASE
                           WHEN SP_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                                  PR_OVR_JOB.INSERT_TIMESTAMP
                                                                - 2,
                                                                  PR_OVR_BASE.INSERT_TIMESTAMP
                                                                - 2)
                                                         AND COALESCE (
                                                                PR_OVR_JOB.EXPIRE_DATE,
                                                                PR_OVR_BASE.EXPIRE_DATE,
                                                                SP_HIST.PROCESS_DATE)
                           THEN
                              CASE
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         COALESCE (PR_OVR_JOB.MULTIPLIER,
                                                   PR_OVR_BASE.MULTIPLIER)
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         (  TRUNC (
                                               COALESCE (
                                                  PR_OVR_JOB.MULTIPLIER,
                                                  PR_OVR_BASE.MULTIPLIER),
                                               2)
                                          + .01)
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         (ROUND (
                                             COALESCE (
                                                PR_OVR_JOB.MULTIPLIER,
                                                PR_OVR_BASE.MULTIPLIER),
                                             2))
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         (  TRUNC (
                                               COALESCE (
                                                  PR_OVR_JOB.MULTIPLIER,
                                                  PR_OVR_BASE.MULTIPLIER),
                                               1)
                                          + .1)
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (
                                              COALESCE (
                                                 PR_OVR_JOB.MULTIPLIER,
                                                 PR_OVR_BASE.MULTIPLIER))
                                         + 1
                                 THEN
                                    'OVERRIDE'
                                 WHEN TO_CHAR (SP_HIST.UNIT_NET_PRICE_AMOUNT) =
                                         COALESCE (PR_OVR_JOB.FORMULA,
                                                   PR_OVR_BASE.FORMULA)
                                 THEN
                                    'OVERRIDE'
                                 WHEN REPLACE (SP_HIST.PRICE_FORMULA,
                                               '0.',
                                               '.') =
                                         REPLACE (
                                            COALESCE (PR_OVR_JOB.FORMULA,
                                                      PR_OVR_BASE.FORMULA),
                                            '0.',
                                            '.')
                                 THEN
                                    'OVERRIDE'
                              END
                        END
                  END
                     PRICE_CATEGORY_OVR_PR,
                  CASE
                     WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                     THEN
                        CASE
                           WHEN SP_HIST.PROCESS_DATE BETWEEN (  PR_OVR_JOB.INSERT_TIMESTAMP
                                                              - 2)
                                                         AND PR_OVR_JOB.EXPIRE_DATE
                           THEN
                              CASE
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         PR_OVR_JOB.MULTIPLIER
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         (  TRUNC (PR_OVR_JOB.MULTIPLIER, 2)
                                          + .01)
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         (ROUND (PR_OVR_JOB.MULTIPLIER, 2))
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         (  TRUNC (PR_OVR_JOB.MULTIPLIER, 1)
                                          + .1)
                                 THEN
                                    'OVERRIDE'
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                         FLOOR (PR_OVR_JOB.MULTIPLIER) + 1
                                 THEN
                                    'OVERRIDE'
                                 WHEN TO_CHAR (SP_HIST.UNIT_NET_PRICE_AMOUNT) =
                                         (PR_OVR_JOB.FORMULA)
                                 THEN
                                    'OVERRIDE'
                                 WHEN REPLACE (SP_HIST.PRICE_FORMULA,
                                               '0.',
                                               '.') =
                                         REPLACE (PR_OVR_JOB.FORMULA,
                                                  '0.',
                                                  '.')
                                 THEN
                                    'OVERRIDE'
                              END
                        END
                  END
                     PRICE_CATEGORY_OVR_PR_JOB,
                  --PROCESS DATE CHANGED TO INCLUDE INVOICE PROCESSING DATE
                  --PRICE CATEGORY CHANGE TO INCLUDE ROUNDING AND NDP
                  CASE
                     WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                     THEN
                        CASE
                           WHEN SP_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                                  GR_OVR_JOB.INSERT_TIMESTAMP
                                                                - 1,
                                                                  GR_OVR_BASE.INSERT_TIMESTAMP
                                                                - 1)
                                                         AND COALESCE (
                                                                GR_OVR_JOB.EXPIRE_DATE,
                                                                GR_OVR_BASE.EXPIRE_DATE,
                                                                SP_HIST.PROCESS_DATE)
                           THEN
                              CASE
                                 WHEN REPLACE (SP_HIST.PRICE_FORMULA,
                                               '0.',
                                               '.') =
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
                  END
                     PRICE_CATEGORY_OVR_GR,
                  COALESCE (PR_OVR_JOB.FORMULA, PR_OVR_BASE.FORMULA) PR_OVR,
                  REPLACE (
                     COALESCE (PR_OVR_JOB.FORMULA, PR_OVR_BASE.FORMULA),
                     '0.',
                     '.')
                     PR_TRIM_FORM,
                  COALESCE (PR_OVR_JOB.BASIS, PR_OVR_BASE.BASIS) PR_OVR_BASIS,
                  COALESCE (GR_OVR_JOB.FORMULA, GR_OVR_BASE.FORMULA) GR_OVR,
                  REPLACE (
                     COALESCE (GR_OVR_JOB.FORMULA, GR_OVR_BASE.FORMULA),
                     '0.',
                     '.')
                     GR_TRIM_FORM,
                  COALESCE (PR_OVR_JOB.INSERT_TIMESTAMP,
                            PR_OVR_BASE.INSERT_TIMESTAMP)
                     PR_CCOR_CREATE,
                  COALESCE (PR_OVR_JOB.EXPIRE_DATE, PR_OVR_BASE.EXPIRE_DATE)
                     PR_CCOR_EXPIRE,
                  COALESCE (GR_OVR_JOB.INSERT_TIMESTAMP,
                            GR_OVR_BASE.INSERT_TIMESTAMP)
                     GR_CCOR_CREATE,
                  COALESCE (GR_OVR_JOB.EXPIRE_DATE, GR_OVR_BASE.EXPIRE_DATE)
                     GR_CCOR_EXPIRE,
                  COALESCE (PR_OVR_JOB.INSERT_TIMESTAMP,
                            GR_OVR_JOB.INSERT_TIMESTAMP,
                            PR_OVR_BASE.INSERT_TIMESTAMP,
                            GR_OVR_BASE.INSERT_TIMESTAMP)
                     CCOR_CREATE,
                  COALESCE (PR_OVR_JOB.EXPIRE_DATE,
                            GR_OVR_JOB.EXPIRE_DATE,
                            PR_OVR_BASE.EXPIRE_DATE,
                            GR_OVR_BASE.EXPIRE_DATE)
                     CCOR_EXPIRE,
                  LB.LINEBUY_NAME,
                  DG.DISCOUNT_GROUP_NAME,
                  MV.MASTER_VENDOR_NAME
             FROM (SELECT IHF.ACCOUNT_NUMBER,
                          IHF.YEARMONTH,
                          CUST.ACCOUNT_NAME,
                          IHF.WAREHOUSE_NUMBER,
                          IHF.INVOICE_NUMBER_NK,
                          IHF.JOB_NAME,
                          IHF.CONTRACT_DESCRIPTION,
                          IHF.CONTRACT_NUMBER,
                          IHF.OML_ASSOC_NAME,
                          CASE WHEN ILF.SHIPPED_QTY > 0 THEN 1 ELSE 0 END
                             INVOICE_LINES,
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
                          IHF.CHANNEL_TYPE,
                          IHF.SHIP_VIA_NAME,
                          ICD.ORDER_CHANNEL,
                          ICD.DELIVERY_CHANNEL,
                          NVL (IHF.WRITER, IHF.OML_ASSOC_INI) WRITER,
                             SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
                                     0,
                                     1)
                          || SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), -1)
                             WR_FL_INI,
                          IHF.OML_ASSOC_INI,
                             SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
                          || SUBSTR (IHF.OML_ASSOC_INI, -1)
                             OML_FL_INI,
                          CASE
                             WHEN NVL (IHF.WRITER, IHF.OML_ASSOC_INI) =
                                     IHF.OML_ASSOC_INI
                             THEN
                                IHF.OML_ASSOC_NAME
                             WHEN    SUBSTR (
                                        NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
                                        0,
                                        1)
                                  || SUBSTR (
                                        NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
                                        -1) =
                                        SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
                                     || SUBSTR (IHF.OML_ASSOC_INI, -1)
                             THEN
                                IHF.OML_ASSOC_NAME
                             ELSE
                                NULL
                          END
                             ASSOC_NAME,
                          ILF.INVOICE_LINE_NUMBER,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.MANUFACTURER
                             ELSE
                                SP_PROD.PRIMARY_VNDR
                          END
                             AS MANUFACTURER,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.PRODUCT_NK
                             ELSE
                                SP_PROD.SPECIAL_PRODUCT_NK
                          END
                             AS PRODUCT_NK,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.ALT1_CODE
                             ELSE
                                SP_PROD.ALT_CODE
                          END
                             AS ALT1_CODE,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.DISCOUNT_GROUP_NK
                             ELSE
                                SP_PROD.SPECIAL_DISC_GROUP
                          END
                             AS DISCOUNT_GROUP_NK,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.LINEBUY_NK
                             ELSE
                                SP_PROD.SPECIAL_LINE
                          END
                             AS LINEBUY_NK,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.PRODUCT_NAME
                             ELSE
                                SP_PROD.SPECIAL_PRODUCT_NAME
                          END
                             AS PRODUCT_NAME,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                NVL (ILF.PRODUCT_STATUS, 'STOCK')
                             ELSE
                                'SP-'
                          END
                             AS STATUS,
                          CASE
                             WHEN ILF.EXT_SALES_AMOUNT <= 1500 THEN 'Y'
                             ELSE 'N'
                          END
                             "<1500",
                          PROD.UNIT_OF_MEASURE UM,
                          PROD.SELL_MULT,
                          PROD.SELL_PACKAGE_QTY PACK_QTY,
                          ILF.SHIPPED_QTY,
                          ILF.EXT_AVG_COGS_AMOUNT,
                          ILF.EXT_SALES_AMOUNT,
                          ILF.CORE_ADJ_AVG_COST,
                          --PRICE CATEGORY DEFINITION TO INCLUDE
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
                                   WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                           ILF.MATRIX
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
                             WHEN REGEXP_LIKE (ILF.PRICE_CODE,
                                               '[0-9]?[0-9]?[0-9]')
                             THEN
                                'MATRIX'
                             WHEN ILF.PRICE_CODE IN ('FC', 'PM', 'SPEC')
                             THEN
                                'MATRIX'
                             WHEN ILF.PRICE_CODE LIKE 'M%'
                             THEN
                                'MATRIX'
                             WHEN ILF.PRICE_FORMULA IN ('CPA', 'CPO')
                             THEN
                                'OVERRIDE'
                             WHEN ILF.PRICE_CODE IN ('PR',
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
                             WHEN ILF.PRICE_CODE IN ('GI',
                                                     'GPC',
                                                     'HPF',
                                                     'HPN',
                                                     'NC')
                             THEN
                                'MANUAL'
                             WHEN ILF.PRICE_CODE = '*E'
                             THEN
                                'OTH/ERROR'
                             WHEN ILF.PRICE_CODE = 'SKC'
                             THEN
                                'OTH/ERROR'
                             WHEN ILF.PRICE_CODE IN ('%',
                                                     '$',
                                                     'N',
                                                     'F',
                                                     'B',
                                                     'PO')
                             THEN
                                'TOOLS'
                             WHEN ILF.PRICE_CODE IS NULL
                             THEN
                                'MANUAL'
                             WHEN ILF.PRICE_CODE IN ('R', 'N/A')
                             THEN
                                CASE
                                   WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                           ILF.MATRIX_PRICE
                                   THEN
                                      'MATRIX'
                                   WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                           ILF.MATRIX
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
                                   --PRICE CATEGORY DEFINED FOR NDP
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
                             AS PRICE_CATEGORY,
                          --PRICE CATEGORY DEFINITION USING ORIG PRICE CODE
                          CASE
                             WHEN IHF.ORDER_CODE = 'IC'
                             THEN
                                'CREDITS'
                             WHEN ILF.SPECIAL_PRODUCT_GK IS NOT NULL
                             THEN
                                'SPECIALS'
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) =
                                     'Q'
                             THEN
                                CASE
                                   WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                           ILF.MATRIX_PRICE
                                   THEN
                                      'MATRIX'
                                   WHEN ILF.UNIT_NET_PRICE_AMOUNT =
                                           ILF.MATRIX
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
                                     NVL (ILF.ORIG_PRICE_CODE,
                                          ILF.PRICE_CODE),
                                     '[0-9]?[0-9]?[0-9]')
                             THEN
                                'MATRIX'
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN ('FC',
                                                                                'PM',
                                                                                'SPEC')
                             THEN
                                'MATRIX'
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) LIKE
                                     'M%'
                             THEN
                                'NDP'
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN ('CPA',
                                                                                'CPO')
                             THEN
                                'OVERRIDE'
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN ('PR',
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
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN ('GI',
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
                             WHEN NVL (ILF.ORIG_PRICE_CODE, ILF.PRICE_CODE) IN ('%',
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
                             AS ORIG_PRICE_CATEGORY,
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
                          ILF.MATRIX_PRICE OG_MATRIX,
                          NVL (ILF.MATRIX_PRICE, ILF.MATRIX) MATRIX_PRICE,
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
                          CUST.CUSTOMER_TYPE
                     FROM DW_FEI.INVOICE_HEADER_FACT IHF,
                          DW_FEI.INVOICE_LINE_FACT ILF,
                          DW_FEI.PRODUCT_DIMENSION PROD,
                          DW_FEI.CUSTOMER_DIMENSION CUST,
                          DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD,
                          SALES_MART.SALES_WAREHOUSE_DIM SWD,
                          SALES_MART.INVOICE_CHANNEL_DIMENSION ICD
                          --DW_FEI.INVOICE_LINE_CORE_FACT ILCF
                    WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                          AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
                          AND SWD.WAREHOUSE_NUMBER_NK = IHF.WAREHOUSE_NUMBER
                          AND IHF.INVOICE_NUMBER_GK = ICD.INVOICE_NUMBER_GK
                          --AND IHF.INVOICE_NUMBER_GK = ILCF.INVOICE_NUMBER_GK
                          --AND ILCF.YEARMONTH = ILF.YEARMONTH
                          --AND ILCF.INVOICE_LINE_NUMBER = ILF.INVOICE_LINE_NUMBER
                          --AND ILCF.SELL_WAREHOUSE_NUMBER_NK = ILF.SELL_WAREHOUSE_NUMBER_NK
                          --AND PROD.MANUFACTURER = '774'
                          --AND ILF.
                          --AND IHF.ACCOUNT_NUMBER = 215
                          --AND IHF.WRITER = 'JPB'
                          --AND CUST.CUSTOMER_NK = '19037'
                          --AND IHF.REF_BID_NUMBER <> 'N/A'
                          AND DECODE (NVL (CUST.AR_GL_NUMBER, '9999'),
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
                          AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
                          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
                          AND ILF.SPECIAL_PRODUCT_GK =
                                 SP_PROD.SPECIAL_PRODUCT_GK(+)
                          AND IHF.IC_FLAG = 0
                          AND ILF.SHIPPED_QTY <> 0
                          --AND IHF.ORDER_CODE NOT IN 'IC'
                          --EXCLUDES SHIPMENTS TO OTHER FEI LOCATIONS.
                          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
                          AND ILF.YEARMONTH =
                                 TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                          'YYYYMM')
                          AND IHF.YEARMONTH =
                                 TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                          'YYYYMM')) SP_HIST
                  LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
                     ON SP_HIST.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
                  LEFT OUTER JOIN DW_FEI.LINE_BUY_DIMENSION LB
                     ON SP_HIST.LINEBUY_NK = LB.LINEBUY_NK
                  LEFT OUTER JOIN DW_FEI.MASTER_VENDOR_DIMENSION MV
                     ON SP_HIST.MANUFACTURER = MV.MASTER_VENDOR_NK
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
                             COD.BASIS
                          || COD.OPERATOR_USED
                          || '0'
                          || COD.MULTIPLIER
                             FORMULA
                     FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
                          DW_FEI.CUSTOMER_DIMENSION CUST
                    WHERE     COD.OVERRIDE_TYPE = 'G'
                          AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
                          AND COD.DELETE_DATE IS NULL
                          AND CUST.JOB_YN = 'Y'
                          AND NVL (COD.EXPIRE_DATE, SYSDATE) >=
                                 (SYSDATE - 62)) GR_OVR_JOB
                     ON (    SP_HIST.DISCOUNT_GROUP_NK =
                                (LTRIM (GR_OVR_JOB.DISC_GROUP, '0'))
                         AND SP_HIST.ACCOUNT_NUMBER =
                                GR_OVR_JOB.BRANCH_NUMBER_NK
                         AND SP_HIST.CUSTOMER_ACCOUNT_GK =
                                GR_OVR_JOB.CUSTOMER_GK
                         AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
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
                             COD.BASIS
                          || COD.OPERATOR_USED
                          || '0'
                          || COD.MULTIPLIER
                             FORMULA
                     FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD,
                          DW_FEI.CUSTOMER_DIMENSION CUST
                    WHERE     COD.OVERRIDE_TYPE = 'G'
                          AND COD.CUSTOMER_GK = CUST.CUSTOMER_GK
                          AND COD.DELETE_DATE IS NULL
                          AND CUST.JOB_YN = 'N'
                          AND NVL (COD.EXPIRE_DATE, SYSDATE) >=
                                 (SYSDATE - 62)) GR_OVR_BASE
                     ON (    SP_HIST.DISCOUNT_GROUP_NK =
                                (LTRIM (GR_OVR_BASE.DISC_GROUP, '0'))
                         AND SP_HIST.ACCOUNT_NUMBER =
                                GR_OVR_BASE.BRANCH_NUMBER_NK
                         AND SP_HIST.MAIN_CUSTOMER_NK =
                                GR_OVR_BASE.CUSTOMER_NK
                         AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                                NVL (GR_OVR_BASE.CONTRACT_ID,
                                     'DEFAULT_MATCH'))
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
                          TO_NUMBER (COD.MULTIPLIER) MULTIPLIER,
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
                          AND NVL (COD.EXPIRE_DATE, SYSDATE) >=
                                 (SYSDATE - 62)) PR_OVR_JOB
                     ON (    SP_HIST.PRODUCT_NK = PR_OVR_JOB.MASTER_PRODUCT
                         AND SP_HIST.ACCOUNT_NUMBER =
                                PR_OVR_JOB.BRANCH_NUMBER_NK
                         AND SP_HIST.CUSTOMER_ACCOUNT_GK =
                                PR_OVR_JOB.CUSTOMER_GK
                         AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                                NVL (PR_OVR_JOB.CONTRACT_ID, 'DEFAULT_MATCH'))
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
                          TO_NUMBER (COD.MULTIPLIER) MULTIPLIER,
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
                          AND NVL (COD.EXPIRE_DATE, SYSDATE) >=
                                 (SYSDATE - 62)) PR_OVR_BASE
                     ON (    SP_HIST.PRODUCT_NK = PR_OVR_BASE.MASTER_PRODUCT
                         AND SP_HIST.ACCOUNT_NUMBER =
                                PR_OVR_BASE.BRANCH_NUMBER_NK
                         AND SP_HIST.MAIN_CUSTOMER_NK =
                                PR_OVR_BASE.CUSTOMER_NK
                         AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                                NVL (PR_OVR_BASE.CONTRACT_ID,
                                     'DEFAULT_MATCH'))) SP_DTL
        --WHERE SP_DTL.DISCOUNT_GROUP_NK IN ('5590','5594', '5605', '5606', '5608', '5617', '5786')
;

GRANT SELECT ON AAA6863.PR_VICT2_CUST_12MO TO PUBLIC;