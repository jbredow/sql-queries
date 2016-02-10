SELECT whse.ACCOUNT_NUMBER_NK,
	whse.ACCOUNT_NAME,
	poh.WAREHOUSE_NUMBER_NK,
	bvd.VENDOR_NK,
	bvd.VENDOR_NAME,
	poh.PO_NUMBER_NK,
	poh.PO_DATE,
	poh.ENTERED_BY,
	prod.PRODUCT_NK,
	prod.ALT1_CODE,
	prod.PRODUCT_NAME,
	prod.DISCOUNT_GROUP_NK,
	prod.LINEBUY_NK,
	prod.UNIT_OF_MEASURE,
	pol.PER,
	pol.UNIT_COST,
	pol.EXT_LINE_COST,
	pol.received_qty
	FROM DW_FEI.PO_HEADER_FACT poh
	INNER JOIN DW_FEI.PO_LINE_FACT pol
		ON poh.PO_GK 					= pol.PO_GK
	LEFT JOIN DW_FEI.BRANCH_VENDOR_DIMENSION bvd
		ON poh.BRANCH_VENDOR_GK 		= bvd.VENDOR_GK
	LEFT JOIN DW_FEI.WAREHOUSE_DIMENSION whse
		ON whse.WAREHOUSE_GK 			= poh.WAREHOUSE_NUMBER_GK
	LEFT JOIN DW_FEI.PRODUCT_DIMENSION prod
		ON pol.PRODUCT_GK 				= prod.PRODUCT_GK
	INNER JOIN BRANCH_CONTACTS bc
		ON whse.ACCOUNT_NUMBER_NK    	= bc.ACCOUNT_NK

WHERE  prod.DISCOUNT_GROUP_NK IN (
			'1025', '1027', '1039', '1052', '1053', 
			'1179', '1374', '1395', '1502', '3044', 
			'4055', '4095', '4447', '4562', '5102', 
			'5168', '5463', '5635', '5636', '5637', 
			'5791', '5793', '5797', '5799', '5801', 
			'5805', '5806', '5807', '5808', '5809', 
			'5810', '5811', '5819', '5820', '5821', 
			'5835', '5836', '5838', '5839', '7807', 
			'8260')
	--AND whse.ACCOUNT_NUMBER_NK = '13'
	AND bc.district IN ('C10', 'C11', 'C12')
	/* AND poh.PO_DATE_YEARMONTH = 201308 */
	/* AND poh.PO_DATE_YEARMONTH
		= TO_NUMBER(TO_CHAR(TRUNC(SysDate, 'MM') - 1, 'YYYYMM')) */
		
	AND poh.PO_DATE_YEARMONTH BETWEEN TO_CHAR (
											TRUNC (
												SYSDATE
												- NUMTOYMINTERVAL (
														3,
												'MONTH'),
											'MONTH'),
										'YYYYMM')
				AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')

    ;