/*
	pull from "pr_vict2_cust_12mo.sql"  
	added source order field 2/20/15
*/

SELECT DISTINCT
	/*CASE
		WHEN MAN.ACCOUNT_NUMBER = '1480'
		THEN OHV.OHVAL_BU
		ELSE MAN.ACCOUNT_NAME
	END "BRANCH NAME",*/	
	MAN.ACCOUNT_NAME,
	MAN.ACCOUNT_NUMBER "BR #",
	MAN.OML_ASSOC_INI "OML INI",
	MAN.WRITER "WRITER",
	--MAN.ASSOC_NAME "ASSOC. NAME",
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
	MAN.PRICE_CATEGORY_OVR "PR CAT OVERRIDE",
	MAN.TYPE_OF_SALE "SALE TYPE",
	MAN.REF_BID_NUMBER "BID #",
	MAN.SOURCE_SYSTEM "SOURCE",
	MAN.INVOICE_LINE_NUMBER "INV LINE",
	MAN.MANUFACTURER "MFG#",
	MAN.PR_OVR "PR OVR",
	MAN.PR_OVR_BASIS "PR OVR BASIS",
	MAN.GR_OVR "GRP OVR",
	DG.DISCOUNT_GROUP_NAME "DG",
	MAN.COPY_SOURCE_HIST

FROM	AAA6863.PR_VICT2_CUST_12MO MAN
	LEFT OUTER JOIN AAA6863.OHVAL_BREAKOUT OHV
		ON MAN.WAREHOUSE_NUMBER = OHV.WAREHOUSE_NUMBER_NK
	LEFT OUTER JOIN AAA6863.BRANCH_CONTACTS BC
		ON MAN.ACCOUNT_NUMBER = BC.ACCOUNT_NK
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
		ON MAN.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
	
WHERE 
	MAN.PRICE_CATEGORY  IN ('TOOLS', 'MANUAL', 'QUOTE')
	AND NVL (MAN.PRICE_CATEGORY_OVR, 'N/A') NOT IN ('OVERRIDE')
	--AND MAN.ACCOUNT_NUMBER IN ('1480')
	AND MAN.PRICE_CODE <> 'C'
	AND UPPER (MAN.PRICE_FORMULA) <> 'SPEC'
	AND UPPER (MAN.ALT1_CODE) <> 'APPDEP'
	
	--AND UPPER(BC.RPC) = 'SOUTHERN'
	--AND UPPER(BC.RPC) = 'WESTERN'
	--AND UPPER(BC.RPC) = 'ATLANTIC'
	AND UPPER(BC.RPC) = 'MIDWEST'	
	
	AND NOT UPPER(MAN.ALT1_CODE) LIKE('SP-%')

ORDER BY 
	MAN.ACCOUNT_NUMBER ASC,
	MAN.CUSTOMER_NAME ASC
	;