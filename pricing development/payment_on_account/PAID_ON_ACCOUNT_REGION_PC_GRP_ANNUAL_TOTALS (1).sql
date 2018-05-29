/* 
      pcg_poa
      regional customer segment pmt on account paymethod inv header summary 
*/

SELECT X.REGION,
       X.DISTRICT,
       X.ACCT_NK,
       X.ACCOUNT_NAME,
       X."PriceColGroup",
       X.FISCAL_YY,
       SUM (X.CASH_CHK_PAID) CASH_CHK_PAID,
       SUM (X.CC_PAID) CC_PAID,
       SUM (X.EST_CC_FEES) EST_CC_FEES,
       SUM (Y.EX_SALES) EX_SALES,
       SUM (Y.EX_COGS) EX_COGS,
       SUM (Y.EX_SALES - Y.EX_COGS) EX_GP_AMT
  FROM (SELECT SWD.DIVISION_NAME REGION,
               SWD.REGION_NAME DISTRICT,
               SWD.ACCOUNT_NUMBER_NK ACCT_NK,
               SWD.ACCOUNT_NAME,
               SWD.ALIAS_NAME,
               POA.CUSTOMER_GK,
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
                    WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201608
                                                                      AND 201707
                    THEN
                       'FY17'
                    ELSE
                       'FY18'
               END
                  FISCAL_YY,
               SUM (CASE
                       WHEN POA.PAID_BY NOT IN ('AX',
                                                'DI',
                                                'MC',
                                                'VI')
                       THEN
                          POA.AMOUNT_PAID
                       ELSE
                          0
                    END)
                  CASH_CHK_PAID,
               SUM (CASE
                       WHEN POA.PAID_BY IN ('AX',
                                            'DI',
                                            'MC',
                                            'VI')
                       THEN
                          POA.AMOUNT_PAID
                       ELSE
                          0
                    END)
                  CC_PAID,
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
         WHERE TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201408
                                                            AND 201807
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
                 POA.CUSTOMER_GK,
                 CASE
                    WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201408
                                                                      AND 201507
                    THEN
                       'FY15'
                    WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201508
                                                                      AND 201607
                    THEN
                       'FY16'
                    WHEN TO_CHAR (POA.INSERT_TIMESTAMP, 'YYYYMM') BETWEEN 201608
                                                                      AND 201707
                    THEN
                       'FY17'
                    ELSE
                       'FY18'
                 END) X
       INNER JOIN
       (SELECT SLS.ACCOUNT_NUMBER,
               SLS.CUSTOMER_ACCOUNT_GK,
               CASE
                  WHEN SLS.YEARMONTH BETWEEN 201408 AND 201507 THEN 'FY15'
                  WHEN SLS.YEARMONTH BETWEEN 201508 AND 201607 THEN 'FY16'
                  WHEN SLS.YEARMONTH BETWEEN 201608 AND 201707 THEN 'FY17'
                  ELSE 'FY18'
               END
                  FISCAL_YY,
               PC."PriceColGroup",
               SUM (SLS.SALES_SUBTOTAL_AMOUNT) EX_SALES,
               SUM (SLS.COST_SUBTOTAL_AMOUNT) EX_COGS
          FROM DW_FEI.INVOICE_HEADER_FACT SLS
               INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                  ON SLS.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
               INNER JOIN AAD9606.PPE_DIM_PRICE_COLUMN PC
                  ON (CUST.PRICE_COLUMN = PC."PriceColumnNumber")
         --  INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
         --   ON (SLS.YEARMONTH = TPD.YEARMONTH)
         WHERE                      -- TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
               --TPD  .FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
               SLS.YEARMONTH BETWEEN 201408 AND 201807 AND SLS.IC_FLAG = 0
          AND SLS.ACCOUNT_NUMBER IN ('20', '2000')
        GROUP BY SLS.ACCOUNT_NUMBER,
                 SLS.CUSTOMER_ACCOUNT_GK,
                 CASE
                    WHEN SLS.YEARMONTH BETWEEN 201408 AND 201507 THEN 'FY15'
                    WHEN SLS.YEARMONTH BETWEEN 201508 AND 201607 THEN 'FY16'
                    WHEN SLS.YEARMONTH BETWEEN 201608 AND 201707 THEN 'FY17'
                    ELSE 'FY18'
                 END,
                 PC."PriceColGroup") Y
          ON (    X."PriceColGroup" = Y."PriceColGroup"
              AND X.ACCT_NK = Y.ACCOUNT_NUMBER
              AND X.FISCAL_YY = Y.FISCAL_YY
              AND X.CUSTOMER_GK = Y.CUSTOMER_ACCOUNT_GK)
GROUP BY X.REGION,
         X.DISTRICT,
         X.ACCT_NK,
         X.ACCOUNT_NAME,
         X."PriceColGroup",
         X.FISCAL_YY