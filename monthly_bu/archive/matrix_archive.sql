
SELECT * 
	FROM
	(SELECT DISTINCT 
		PRICE.BRANCH_NUMBER_NK 	BRANCH,
		CONTACTS.DISTRICT		DIST,
		PRICE.PRICE_COLUMN     	PC,
		PRICE.PRICE_TYPE       	PTYPE,
		PRICE.DISC_GROUP       	DG_ITEM,
		dg.discount_group_name 	DESCR,
		PRICE.BASIS            	B,
		PRICE.OPERATOR_USED    	OP,
		PRICE.MULTIPLIER       	MULT,
		PRICE.UPDATE_TIMESTAMP 	UPDATE_DATE,
		CONTACTS.RPC            RPC
	  
	FROM DW_FEI.PRICE_DIMENSION PRICE,
		DW_FEI.discount_group_dimension DG,
		BRANCH_CONTACTS CONTACTS
	  
	WHERE PRICE.BRANCH_NUMBER_NK 	 = CONTACTS.ACCOUNT_NK
		AND dg.discount_group_nk 	 = PRICE.DISC_GROUP
		AND PRICE.DISC_GROUP    	IN ('4782',
										'4783',
										'4784',
										'4785',
										'4792',
										'4787',
										'4786',
										'4777',
										'4788',
										'4789',
										'4798',
										'4793',
										'4791',
										'4790',
										'4780',
										'4804',
										'4805',
										'4806',
										'4807',
										'4809',
										'4808',
										'4794',
										'4814',
										'4810',
										'4811',
										'4795',
										'4796',
										'4797',
										'4813',
										'4812',
										'4815',
										'4702',
										'4763',
										'4764',
										'4765',
										'4766',
										'4776',
										'4768',
										'4767',
										'4773',
										'4761',
										'4759',
										'4769',
										'4770',
										'4778',
										'4774',
										'4772',
										'4771',
										'4700',
										'4760',
										)
		AND PRICE.PRICE_TYPE         = 'G'
		AND CONTACTS.RPC             = 'Midwest'
		AND PRICE.DELETE_DATE       IS NULL) MTX
	
ORDER BY MTX.BRANCH,
	MTX.DG_ITEM,
	MTX.PC
;