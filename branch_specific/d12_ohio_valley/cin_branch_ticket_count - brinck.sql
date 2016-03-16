SELECT V2.WAREHOUSE_NUMBER,
	V2.WRITER,
	EMP.TITLE_DESC,
	EMP.ASSOC_NAME,
	V2.PRICE_CATEGORY,
	COUNT(DISTINCT V2.INVOICE_NUMBER_NK),
	EMP.DELETE_DATE
FROM PR_VICT2_CUST_12MO V2
	INNER JOIN DW_FEI.EMPLOYEE_DIMENSION EMP
		ON EMP.INITIALS         = V2.WRITER
		AND EMP.ACCOUNT_NAME    = V2.ACCOUNT_NAME
WHERE V2.ACCOUNT_NUMBER = 1480
	AND V2.PRICE_CATEGORY  IN ('MATRIX', 'MATRIX BID')
	AND EMP.DELETE_DATE    IS NULL
GROUP BY V2.WAREHOUSE_NUMBER,
	V2.WRITER,
	EMP.TITLE_DESC,
	EMP.ASSOC_NAME,
	V2.PRICE_CATEGORY,
	EMP.DELETE_DATE
ORDER BY V2.WAREHOUSE_NUMBER,
	V2.WRITER