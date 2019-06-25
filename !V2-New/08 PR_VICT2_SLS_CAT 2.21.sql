TRUNCATE TABLE PRICE_MGMT.PR_VICT2_SLS_CAT;
DROP TABLE PRICE_MGMT.PR_VICT2_SLS_CAT;

CREATE TABLE PRICE_MGMT.PR_VICT2_SLS_CAT
NOLOGGING
AS
   SELECT DISTINCT
          V.YEARMONTH,
          V.EOM_YEARMONTH,
          V.ACCOUNT_NUMBER,
          V.ACCOUNT_NAME,
          V.WAREHOUSE_NUMBER,
          V.INVOICE_NUMBER_NK,
          V.INVOICE_NUMBER_GK,
          V.TYPE_OF_SALE,
          V.SHIP_VIA_NAME,
          V.OML_ASSOC_INI,
          V.OML_FL_INI,
          V.OML_ASSOC_NAME,
          V.WRITER,
          V.WR_FL_INI,
          V.ASSOC_NAME,
          V.DISCOUNT_GROUP_NK,
          V.DISCOUNT_GROUP_NAME,
          V.CHANNEL_TYPE,
          V.INVOICE_LINE_NUMBER,
          V.MANUFACTURER,
          V.PRODUCT_NK,
          V.ALT1_CODE,
          V.PRODUCT_NAME,
          V.STATUS,
          V.SHIPPED_QTY,
          V.EXT_WEIGHT_LB,
          V.EXT_SALES_AMOUNT,
          V.PRODUCT_GK,
          V.SPECIAL_PRODUCT_GK,
          V.INSERT_TIMESTAMP INSERT_TIMESTAMP_IHF,
          V.PROCESS_DATE,
          V.EXT_AVG_COGS_AMOUNT,
          V.CORE_ADJ_AVG_COST,
          V.ORDER_CHANNEL,
          V.DELIVERY_CHANNEL,
          V.REPLACEMENT_COST,
          V.UNIT_INV_COST,
          V.PRICE_CODE,
          COALESCE (V.PRICE_CATEGORY_OVR_PR,
                    V.PRICE_CATEGORY_OVR_GR,
                    V.PRICE_CATEGORY)
             PRICE_CATEGORY,
          V.ORIG_PRICE_CODE,
          V.GR_OVR,
          V.PR_OVR,
          V.PRICE_FORMULA,
          V.UNIT_NET_PRICE_AMOUNT,
          V.UM,
          V.SELL_MULT,
          V.PACK_QTY,
          V.LIST_PRICE,
          V.MATRIX_PRICE,
          V.MATRIX,
          CASE
             WHEN V.PRICE_CATEGORY_OVR_PR IS NOT NULL THEN V.PR_OVR
             ELSE NULL
          END
             PR_TRIM_FORM,
          CASE
             WHEN V.PRICE_CATEGORY_OVR_PR IS NOT NULL THEN V.PR_OVR_BASIS
             ELSE NULL
          END
             PR_OVR_BASIS,
          CASE
             WHEN V.PRICE_CATEGORY_OVR_GR IS NOT NULL THEN V.GR_OVR
             ELSE NULL
          END
             GR_TRIM_FORM,
          V.ORDER_CODE,
          V.SOURCE_SYSTEM,
          V.CONSIGN_TYPE,
          V.MAIN_CUSTOMER_NK,
          V.CUSTOMER_ACCOUNT_GK,
          V.CUSTOMER_NK,
          V.CUSTOMER_NAME,
          V.PRICE_COLUMN,
          V.CUSTOMER_TYPE,
          V.REF_BID_NUMBER,
          V.SOURCE_ORDER,
          V.ORDER_ENTRY_DATE,
          V.COPY_SOURCE_HIST,
          V.CONTRACT_DESCRIPTION,
          V.CONTRACT_NUMBER,
          V.SALESREP_NK,
          V.SALESREP_NAME,
          CASE
             WHEN     COALESCE (V.PRICE_CATEGORY_OVR_PR,
                                V.PRICE_CATEGORY_OVR_GR,
                                V.PRICE_CATEGORY) IN
                         ('MANUAL', 'QUOTE', 'MATRIX_BID')
                  AND V.ORIG_PRICE_CODE IS NOT NULL
                  AND NVL (V.REF_BID_NUMBER, 'N/A') <> 'N/A'
             THEN
                CASE
                   WHEN REGEXP_LIKE (V.orig_price_code, '[0-9]?[0-9]?[0-9]')
                   THEN
                      'MATRIX'
                   WHEN V.orig_price_code IN ('FC', 'PM', 'spec')
                   THEN
                      'MATRIX'
                   WHEN V.orig_price_code LIKE 'M%'
                   THEN
                      'NDP'
                   WHEN V.orig_price_code IN ('CPA', 'CPO')
                   THEN
                      'OVERRIDE'
                   WHEN V.orig_price_code IN ('PR',
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
                   WHEN V.orig_price_code IN ('GI',
                                              'GPC',
                                              'HPF',
                                              'HPN',
                                              'NC')
                   THEN
                      'MANUAL'
                   WHEN V.orig_price_code = '*E'
                   THEN
                      'OTH/ERROR'
                   WHEN V.orig_price_code = 'SKC'
                   THEN
                      'OTH/ERROR'
                   WHEN V.orig_price_code IN ('%',
                                              '$',
                                              'N',
                                              'F',
                                              'B',
                                              'PO')
                   THEN
                      'TOOLS'
                   WHEN V.orig_price_code IS NULL
                   THEN
                      'MANUAL'
                   ELSE
                      'MANUAL'
                END
             ELSE
                COALESCE (V.PRICE_CATEGORY_OVR_PR,
                          V.PRICE_CATEGORY_OVR_GR,
                          V.PRICE_CATEGORY)
          END
             PRICE_CATEGORY_FINAL,
          V.INVOICE_DATE,
          V.MASTER_VENDOR_NAME,
          V.BASE_GROUP_FORM,
          V.JOB_GROUP_FORM,
          V.BASE_PROD_FORM,
          V.JOB_PROD_FORM,
          V.COST_CODE_IND,
          V.VENDOR_NAME,
          V.VENDOR_AGREEMENT,
          V.CONTRACT_NAME,
          V.SUBLINE_QTY,
          V.SUBLINE_COST,
          V.CLAIM_AMOUNT
   FROM (SELECT SP_HIST.*,
                GR_OVR_BASE.FORMULA
                   BASE_GROUP_FORM,
                GR_OVR_JOB.FORMULA
                   JOB_GROUP_FORM,
                PR_OVR_BASE.FORMULA
                   BASE_PROD_FORM,
                PR_OVR_JOB.FORMULA
                   JOB_PROD_FORM,
                CASE
                   WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                   THEN
                      CASE
                         WHEN (   SP_HIST.ORDER_ENTRY_DATE BETWEEN COALESCE (
                                                                        PR_OVR_JOB.INSERT_TIMESTAMP
                                                                      - 1,
                                                                        PR_OVR_BASE.INSERT_TIMESTAMP
                                                                      - 1)
                                                               AND COALESCE (
                                                                      PR_OVR_JOB.EXPIRE_DATE,
                                                                      PR_OVR_BASE.EXPIRE_DATE,
                                                                      SP_HIST.ORDER_ENTRY_DATE)
                               OR SP_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                                    PR_OVR_JOB.INSERT_TIMESTAMP
                                                                  - 1,
                                                                    PR_OVR_BASE.INSERT_TIMESTAMP
                                                                  - 1)
                                                           AND COALESCE (
                                                                  PR_OVR_JOB.EXPIRE_DATE,
                                                                  PR_OVR_BASE.EXPIRE_DATE,
                                                                  SP_HIST.ORDER_ENTRY_DATE))
                         THEN
                            CASE
                               WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                    COALESCE (PR_OVR_JOB.MULTIPLIER,
                                              PR_OVR_BASE.MULTIPLIER)
                               THEN
                                  'OVERRIDE'
                               WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                    (  TRUNC (
                                          COALESCE (PR_OVR_JOB.MULTIPLIER,
                                                    PR_OVR_BASE.MULTIPLIER),
                                          2)
                                     + .01)
                               THEN
                                  'OVERRIDE'
                               WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                    (ROUND (
                                        COALESCE (PR_OVR_JOB.MULTIPLIER,
                                                  PR_OVR_BASE.MULTIPLIER),
                                        2))
                               THEN
                                  'OVERRIDE'
                               WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                    (  TRUNC (
                                          COALESCE (PR_OVR_JOB.MULTIPLIER,
                                                    PR_OVR_BASE.MULTIPLIER),
                                          1)
                                     + .1)
                               THEN
                                  'OVERRIDE'
                               WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
                                      FLOOR (
                                         COALESCE (PR_OVR_JOB.MULTIPLIER,
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
                         WHEN (   SP_HIST.ORDER_ENTRY_DATE BETWEEN COALESCE (
                                                                        GR_OVR_JOB.INSERT_TIMESTAMP
                                                                      - 1,
                                                                        GR_OVR_BASE.INSERT_TIMESTAMP
                                                                      - 1)
                                                               AND COALESCE (
                                                                      GR_OVR_JOB.EXPIRE_DATE,
                                                                      GR_OVR_BASE.EXPIRE_DATE,
                                                                      SP_HIST.ORDER_ENTRY_DATE)
                               OR SP_HIST.PROCESS_DATE BETWEEN COALESCE (
                                                                    GR_OVR_JOB.INSERT_TIMESTAMP
                                                                  - 1,
                                                                    GR_OVR_BASE.INSERT_TIMESTAMP
                                                                  - 1)
                                                           AND COALESCE (
                                                                  GR_OVR_JOB.EXPIRE_DATE,
                                                                  GR_OVR_BASE.EXPIRE_DATE,
                                                                  SP_HIST.ORDER_ENTRY_DATE))
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
                COALESCE (PR_OVR_JOB.FORMULA, PR_OVR_BASE.FORMULA)
                   PR_OVR,
                REPLACE (COALESCE (PR_OVR_JOB.FORMULA, PR_OVR_BASE.FORMULA),
                         '0.',
                         '.')
                   PR_TRIM_FORM,
                COALESCE (PR_OVR_JOB.BASIS, PR_OVR_BASE.BASIS)
                   PR_OVR_BASIS,
                COALESCE (GR_OVR_JOB.FORMULA, GR_OVR_BASE.FORMULA)
                   GR_OVR,
                REPLACE (COALESCE (GR_OVR_JOB.FORMULA, GR_OVR_BASE.FORMULA),
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
                --LB.LINEBUY_NAME,
                DG.DISCOUNT_GROUP_NAME,
                MV.MASTER_VENDOR_NAME,
                CORE.COST_CODE_IND,
                CORE.VENDOR_NAME,
                CORE.VENDOR_AGREEMENT,
                CORE.CONTRACT_NAME,
                CORE.SUBLINE_QTY,
                CORE.SUBLINE_COST,
                CORE.CLAIM_AMOUNT
         FROM PRICE_MGMT.PR_VICT2_SLS SP_HIST
              LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
                 ON SP_HIST.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
              --LEFT OUTER JOIN DW_FEI.LINE_BUY_DIMENSION LB
              --   ON SP_HIST.LINEBUY_NK = LB.LINEBUY_NK
              LEFT OUTER JOIN DW_FEI.MASTER_VENDOR_DIMENSION MV
                 ON SP_HIST.MANUFACTURER = MV.MASTER_VENDOR_NK
              LEFT OUTER JOIN PRICE_MGMT.GR_OVR_JOB
                 ON (    SP_HIST.DISCOUNT_GROUP_NK = GR_OVR_JOB.DISC_GROUP
                     AND SP_HIST.ACCOUNT_NUMBER = GR_OVR_JOB.BRANCH_NUMBER_NK
                     AND SP_HIST.CUSTOMER_ACCOUNT_GK = GR_OVR_JOB.CUSTOMER_GK
                     AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                         NVL (GR_OVR_JOB.CONTRACT_ID, 'DEFAULT_MATCH'))
              LEFT OUTER JOIN PRICE_MGMT.GR_OVR_BASE
                 ON (    SP_HIST.DISCOUNT_GROUP_NK = GR_OVR_BASE.DISC_GROUP
                     AND SP_HIST.ACCOUNT_NUMBER =
                         GR_OVR_BASE.BRANCH_NUMBER_NK
                     AND SP_HIST.MAIN_CUSTOMER_NK = GR_OVR_BASE.CUSTOMER_NK
                     AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                         NVL (GR_OVR_BASE.CONTRACT_ID, 'DEFAULT_MATCH'))
              LEFT OUTER JOIN PRICE_MGMT.PR_OVR_JOB
                 ON (    SP_HIST.PRODUCT_NK = PR_OVR_JOB.MASTER_PRODUCT
                     AND SP_HIST.ACCOUNT_NUMBER = PR_OVR_JOB.BRANCH_NUMBER_NK
                     AND SP_HIST.CUSTOMER_ACCOUNT_GK = PR_OVR_JOB.CUSTOMER_GK
                     AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                         NVL (PR_OVR_JOB.CONTRACT_ID, 'DEFAULT_MATCH'))
              LEFT OUTER JOIN PRICE_MGMT.PR_OVR_BASE
                 ON (    SP_HIST.PRODUCT_NK = PR_OVR_BASE.MASTER_PRODUCT
                     AND SP_HIST.ACCOUNT_NUMBER =
                         PR_OVR_BASE.BRANCH_NUMBER_NK
                     AND SP_HIST.MAIN_CUSTOMER_NK = PR_OVR_BASE.CUSTOMER_NK
                     AND NVL (SP_HIST.CONTRACT_NUMBER, 'DEFAULT_MATCH') =
                         NVL (PR_OVR_BASE.CONTRACT_ID, 'DEFAULT_MATCH'))
              LEFT OUTER JOIN PRICE_MGMT.CORE_CLAIM_VDR CORE
                 ON     SP_HIST.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK
                    AND SP_HIST.INVOICE_LINE_NUMBER =
                        CORE.INVOICE_LINE_NUMBER) V