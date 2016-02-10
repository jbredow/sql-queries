/* Quick and Easy ctype column sales volume review */

SELECT CUST.PRICE_COLUMN,
       CUST.CUSTOMER_TYPE,
       COUNT (DISTINCT CUST.CUSTOMER_GK) CUST_COUNT,
       COUNT (DISTINCT IHF.ACCOUNT_NUMBER||'_'||CUST.MAIN_CUSTOMER_NK) MAIN_CUST_COUNT,
       MIN(IHF.YEARMONTH) MIN_YM,
       MAX(IHF.YEARMONTH) MAX_YM,
       COUNT(DISTINCT IHF.YEARMONTH) YM_COUNT,
       SUM (IHF.AVG_COST_SUBTOTAL_AMOUNT) AVG_COGS,
       SUM (IHF.SALES_SUBTOTAL_AMOUNT) SALES
  FROM    DW_FEI.INVOICE_HEADER_FACT IHF
       INNER JOIN
          DW_FEI.CUSTOMER_DIMENSION CUST
       ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK)
WHERE IHF.YEARMONTH BETWEEN TO_CHAR (
                                TRUNC (
                                   SYSDATE - NUMTOYMINTERVAL (12, 'MONTH'),
                                   'MONTH'),
                                'YYYYMM')
                         AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
       AND (cust.ar_gl_number NOT IN
               ('1320',
                '1360',
                '1380',
                '1400',
                '1401',
                '1500',
                '4000',
                '7100')
            AND cust.ar_gl_number IS NOT NULL)
       AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
       AND IHF.IC_FLAG = 0
       AND IHF.PO_WAREHOUSE_NUMBER IS NULL
GROUP BY CUST.PRICE_COLUMN, CUST.CUSTOMER_TYPE
