SELECT IHF.ACCOUNT_NUMBER,
	BC.ACCOUNT_NAME,
	ILF.YEARMONTH,
	PROD.DISCOUNT_GROUP_NK,
	CASE
		WHEN  IHF.CHANNEL_TYPE IN('H3', 'H7', 'O3', 'O7') 
		THEN 'Direct'
		ELSE 'Stock'
	END
		AS CHANNEL,
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
		ON ILF.PRODUCT_NUMBER_NK   = PROD.PRODUCT_NK

WHERE BC.DISTRICT IN ('D20')
	--AND IHF.ACCOUNT_NUMBER   IN ('13', '100','56')
	--AND ILF.YEARMONTH         = '201308'
	--AND IHF.YEARMONTH         = '201308'
	AND ILF.YEARMONTH BETWEEN TO_CHAR (
									TRUNC (
										SYSDATE
										- NUMTOYMINTERVAL (
												12,
										'MONTH'),
									'MONTH'),
								'YYYYMM')
			AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
	AND IHF.YEARMONTH BETWEEN TO_CHAR (
									TRUNC (
										SYSDATE
										- NUMTOYMINTERVAL (
											12,
										'MONTH'),
									'MONTH'),
								'YYYYMM')
			AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM') 
	--AND BC.DISTRICT IN ('W50', 'W51', 'W52', 'W53', 'W54')
	AND PROD.DISCOUNT_GROUP_NK IN (
					'2106',	'2284',	'2539',	'3402',	'3406',	'3413',
					'3419',	'3422',	'3683',	'3698',	'3735',	'3755',
					'3785',	'3800',	'3846',	'3849',	'3851',	'3854',
					'3861',	'3864',	'3867',	'3873',	'3896',	'3897',
					'3898',	'3899',	'3901',	'3905',	'3915',	'3949',
					'3951',	'3953',	'3954',	'3955',	'4058',	'4079',
					'4156',	'4167',	'4209',	'4235',	'4312')
GROUP BY IHF.ACCOUNT_NUMBER,
	BC.ACCOUNT_NAME,
	ILF.YEARMONTH,
	PROD.DISCOUNT_GROUP_NK,
	IHF.CHANNEL_TYPE,
	CASE
		WHEN  IHF.CHANNEL_TYPE IN('H3', 'H7', 'O3', 'O7') 
		THEN 'Direct'
		ELSE 'Stock'
	END
;