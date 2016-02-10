--DROP TABLE AAD9606.PR_SP_SUMMARY_13MO;

--CREATE TABLE AAD9606.PR_SP_SUMMARY_13MO
--AS
   SELECT SP_LM.YEARMONTH,
          SP_LM.ACCOUNT_NUMBER,
          SP_LM."<1500",
          SP_LM.WAREHOUSE_NUMBER WHSE,
          SP_LM.DIVISION_NAME,
          SP_LM.REGION_NAME,
          SP_LM.SP_TYPE,
          SUM (SP_LM.EXT_SALES_AMOUNT) AS EXT_SLS,
          SUM (SP_LM.EXT_SALES_AMOUNT - SP_LM.EXT_AVG_COGS_AMOUNT) AS GP,
          SUM (
             CASE
                WHEN SP_LM.SP_TYPE = 'SP' THEN SP_LM.EXT_SALES_AMOUNT
                ELSE 0
             END)
             AS SP_EXT_SLS,
          SUM (
             CASE
                WHEN SP_LM.SP_TYPE = 'SP'
                THEN
                   SP_LM.EXT_SALES_AMOUNT - SP_LM.EXT_AVG_COGS_AMOUNT
                ELSE
                   0
             END)
             AS SP_GP,
          SUM (
             CASE
                WHEN SP_LM.SP_TYPE = 'SP-' THEN SP_LM.EXT_SALES_AMOUNT
                ELSE 0
             END)
             AS "SP- EXT_SLS",
          SUM (
             CASE
                WHEN SP_LM.SP_TYPE = 'SP-'
                THEN
                   SP_LM.EXT_SALES_AMOUNT - SP_LM.EXT_AVG_COGS_AMOUNT
                ELSE
                   0
             END)
             AS "SP- GP"
     FROM (SELECT IHF.ACCOUNT_NUMBER,
                  IHF.YEARMONTH,
                  IHF.WAREHOUSE_NUMBER,
                  SWD.DIVISION_NAME,
                  SWD.REGION_NAME,
                  IHF.INVOICE_NUMBER_NK,
                  IHF.JOB_NAME,
                  IHF.OML_ASSOC_NAME,
                  IHF.WRITER,
                  ILF.INVOICE_LINE_NUMBER,
                  /*CASE
                     WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.MANUFACTURER
                     ELSE SP_PROD.PRIMARY_VNDR
                  END
                     AS MANUFACTURER,
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
                     WHEN ILF.PRODUCT_GK IS NOT NULL
                     THEN
                        PROD.DISCOUNT_GROUP_NK
                     ELSE
                        SP_PROD.SPECIAL_DISC_GROUP
                  END
                     AS DISCOUNT_GROUP_NK,
                  CASE
                     WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.LINEBUY_NK
                     ELSE SP_PROD.SPECIAL_LINE
                  END
                     AS LINEBUY_NK,
                  CASE
                     WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.PRODUCT_NAME
                     ELSE SP_PROD.SPECIAL_PRODUCT_NAME
                  END
                     AS PRODUCT_NAME,*/
                  CASE
                     WHEN ILF.PRODUCT_GK IS NOT NULL THEN 'SP'
                     ELSE 'SP-'
                  END
                     AS SP_TYPE,
                  CASE
                     WHEN ILF.EXT_SALES_AMOUNT <= 1500 THEN 'Y'
                     ELSE 'N'
                  END
                     "<1500",
                  /*PROD.DISCOUNT_GROUP_NK,
                  PROD.LINEBUY_NK,
                  PROD.PRODUCT_NK,
                  PROD.ALT1_CODE,
                  PROD.PRODUCT_NAME,
                  SP_PROD.ALT_CODE,
                  SP_PROD.PRIMARY_VNDR,
                  SP_PROD.SPECIAL_PRODUCT_NAME,
                  SP_PROD.SPECIAL_PRODUCT_NK,
                  SP_PROD.SPECIAL_DISC_GROUP,
                  SP_PROD.SPECIAL_LINE,*/
                  ILF.SHIPPED_QTY,
                  ILF.EXT_AVG_COGS_AMOUNT,
                  ILF.EXT_SALES_AMOUNT,
                  --ILF.MATRIX_PRICE,
                  CASE
                     WHEN ihf.order_code = 'IC'
                     THEN
                        'CREDITS'
                     WHEN ihf.order_code = 'SP'
                     THEN
                        'SPECIALS'
                     WHEN ilf.price_code = 'Q'
                     THEN
                        CASE
                           WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2) =
                                   ROUND (ilf.matrix_price, 2)
                           THEN
                              'MATRIX'
                           ELSE
                              'QUOTE'
                        END
                     WHEN REGEXP_LIKE (ilf.price_code, '[0-9]?[0-9]?[0-9]')
                     THEN
                        'MATRIX'
                     --WHEN NVL (ihf.split_ticket_flag, '0') = '1'
                     --THEN
                     --   'MATRIX'
                  WHEN ilf.price_code IN ('FC', 'PM')
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
                        'OTH/ERROR'
                     WHEN ilf.price_code = 'SKC'
                     THEN
                        'OTH/ERROR'
                     WHEN ilf.price_code IN ('%', '$', 'N', 'F', 'B', 'PO')
                     THEN
                        'TOOLS'
                     WHEN ilf.price_code IS NULL
                     THEN
                        'MANUAL'
                     WHEN ilf.price_code IN ('R', 'N/A')
                     THEN
                        CASE
                           WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2)
                                - ROUND (NVL (ilf.MATRIX_PRICE, ilf.MATRIX),
                                         2) BETWEEN 0
                                                AND .01
                           THEN
                              'MATRIX'
                           WHEN ihf.CONTRACT_NUMBER IS NOT NULL
                           THEN
                              'OVERRIDE'
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
                  NVL (ILF.MATRIX_PRICE, ILF.MATRIX) MATRIX_PRICE
             FROM DW_FEI.INVOICE_HEADER_FACT IHF,
                  DW_FEI.INVOICE_LINE_FACT ILF,
                  DW_FEI.PRODUCT_DIMENSION PROD,
                  DW_FEI.CUSTOMER_DIMENSION CUST,
                  --DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD,
                  SALES_MART.SALES_WAREHOUSE_DIM SWD
            WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                  AND ILF.PRODUCT_STATUS = 'SP'
                  --AND IHF.ACCOUNT_NUMBER = 1350
                  AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
                  AND IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
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
                  AND cust.ar_gl_number IS NOT NULL)
                  AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
                  AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
                  AND TO_NUMBER (NVL (PROD.LINEBUY_NK, 9999)) > 100
                  --AND ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK(+)
                  AND IHF.IC_FLAG = 0
                  AND ILF.SHIPPED_QTY > 0
                  AND IHF.ORDER_CODE NOT IN 'IC'
                  --Excludes shipments to other FEI locations.
                  AND IHF.PO_WAREHOUSE_NUMBER IS NULL
                  AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                               TRUNC (
                                                  SYSDATE
                                                  - NUMTOYMINTERVAL (25,
                                                                     'MONTH'),
                                                  'MONTH'),
                                               'YYYYMM')
                                        AND TO_CHAR (
                                               TRUNC (SYSDATE, 'MM') - 1,
                                               'YYYYMM')
                  AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                               TRUNC (
                                                  SYSDATE
                                                  - NUMTOYMINTERVAL (25,
                                                                     'MONTH'),
                                                  'MONTH'),
                                               'YYYYMM')
                                        AND TO_CHAR (
                                               TRUNC (SYSDATE, 'MM') - 1,
                                               'YYYYMM')) SP_LM
   GROUP BY SP_LM.ACCOUNT_NUMBER,
            SP_LM.YEARMONTH,
            SP_LM."<1500",
            SP_LM.WAREHOUSE_NUMBER,
            SP_LM.DIVISION_NAME,
            SP_LM.REGION_NAME,
            SP_LM.SP_TYPE;

--GRANT SELECT ON AAD9606.PR_SP_SUMMARY_13MO TO PUBLIC;