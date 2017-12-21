--drop TABLE AAA6863.PR_HVAC_FLYER_SLS_MONTH;

CREATE TABLE AAA6863.PR_HVAC_FLYER_SLS_SUMS

AS

SELECT CASE
          WHEN DTL.MSTR_CUSTNO IS NOT NULL THEN 'MSTR_' || DTL.MSTR_CUSTNO
          ELSE DTL.ACCOUNT_NUMBER || '_' || DTL.MAIN_CUSTOMER_NK
       END
          CUST_ROLLUP,
       MIN (CUST.SIGNUP_DATE) SIGNUP_DATE,
       DTL.MSTR_CUSTNO,
       DTL.MSTR_CUST_NAME,
       DTL.MAIN_CUSTOMER_NK,
       DTL.CUSTOMER_NAME,
       DTL.ACCOUNT_NUMBER ACCT_NK,
       DTL.ACCOUNT_NAME,
       DTL.ALIAS_NAME,
       DTL.DISCOUNT_GROUP_NK,
       DTL.DISCOUNT_GROUP_NAME,
       DTL.ALT1_CODE,
       COUNT (DTL.INVOICE_NUMBER_NK) INV_LINES,
       DTL.YEARMONTH,
       MAX (DTL.PROCESS_DATE) LAST_SALE,
       SUM (DTL.EXT_SALES_AMOUNT) EXT_SALES,
       SUM (DTL.EXT_AVG_COGS_AMOUNT) EXT_COGS,
       SUM (DTL.EXT_SALES_AMOUNT - DTL.EXT_AVG_COGS_AMOUNT) GP_AMT,
       SUM (DTL.SHIPPED_QTY) SHIP_QTY,
       CASE
          WHEN SUBSTR (DTL.PRICE_FORMULA, 0, 1) = '5' THEN DTL.PRICE_FORMULA
          ELSE 'OTHER'
       END
          PRICE_FORMULA,
       CASE
          WHEN REPLACE (DTL.PRICE_FORMULA, '0.', '.') IN
                     ('5-.5',
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
  FROM    AAA6863.PR_HVAC_FLYER_VICT2 DTL
       LEFT OUTER JOIN
          AAA6863.PR_PROMO_REPORT_PCCA CUST
       ON DTL.CUSTOMER_GK = CUST.CUSTOMER_GK
 WHERE SUBSTR (DTL.PRICE_FORMULA, 0, 1) = '5'
-- WHERE DTL.PROCESS_DATE>(CUST.SIGNUP_DATE-2)
--AND DTL.YEARMONTH <= TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
GROUP BY DTL.ACCOUNT_NAME,
         DTL.ACCOUNT_NUMBER,
         DTL.ALIAS_NAME,
         DTL.MAIN_CUSTOMER_NK,
         --DTL.SIGNUP_DATE,
         DTL.MSTR_CUSTNO,
         CASE
            WHEN DTL.MSTR_CUSTNO IS NOT NULL THEN 'MSTR_' || DTL.MSTR_CUSTNO
            ELSE DTL.ACCOUNT_NUMBER || '_' || DTL.MAIN_CUSTOMER_NK
         END,
         DTL.MSTR_CUST_NAME,
         DTL.CUSTOMER_NAME,
         DTL.DISCOUNT_GROUP_NK,
         DTL.DISCOUNT_GROUP_NAME,
         DTL.ALT1_CODE,
         DTL.YEARMONTH,
         CASE
            WHEN SUBSTR (DTL.PRICE_FORMULA, 0, 1) = '5' THEN DTL.PRICE_FORMULA
            ELSE 'OTHER'
         END,
         CASE
            WHEN REPLACE (DTL.PRICE_FORMULA, '0.', '.') IN
                       ('5-.5',
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