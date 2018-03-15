DROP TABLE AAA6863.BMI2_SRC_SALES_MATR;

CREATE TABLE AAA6863.BMI2_SRC_SALES_MATR

AS

SELECT ACCOUNT_NUMBER_NK,
       DISCOUNT_GROUP_NK,
       DISCOUNT_GROUP_NK_NAME,
       PRICE_COLUMN,
       MAIN_CUSTOMER_GK,
       MAIN_CUSTOMER_NK,
       CUSTOMER_NAME,
       PRODUCT_NK,
       ALT1_CODE_AND_PRODUCT_NAME,
       TOTAL_QTY,
       TOTAL_EXT_SALES,
       TOTAL_EXT_AVG_COGS,
       MATRIX_QTY,
       MATRIX_SLS,
       MATRIX_AVG_COGS,
    -- MANUAL_QTY,
     --  MANUAL_SLS,
      -- MANUAL_AVG_COGS,
      -- CCOR_QTY,
      -- CCOR_SLS,
      -- CCOR_AVG_COGS,
       PRICE_ID,
       BASIS,
       OPER,
       MULT,
       CASE
          WHEN BASIS = 'L' THEN LIST_PR
          WHEN BASIS = '6' THEN BASIS_6
          ELSE NULL
       END
          AS NUM_BASIS,
       ROUND (
          CASE
             WHEN OPER = '-'
             THEN
                (  CASE
                      WHEN BASIS = 'L' THEN LIST_PR
                      WHEN BASIS = '6' THEN BASIS_6
                      ELSE NULL
                   END
                 * (1 - MULT))
             WHEN OPER = 'X'
             THEN
                (  CASE
                      WHEN BASIS = 'L' THEN LIST_PR
                      WHEN BASIS = '6' THEN BASIS_6
                      ELSE NULL
                   END
                 * MULT)
             WHEN OPER = '$'
             THEN
                MULT
             ELSE
                NULL
          END,
          2)
          AS NET_SALE_PRICE,
       ROUND (
          CASE
             WHEN UM_CODE <> 0
             THEN
                  (CASE
                      WHEN OPER = '-'
                      THEN
                         (  CASE
                               WHEN BASIS = 'L' THEN LIST_PR
                               WHEN BASIS = '6' THEN BASIS_6
                               ELSE NULL
                            END
                          * (1 - MULT))
                      WHEN OPER = 'X'
                      THEN
                         (  CASE
                               WHEN BASIS = 'L' THEN LIST_PR
                               WHEN BASIS = '6' THEN BASIS_6
                               ELSE NULL
                            END
                          * MULT)
                      WHEN OPER = '$'
                      THEN
                         MULT
                      ELSE
                         NULL
                   END)
                / UM_CODE
             ELSE
                CASE
                   WHEN OPER = '-'
                   THEN
                      (  CASE
                            WHEN BASIS = 'L' THEN LIST_PR
                            WHEN BASIS = '6' THEN BASIS_6
                            ELSE NULL
                         END
                       * (1 - MULT))
                   WHEN OPER = 'X'
                   THEN
                      (  CASE
                            WHEN BASIS = 'L' THEN LIST_PR
                            WHEN BASIS = '6' THEN BASIS_6
                            ELSE NULL
                         END
                       * MULT)
                   WHEN OPER = '$'
                   THEN
                      MULT
                   ELSE
                      NULL
                END
          END,
          2)
          AS NET_SALE_PRICE_UMADJ,
          UM_CODE
  FROM (SELECT X.ACCOUNT_NUMBER_NK,
               X.DISCOUNT_GROUP_NK,
               X.DISCOUNT_GROUP_NK_NAME,
               X.PRICE_COLUMN,
               X.MAIN_CUSTOMER_GK,
               X.MAIN_CUSTOMER_NK,
               X.CUSTOMER_NAME,
               X.PRODUCT_NK,
               X.ALT1_CODE_AND_PRODUCT_NAME,
               X.TOTAL_QTY,
               X.TOTAL_EXT_AVG_COGS,
               X.TOTAL_EXT_SALES,
               X.MATRIX_QTY,
               X.MATRIX_SLS,
               X.MATRIX_AVG_COGS,
             --  X.MANUAL_QTY,
              -- X.MANUAL_SLS,
              -- X.MANUAL_AVG_COGS,
              -- X.CCOR_QTY,
               --X.CCOR_SLS,
              -- X.CCOR_AVG_COGS,
               NVL (X.PROD_PRICE_ID, X.GRP_PRICE_ID) PRICE_ID,
               CASE
                  WHEN NVL (X.PROD_PRICE_ID, X.GRP_PRICE_ID) =
                          X.PROD_PRICE_ID
                  THEN
                     X.PROD_BASIS
                  ELSE
                     X.GRP_BASIS
               END
                  AS BASIS,
               CASE
                  WHEN NVL (X.PROD_PRICE_ID, X.GRP_PRICE_ID) =
                          X.PROD_PRICE_ID
                  THEN
                     X.PROD_OPER
                  ELSE
                     X.GRP_OPER
               END
                  AS OPER,
               CASE
                  WHEN NVL (X.PROD_PRICE_ID, X.GRP_PRICE_ID) =
                          X.PROD_PRICE_ID
                  THEN
                     X.PROD_MULT
                  ELSE
                     X.GRP_MULT
               END
                  AS MULT,
               CASE
                  WHEN BASIS.HAS_MASTER_LIST = 'Y' THEN MSTR_LIST
                  ELSE AVG_BRANCH_LIST
               END
                  AS LIST_PR,
               BASIS.BASIS_6,
               BASIS.UM_CODE
          FROM (SELECT SLS.ACCOUNT_NUMBER_NK,
                       SLS.DISCOUNT_GROUP_NK,
                       SLS.DISCOUNT_GROUP_NK_NAME,
                       SLS.PRICE_COLUMN,
                       SLS.MAIN_CUSTOMER_GK,
                       SLS.MAIN_CUSTOMER_NK,
                       SLS.CUSTOMER_NAME,
                       SLS.PRODUCT_NK,
                       SLS.ALT1_CODE_AND_PRODUCT_NAME,
                       SLS.TOTAL_QTY,
                       SLS.TOTAL_EXT_AVG_COGS,
                       SLS.TOTAL_EXT_SALES,
                       SLS.MATRIX_QTY,
                       SLS.MATRIX_SLS,
                       SLS.MATRIX_AVG_COGS,
                    --   SLS.MANUAL_QTY,
                    --   SLS.MANUAL_SLS,
                     --  SLS.MANUAL_AVG_COGS,
                     --  SLS.CCOR_QTY,
                      -- SLS.CCOR_SLS,
                      -- SLS.CCOR_AVG_COGS,
                       PROD.PRICE_ID PROD_PRICE_ID,
                       PROD.BASIS PROD_BASIS,
                       PROD.OPERATOR_USED PROD_OPER,
                       PROD.MULTIPLIER PROD_MULT,
                       GRP.PRICE_ID GRP_PRICE_ID,
                       GRP.BASIS GRP_BASIS,
                       GRP.OPERATOR_USED GRP_OPER,
                       GRP.MULTIPLIER GRP_MULT
                  FROM AAA6863.BMI2_PROD_SALES SLS
                       LEFT OUTER JOIN DW_FEI.PRICE_DIMENSION GRP --***********GROUP LEVEL MATRIX***********-----
                          ON     SLS.PRICE_COLUMN = GRP.PRICE_COLUMN
                             AND SLS.ACCOUNT_NUMBER_NK = GRP.BRANCH_NUMBER_NK
                             AND SLS.DISCOUNT_GROUP_NK = GRP.DISC_GROUP
                             AND GRP.DELETE_DATE IS NULL
                       LEFT OUTER JOIN DW_FEI.PRICE_DIMENSION PROD --******PRODUCT LEVEL MATRIX*******-----
                          ON     (SLS.ACCOUNT_NUMBER_NK =
                                     PROD.BRANCH_NUMBER_NK)
                             AND (SLS.PRICE_COLUMN = PROD.PRICE_COLUMN)
                             AND (SLS.PRODUCT_NK = PROD.MASTER_PRODUCT_NK)
                             AND PROD.DELETE_DATE IS NULL
                 WHERE SLS.MATRIX_SLS <> 0
                ORDER BY SLS.ACCOUNT_NUMBER_NK,
                         SLS.MAIN_CUSTOMER_GK,
                         SLS.DISCOUNT_GROUP_NK,
                         SLS.PRODUCT_NK) X
               LEFT OUTER JOIN
               (SELECT ACCOUNT_NUMBER_NK,
                       PRODUCT_NK,
                       HAS_MASTER_LIST,
                       AVG_BRANCH_LIST,
                       UM_CODE,
                       MSTR_LIST,
                       PRIOR_MSTR_LIST,
                       BASIS_6,
                       DISC_GRP
                  FROM AAA6863.BRANCH_STOCK_SKUS_LISTPR) BASIS
                  ON X.PRODUCT_NK = BASIS.PRODUCT_NK
                  AND X.ACCOUNT_NUMBER_NK = BASIS.ACCOUNT_NUMBER_NK)