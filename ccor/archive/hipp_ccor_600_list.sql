--  overrides about to expire 

SELECT 
	BC.DISTRICT DIST,
	CCOR.BRANCH_NUMBER_NK BRANCH,
	BC.BRANCH_NAME,
	CUST.CUSTOMER_NAME,
	CCOR.CONTRACT_ID,
	CCOR.OVERRIDE_ID_NK,
	CCOR.OVERRIDE_TYPE "P/G",
	CCOR.DISC_GROUP DG,
	CCOR.MASTER_PRODUCT P_NUM,
	CCOR.PRODUCT_TEMPLATE TEMPLATE,
	CCOR.EFFECTIVE_PROD,
	CCOR.EXPIRE_DATE EXPIRE,
	CCOR.BASIS BAS,
	CCOR.OPERATOR_USED OP,
	CCOR.MULTIPLIER MULT,
	CCOR.QTY_1,
	CCOR.LAST_UPDATE
FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
	INNER JOIN BRANCH_CONTACTS BC
		ON BC.ACCOUNT_NK = CCOR.BRANCH_NUMBER_NK
	INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
		ON CCOR.CUSTOMER_GK        = CUST.CUSTOMER_GK
			AND CUST.ACCOUNT_NUMBER_NK = BC.ACCOUNT_NK
WHERE BC.DISTRICT              IN ('C10', 'C11', 'C12')

	AND TO_CHAR (CCOR.EXPIRE_DATE, 'YYYYMM') BETWEEN TO_CHAR (
                                                           TRUNC (
                                                              SYSDATE
                                                              - NUMTOYMINTERVAL (
                                                                   4,
                                                                   'MONTH'),
                                                              'MONTH'),
                                                           'YYYYMM')
                                                    AND TO_CHAR (
                                                           TRUNC (SYSDATE,
                                                                  'MM')
                                                           - 1,
                                                           'YYYYMM')
	AND CCOR.DELETE_DATE      IS NULL
	;