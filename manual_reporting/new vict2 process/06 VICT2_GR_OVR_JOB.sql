TRUNCATE TABLE PRICE_MGMT.GR_OVR_JOB;
DROP TABLE PRICE_MGMT.GR_OVR_JOB;

CREATE TABLE PRICE_MGMT.GR_OVR_JOB
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
   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD, PRICE_MGMT.PR_VICT2_SALES V
   WHERE     COD.OVERRIDE_TYPE = 'G'
         AND COD.BRANCH_NUMBER_NK = V.ACCOUNT_NUMBER
         AND COD.CUSTOMER_GK = V.CUSTOMER_ACCOUNT_GK
         AND COD.DELETE_DATE IS NULL
         AND V.JOB_YN = 'Y'
         AND NVL (COD.EXPIRE_DATE, SYSDATE) >= (SYSDATE - 8)
         AND V.DISCOUNT_GROUP_NK = COD.DISC_GROUP