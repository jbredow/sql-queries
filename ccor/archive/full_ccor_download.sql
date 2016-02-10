--full customer contract override download(12 Month)
--DROP TABLE AAA6863.CCOR_MIDWEST_0913;

CREATE TABLE AAA6863.CCOR_MIDWEST_1113 AS

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
    CCORG.EXPIRE_DATE,
    CCORG.BASIS,
    CCORG.OPERATOR_USED,
    CCORG.MULTIPLIER,
    CCORG.INSERT_TIMESTAMP,
    CCORG.UPDATE_TIMESTAMP,
    CCORG.LAST_UPDATE,
    CCORG.DELETE_DATE

FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORG,
     DW_FEI.DISCOUNT_GROUP_DIMENSION DG,
     AAF1046.BRANCH_CONTACTS CONTACTS
     
WHERE CCORG.DISC_GROUP = DG.DISCOUNT_GROUP_NK
    AND CONTACTS.ACCOUNT_NK = CCORG.BRANCH_NUMBER_NK
    AND CCORG.OVERRIDE_TYPE = 'G'
    --AND (SYSDATE - CCORG.INSERT_TIMESTAMP > 365)
    AND CCORG.DELETE_DATE IS NULL
    AND CONTACTS.RPC = 'Midwest'
    
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
    CCORP.EXPIRE_DATE,
    CCORP.BASIS,
    CCORP.OPERATOR_USED,
    CCORP.MULTIPLIER,
    CCORP.INSERT_TIMESTAMP,
    CCORP.UPDATE_TIMESTAMP,
    CCORP.LAST_UPDATE,
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
    AND CONTACTS.RPC = 'Midwest';

	GRANT SELECT ON AAA6863.CCOR_MIDWEST_1113 TO PUBLIC;