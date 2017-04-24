--DROP TABLE AAA6863.PR_VICT2_CUST_12MO;

INSERT INTO AAA6863.PR_VICT2_MANUAL_2WK

   SELECT sp_dtl.YEARMONTH,
          sp_dtl.ACCOUNT_NUMBER,
          sp_dtl.ACCOUNT_NAME,
          sp_dtl.WAREHOUSE_NUMBER,
          sp_dtl.INVOICE_NUMBER_NK,
          sp_dtl.TYPE_OF_SALE,
          sp_dtl.SHIP_VIA_NAME,
          sp_dtl.SALESREP_NK,
          sp_dtl.SALESREP_NAME,
          sp_dtl.OML_ASSOC_INI,
          sp_dtl.OML_FL_INI,
          sp_dtl.OML_ASSOC_NAME,
          sp_dtl.WRITER,
          sp_dtl.WR_FL_INI,
          sp_dtl.ASSOC_NAME,
          sp_dtl.DISCOUNT_GROUP_NK,
          sp_Dtl.DISCOUNT_GROUP_NAME,
          sp_Dtl.CHANNEL_TYPE,
          sp_dtl.INVOICE_LINE_NUMBER,
          sp_dtl.MANUFACTURER,
          sp_dtl.MASTER_VENDOR_NAME,
          sp_dtl.PRODUCT_NK,
          sp_dtl.ALT1_CODE,
          sp_dtl.PRODUCT_NAME,
          sp_dtl.STATUS,
          sp_dtl.SHIPPED_QTY,
          sp_dtl.EXT_SALES_AMOUNT,
          sp_dtl.EXT_AVG_COGS_AMOUNT,
          sp_dtl.REPLACEMENT_COST,
          sp_dtl.UNIT_INV_COST,
          sp_dtl.PRICE_CODE,
          sp_dtl.PRICE_CATEGORY,
          sp_dtl.PRICE_CATEGORY_OVR_PR,
          sp_dtl.PRICE_CATEGORY_OVR_GR,
          sp_dtl.PRICE_FORMULA,
          sp_dtl.UNIT_NET_PRICE_AMOUNT,
          sp_dtl.UM,
          sp_dtl.SELL_MULT,
          sp_dtl.PACK_QTY,
          sp_dtl.LIST_PRICE,
          sp_dtl.MATRIX_PRICE,
          sp_dtl.MATRIX,
          sp_dtl.OG_MATRIX,
          sp_dtl.ORDER_CODE,
          sp_dtl.SOURCE_SYSTEM,
          sp_dtl.CONSIGN_TYPE,
          sp_dtl.CUSTOMER_NK,
          sp_dtl.CUSTOMER_NAME,
          sp_dtl.PRICE_COLUMN,
          sp_dtl.CUSTOMER_TYPE,
          sp_dtl.REF_BID_NUMBER,
          sp_dtl.SOURCE_ORDER,
          sp_dtl.ORDER_ENTRY_DATE,
          sp_dtl.COPY_SOURCE_HIST,
          sp_dtl.CONTRACT_DESCRIPTION,
          sp_dtl.CONTRACT_NUMBER,
          sp_dtl.INVOICE_DATE
     FROM (SELECT SP_HIST.*,
                  CASE
                     WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                     THEN
                        CASE
                           WHEN SP_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                                  PR_OVR_JOB.INSERT_TIMESTAMP
                                                                - 1,
                                                                  PR_OVR_BASE.INSERT_TIMESTAMP
                                                                - 1)
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
                  DG.DISCOUNT_GROUP_NAME,
                  MV.MASTER_VENDOR_NAME
             FROM (SELECT IHF.ACCOUNT_NUMBER,
                          IHF.YEARMONTH,
                          CUST.ACCOUNT_NAME,
                          REPS.SALESREP_NK,
                          REPS.SALESREP_NAME,
                          IHF.WAREHOUSE_NUMBER,
                          IHF.INVOICE_NUMBER_NK,
                          IHF.INVOICE_DATE,
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
                          IHF.SHIP_VIA_NAME,
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
                          PROD.MANUFACTURER,
                          PROD.PRODUCT_NK,
                          PROD.ALT1_CODE,
                          PROD.DISCOUNT_GROUP_NK,
                          PROD.LINEBUY_NK,
                          PROD.PRODUCT_NAME,
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
                          CASE
                             WHEN ihf.order_code = 'IC'
                             THEN
                                'CREDITS'
                             WHEN ilf.price_code = 'Q'
                             THEN
                                CASE
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX_PRICE
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX
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
                                           (ROUND (ilf.MATRIX_PRICE, 2))
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (ROUND (ilf.MATRIX, 2))
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
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (ilf.MATRIX) + 1
                                   THEN
                                      'MATRIX_BID'
                                   ELSE
                                      'QUOTE'
                                END
                             WHEN REGEXP_LIKE (ilf.price_code,
                                               '[0-9]?[0-9]?[0-9]')
                             THEN
                                'MATRIX'
                             WHEN ilf.price_code IN ('FC', 'PM', 'spec')
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
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX_PRICE
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX
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
                                           (ROUND (ilf.MATRIX_PRICE, 2))
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (ROUND (ilf.MATRIX, 2))
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
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (ilf.MATRIX) + 1
                                   THEN
                                      'MATRIX_BID'
                                   ELSE
                                      'MANUAL'
                                END
                             ELSE
                                'MANUAL'
                          END
                             AS PRICE_CATEGORY,
                          ILF.PRICE_CODE,
                          ILF.PRICE_FORMULA,
                          ILF.UNIT_NET_PRICE_AMOUNT,
                          ILF.UNIT_INV_COST,
                          ILF.REPLACEMENT_COST,
                          ILF.LIST_PRICE,
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
                          DW_FEI.SALESREP_DIMENSION REPS
                    WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                          AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
                          AND IHF.SALESREP_GK = REPS.SALESREP_GK
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
                          AND NVL (IHF.CONSIGN_TYPE, 'N/A') <> 'R'
                          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK
                          AND IHF.IC_FLAG = 0
                          AND ILF.SHIPPED_QTY <> 0
                          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
                          AND DECODE (ILF.PRICE_CODE,
                                      'R', 0,
                                      'N/A', 0,
                                      '%', 0,
                                      '$', 0,
                                      'N', 0,
                                      'F', 0,
                                      'B', 0,
                                      'PO', 0,
                                      NULL, 0) = 0
                          /*AND NVL (ILF.PRICE_CODE, 'N/A') IN ('R',
                                                              'N/A',
                                                              '%',
                                                              '$',
                                                              'N',
                                                              'F',
                                                              'B',
                                                              'PO')*/
                          AND (TRUNC (IHF.INVOICE_DATE) = TRUNC (
                                                                     SYSDATE
                                                                   - 1)
                                                            ))
                  SP_HIST
                  INNER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
                     ON SP_HIST.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
                  INNER JOIN DW_FEI.MASTER_VENDOR_DIMENSION MV
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
                                     'DEFAULT_MATCH'))) sp_dtl
    WHERE COALESCE (sp_dtl.PRICE_CATEGORY_OVR_PR,
                    sp_dtl.PRICE_CATEGORY_OVR_GR,
                    sp_dtl.PRICE_CATEGORY) = 'MANUAL'
   GROUP BY sp_dtl.YEARMONTH,
            sp_dtl.ACCOUNT_NUMBER,
            sp_dtl.ACCOUNT_NAME,
            sp_dtl.WAREHOUSE_NUMBER,
            sp_dtl.INVOICE_NUMBER_NK,
            sp_dtl.TYPE_OF_SALE,
            sp_dtl.SHIP_VIA_NAME,
            sp_dtl.SALESREP_NK,
            sp_dtl.SALESREP_NAME,
            sp_dtl.OML_ASSOC_INI,
            sp_dtl.OML_FL_INI,
            sp_dtl.OML_ASSOC_NAME,
            sp_dtl.WRITER,
            sp_dtl.WR_FL_INI,
            sp_dtl.ASSOC_NAME,
            sp_dtl.DISCOUNT_GROUP_NK,
            sp_Dtl.DISCOUNT_GROUP_NAME,
            sp_Dtl.CHANNEL_TYPE,
            sp_dtl.INVOICE_LINE_NUMBER,
            sp_dtl.MANUFACTURER,
            sp_dtl.MASTER_VENDOR_NAME,
            sp_dtl.PRODUCT_NK,
            sp_dtl.ALT1_CODE,
            sp_dtl.PRODUCT_NAME,
            sp_dtl.STATUS,
            sp_dtl.SHIPPED_QTY,
            sp_dtl.EXT_SALES_AMOUNT,
            sp_dtl.EXT_AVG_COGS_AMOUNT,
            sp_dtl.REPLACEMENT_COST,
            sp_dtl.UNIT_INV_COST,
            sp_dtl.PRICE_CODE,
            sp_dtl.PRICE_CATEGORY,
            sp_dtl.PRICE_CATEGORY_OVR_PR,
            sp_dtl.PRICE_CATEGORY_OVR_GR,
            sp_dtl.PRICE_FORMULA,
            sp_dtl.UNIT_NET_PRICE_AMOUNT,
            sp_dtl.UM,
            sp_dtl.SELL_MULT,
            sp_dtl.PACK_QTY,
            sp_dtl.LIST_PRICE,
            sp_dtl.MATRIX_PRICE,
            sp_dtl.MATRIX,
            sp_dtl.OG_MATRIX,
            sp_dtl.ORDER_CODE,
            sp_dtl.SOURCE_SYSTEM,
            sp_dtl.CONSIGN_TYPE,
            sp_dtl.CUSTOMER_NK,
            sp_dtl.CUSTOMER_NAME,
            sp_dtl.PRICE_COLUMN,
            sp_dtl.CUSTOMER_TYPE,
            sp_dtl.REF_BID_NUMBER,
            sp_dtl.SOURCE_ORDER,
            sp_dtl.ORDER_ENTRY_DATE,
            sp_dtl.COPY_SOURCE_HIST,
            sp_dtl.CONTRACT_DESCRIPTION,
            sp_dtl.CONTRACT_NUMBER,
            sp_dtl.INVOICE_DATE;

--
--GRANT SELECT ON AAA6863.PR_VICT2_CUST_12MO TO PUBLIC;