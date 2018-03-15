--Update Branch Logon Account Names in Query Body to reflect current and destination branches
SELECT Q.SRC_ACCT, 
			 Q.PRICE_COLUMN,
       Q.MAIN_CUSTOMER_GK,
       Q.MAIN_CUSTOMER_NK,
       Q.CUSTOMER_NAME,
       Q.DISCOUNT_GROUP_NK,
       Q.DISCOUNT_GROUP_NK_NAME,
       Q.PRODUCT_NK,
       P.ALT1_CODE,
       Q.PRICE_ID,
       Q.BASIS,
       Q.OPER,
       Q.MULT,
       Q.NUM_BASIS,
       Q.NET_SALE_PRICE,
       Q.TOTAL_QTY,
       Q.TOTAL_EXT_AVG_COGS,
       Q.TOTAL_EXT_SALES,
       Q.MATRIX_QTY,
       Q.MATRIX_SLS,
       Q.MATRIX_AVG_COGS,
       Q.DEST_PC,
       Q.DEST_PRICE_ID,
       Q.DEST_BASIS,
       Q.DEST_OPER,
       Q.DEST_TRUE_MULT,
       Q.DEST_MULT,
       Q.DEST_NUM_BASIS,
       Q.DEST_NET_PRICE,
       CASE WHEN Q.NET_SALE_PRICE <> 0 THEN ROUND((Q.DEST_NET_PRICE-Q.NET_SALE_PRICE)/Q.NET_SALE_PRICE,3) ELSE NULL END AS FORM_COMPARE,
       ABS(ROUND((Q.DEST_NET_PRICE-Q.NET_SALE_PRICE)*Q.MATRIX_QTY,3)) IMPACT_AMT,
       ROUND((Q.DEST_NET_PRICE-Q.NET_SALE_PRICE)*Q.MATRIX_QTY,3) NET_IMPACT_AMT
  FROM (SELECT SALES.ACCOUNT_NUMBER_NK SRC_ACCT,
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
                     --  X.DEST_PC_SUBGRP,
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
                             --  COMP.SRC_PC_SUBGRP,
                               --SRC.NET_SALE_PRICE,
                               DEST.ACCOUNT_NUMBER_NK DEST_ACCOUNT_NUMBER_NK,
                               COMP.DEST_PC,
                              -- COMP.DEST_PC_SUBGRP,
                               DEST_PC || '*P#' || SRC.PRODUCT_NK
                                  AS DEST_PROD_PRICE_ID,
                               DEST_PC || '*G#' || SRC.DISCOUNT_GROUP_NK
                                  AS DEST_GRP_PRICE_ID
                          --GRP.TRUE_MULT
                          FROM AAA6863.BMI2_SRC_SALES_MATR SRC --****SOURCE SALES + MATRIX INFO***
                               INNER JOIN AAA6863.BMI2_DEST_MATR DEST --*****/////DEST MATRIX////****
                                  ON SRC.DISCOUNT_GROUP_NK =
                                        DEST.DISC_GRP
                               INNER JOIN AAA6863.PR_MERGE_PC_COMPARE_NE COMP --****COMPARISON TABLE****
                                  ON     SRC.PRICE_COLUMN = COMP.SRC_PC
                                     AND COMP.DEST_PC =
                                            DEST.PRICE_COLUMN) X
                       LEFT OUTER JOIN AAA6863.BMI2_DEST_MATR PROD ------*******DEST MATRIX PRODUCT
                          ON     X.DEST_PROD_PRICE_ID = PROD.PRICE_ID
                             AND X.DEST_PC = PROD.PRICE_COLUMN
                       LEFT OUTER JOIN AAA6863.BMI2_DEST_MATR GRP ---********DEST MATRIX GROUP
                          ON     X.DEST_GRP_PRICE_ID = GRP.PRICE_ID
                             AND X.DEST_PC = GRP.PRICE_COLUMN
                       LEFT OUTER JOIN AAA6863.BRANCH_STOCK_SKUS_LISTPR LISTPR ----*******LIST PRICE
                          ON X.PRODUCT_NK = LISTPR.PRODUCT_NK
                          AND X.DEST_ACCOUNT_NUMBER_NK = LISTPR.ACCOUNT_NUMBER_NK
                          ) COMP
                  ON     SALES.DISCOUNT_GROUP_NK = COMP.DISCOUNT_GROUP_NK
                     AND SALES.PRICE_COLUMN = COMP.SRC_PC
                     AND SALES.PRODUCT_NK = COMP.PRODUCT_NK
                     AND SALES.ACCOUNT_NUMBER_NK = COMP.SRC_ACCT) Q
                INNER JOIN AAA6863.PR_MERGE_REC2 REC
                     ON      Q.SRC_ACCT = REC.ACCOUNT_NUMBER_NK
              AND Q.DEST_PC = REC.DEST_PC
             AND Q.MAIN_CUSTOMER_GK = REC.MAIN_CUSTOMER_GK
             LEFT OUTER JOIN DW_FEI.PRODUCT_DIMENSION P
             ON Q.PRODUCT_NK = P.PRODUCT_NK