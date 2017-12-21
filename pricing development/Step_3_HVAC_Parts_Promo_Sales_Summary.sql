SELECT    MAIN_CUSTOMER_NK
       || '_'
       || CUSTOMER_NAME
       || '_'
       || CASE
             WHEN FLYER.PRICE_CATEGORY = 'FLYER' THEN 'FLYER PRICE'
             ELSE 'OTHER'
          END
          "KEY",
       FLYER.*,
       CASE
          WHEN FLYER.PRICE_CATEGORY = 'FLYER' THEN 'FLYER PRICE'
          ELSE 'OTHER'
       END
          REPORT_CATEGORY,
       SUM (
          CASE WHEN FLYER.PRICE_CATEGORY = 'FLYER' THEN EXT_SALES ELSE 0 END)
       OVER (PARTITION BY ACCOUNT_NAME, MAIN_CUSTOMER_NK)
          CUST_FLYER_SLS
  FROM (SELECT DTL.MAIN_CUSTOMER_NK,
               DTL.CUSTOMER_NAME,
               DTL.ACCOUNT_NAME,
               DTL.DISCOUNT_GROUP_NK,
               DTL.DISCOUNT_GROUP_NAME,
               DTL.ALT1_CODE,
               COUNT (DTL.INVOICE_NUMBER_NK) INV_LINES,
               DTL.YEARMONTH,
               /*TO_CHAR (DTL.PROCESS_DATE, 'IW') WEEK,
               MIN (DTL.PROCESS_DATE) FSTDAY,
               MAX (DTL.PROCESS_DATE) LSTDAY,*/
               SUM (DTL.EXT_SALES_AMOUNT) EXT_SALES,
               SUM (DTL.EXT_AVG_COGS_AMOUNT) EXT_COGS,
               SUM (DTL.EXT_SALES_AMOUNT - DTL.EXT_AVG_COGS_AMOUNT) GP_AMT,
               SUM (DTL.SHIPPED_QTY) SHIP_QTY,
               ROUND (
                  SUM (
                     CASE
                        WHEN REPLACE (DTL.PRICE_FORMULA, '0.', '.') IN ('5-.5',
                                                                        '5-.50',
                                                                        '5X.5',
                                                                        '5X.50',
                                                                        '5-.51',
                                                                        '5-.51',
                                                                        '5-.52',
                                                                        '5-.52',
                                                                        '5-.53',
                                                                        '5-.53')
                        THEN
                           .05 * DTL.EXT_SALES_AMOUNT
                        ELSE
                           0
                     END),
                  2)
                  MAX_REBATE,
               CASE
                  WHEN SUBSTR (DTL.PRICE_FORMULA, 0, 1) = '5'
                  THEN
                     DTL.PRICE_FORMULA
                  ELSE
                     'OTHER'
               END
                  PRICE_FORMULA,
               CASE
                  WHEN REPLACE (DTL.PRICE_FORMULA, '0.', '.') IN ('5-.5',
                                                                  '5-.50',
                                                                  '5X.5',
                                                                  '5X.50',
                                                                  '5-.51',
                                                                  '5-.51',
                                                                  '5-.52',
                                                                  '5-.52',
                                                                  '5-.53',
                                                                  '5-.53')
                  THEN
                     'FLYER'
                  ELSE
                     DECODE (DTL.PRICE_CATEGORY,
                             'MATRIX_BID', 'MATRIX',
                             'QUOTE', 'MANUAL',
                             'TOOLS', 'MANUAL',
                             DTL.PRICE_CATEGORY)
               END
                  PRICE_CATEGORY
          FROM AAA3078.PR_HVAC_FLYER_VICT2 DTL
        GROUP BY DTL.ACCOUNT_NAME,
                 DTL.MAIN_CUSTOMER_NK,
                 DTL.CUSTOMER_NAME,
                 DTL.DISCOUNT_GROUP_NK,
                 DTL.DISCOUNT_GROUP_NAME,
                 DTL.ALT1_CODE,
                 DTL.YEARMONTH,
                 CASE
                    WHEN SUBSTR (DTL.PRICE_FORMULA, 0, 1) = '5'
                    THEN
                       DTL.PRICE_FORMULA
                    ELSE
                       'OTHER'
                 END,
                 CASE
                    WHEN REPLACE (DTL.PRICE_FORMULA, '0.', '.') IN ('5-.5',
                                                                    '5-.50',
                                                                    '5X.5',
                                                                    '5X.50',
                                                                    '5-.51',
                                                                    '5-.51',
                                                                    '5-.52',
                                                                    '5-.52',
                                                                    '5-.53',
                                                                    '5-.53')
                    THEN
                       'FLYER'
                    ELSE
                       DECODE (DTL.PRICE_CATEGORY,
                               'MATRIX_BID', 'MATRIX',
                               'QUOTE', 'MANUAL',
                               'TOOLS', 'MANUAL',
                               DTL.PRICE_CATEGORY)
                 END) FLYER
--WHERE FLYER.PRICE_CATEGORY = 'FLYER'