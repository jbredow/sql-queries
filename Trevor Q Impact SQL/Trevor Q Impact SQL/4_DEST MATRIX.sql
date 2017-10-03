DROP TABLE AAA6863.BMI2_DEST_MATR;

CREATE TABLE AAA6863.BMI2_DEST_MATR --Name table here with your AA# and merge location
AS
SELECT
ACCOUNT_NUMBER_NK,
PRICE_COLUMN, 
DISC_GRP,
PRICE_ID,
BASIS B,
OPER O,
TRUE_MULT,
DISCOUNT,
MULTIPLIER,
SUBSTR(PRICE_ID,5,1) PRICE_CODE,
CASE 
WHEN SUBSTR(PRICE_ID,5,1) = 'P'
THEN SUBSTR(PRICE_ID,7) 
ELSE NULL 
END AS PRODUCT_NK
FROM(SELECT --ACCOUNT_NAME,
                  ACCOUNT_NUMBER_NK,
                  PRICE_COLUMN,
                  DISC_GRP,
                  --DISCOUNT_GROUP_NAME,
                  PRICE_ID,
                  -- MAX (PROD_OVR_COUNT) PROD_OVR_COUNT,
                  MAX (BASIS) BASIS,
                  MAX (OPER) OPER,
                  MAX (TRUE_MULT) TRUE_MULT,
                  MAX (DISCOUNT) DISCOUNT,
                  MAX (MULTIPLIER) MULTIPLIER
             FROM (SELECT SD.ACCOUNT_NAME,
                          SD.ACCOUNT_NUMBER_NK,
                          PR_DIM.PRICE_COLUMN,
                          PR_DIM.DISC_GROUP DISC_GRP,
                          DG.DISCOUNT_GROUP_NAME,
                          PR_DIM.PRICE_ID,
                          --NULL PROD_OVR_COUNT,
                          PR_DIM.BASIS,
                          PR_DIM.OPERATOR_USED AS OPER,
                          PR_DIM.MULTIPLIER AS TRUE_MULT,
                          (  1
                           - (CASE
                                 WHEN PR_DIM.OPERATOR_USED = '-'
                                 THEN
                                    1 - PR_DIM.MULTIPLIER
                                 WHEN PR_DIM.OPERATOR_USED = '+'
                                 THEN
                                    1 + PR_DIM.MULTIPLIER
                                 WHEN PR_DIM.OPERATOR_USED = '/'
                                 THEN
                                    1 / PR_DIM.MULTIPLIER
                                 ELSE
                                    PR_DIM.MULTIPLIER
                              END))
                             AS DISCOUNT,
                          CASE
                             WHEN PR_DIM.OPERATOR_USED = '-'
                             THEN
                                1 - PR_DIM.MULTIPLIER
                             WHEN PR_DIM.OPERATOR_USED = '+'
                             THEN
                                1 + PR_DIM.MULTIPLIER
                             WHEN PR_DIM.OPERATOR_USED = '/'
                             THEN
                                1 / PR_DIM.MULTIPLIER
                             ELSE
                                PR_DIM.MULTIPLIER
                          END
                             AS MULTIPLIER
                     FROM DW_FEI.PRICE_DIMENSION PR_DIM,
                          --DW_FEI.PRODUCT_DIMENSION PROD,
                          EBUSINESS.SALES_DIVISIONS SD,
                          DW_FEI.DISCOUNT_GROUP_DIMENSION DG
                    WHERE     PR_DIM.DISC_GROUP = DG.DISCOUNT_GROUP_NK
                          AND PR_DIM.BRANCH_NUMBER_NK = SD.ACCOUNT_NUMBER_NK
                          AND PR_DIM.PRICE_TYPE = 'G'
                          AND PR_DIM.PRICE_COLUMN IN ('001','002','003','004')
                          AND PR_DIM.DELETE_DATE IS NULL
                          --AND PR_DIM.BASIS || PR_DIM.OPERATOR_USED IN ('L-', 'LX')
                          AND NVL (PR_DIM.MULTIPLIER, 0) <> 0
                          --*** LIST BRANCHES HERE ***--
                          AND SD.ACCOUNT_NUMBER_NK IN ('501') --Insert all involved Branches here
                                                              )
           GROUP BY ACCOUNT_NAME,
                    ACCOUNT_NUMBER_NK,
                    PRICE_COLUMN,
                    DISC_GRP,
                    DISCOUNT_GROUP_NAME,
                    PRICE_ID
          UNION
          SELECT PR_DIM.BRANCH_NUMBER_NK,
                  PR_DIM.PRICE_COLUMN,
                  PROD.DISCOUNT_GROUP_NK,
                  --PROD.PRODUCT_NK,
                  PR_DIM.PRICE_ID,
                  PR_DIM.BASIS,
                  PR_DIM.OPERATOR_USED AS OPER,
                  PR_DIM.MULTIPLIER AS TRUE_MULT,
                  (  1
                   - (CASE
                         WHEN PR_DIM.OPERATOR_USED = '-'
                         THEN
                            1 - PR_DIM.MULTIPLIER
                         WHEN PR_DIM.OPERATOR_USED = '+'
                         THEN
                            1 + PR_DIM.MULTIPLIER
                         WHEN PR_DIM.OPERATOR_USED = '/'
                         THEN
                            1 / PR_DIM.MULTIPLIER
                         ELSE
                            PR_DIM.MULTIPLIER
                      END))
                     AS DISCOUNT,
                  CASE
                     WHEN PR_DIM.OPERATOR_USED = '-'
                     THEN
                        1 - PR_DIM.MULTIPLIER
                     WHEN PR_DIM.OPERATOR_USED = '+'
                     THEN
                        1 + PR_DIM.MULTIPLIER
                     WHEN PR_DIM.OPERATOR_USED = '/'
                     THEN
                        1 / PR_DIM.MULTIPLIER
                     ELSE
                        PR_DIM.MULTIPLIER
                  END
                     AS MULTIPLIER
             FROM DW_FEI.PRICE_DIMENSION PR_DIM
                  INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
                     ON PR_DIM.MASTER_PRODUCT_NK = PROD.PRODUCT_NK
            WHERE     PR_DIM.PRICE_TYPE = 'P'
                  AND PR_DIM.PRICE_COLUMN IN('001','002','003','004')
                  AND PR_DIM.DELETE_DATE IS NULL
                  --AND PR_DIM.BASIS || PR_DIM.OPERATOR_USED IN ('L-', 'LX')
                  AND NVL (PR_DIM.MULTIPLIER, 0) <> 0
                  --*** LIST BRANCHES HERE ***--
                  AND PR_DIM.BRANCH_NUMBER_NK = '501')