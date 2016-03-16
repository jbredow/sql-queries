/* price column descriptions */
SELECT DISTINCT 
	PC.PRICE_COLUMN,
	PC.COLUMN_NAME
FROM AAD9606.PR_COLUMN_STRATEGY_2014 PC
WHERE PC.STATUS = 'Valid'
;