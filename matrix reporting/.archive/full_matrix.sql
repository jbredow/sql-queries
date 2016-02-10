SELECT DISTINCT
  CASE
    WHEN PRICE.PRICE_TYPE = 'G' 
	THEN PRICE.PRICE_TYPE
      || '#'
      || PRICE.DISC_GROUP
      || '*'
      || PRICE.PRICE_COLUMN
    WHEN PRICE.PRICE_TYPE = 'P' THEN PRICE.PRICE_TYPE
      || '#'
      || PROD.ALT1_CODE
      || '*'
      || PRICE.PRICE_COLUMN
    ELSE NULL
  END AS CONCAT,
  PRICE.BRANCH_NUMBER_NK,
  PRICE.PRICE_COLUMN AS PC,
  PRICE.MASTER_PRODUCT_NK,
  PROD.ALT1_CODE,
  PRICE.DISC_GROUP AS DG,
  PRICE.PRICE_TYPE AS PTYPE,
  PRICE.BASIS BAS,
  PRICE.OPERATOR_USED OP,
  PRICE.MULTIPLIER,
  PRICE.UPDATE_TIMESTAMP UPDATE_DATE,
  CONTACTS.RPC
FROM DW_FEI.PRICE_DIMENSION PRICE,
  BRANCH_CONTACTS CONTACTS,
  DW_FEI.PRODUCT_DIMENSION PROD
WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
AND PRICE.MASTER_PRODUCT_NK  = PROD.PRODUCT_NK
AND (PRICE.PRICE_COLUMN      < (170)
AND CONTACTS.RPC             = 'Midwest'
AND PRICE.DELETE_DATE       IS NULL
AND CONTACTS.ACCOUNT_NK      = '1116'
AND PRICE.PRICE_COLUMN NOT  IN (23))
ORDER BY PRICE.BRANCH_NUMBER_NK,
  PRICE.DISC_GROUP,
  PRICE.PRICE_COLUMN;