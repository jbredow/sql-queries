/*
	regional customer segment pmt on account paymethod inv header summary
*/
SELECT SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DISTRICT,
       SWD.ACCOUNT_NUMBER_NK AS BRANCH_NK,
       SWD.ACCOUNT_NAME AS ALIAS,
       CUST.CUSTOMER_NK,
       CUST.CUSTOMER_GK,
       CUST.CUSTOMER_NAME,
       CUST.MAIN_CUSTOMER_NK,
       CUST.CUSTOMER_TYPE,
       NVL (BG_CT.BUS_GRP, 'OTHER') BUS_GRP,
       /* POA_HDR.DRAWER,
        POA_HDR.APPLY_TO,
        POA_HDR.ENTRY_DATE,
        POA_HDR.COMMENTS,*/
       /*DECODE (POA_LINE.PAID_BY,
               'AX', 'CC',
               'DI', 'CC',
               'MC', 'CC',
               'VI', 'CC',
               'CASH_CHK')
          PAID_BY,*/
       SUM (CASE
               WHEN POA_LINE.PAID_BY IN ('AX',
                                         'DI',
                                         'MC',
                                         'VI')
               THEN
                  POA_LINE.AMOUNT_PAID
               ELSE
                  0
            END)
          CC_PAID,
       SUM (CASE
               WHEN POA_LINE.PAID_BY NOT IN ('AX',
                                             'DI',
                                             'MC',
                                             'VI')
               THEN
                  POA_LINE.AMOUNT_PAID
               ELSE
                  0
            END)
          CASH_CHK_PAID,
       --  POA_LINE.INSERT_TIMESTAMP,
       --  POA_LINE.UPDATE_TIMESTAMP,
       CUST.TERMS,
       CUST.CREDIT_CODE,
       CUST.CREDIT_LIMIT,
       CUST.CUSTOMER_STATUS CUST_STATUS,
       EX_SALES,
       EX_COGS
  FROM DW_FEI.CUSTOMER_DIMENSION CUST
       INNER JOIN DW_FEI.BR_PAY_ON_ACCT_LINE_FACT POA_LINE
          ON (CUST.CUSTOMER_GK = POA_LINE.CUSTOMER_GK)
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (POA_LINE.WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
       INNER JOIN AAD9606.BUSGRP_CTYPE BG_CT
          ON (CUST.CUSTOMER_TYPE = BG_CT.CUSTOMER_TYPE)
       INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
          ON TO_CHAR (POA_LINE.INSERT_TIMESTAMP, 'YYYYMM') = TPD.YEARMONTH
       LEFT OUTER JOIN
       (SELECT SLS.ACCOUNT_NUMBER,
               SLS.CUSTOMER_ACCOUNT_GK CUSTOMER_GK,
               SUM (SLS.SALES_SUBTOTAL_AMOUNT) EX_SALES,
               SUM (SLS.COST_SUBTOTAL_AMOUNT) EX_COGS
          FROM DW_FEI.INVOICE_HEADER_FACT SLS
               INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                  ON (SLS.YEARMONTH = TPD.YEARMONTH)
         WHERE                      -- TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
              TPD  .FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
               AND SLS.IC_FLAG = 0
               AND SLS.ACCOUNT_NUMBER IN ('20', '2000')
        GROUP BY SLS.ACCOUNT_NUMBER, SLS.CUSTOMER_ACCOUNT_GK) SALES
          ON CUST.CUSTOMER_GK = SALES.CUSTOMER_GK
 WHERE     SWD.ACCOUNT_NUMBER_NK IN ('20', '2000')
       AND                          -- TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
          TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
GROUP BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         CUST.CUSTOMER_NK,
         CUST.CUSTOMER_GK,
         CUST.CUSTOMER_NAME,
         CUST.MAIN_CUSTOMER_NK,
         CUST.CUSTOMER_TYPE,
         NVL (BG_CT.BUS_GRP, 'OTHER'),
         /*DECODE (POA_LINE.PAID_BY,
                 'AX', 'CC',
                 'DI', 'CC',
                 'MC', 'CC',
                 'VI', 'CC',
                 'CASH_CHK'),*/

         CUST.TERMS,
         CUST.CREDIT_CODE,
         CUST.CREDIT_LIMIT,
         CUST.CUSTOMER_STATUS,
         EX_SALES,
         EX_COGS