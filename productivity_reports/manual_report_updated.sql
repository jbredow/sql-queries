
/* 
	use for single month reports in toolbox
	AAE0376 - Jenn
	AAD9606 - Leigh
	AAA6863 - Joe
 */
SELECT DISTINCT
	MAN.ACCOUNT_NAME,
	MAN.ACCOUNT_NUMBER "BR #",
	MAN.OML_ASSOC_INI "OML INI",
	MAN.WRITER "WRITER",
	-- MAN.SALESMAN_CODE SLSM,
	-- MAN.ASSOC_NAME "ASSOC. NAME",
	MAN.PRICE_COLUMN "PC",
	MAN.WAREHOUSE_NUMBER "SHIP WH",
	MAN.INVOICE_NUMBER_NK "INV #",
	MAN.SHIP_VIA_NAME "VIA",
	MAN.ORDER_CODE "ORDER CODE",
	MAN.CUSTOMER_NK "CUST #", 
	MAN.CUSTOMER_NAME "CUST NAME",
	MAN.ALT1_CODE "ALT 1",
	MAN.PRODUCT_NAME "PRODUCT",
	MAN.STATUS "ST",
	MAN.UM "U/M",
	MAN.DISCOUNT_GROUP_NK "DG",
	MAN.SHIPPED_QTY "SHPD",
	MAN.UNIT_NET_PRICE_AMOUNT "UNIT NET",
	ROUND(MAN.EXT_AVG_COGS_AMOUNT / MAN.SHIPPED_QTY, 2) "UNIT AC",
	CASE 
		WHEN MAN.EXT_AVG_COGS_AMOUNT = 0 THEN 0
		WHEN MAN.EXT_SALES_AMOUNT = 0 THEN 0
		ELSE ROUND((MAN.EXT_SALES_AMOUNT - MAN.EXT_AVG_COGS_AMOUNT) / MAN.EXT_SALES_AMOUNT, 4)
	END "GP %",
	MAN.MATRIX_PRICE "MATRIX",
	ROUND(MAN.UNIT_NET_PRICE_AMOUNT - MAN.MATRIX_PRICE, 2) "MATRIX VAR",
	MAN.EXT_SALES_AMOUNT "EXT NET",
	MAN.EXT_AVG_COGS_AMOUNT "EXT AC",
	MAN.UNIT_INV_COST "UNIT INV",
	MAN.REPLACEMENT_COST "UNIT REP",
	MAN.LIST_PRICE "LIST",
	MAN.ORDER_ENTRY_DATE "ORD DATE",
	MAN.PRICE_FORMULA "FORM",
	MAN.PRICE_CODE "PRCD",
	--MAN.PRICE_CATEGORY_OVR "PR CAT OVERRIDE",
	MAN.TYPE_OF_SALE "SALE TYPE",
	MAN.REF_BID_NUMBER "BID #",
	MAN.SOURCE_SYSTEM "SOURCE",
	MAN.INVOICE_LINE_NUMBER "INV LINE",
	MAN.MANUFACTURER "MFG#",
	--MAN.PR_OVR "PR OVR",
	MAN.PR_OVR_BASIS "PR OVR BASIS",
	--MAN.GR_OVR "GRP OVR",
	DG.DISCOUNT_GROUP_NAME "DG Description",
	MAN.COPY_SOURCE_HIST   --,
	-- MAN.INVOICE_DATE "INV_DATE"

FROM	AAA6863.PR_VICT2_CUST_12MO MAN
	/*LEFT OUTER JOIN AAF1046.BRANCH_CONTACTS BC
		ON MAN.ACCOUNT_NUMBER = BC.ACCOUNT_NK*/
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
		ON MAN.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
	INNER JOIN EBUSINESS.SALES_DIVISIONS SWD
		ON SWD.ACCOUNT_NUMBER_NK = MAN.ACCOUNT_NUMBER

WHERE 
	MAN.PRICE_CODE <> 'C'
	AND COALESCE ( MAN.PR_OVR,
									 MAN.GR_OVR,
										 MAN.PRICE_CATEGORY) IN ( 'TOOLS',
																							'MANUAL',
																							'QUOTE',
																							'OTH/ERROR' )
	AND MAN.PRICE_CODE <> 'C'
	AND UPPER (MAN.PRICE_FORMULA) <> 'SPEC'
	AND UPPER (MAN.ALT1_CODE) <> 'APPDEP'
	/*AND (( SUBSTR(SWD.REGION_NAME,1,3) IN ( 
			 					'D10', 'D11', 'D12', 'D13', 
								'D14', 'D30', 'D31', 'D32', 
								'D50', 'D51', 'D53' , 'D59')) 
			OR ( MAN.WAREHOUSE_NUMBER = '5350' ))*/
	--AND MAN.ACCOUNT_NUMBER = '2000'
	AND MAN.WAREHOUSE_NUMBER = '5350'
	AND LENGTH ( MAN.PRICE_FORMULA ) <> 7
	AND NOT UPPER(MAN.ALT1_CODE) LIKE('SP-%')

ORDER BY 
	MAN.ACCOUNT_NUMBER ASC,
	MAN.CUSTOMER_NAME ASC
	 
	;
