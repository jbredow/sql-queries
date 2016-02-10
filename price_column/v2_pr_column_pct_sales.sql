-- pulled from the pricing report package table 
SELECT X.ACCOUNT_NAME,
       X.KOB,
       X.DISTRICT,
       X.REGION,
       X.BU_TYPE,
       SUM (X.SLS_SUBTOTAL) OVER (PARTITION BY X.ACCOUNT_NAME)
          ACCT_SALES_TOTAL,
       X.PRICE_COLUMN,
       X.SLS_SUBTOTAL,
       X.MATRIX_SALES,
       X.MATRIX_COST,
       X.CONTRACT_SALES
       --X.ACTIVE_MAIN_CUST_COUNT
       --Y.MAIN_CUST_COUNT
  FROM (SELECT GP_DATA.ACCOUNT_NAME,
               GP_DATA.KOB,
               GP_DATA.DISTRICT,
               GP_DATA.REGION,
               GP_DATA.BU_TYPE,
               GP_DATA.PRICE_COLUMN,

               SUM (GP_DATA.EXT_SALES) SLS_SUBTOTAL,
               SUM (GP_DATA.AVG_COGS) TOTAL_COST,
               SUM (GP_DATA.AVG_COGS) COST_SUBTOTAL,
               SUM (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS) TOTAL_GP,
               SUM (GP_DATA.INVOICE_LINES) TOTAL_LINES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  MATRIX_SALES,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                     THEN
                        (GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  MATRIX_COST,
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                     THEN
                        (GP_DATA.EXT_SALES - GP_DATA.AVG_COGS)
                     ELSE
                        0
                  END)
                  MATRIX_GP,
    
               SUM (
                  CASE
                     WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                        (GP_DATA.EXT_SALES)
                     ELSE
                        0
                  END)
                  CONTRACT_SALES 
              
          FROM (SELECT PR_DATA.SELL_ACCOUNT_NAME ACCOUNT_NAME,
                       PR_DATA.SELL_KIND_OF_BUSINESS KOB,
                       PR_DATA.SELL_DISTRICT DISTRICT,
                       PR_DATA.SELL_REGION_NAME REGION,
                       PR_DATA.SELL_BU_NAME BU_TYPE,
                       PR_DATA.MAIN_CUSTOMER_GK,
                       SUM (PR_DATA.TOTAL_LINES) INVOICE_LINES,
                       SUM (PR_DATA.EXT_AVG_COGS_AMOUNT) AVG_COGS,
                       SUM (PR_DATA.EXT_SALES_AMOUNT) EXT_SALES,
                       NVL (PR_DATA.PRICE_SUB_CATEGORY,
                            PR_DATA.PRICE_CATEGORY)
                          PRICE_CATEGORY,
                       PR_DATA.PRICE_COLUMN
                  FROM SALES_MART.PRICE_MGMT_DATA_SUMM PR_DATA
                 WHERE SELL_ACCOUNT_NAME IN
                          ('KC')
                       AND IC_FLAG = 'REGULAR'
                       AND DECODE (PRICE_COLUMN,
                                   '000', 1,
                                   'C', 1,
                                   'N/A', 1,
                                   'NA', 1,
                                   0) <> 1
                       AND PR_DATA.YEARMONTH BETWEEN TO_CHAR (
                                                        TRUNC (
                                                           SYSDATE
                                                           - NUMTOYMINTERVAL (
                                                                13,
                                                                'MONTH'),
                                                           'MONTH'),
                                                        'YYYYMM')
                                                 AND TO_CHAR (
                                                        TRUNC (SYSDATE, 'MM')
                                                        - 1,
                                                        'YYYYMM')
                GROUP BY 
                  PR_DATA.SELL_KIND_OF_BUSINESS, 
                  PR_DATA.SELL_DISTRICT, 
                  PR_DATA.SELL_REGION_NAME, 
                  PR_DATA.SELL_BU_NAME, 
                  PR_DATA.MAIN_CUSTOMER_GK, 
                  NVL (PR_DATA.PRICE_SUB_CATEGORY, PR_DATA.PRICE_CATEGORY), 
                  PR_DATA.PRICE_COLUMN
            ) GP_DATA
        GROUP BY GP_DATA.ACCOUNT_NAME,
                 GP_DATA.KOB,
                 GP_DATA.DISTRICT,
                 GP_DATA.REGION,
                 GP_DATA.BU_TYPE,
                 GP_DATA.PRICE_COLUMN) X,
       (SELECT ACCOUNT_NAME,
               PRICE_COLUMN
               -- COUNT (DISTINCT MAIN_CUSTOMER_NK) MAIN_CUST_COUNT
          FROM DW_FEI.CUSTOMER_DIMENSION CUST
         WHERE DELETE_DATE IS NULL
        GROUP BY ACCOUNT_NAME, PRICE_COLUMN) Y
 WHERE X.ACCOUNT_NAME = Y.ACCOUNT_NAME AND X.PRICE_COLUMN = Y.PRICE_COLUMN;