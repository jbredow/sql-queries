SELECT IHF.ACCOUNT_NUMBER,
	BC.ACCOUNT_NAME,
	ILF.YEARMONTH,
	PROD.DISCOUNT_GROUP_NK,
	CASE
		WHEN IHF.CHANNEL_TYPE IN ('H3', 'H7', 'O3', 'O7')
		THEN 'Direct'
		ELSE 'Stock'
	END AS CHANNEL,
	SUM(ILF.EXT_SALES_AMOUNT),
	SUM(ILF.EXT_AVG_COGS_AMOUNT)
FROM DW_FEI.INVOICE_LINE_FACT ILF
	INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
		ON IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
	INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
		ON IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
	INNER JOIN AAA6863.BRANCH_CONTACTS BC
		ON CUST.ACCOUNT_NUMBER_NK = BC.ACCOUNT_NK
	INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
		ON ILF.PRODUCT_NUMBER_NK = PROD.PRODUCT_NK
WHERE BC.DISTRICT IN ('C10', 'C11', 'C12')
	AND ILF.YEARMONTH BETWEEN TO_CHAR(TRUNC(
			SYSDATE - NUMTOYMINTERVAL(12, 'MONTH'), 'MONTH'), 'YYYYMM') 
		AND TO_CHAR(TRUNC(SYSDATE, 'MM') - 1, 'YYYYMM')
	AND IHF.YEARMONTH BETWEEN TO_CHAR(TRUNC(
			SYSDATE - NUMTOYMINTERVAL(12, 'MONTH'), 'MONTH'), 'YYYYMM') 
		AND TO_CHAR(TRUNC(SYSDATE, 'MM') - 1, 'YYYYMM')
	AND DECODE (PROD.DISCOUNT_GROUP_NK, 	'2106', 1, 
											'2284', 1,  
											'2539', 1, 
											'3402', 1,
											'3406', 1,
											'3413', 1,
											'3419', 1,
											'3422', 1,
											'3683', 1,
											'3698', 1,
											'3735', 1,
											'3755', 1,
											'3785', 1,
											'3800', 1,
											'3846', 1,
											'3851', 1,
											'3854', 1,
											'3861', 1,
											'3864', 1,
											'3867', 1,
											'3896', 1,
											'3897', 1,
											'3898', 1,
											'3899', 1,
											'3955', 1,
											'4058', 1,
											'4079', 1,
											'4156', 1,
											'4167', 1,
											'4209', 1,
											'4235', 1,
											'4312', 1,
											'3915', 1,
											'3873', 1,
											'3849', 1,
											'3949', 1,
											'3901', 1,
											'3905', 1,
											'3951', 1,
											'3953', 1,
											'3954' 1, 0) = 1
GROUP BY IHF.ACCOUNT_NUMBER,
	BC.ACCOUNT_NAME,
	ILF.YEARMONTH,
	PROD.DISCOUNT_GROUP_NK,
	CASE
		WHEN IHF.CHANNEL_TYPE IN ('H3', 'H7', 'O3', 'O7')
		THEN 'Direct'
		ELSE 'Stock'
	END,
	IHF.CHANNEL_TYPE