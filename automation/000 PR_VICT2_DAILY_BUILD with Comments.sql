-- COMPARE INVOICE DATA IN DW TO PRICE_MGMT ARCHIVE TO IDENTIFY NEW INVOICES SINCE LAST RUN

--01 **identify each section of code in sequence
TRUNCATE TABLE PRICE_MGMT.MISSING_INVOICES;

--02
INSERT INTO PRICE_MGMT.MISSING_INVOICES
   SELECT h.YEARMONTH,
          h.WAREHOUSE_NUMBER,
          l.INVOICE_NUMBER_GK,
          l.INVOICE_LINE_NUMBER,
          l.EXT_SALES_AMOUNT
   FROM DW_FEI.INVOICE_HEADER_FACT h
        INNER JOIN DW_FEI.INVOICE_LINE_FACT l
           ON (h.INVOICE_NUMBER_GK = l.INVOICE_NUMBER_GK)
        LEFT OUTER JOIN PRICE_MGMT.PR_PRICE_CAT_HIST p
           ON (    l.INVOICE_NUMBER_GK = p.INVOICE_NUMBER_GK
               AND l.INVOICE_LINE_NUMBER = p.INVOICE_LINE_NUMBER)
        LEFT OUTER JOIN PRICE_MGMT.PR_VICT2_CUST_R2MO c
           ON h.INVOICE_NUMBER_GK = c.INVOICE_NUMBER_GK
   WHERE     h.IC_FLAG = 0
         AND h.INSERT_TIMESTAMP > SYSDATE - 7
         AND h.PO_WAREHOUSE_NUMBER IS NULL
         AND p.INVOICE_NUMBER_GK IS NULL
         AND p.INVOICE_LINE_NUMBER IS NULL
         AND c.INVOICE_NUMBER_GK IS NULL;

--03
COMMIT;

-- BUILD OUT DETAILS ON NEW INVOICE LINES FOR MASTER PRODUCTS

--04
TRUNCATE TABLE PRICE_MGMT.PR_VICT2_SLS;

--05
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
          PROD.MANUFACTURER,
          PROD.PRODUCT_NK,
          PROD.ALT1_CODE,
          PROD.DISCOUNT_GROUP_NK,
          PROD.LINEBUY_NK,
          PROD.PRODUCT_NAME,
          NVL (ILF.PRODUCT_STATUS, 'STOCK')
             AS STATUS,
          CASE WHEN ILF.EXT_SALES_AMOUNT <= 1500 THEN 'Y' ELSE 'N' END
             "<1500",
          PROD.UNIT_OF_MEASURE
             UM,
          PROD.SELL_MULT,
          PROD.SELL_PACKAGE_QTY
             PACK_QTY,
          ILF.SHIPPED_QTY,
          ILF.EXT_AVG_COGS_AMOUNT,
          ILF.CORE_ADJ_AVG_COST,
          ILF.EXT_SALES_AMOUNT,
          ILF.EXT_WEIGHT_LB,
          ILF.EXT_ACTUAL_COGS_AMOUNT,
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
                   WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND (ilf.MATRIX, 2))
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
                   WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX_PRICE
                   THEN
                      'MATRIX'
                   WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX
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
                   WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND (ilf.MATRIX, 2))
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
             AS PRICE_CATEGORY,
          ILF.PRICE_CODE,
          ILF.ORIG_PRICE_CODE,
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
          IHF.INSERT_TIMESTAMP
   FROM DW_FEI.INVOICE_HEADER_FACT IHF,
        DW_FEI.INVOICE_LINE_FACT ILF,
        DW_FEI.PRODUCT_DIMENSION PROD,
        DW_FEI.CUSTOMER_DIMENSION CUST,
        SALES_MART.SALES_WAREHOUSE_DIM SWD,
        DW_FEI.SALESREP_DIMENSION REPS,
        SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN,
        PRICE_MGMT.MISSING_INVOICES MI
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
         AND ILF.PRODUCT_GK = PROD.PRODUCT_GK
         AND IHF.IC_FLAG = 0
         AND IHF.PO_WAREHOUSE_NUMBER IS NULL;

--06
COMMIT;

-- BUILD OUT DETAILS ON NEW INVOICE LINES FOR SP- PRODUCTS

--07
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
          IHF.INSERT_TIMESTAMP
   FROM DW_FEI.INVOICE_HEADER_FACT IHF,
        DW_FEI.INVOICE_LINE_FACT ILF,
        DW_FEI.CUSTOMER_DIMENSION CUST,
        DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD,
        SALES_MART.SALES_WAREHOUSE_DIM SWD,
        DW_FEI.SALESREP_DIMENSION REPS,
        SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN,
        PRICE_MGMT.MISSING_INVOICES MI
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
         AND ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK
         AND IHF.IC_FLAG = 0
         AND IHF.PO_WAREHOUSE_NUMBER IS NULL;

--08
COMMIT;

-- BUILD OUT REFERENCE FOR BASE CONTRACT PRODUCT CCOR RELATED TO NEW INVOICES

--09
TRUNCATE TABLE PRICE_MGMT.PR_OVR_BASE;

--10
INSERT INTO PRICE_MGMT.PR_OVR_BASE
   SELECT DISTINCT
          COD.BASIS,
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
   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD, PRICE_MGMT.PR_VICT2_SLS V
   WHERE     COD.OVERRIDE_TYPE = 'P'
         AND COD.BRANCH_NUMBER_NK = V.ACCOUNT_NUMBER
         AND COD.CUSTOMER_NK = V.MAIN_CUSTOMER_NK
         AND COD.DELETE_DATE IS NULL
         AND NVL (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 8)
         AND V.PRODUCT_NK = COD.MASTER_PRODUCT;

--11
COMMIT;

-- BUILD OUT REFERENCE FOR BASE CONTRACT GROUP CCOR RELATED TO NEW INVOICES

--12
TRUNCATE TABLE PRICE_MGMT.GR_OVR_BASE;

--13
INSERT INTO PRICE_MGMT.GR_OVR_BASE
   SELECT DISTINCT
          COD.BASIS,
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
   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD, PRICE_MGMT.PR_VICT2_SLS V
   WHERE     COD.OVERRIDE_TYPE = 'G'
         AND COD.BRANCH_NUMBER_NK = V.ACCOUNT_NUMBER
         AND COD.CUSTOMER_NK = V.MAIN_CUSTOMER_NK
         AND COD.DELETE_DATE IS NULL
         AND NVL (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 8)
         AND V.DISCOUNT_GROUP_NK = COD.DISC_GROUP;

--14
COMMIT;

-- BUILD OUT REFERENCE FOR JOB CONTRACT PRODUCT CCOR RELATED TO NEW INVOICES

--15
TRUNCATE TABLE PRICE_MGMT.PR_OVR_JOB;

--16
INSERT INTO PRICE_MGMT.PR_OVR_JOB
   SELECT DISTINCT
          COD.BASIS,
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
   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD, PRICE_MGMT.PR_VICT2_SLS V
   WHERE     COD.OVERRIDE_TYPE = 'P'
         AND COD.BRANCH_NUMBER_NK = V.ACCOUNT_NUMBER
         AND COD.CUSTOMER_GK = V.CUSTOMER_ACCOUNT_GK
         AND COD.DELETE_DATE IS NULL
         AND V.JOB_YN = 'Y'
         AND NVL (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 8)
         AND V.PRODUCT_NK = COD.MASTER_PRODUCT;

--17
COMMIT;

-- BUILD OUT REFERENCE FOR JOB CONTRACT GROUP CCOR RELATED TO NEW INVOICES

--18
TRUNCATE TABLE PRICE_MGMT.GR_OVR_JOB;

--19
INSERT INTO PRICE_MGMT.GR_OVR_JOB
   SELECT DISTINCT
          COD.BASIS,
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
   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD, PRICE_MGMT.PR_VICT2_SLS V
   WHERE     COD.OVERRIDE_TYPE = 'G'
         AND COD.BRANCH_NUMBER_NK = V.ACCOUNT_NUMBER
         AND COD.CUSTOMER_GK = V.CUSTOMER_ACCOUNT_GK
         AND COD.DELETE_DATE IS NULL
         AND V.JOB_YN = 'Y'
         AND NVL (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 8)
         AND V.DISCOUNT_GROUP_NK = COD.DISC_GROUP;

--20
COMMIT;

-- BUILD OUT REFERENCE FOR CORE CONTRACTS RELATED TO NEW INVOICES

--21
TRUNCATE TABLE PRICE_MGMT.CORE_CLAIM_VDR;

--22
INSERT INTO PRICE_MGMT.CORE_CLAIM_VDR
   SELECT ILCF.INVOICE_NUMBER_GK,
          ILCF.INVOICE_LINE_NUMBER,
          ILCF.COST_CODE_IND,
          ILCF.VENDOR_NAME,
          ILCF.VENDOR_AGREEMENT,
          ILCF.CONTRACT_NAME,
          ILCF.SUBLINE_QTY,
          ILCF.SUBLINE_COST,
          ILCF.CLAIM_AMOUNT,
          ILCF.INVOICE_DATE,
          ILCF.PROCESS_DATE
   FROM PRICE_MGMT.PR_VICT2_SLS PR_VICT2_SLS
        INNER JOIN DW_FEI.INVOICE_LINE_CORE_FACT ILCF
           ON (    PR_VICT2_SLS.INVOICE_NUMBER_GK = ILCF.INVOICE_NUMBER_GK
               AND PR_VICT2_SLS.INVOICE_LINE_NUMBER =
                   ILCF.INVOICE_LINE_NUMBER)
   WHERE ILCF.COST_CODE_IND = 'C';

--23
COMMIT;

-- ADD CONTEXT TO NEW INVOICES
-- LOGICALLY COMPARE NEW INVOICES TO CONTRACT REFERENCE TABLES TO VALIDATE PRICE CATEGORY

--24
TRUNCATE TABLE PRICE_MGMT.PR_VICT2_SLS_CAT;

--25
INSERT INTO PRICE_MGMT.PR_VICT2_SLS_CAT
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
          V.INSERT_TIMESTAMP
             INSERT_TIMESTAMP_IHF,
          V.PROCESS_DATE,
          V.EXT_AVG_COGS_AMOUNT,
          V.EXT_ACTUAL_COGS_AMOUNT,
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
                        CORE.INVOICE_LINE_NUMBER) V;

--26
COMMIT;

-- INSERT NEW INVOICE DATA INTO DETAILED DAILY ARCHIVE

--27
INSERT INTO PRICE_MGMT.PR_VICT2_CUST_R2MO
   SELECT SRC.*
   FROM PRICE_MGMT.PR_VICT2_SLS_CAT SRC
        LEFT OUTER JOIN PRICE_MGMT.PR_VICT2_CUST_R2MO DEST
           ON     (SRC.INVOICE_NUMBER_GK = DEST.INVOICE_NUMBER_GK)
              AND (SRC.INVOICE_LINE_NUMBER = DEST.INVOICE_LINE_NUMBER)
   WHERE (DEST.INVOICE_NUMBER_GK IS NULL AND DEST.INVOICE_LINE_NUMBER IS NULL);

--28
COMMIT;

-- INSERT NEW INVOICE DATA INTO STREAMLINED REFERENCE ARCHIVE

--29
INSERT INTO PRICE_MGMT.PR_PRICE_CAT_HIST
   SELECT SRC.YEARMONTH,
          SRC.EOM_YEARMONTH,
          SRC.INVOICE_NUMBER_GK,
          SRC.INVOICE_LINE_NUMBER,
          SRC.PRODUCT_GK,
          SRC.SPECIAL_PRODUCT_GK,
          SRC.PROCESS_DATE,
          SRC.SHIPPED_QTY,
          SRC.EXT_SALES_AMOUNT,
          SRC.EXT_ACTUAL_COGS_AMOUNT,
          SRC.CORE_ADJ_AVG_COST,
          SRC.EXT_AVG_COGS_AMOUNT,
          SRC.INSERT_TIMESTAMP_IHF INSERT_TIMESTAMP,
          SRC.PRICE_CODE,
          SRC.GR_OVR PRICE_CATEGORY_OVR_PR,
          SRC.PR_OVR PRICE_CATEGORY_OVR_GR,
          SRC.PRICE_CATEGORY,
          SRC.ORIG_PRICE_CODE,
          SRC.PRICE_FORMULA,
          SRC.PRICE_CATEGORY_FINAL,
          SRC.WAREHOUSE_NUMBER,
          SRC.CUSTOMER_ACCOUNT_GK
   FROM PRICE_MGMT.PR_VICT2_SLS_CAT SRC
        LEFT OUTER JOIN PRICE_MGMT.PR_PRICE_CAT_HIST DEST
           ON     SRC.INVOICE_NUMBER_GK = DEST.INVOICE_NUMBER_GK
              AND SRC.INVOICE_LINE_NUMBER = DEST.INVOICE_LINE_NUMBER
   WHERE (DEST.INVOICE_NUMBER_GK IS NULL AND DEST.INVOICE_LINE_NUMBER IS NULL);

--30
COMMIT;