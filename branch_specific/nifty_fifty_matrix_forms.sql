--CREATE TABLE AAA6863.A_MATRIX_CENT_201412
--AS
SELECT * FROM (
	SELECT DISTINCT 
		--groups
		PRICE.PRICE_TYPE 
		|| '#'
		|| PRICE.DISC_GROUP
		||'*'
		|| PRICE.PRICE_COLUMN 	AS COMBO_CODE,
		PRICE.BRANCH_NUMBER_NK 	AS BRANCH,
		CONTACTS.DISTRICT				AS DIST,
		PRICE.PRICE_COLUMN     	AS PC,
		PRICE.PRICE_TYPE       	AS PTYPE,
		PRICE.DISC_GROUP       	AS DG,
		PRICE.DISC_GROUP       	AS DG_ITEM,
		dg.discount_group_name 	AS DESCR,
		PRICE.BASIS            	AS B,
		PRICE.OPERATOR_USED    	AS OP,
		PRICE.MULTIPLIER       	AS MULT,
		PRICE.UPDATE_TIMESTAMP 	AS UPDATE_DATE,
		CONTACTS.RPC
	  
	FROM DW_FEI.PRICE_DIMENSION PRICE,
		DW_FEI.discount_group_dimension DG,
		AAF1046.BRANCH_CONTACTS CONTACTS
	  
	WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
		AND dg.discount_group_nk = PRICE.DISC_GROUP
		/*AND (PRICE.PRICE_COLUMN   NOT  	 IN (23, 170, 171, 172, 173,
											180, 181, 182, 183,
											190, 191, 192, 193)*/
		AND PRICE.PRICE_TYPE         = 'G'
		AND CONTACTS.RPC             = 'Midwest'
		AND PRICE.DELETE_DATE       IS NULL
		--AND CONTACTS.DISTRICT 			 = 'C11'
		AND PRICE.DISC_GROUP IN (	'0023', 	'0143', 	'1141', 	'1285', 	'1518', 
									'0504', 	'0505', 	'0511', 	'0513', 	'0525', 
									'0529', 	'4074', 	'4086', 	'4239', 	'5459', 
									'1637' )
		--AND CONTACTS.ACCOUNT_NK      = '1116'
		--
	UNION
	SELECT DISTINCT 
		--products
		PRICE.PRICE_TYPE 
		|| '#'
		|| PRICE.MASTER_PRODUCT_NK
		||'*'
		|| PRICE.PRICE_COLUMN AS COMBO_CODE,
		PRICE.BRANCH_NUMBER_NK AS BRANCH,
		CONTACTS.DISTRICT		AS DIST,
		PRICE.PRICE_COLUMN     AS PC,
		PRICE.PRICE_TYPE       AS PTYPE,
		PRICE.DISC_GROUP       	AS DG,
		PROD.ALT1_CODE         AS DG_ITEM,
		PROD.PRODUCT_NAME      AS DESCR,
		PRICE.BASIS            AS B,
		PRICE.OPERATOR_USED    AS OP,
		PRICE.MULTIPLIER       AS MULT,
		PRICE.UPDATE_TIMESTAMP AS UPDATE_DATE,
		CONTACTS.RPC
	  
	FROM DW_FEI.PRICE_DIMENSION PRICE,
		AAF1046.BRANCH_CONTACTS CONTACTS,
		DW_FEI.PRODUCT_DIMENSION PROD
	  
	WHERE PRICE.BRANCH_NUMBER_NK = CONTACTS.ACCOUNT_NK
		AND PRICE.MASTER_PRODUCT_NK  = PROD.PRODUCT_NK
		/*AND (PRICE.PRICE_COLUMN   NOT  	 IN (23, 170, 171, 172, 173,
											180, 181, 182, 183,
											190, 191, 192, 193)*/
		AND PRICE.PRICE_TYPE         = 'P'
		AND CONTACTS.RPC             = 'Midwest'
		AND PRICE.DELETE_DATE       IS NULL
		AND PROD.DISCOUNT_GROUP_NK IN (	'0023', 	'0143', 	'1141', 	'1285', 	'1518', 
									'0504', 	'0505', 	'0511', 	'0513', 	'0525', 
									'0529', 	'4074', 	'4086', 	'4239', 	'5459', 
									'1637' )
		--AND prod.alt1_code = 'JSF30PR'
		--AND CONTACTS.ACCOUNT_NK      = '2000'
		) 
  ;
 
--GRANT SELECT ON AAA6863.A_MATRIX_CENT_201412 TO PUBLIC;

	
--SELECT * FROM AAA6863.A_MATRIX_CENT_201412 MX WHERE MX.DIST = 'W53';