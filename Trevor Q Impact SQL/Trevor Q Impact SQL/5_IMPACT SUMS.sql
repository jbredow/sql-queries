--Update Branch Logon Account Names in Query Body to reflect current and destination branches

DROP TABLE AAA6863.BMI2_IMPACT_SUMS;

CREATE TABLE AAA6863.BMI2_IMPACT_SUMS

AS
   SELECT ACCOUNT_NUMBER_NK,
          MAIN_CUSTOMER_GK,
          MAIN_CUSTOMER_NK,
          CUSTOMER_NAME,
          LTRIM (PRICE_COLUMN) SRC_PRICE_COLUMN,
          LTRIM (DEST_PC) DEST_PC,
          LTRIM (PRICE_COLUMN || '_' || DEST_PC) IMPACT_KEY,
          SUM (NET_IMPACT_AMT) IMPACT_AMT
     FROM (
SELECT ACCOUNT_NUMBER_NK,
       PRICE_COLUMN,
       MAIN_CUSTOMER_GK,
       MAIN_CUSTOMER_NK,
       CUSTOMER_NAME,
       DISCOUNT_GROUP_NK,
       DISCOUNT_GROUP_NK_NAME,
       PRICE_ID,
       PRODUCT_NK,
       BASIS,
       OPER,
       MULT,
       NUM_BASIS,
       NET_SALE_PRICE,
       TOTAL_QTY,
       TOTAL_EXT_AVG_COGS,
       TOTAL_EXT_SALES,
       MATRIX_QTY,
       MATRIX_SLS,
       MATRIX_AVG_COGS,
       DEST_PC,
       DEST_PRICE_ID,
       DEST_BASIS,
       DEST_OPER,
       DEST_TRUE_MULT,
       DEST_MULT,
       DEST_NUM_BASIS,
       DEST_NET_PRICE,
       ROUND(((DEST_NET_PRICE-NET_SALE_PRICE)/NET_SALE_PRICE),3) FORM_COMPARE,
       ABS(ROUND(((DEST_NET_PRICE - NET_SALE_PRICE)*MATRIX_QTY),3)) ABS_IMPACT_AMT,
       ROUND(((DEST_NET_PRICE - NET_SALE_PRICE)*MATRIX_QTY),3) NET_IMPACT_AMT
  FROM (SELECT SALES.ACCOUNT_NUMBER_NK,
               SALES.PRICE_COLUMN,
               SALES.MAIN_CUSTOMER_GK,
               SALES.MAIN_CUSTOMER_NK,
               SALES.CUSTOMER_NAME,
               SALES.DISCOUNT_GROUP_NK,
               SALES.DISCOUNT_GROUP_NK_NAME,
               SALES.PRODUCT_NK,
               SALES.PRICE_ID,
               SALES.BASIS,
               SALES.OPER,
               SALES.MULT,
               SALES.NUM_BASIS,
               SALES.NET_SALE_PRICE_UMADJ NET_SALE_PRICE,
               SALES.TOTAL_QTY,
               SALES.TOTAL_EXT_AVG_COGS,
               SALES.TOTAL_EXT_SALES,
               SALES.MATRIX_QTY,
               SALES.MATRIX_SLS,
               SALES.MATRIX_AVG_COGS,
               COMP.DEST_PC,
               COMP.DEST_PRICE_ID,
               COMP.DEST_BASIS,
               COMP.DEST_OPER,
               COMP.DEST_TRUE_MULT,
               COMP.DEST_MULT,
               COMP.DEST_NUM_BASIS,
               CASE
                  WHEN COMP.UM_CODE <> 0
                  THEN
                     ROUND (
                          (CASE
                              WHEN COMP.DEST_OPER = '$'
                              THEN
                                 COMP.DEST_TRUE_MULT
                              ELSE
                                 ROUND (COMP.DEST_NUM_BASIS * COMP.DEST_MULT,
                                        2)
                           END)
                        / COMP.UM_CODE,
                        2)
                  ELSE
                     (CASE
                         WHEN COMP.DEST_OPER = '$' THEN COMP.DEST_TRUE_MULT
                         ELSE ROUND (COMP.DEST_NUM_BASIS * COMP.DEST_MULT, 2)
                      END)
               END
                  AS DEST_NET_PRICE
          FROM AAA6863.BMI2_SRC_SALES_MATR SALES --****SOURCE SALES + MATRIX INFO***---
               LEFT OUTER JOIN
               (SELECT X.SRC_ACCT,
                       X.DISCOUNT_GROUP_NK,
                       X.PRODUCT_NK,
                       X.NUM_BASIS,
                       X.UM_CODE,
                       X.SRC_PC,
                      -- X.SRC_PC_SUBGRP,
                       X.DEST_PC,
                    --   X.DEST_PC_SUBGRP,
                       NVL (PROD.PRICE_ID, GRP.PRICE_ID) DEST_PRICE_ID,
                       CASE
                          WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                  PROD.PRICE_ID
                          THEN
                             PROD.B
                          ELSE
                             GRP.B
                       END
                          AS DEST_BASIS,
                       CASE
                          WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                  PROD.PRICE_ID
                          THEN
                             PROD.O
                          ELSE
                             GRP.O
                       END
                          AS DEST_OPER,
                       CASE
                          WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                  PROD.PRICE_ID
                          THEN
                             PROD.TRUE_MULT
                          ELSE
                             GRP.TRUE_MULT
                       END
                          AS DEST_TRUE_MULT,
                       CASE
                          WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                  PROD.PRICE_ID
                          THEN
                             PROD.MULTIPLIER
                          ELSE
                             GRP.MULTIPLIER
                       END
                          AS DEST_MULT,
                       CASE
                          WHEN (CASE
                                   WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                           PROD.PRICE_ID
                                   THEN
                                      PROD.O
                                   ELSE
                                      GRP.O
                                END) = '$'
                          THEN
                             (CASE
                                 WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                         PROD.PRICE_ID
                                 THEN
                                    PROD.TRUE_MULT
                                 ELSE
                                    GRP.TRUE_MULT
                              END)
                          WHEN (CASE
                                   WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                           PROD.PRICE_ID
                                   THEN
                                      PROD.B
                                   ELSE
                                      GRP.B
                                END) = 'L'
                          THEN
                             (CASE
                                 WHEN LISTPR.HAS_MASTER_LIST = 'Y'
                                 THEN
                                    LISTPR.MSTR_LIST
                                 ELSE
                                    LISTPR.AVG_BRANCH_LIST
                              END)
                          WHEN (CASE
                                   WHEN NVL (PROD.PRICE_ID, GRP.PRICE_ID) =
                                           PROD.PRICE_ID
                                   THEN
                                      PROD.B
                                   ELSE
                                      GRP.B
                                END) = '6'
                          THEN
                             LISTPR.BASIS_6
                          ELSE
                             NULL
                       END
                          AS DEST_NUM_BASIS
                  FROM (SELECT DISTINCT
                               SRC.ACCOUNT_NUMBER_NK SRC_ACCT,
                               SRC.DISCOUNT_GROUP_NK,
                               SRC.PRODUCT_NK,
                               SRC.NUM_BASIS,
                               SRC.UM_CODE,
                               COMP.SRC_PC,
                              -- COMP.SRC_PC_SUBGRP,
                               DEST.ACCOUNT_NUMBER_NK DEST_ACCT,
                               COMP.DEST_PC,
                              -- COMP.DEST_PC_SUBGRP,
                               DEST_PC ||'*P#'|| SRC.PRODUCT_NK
                                  AS DEST_PROD_PRICE_ID,
                               DEST_PC ||'*G#'|| SRC.DISCOUNT_GROUP_NK
                                  AS DEST_GRP_PRICE_ID
                          --GRP.TRUE_MULT
                          FROM AAA6863.BMI2_SRC_SALES_MATR SRC --****SOURCE SALES + SOURCE MATRIX INFO***
                               INNER JOIN AAA6863.BMI2_DEST_MATR DEST --*****/////DEST MATRIX////****
                                  ON SRC.DISCOUNT_GROUP_NK =
                                        DEST.DISC_GRP
                               INNER JOIN AAA6863.PR_MERGE_PC_COMPARE_NE COMP --****PC COMPARISON TABLE****
                                  ON     SRC.PRICE_COLUMN = COMP.SRC_PC
                                     AND COMP.DEST_PC =
                                            DEST.PRICE_COLUMN) X
                       LEFT OUTER JOIN AAA6863.BMI2_DEST_MATR PROD ------*******DEST PROD MATRIX
                          ON     X.DEST_PROD_PRICE_ID = PROD.PRICE_ID
                             AND X.DEST_PC = PROD.PRICE_COLUMN
                       LEFT OUTER JOIN AAA6863.BMI2_DEST_MATR GRP ---********DEST GROUP MATRIX
                          ON     X.DEST_GRP_PRICE_ID = GRP.PRICE_ID
                             AND X.DEST_PC = GRP.PRICE_COLUMN
                       LEFT OUTER JOIN AAA6863.BRANCH_STOCK_SKUS_LISTPR LISTPR ----*******DESTINATION LIST PRICE**********
                          ON X.PRODUCT_NK = LISTPR.PRODUCT_NK
                          AND X.DEST_ACCT=LISTPR.ACCOUNT_NUMBER_NK) COMP --REMOVE JOIN BETWEEN ACCOUNT # HERE TO APPLY SOURCE LIST PRICE TO DESTINATION FORMULAE
                  ON     SALES.DISCOUNT_GROUP_NK = COMP.DISCOUNT_GROUP_NK
                     AND SALES.PRICE_COLUMN = COMP.SRC_PC
                     AND SALES.PRODUCT_NK = COMP.PRODUCT_NK
                     AND SALES.ACCOUNT_NUMBER_NK = COMP.SRC_ACCT)) 
    WHERE DEST_PC IS NOT NULL   
    GROUP BY ACCOUNT_NUMBER_NK,
            MAIN_CUSTOMER_GK,
            MAIN_CUSTOMER_NK,
            CUSTOMER_NAME,
            LTRIM (PRICE_COLUMN),
            LTRIM (DEST_PC),
            LTRIM (PRICE_COLUMN || '_' || DEST_PC);