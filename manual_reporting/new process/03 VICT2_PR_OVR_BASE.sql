TRUNCATE TABLE PRICE_MGMT.PR_OVR_BASE;
DROP TABLE PRICE_MGMT.PR_OVR_BASE;

CREATE TABLE PRICE_MGMT.PR_OVR_BASE
NOLOGGING
AS
   SELECT DISTINCT
          COD.BASIS,
          COD.BRANCH_NUMBER_NK,
          COD.CONTRACT_ID,
          COD.CUSTOMER_GK,
          COD.CUSTOMER_NK,
          COD.DISC_GROUP,
          COD.INSERT_TIMESTAMP,
          NVL (COD.EXPIRE_DATE, SYSDATE)
             EXPIRE_DATE,
          COD.MASTER_PRODUCT,
          TO_NUMBER (COD.MULTIPLIER)
             MULTIPLIER,
          COD.OPERATOR_USED,
          COD.OVERRIDE_ID_NK,
          COD.OVERRIDE_TYPE,
          CASE
             WHEN COD.OPERATOR_USED <> '$'
             THEN
                COD.BASIS || COD.OPERATOR_USED || '0' || COD.MULTIPLIER
             ELSE
                TO_CHAR (COD.MULTIPLIER)
          END
             FORMULA
   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD, PRICE_MGMT.PR_VICT2_SLS V
   WHERE     COD.OVERRIDE_TYPE = 'P'
         AND COD.BRANCH_NUMBER_NK = V.ACCOUNT_NUMBER
         AND COD.CUSTOMER_NK = V.MAIN_CUSTOMER_NK
         AND COD.DELETE_DATE IS NULL
         --AND V.JOB_YN = 'N'
         AND NVL (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 8)
         AND V.PRODUCT_NK = COD.MASTER_PRODUCT