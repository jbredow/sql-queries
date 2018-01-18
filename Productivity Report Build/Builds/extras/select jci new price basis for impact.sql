SELECT ACCOUNT_NUMBER,
       ACCOUNT_NAME,
       PRICE_COLUMN,
       DISCOUNT_GROUP_NK,
       DISCOUNT_GROUP_NAME,
       PRODUCT_NK,
       ALT1_CODE,
       PRODUCT_NAME,
       SELL_MULT,
       PRICE_FORMULA,
       POS_DISC,
       ACT_UNIT_NET,
       POS_LIST,
       CURR_LIST,
       PRICE_CATEGORY,
       CUSTOMERS,
       LINES,
       SALES,
       COGS,
       GP_AMT,
       QTY,
       CASE
          WHEN POS_LIST = CURR_LIST THEN ACT_UNIT_NET
          ELSE (ROUND (CURR_LIST * (1 - POS_DISC), 3))
       END
          CURR_NET,
       ROUND(CASE
          WHEN POS_LIST = CURR_LIST THEN SALES
          ELSE ((ROUND (CURR_LIST * (1 - POS_DISC), 3)) / SELL_MULT) * QTY
       END,2)
          CURR_SLS
  FROM (SELECT DTL.ACCOUNT_NUMBER,
               DTL.ACCOUNT_NAME,
               DTL.PRICE_COLUMN,
               DTL.DISCOUNT_GROUP_NK,
               DTL.DISCOUNT_GROUP_NAME,
               DTL.PRODUCT_NK,
               DTL.ALT1_CODE,
               NVL (DTL.PACK_QTY, 1) SELL_MULT,
               DTL.PRODUCT_NAME,
               DTL.PRICE_FORMULA,
               ROUND (
                  CASE
                     WHEN NVL (DTL.LIST_PRICE, DTL.MSTR_LIST) > 0
                     THEN
                          (  NVL (DTL.LIST_PRICE, DTL.MSTR_LIST)
                           - DTL.UNIT_NET_PRICE_AMOUNT)
                        / NVL (DTL.LIST_PRICE, DTL.MSTR_LIST)
                     ELSE
                        0
                  END,
                  3)
                  POS_DISC,
               DTL.UNIT_NET_PRICE_AMOUNT ACT_UNIT_NET,
               DTL.LIST_PRICE POS_LIST,
               CASE
                  WHEN DTL.MSTR_LIST = 0 THEN BR_LIST.MIN_BR_LIST
                  ELSE DTL.MSTR_LIST
               END
                  CURR_LIST,
               DECODE (DTL.PRICE_CATEGORY,
                       'QUOTE', 'MANUAL',
                       'TOOLS', 'MANUAL',
                       'MATRIX_BID', 'MATRIX',
                       DTL.PRICE_CATEGORY)
                  PRICE_CATEGORY,
               COUNT (DISTINCT DTL.MAIN_CUSTOMER_NK) AS CUSTOMERS,
               COUNT (DTL.INVOICE_LINE_NUMBER) AS LINES,
               SUM (DTL.EXT_SALES_AMOUNT) AS SALES,
               SUM (DTL.EXT_AVG_COGS_AMOUNT) AS COGS,
               SUM (DTL.EXT_SALES_AMOUNT - DTL.EXT_AVG_COGS_AMOUNT) AS GP_AMT,
               SUM (DTL.SHIPPED_QTY) AS QTY
          FROM AAD9606.PR_VICT2_JCI_DTL DTL
               LEFT OUTER JOIN AAD9606.PR_JCON_BR_LIST BR_LIST
                  ON (    DTL.PRODUCT_NK = BR_LIST.PRODUCT_NK
                      AND DTL.ACCOUNT_NUMBER = BR_LIST.ACCOUNT_NUMBER_NK)
         WHERE DTL.PRICE_CATEGORY NOT IN ('CREDITS', 'SPECIALS')
        GROUP BY DTL.ACCOUNT_NUMBER,
                 DTL.ACCOUNT_NAME,
                 DTL.PRICE_COLUMN,
                 DTL.DISCOUNT_GROUP_NK,
                 DTL.DISCOUNT_GROUP_NAME,
                 DTL.PRODUCT_NK,
                 DTL.ALT1_CODE,
                 NVL (DTL.PACK_QTY, 1),
                 DTL.PRODUCT_NAME,
                 DTL.PRICE_FORMULA,
                 DTL.UNIT_NET_PRICE_AMOUNT,
                 DTL.LIST_PRICE,
                 DTL.MSTR_LIST,
                 BR_LIST.MIN_BR_LIST,
                 DECODE (DTL.PRICE_CATEGORY,
                         'QUOTE', 'MANUAL',
                         'TOOLS', 'MANUAL',
                         'MATRIX_BID', 'MATRIX',
                         DTL.PRICE_CATEGORY))