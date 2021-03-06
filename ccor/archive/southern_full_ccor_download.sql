/*     change the tablename to current month     */

--full customer contract override download(12 Month)
DROP TABLE AAB9896.CCOR_SOUTHERN_0314;

CREATE TABLE AAB9896.CCOR_SOUTHERN_0314 AS

SELECT DISTINCT CONTACTS.RPC,
	CONTACTS.DISTRICT,
	CCORG.BRANCH_NUMBER_NK,
    CONTACTS.ALIAS,
    CCORG.CUSTOMER_NK,
    CCORG.CONTRACT_ID,
    CCORG.OVERRIDE_ID_NK,
    CCORG.OVERRIDE_TYPE,
    CCORG.DISC_GROUP,
    DG.DISCOUNT_GROUP_NAME,
    NULL AS ALT1_CODE,
    NULL AS PRODUCT_NAME,
    NVL (CCORG.EXPIRE_DATE, NULL) EXP_DATE,
    CCORG.BASIS,
    CCORG.OPERATOR_USED,
    CCORG.MULTIPLIER,
    CCORG.INSERT_TIMESTAMP,
    CCORG.UPDATE_TIMESTAMP,
    CCORG.LAST_UPDATE,
    CCORG.COST_REBATE,
    CCORG.DELETE_DATE

FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORG,
     DW_FEI.DISCOUNT_GROUP_DIMENSION DG,
     AAF1046.BRANCH_CONTACTS CONTACTS
     
WHERE CCORG.DISC_GROUP = DG.DISCOUNT_GROUP_NK
    AND CONTACTS.ACCOUNT_NK = CCORG.BRANCH_NUMBER_NK
    AND CCORG.OVERRIDE_TYPE = 'G'
    --AND (SYSDATE - CCORG.INSERT_TIMESTAMP > 365)
    AND CCORG.DELETE_DATE IS NULL
    --AND CCORG.OPERATOR_USED = 'X'
    AND CONTACTS.RPC = 'Southern'
    --AND CCORG.BRANCH_NUMBER_NK = '305'
    --AND CCORG.EXPIRE_DATE > SYSDATE - 90
    
UNION
--Old Product CCORs (12 Month)
SELECT DISTINCT CONTACTS.RPC,
	CONTACTS.DISTRICT,
	CCORP.BRANCH_NUMBER_NK,
    CONTACTS.ALIAS,
    CCORP.CUSTOMER_NK,
    CCORP.CONTRACT_ID,
    CCORP.OVERRIDE_ID_NK,
    CCORP.OVERRIDE_TYPE,
    PROD.DISCOUNT_GROUP_NK,
    DG.DISCOUNT_GROUP_NAME,
    PROD.ALT1_CODE,
    PROD.PRODUCT_NAME,
    NVL (CCORP.EXPIRE_DATE, NULL) EXP_DATE,
    CCORP.BASIS,
    CCORP.OPERATOR_USED,
    CCORP.MULTIPLIER,
    CCORP.INSERT_TIMESTAMP,
    CCORP.UPDATE_TIMESTAMP,
    CCORP.LAST_UPDATE,
    CCORP.COST_REBATE,
    CCORP.DELETE_DATE
    
FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORP,
     DW_FEI.PRODUCT_DIMENSION PROD,
     DW_FEI.DISCOUNT_GROUP_DIMENSION DG,
     AAF1046.BRANCH_CONTACTS CONTACTS
     
WHERE CCORP.MASTER_PRODUCT = PROD.PRODUCT_NK
    AND PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
    AND CONTACTS.ACCOUNT_NK = CCORP.BRANCH_NUMBER_NK
    AND CCORP.OVERRIDE_TYPE = 'P'
    --AND (SYSDATE - CCORP.INSERT_TIMESTAMP > 365)
    AND CCORP.DELETE_DATE IS NULL
    --AND CCORP.OPERATOR_USED = 'X'
    AND CONTACTS.RPC = 'Southern'
    --AND CCORP.BRANCH_NUMBER_NK = '305'
    --AND CCORP.EXPIRE_DATE > SYSDATE - 90
	
	UNION
--Old Product CCORs (12 Month)
SELECT DISTINCT CONTACTS.RPC,
	CONTACTS.DISTRICT,
	CCORC.BRANCH_NUMBER_NK,
    CONTACTS.ALIAS,
    CCORC.CUSTOMER_NK,
    CCORC.CONTRACT_ID,
    CCORC.OVERRIDE_ID_NK,
    CCORC.OVERRIDE_TYPE,
    PROD.DISCOUNT_GROUP_NK,
    DG.DISCOUNT_GROUP_NAME,
    PROD.ALT1_CODE,
    PROD.PRODUCT_NAME,
    NVL (CCORC.EXPIRE_DATE, NULL) EXP_DATE,
    CCORC.BASIS,
    CCORC.OPERATOR_USED,
    CCORC.MULTIPLIER,
    CCORC.INSERT_TIMESTAMP,
    CCORC.UPDATE_TIMESTAMP,
    CCORC.LAST_UPDATE,
    CCORC.COST_REBATE,
    CCORC.DELETE_DATE
    
    
FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORC,
     DW_FEI.PRODUCT_DIMENSION PROD,
     DW_FEI.DISCOUNT_GROUP_DIMENSION DG,
     AAF1046.BRANCH_CONTACTS CONTACTS
     
WHERE CCORC.MASTER_PRODUCT = PROD.PRODUCT_NK
    AND PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
    AND CONTACTS.ACCOUNT_NK = CCORC.BRANCH_NUMBER_NK
    AND CCORC.OVERRIDE_TYPE = 'C'
    --AND (SYSDATE - CCORP.INSERT_TIMESTAMP > 365)
    AND CCORC.DELETE_DATE IS NULL
    AND CONTACTS.RPC = 'Southern'
    --AND CCORC.BRANCH_NUMBER_NK = '305';
    --AND CCORC.EXPIRE_DATE > SYSDATE - 90;
    
    
    SELECT * FROM AAB9896.CCOR_SOUTHERN_0314 CCOR WHERE CCOR.DISTRICT IN 'W%';
    SELECT * FROM AAB9896.CCOR_SOUTHERN_0314 CCOR WHERE CCOR.DISTRICT = 'H40';
    SELECT * FROM AAB9896.CCOR_SOUTHERN_0314 CCOR WHERE CCOR.DISTRICT IN ('H40','H42');
    SELECT * FROM AAB9896.CCOR_SOUTHERN_0314 CCOR WHERE ccor.branch_number_nk = '305';

	