SELECT BC.DISTRICT,
	BR_DG.ACCOUNT_NUMBER_NK,
	BR_DG.ACCOUNT_NAME,
	BR_DG.BRANCH_DISC_GROUP_NK,
	DISC_GRP.DISCOUNT_GROUP_NAME,
	BR_DG.DISC_TO_COST,
	BR_DG.RAW_DISC_TO_COST
  
FROM dw_fei.branch_disc_group_dimension BR_DG
	LEFT JOIN dw_fei.discount_group_dimension DISC_GRP
		ON DISC_GRP.DISCOUNT_GROUP_GK = BR_DG.BRANCH_DISC_GROUP_GK
	RIGHT JOIN BRANCH_CONTACTS BC
		ON BC.ACCOUNT_NK   = BR_DG.ACCOUNT_NUMBER_NK

WHERE BC.DISTRICT IN ('C10', 'C11', 'C12', 'W50', 'W51', 'W53')
	AND BR_DG.BRANCH_DISC_GROUP_NK IN ( '1072',
																			'1076',
																			'1080',
																			'1084' )

ORDER BY 
	BC.DISTRICT,
	BR_DG.ACCOUNT_NUMBER_NK,
	BR_DG.BRANCH_DISC_GROUP_NK
;