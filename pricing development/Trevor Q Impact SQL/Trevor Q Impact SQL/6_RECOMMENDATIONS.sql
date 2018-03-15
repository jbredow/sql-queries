CREATE OR REPLACE FORCE VIEW AAA6863.PR_MERGE_REC2 --Your AA# and location

AS
   SELECT R.ACCOUNT_NUMBER_NK,
          --R.COLUMN_CATEGORY,
          R.MAIN_CUSTOMER_GK,
          R.MAIN_CUSTOMER_NK,
          R.CUSTOMER_NAME,
          --DW_CUST.CUSTOMER_STATUS,
          --DW_CUST.SALESMAN_CODE,
          R.CUSTOMER_TYPE,
          R.SRC_PRICE_COLUMN,
          --R.SRC_PC_ACTUAL,
          R.DEST_PC,
          R.IMPACT_KEY,
          R.NET_IMPACT,
          R.MIN_IMPACT_AMT
     FROM (SELECT X.ACCOUNT_NUMBER_NK,
                 -- X.COLUMN_CATEGORY,
                  X.MAIN_CUSTOMER_GK,
                  DW_CUST.MAIN_CUSTOMER_NK,
                  DW_CUST.CUSTOMER_NAME,
                 -- DW_CUST.CUSTOMER_STATUS,
                  --DW_CUST.SALESMAN_CODE,
                  DW_CUST.CUSTOMER_TYPE,
                  CUST.SRC_PRICE_COLUMN,
                  --CUST.SRC_PC_ACTUAL,
                  CUST.DEST_PC,
                  CUST.IMPACT_KEY,
                  CUST.NET_IMPACT,
                  X.MIN_IMPACT_AMT,
                  MIN (CUST.DEST_PC) OVER (PARTITION BY X.MAIN_CUSTOMER_GK) MIN_DEST_PC
             FROM (SELECT ACCOUNT_NUMBER_NK,
                         -- COLUMN_CATEGORY,
                          SRC_PRICE_COLUMN,
                          --SRC_PC_ACTUAL,
                          MAIN_CUSTOMER_GK,
                          MIN (ABS (IMPACT_AMT)) MIN_IMPACT_AMT
                     FROM AAA6863.BMI2_IMPACT_SUMS ---******IMPACT SUMS TABLE*****
                   GROUP BY ACCOUNT_NUMBER_NK,
                            --COLUMN_CATEGORY,
                            SRC_PRICE_COLUMN,
                            MAIN_CUSTOMER_GK) X,
                  (SELECT ACCOUNT_NUMBER_NK,
                          --COLUMN_CATEGORY,
                          MAIN_CUSTOMER_GK,
                          SRC_PRICE_COLUMN,
                          --SRC_PC_ACTUAL,
                          DEST_PC,
                          IMPACT_KEY,
                          IMPACT_AMT NET_IMPACT,
                          ABS (IMPACT_AMT) IMPACT_AMT
                     FROM AAA6863.BMI2_IMPACT_SUMS) CUST, ---******IMPACT SUMS TABLE*****
                  DW_FEI.CUSTOMER_DIMENSION DW_CUST
            WHERE     X.MIN_IMPACT_AMT = CUST.IMPACT_AMT
                  AND X.MAIN_CUSTOMER_GK = CUST.MAIN_CUSTOMER_GK
                  AND X.SRC_PRICE_COLUMN = CUST.SRC_PRICE_COLUMN
                  AND X.MAIN_CUSTOMER_GK = DW_CUST.CUSTOMER_GK
           GROUP BY X.ACCOUNT_NUMBER_NK,
                    --X.COLUMN_CATEGORY,
                    X.MAIN_CUSTOMER_GK,
                    DW_CUST.MAIN_CUSTOMER_NK,
                    DW_CUST.CUSTOMER_NAME,
                   DW_CUST.CUSTOMER_STATUS,
                    DW_CUST.SALESMAN_CODE,
                    DW_CUST.CUSTOMER_TYPE,
                    CUST.SRC_PRICE_COLUMN,
                    --CUST.SRC_PC_ACTUAL,
                    CUST.DEST_PC,
                    CUST.IMPACT_KEY,
                    CUST.NET_IMPACT,
                    X.MIN_IMPACT_AMT) R
    WHERE R.DEST_PC = R.MIN_DEST_PC
   GROUP BY R.ACCOUNT_NUMBER_NK,
           -- R.COLUMN_CATEGORY,
            R.MAIN_CUSTOMER_GK,
            R.MAIN_CUSTOMER_NK,
            R.CUSTOMER_NAME,
            R.CUSTOMER_TYPE,
            R.SRC_PRICE_COLUMN,
           -- R.SRC_PC_ACTUAL,
            R.IMPACT_KEY,
            R.DEST_PC,
            R.NET_IMPACT,
            R.MIN_IMPACT_AMT;


