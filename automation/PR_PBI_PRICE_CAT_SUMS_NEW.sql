--TRUNCATE TABLE "PRICE_MGMT"."PR_PBI_PRICE_CAT_SUMS_OLD";
--DROP TABLE "PRICE_MGMT"."PR_PBI_PRICE_CAT_SUMS_OLD";

TRUNCATE TABLE PRICE_MGMT.PR_PBI_PRICE_CAT_SUMS;
DROP TABLE PRICE_MGMT.PR_PBI_PRICE_CAT_SUMS;

CREATE TABLE PRICE_MGMT.PR_PBI_PRICE_CAT_SUMS
NOLOGGING
AS
   SELECT HIST.EOM_YEARMONTH,
          HIST.WAREHOUSE_NUMBER
             WHSE,
          CUST.PRICE_COLUMN
             PC,
          -- NVL (AREA.RPT_NAME, SWD.ACCOUNT_NAME)
          --    AREA,
          NVL (BG.BUSINESS_GROUP, 'OTHER')
             CUST_BUS_GRP,
          CHAN.ORDER_CHANNEL,
          CHAN.DELIVERY_CHANNEL,
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
             ELSE
                'HOUSE'
          END
             AS MAIN_CUST,
          CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL THEN CUST.CUSTOMER_NAME
             ELSE 'HOUSE UNASSIGNED'
          END
             AS CUSTOMER_NAME,
          CASE
             WHEN LTRIM (CUST.SALESMAN_CODE, '0123456789') IS NULL THEN 'Y'
             WHEN REPS.SALESREP_NAME LIKE '%HOUSE%' THEN 'Y'
             WHEN REPS.HOUSE_ACCT_FLAG IS NULL THEN 'N'
             ELSE REPS.HOUSE_ACCT_FLAG
          END
             AS HOUSE_ACCT,
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
        --INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
        --   ON HIST.YEARMONTH = TPD.YEARMONTH
        -- USE FOR CUSTOMER BUS GRP
        INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
           ON HIST.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
        LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
           ON COALESCE (CUST.BMI_BUDGET_CUST_TYPE,
                        CUST.BMI_REPORT_CUST_TYPE,
                        CUST.CUSTOMER_TYPE) =
              BG.CUSTOMER_TYPE
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
   WHERE HIST.EOM_YEARMONTH BETWEEN 201707 AND 201906
   GROUP BY /*TPD.ROLL12MONTHS,
            TPD.FISCAL_YEAR_TO_DATE,
            TPD.ROLLING_QTR,
            TPD.FISCAL_QTR,
            TPD.FISCAL_YEAR,
            TPD.FISCAL_YEARMONTH,*/
--    HIST.YEARMONTH,
    HIST.EOM_YEARMONTH,
    /* SWD.REGION_NAME,
     SWD.DIVISION_NAME,
     SWD.ACCOUNT_NAME,
     SWD.ACCOUNT_NUMBER_NK,*/
    CUST.PRICE_COLUMN,
    CUST.CUSTOMER_TYPE,
    -- NVL (AREA.RPT_NAME, SWD.ACCOUNT_NAME),
    HIST.WAREHOUSE_NUMBER,
    NVL (BG.BUSINESS_GROUP, 'OTHER'),
    CHAN.ORDER_CHANNEL,
    CHAN.DELIVERY_CHANNEL,
    NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
    DG.DISCOUNT_GROUP_NAME,
    --PROD.PRODUCT_NK,
    --PROD.ALT1_CODE,
    --PROD.PRODUCT_NAME,
    IHF.WRITER,
    CUST.SALESMAN_CODE,
    NVL (REPS.SALESREP_NAME, 'UNKNOWN'),
    CASE
       WHEN LTRIM (CUST.SALESMAN_CODE, '0123456789') IS NULL THEN 'Y'
       WHEN REPS.SALESREP_NAME LIKE '%HOUSE%' THEN 'Y'
       WHEN REPS.HOUSE_ACCT_FLAG IS NULL THEN 'N'
       ELSE REPS.HOUSE_ACCT_FLAG
    END,
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
       WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL THEN CUST.MAIN_CUSTOMER_NK
       ELSE 'HOUSE'
    END,
    CASE
       WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL THEN CUST.CUSTOMER_NAME
       ELSE 'HOUSE UNASSIGNED'
    END;