SELECT cd.ACCOUNT_NAME,
	cd.CUSTOMER_NK,
	cd.CUSTOMER_NAME,
	cd.CUSTOMER_TYPE,
	NVL(ct.C_TYPE_DESC, '#n/a'),
	NVL(ct.C_TYPE_GROUPING, '#n/a'),
	cd.MAIN_CUSTOMER_NK,
	cd.PRICE_COLUMN

FROM dw_fei.customer_dimension cd
	LEFT JOIN aaa6863.customer_types ct
		ON cd.CUSTOMER_TYPE 		= ct.CUSTOMER_TYPE
	INNER JOIN aaa6863.branch_contacts bc
		ON cd.ACCOUNT_NUMBER_NK 	= bc.ACCOUNT_NK
		
WHERE NVL(ct.C_TYPE_GROUPING, '#n/a') = '#n/a'
	AND cd.DELETE_DATE                  IS NULL
	AND bc.RPC                          = 'Midwest'
	AND bc.DISTRICT                     = 'C10'
	--AND cd.account_nk                   = '13'
	
ORDER BY cd.ACCOUNT_NAME,
	cd.CUSTOMER_NAME,
	cd.CUSTOMER_NK;