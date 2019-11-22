TRUNCATE TABLE PRICE_MGMT.PR_PBI_PRICE_CAT_SUMS_3RD;


   DROP TABLE PRICE_MGMT.PR_PBI_PRICE_CAT_SUMS_3RD;

   CREATE TABLE PRICE_MGMT.PR_PBI_PRICE_CAT_SUMS_3RD
   NOLOGGING
   AS
   SELECT HIST.EOM_YEARMONTH,
          HIST.WAREHOUSE_NUMBER
             WHSE,
          CUST.PRICE_COLUMN
             PC,
          NVL (BG.BUSGRP, 'OTHER')
             CUST_BUS_GRP,
          CHAN.ORDER_CHANNEL,
          CHAN.DELIVERY_CHANNEL,
          CASE
             WHEN DELIVERY_CHANNEL = 'PICKUP'
             THEN
                CASE
                   WHEN ORDER_CHANNEL = 'COUNTER' THEN 'COUNTER'
                   ELSE 'WILL_CALL'
                END
             ELSE
                NULL
          END
             PICKUP_CHANNEL,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-')
             DISC_GRP,
          IHF.WRITER,
          CUST.CUSTOMER_TYPE,
          CUST.SALESMAN_CODE
             REP_INIT,
          NVL (REPS.SALESREP_NAME, 'UNKNOWN')
             SALESREP_NAME,
          CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL
             THEN
                CUST.MAIN_CUSTOMER_NK
             WHEN CTS.R12M_NET_BILLINGS_AMT > = 4000
             THEN
                CUST.MAIN_CUSTOMER_NK
             ELSE
                'HOUSE'
          END
             AS MAIN_CUST,
          CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL 
             THEN 
                CUST.CUSTOMER_NAME
             WHEN CTS.R12M_NET_BILLINGS_AMT > = 4000
             THEN 
                CUST.CUSTOMER_NAME
             ELSE 
                'HOUSE UNASSIGNED'
          END
             AS CUSTOMER_NAME,
          NVL (REPS.HOUSE_ACCT_FLAG, 'Y')
             HOUSE_ACCT,
          DECODE (HIST.PRICE_CATEGORY_FINAL,
                  'MATRIX', 'MATRIX',
                  'MATRIX_BID', 'MATRIX',
                  'NDP', 'MATRIX',
                  'MANUAL', 'MANUAL',
                  'QUOTE', 'MANUAL',
                  'TOOLS', 'MANUAL',
                  'OVERRIDE', 'CCOR',
                  'SPECIALS', 'SP-',
                  HIST.PRICE_CATEGORY_FINAL)
             PRICE_CATEGORY,
          SUM (HIST.EXT_SALES_AMOUNT)
             EXT_SALES_AMT,
          COUNT (HIST.INVOICE_LINE_NUMBER)
             INVOICE_LINES,
          SUM (HIST.EXT_AVG_COGS_AMOUNT)
             AVG_COGS_AMT,
          SUM (HIST.CORE_ADJ_AVG_COST)
             CORE_COGS_AMT,
          SUM (HIST.EXT_ACTUAL_COGS_AMOUNT)
             INVOICE_COGS_AMT
   FROM PRICE_MGMT.PR_PRICE_CAT_HIST HIST
        INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
           ON (    HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
               AND HIST.YEARMONTH = IHF.YEARMONTH)
        INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
           ON HIST.YEARMONTH = TPD.YEARMONTH
        -- USE FOR CUSTOMER BUS GRP
 -- changed for branch split       
        INNER JOIN DW_FEI.ACTIVE_CUSTOMER_MVW CUST
           ON HIST.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
        
        INNER JOIN USER_SHARED.CUSTOMER_TO_BUSGRP BG
           ON HIST.CUSTOMER_ACCOUNT_GK = BG.CUSTOMER_GK
        -- USE FOR SALESREP REPORTING
        LEFT OUTER JOIN PRICE_MGMT.CURRENT_SALESREP REPS
           ON     CUST.ACCOUNT_NAME = REPS.ACCOUNT_NAME
              AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
        -- USE FOR CHANNEL TYPE ANALYSIS
        INNER JOIN SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN
           ON IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK
        -- USE FOR PRODUCT AND DISCOUNT GROUP
        LEFT OUTER JOIN DW_FEI.PRODUCT_DIMENSION PROD
           ON HIST.PRODUCT_GK = PROD.PRODUCT_GK
        LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
           ON PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
        -- USE FOR 12MO NET BILLINGS >= 500000 VALIDATION FOR HOUSE ACCOUNT DETAIL INCLUSION
        LEFT OUTER JOIN PROF_MART.CTS_CUST_SUMMARY CTS
           ON HIST.CUSTOMER_ACCOUNT_GK = CTS.CUSTOMER_GK
   WHERE TPD.ROLL12MONTHS IS NOT NULL
          AND TPD.FISCAL_QTR = 'THIRD'
   GROUP BY TPD.ROLL12MONTHS,
            TPD.FISCAL_YEAR_TO_DATE,
            TPD.ROLLING_QTR,
            TPD.FISCAL_QTR,
            TPD.FISCAL_YEAR,
            TPD.FISCAL_YEARMONTH,
            HIST.EOM_YEARMONTH,
            CUST.PRICE_COLUMN,
            HIST.WAREHOUSE_NUMBER,
            NVL (BG.BUSGRP, 'OTHER'),
            CHAN.ORDER_CHANNEL,
            CASE
               WHEN DELIVERY_CHANNEL = 'PICKUP'
               THEN
                  CASE
                     WHEN ORDER_CHANNEL = 'COUNTER' THEN 'COUNTER'
                     ELSE 'WILL_CALL'
                  END
               ELSE
                  NULL
            END,
            CHAN.DELIVERY_CHANNEL,
            NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
            DG.DISCOUNT_GROUP_NAME,
            IHF.WRITER,
            CUST.CUSTOMER_TYPE,
            NVL (REPS.HOUSE_ACCT_FLAG, 'Y'),
            CUST.SALESMAN_CODE,
            NVL (REPS.SALESREP_NAME, 'UNKNOWN'),
            DECODE (HIST.PRICE_CATEGORY_FINAL,
                    'MATRIX', 'MATRIX',
                    'MATRIX_BID', 'MATRIX',
                    'NDP', 'MATRIX',
                    'MANUAL', 'MANUAL',
                    'QUOTE', 'MANUAL',
                    'TOOLS', 'MANUAL',
                    'OVERRIDE', 'CCOR',
                    'SPECIALS', 'SP-',
                    HIST.PRICE_CATEGORY_FINAL),
            CASE
               WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL
               THEN
                  CUST.MAIN_CUSTOMER_NK
               WHEN CTS.R12M_NET_BILLINGS_AMT > = 4000
               THEN
                  CUST.MAIN_CUSTOMER_NK
               ELSE
                  'HOUSE'
            END,
            CASE
               WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL
               THEN
                  CUST.CUSTOMER_NAME
               WHEN CTS.R12M_NET_BILLINGS_AMT > = 4000
               THEN
                  CUST.CUSTOMER_NAME
               ELSE
                  'HOUSE UNASSIGNED'
            END;

COMMIT;