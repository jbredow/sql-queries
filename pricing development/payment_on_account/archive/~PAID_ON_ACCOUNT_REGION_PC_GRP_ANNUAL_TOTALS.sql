/*
    pcg_poa
    paid on account regional pc group annual totals
*/
SELECT SWD.DIVISION_NAME REGION,
       SWD.REGION_NAME DISTRICT,
       SWD.ACCOUNT_NUMBER_NK ACCT_NK,
       SWD.ACCOUNT_NAME,
       SWD.ALIAS_NAME,
       PC."PriceColGroup",
       CASE
          WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201408
                                                            AND 201507
          THEN
             'FY15'
          WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201508
                                                            AND 201607
          THEN
             'FY16'
          ELSE
             'FY17'
       END
          FISCAL_YY,
       COUNT (DISTINCT POA.CUSTOMER_GK) CUSTOMERS,
       /*SUM (CASE
               WHEN POA.PAID_BY IN ('VI',
                                    'DI',
                                    'MC',
                                    'AX')
               THEN
                  POA.AMOUNT_PAID
               ELSE
                  0
            END)
          CC_PAID_AMT,
       SUM (CASE
               WHEN POA.PAID_BY NOT IN ('VI',
                                        'DI',
                                        'MC',
                                        'AX')
               THEN
                  POA.AMOUNT_PAID
               ELSE
                  0
            END)
          CASH_CHK_PAID_AMT*/
       DECODE (POA.PAID_BY,
               'AX', 'CC',
               'DI', 'CC',
               'MC', 'CC',
               'VI', 'CC',
               'CASH_CHK')
          PAID_BY,
       SUM (POA.AMOUNT_PAID) PAID_AMT,
       SUM (CASE
               WHEN POA.PAID_BY IN ('AX',
                                    'DI',
                                    'MC',
                                    'VI')
               THEN
                  .012 * POA.AMOUNT_PAID
               ELSE
                  0
            END)
          EST_CC_FEES
  FROM DW_FEI.CUSTOMER_DIMENSION CUST
       INNER JOIN AAD9606.PPE_DIM_PRICE_COLUMN PC
          ON (CUST.PRICE_COLUMN = PC."PriceColumnNumber")
       INNER JOIN DW_FEI.BR_PAY_ON_ACCT_LINE_FACT POA
          ON (POA.CUSTOMER_GK = CUST.CUSTOMER_GK)
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (POA.WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
 WHERE TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201408 AND 201707
/*AND POA.PAID_BY IN ('K',
                    'DI',
                    'MC',
                    'VI')*/
GROUP BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         SWD.ALIAS_NAME,
         PC."PriceColGroup",
         CASE
            WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201408
                                                              AND 201507
            THEN
               'FY15'
            WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201508
                                                              AND 201607
            THEN
               'FY16'
            ELSE
               'FY17'
         END,
         DECODE (POA.PAID_BY,
                 'AX', 'CC',
                 'DI', 'CC',
                 'MC', 'CC',
                 'VI', 'CC',
                 'CASH_CHK')