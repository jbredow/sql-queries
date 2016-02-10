/* 
	data pull for the ProFlo tool promotion for CENT 
	March Madness - pull apr/mar 13 for comparison
*/

SELECT 	BC.DISTRICT				AS "Dist",
		V2.ACCOUNT_NUMBER  		AS  "BR#",
		V2.ACCOUNT_NAME  		AS  "BR Name",
		V2.WAREHOUSE_NUMBER  	AS  "WH#",
		V2.INVOICE_NUMBER_NK  	AS  "INV#",
		V2.INVOICE_LINE_NUMBER  AS  "InvLn",
		V2.OML_ASSOC_NAME  		AS  "OML Assoc",
		V2.WRITER  				AS  "Wrtr",
		V2.DISCOUNT_GROUP_NK  	AS  "DG",
		V2.DISCOUNT_GROUP_NAME  AS  "DG Description",
		V2.ALT1_CODE  			AS  "ALT1_CODE",
		V2.PRODUCT_NAME  		AS  "Procudt Name",
		V2.STATUS  				AS  "Status",
		V2.SHIPPED_QTY  		AS  "Shpd",
		V2.EXT_SALES_AMOUNT  	AS  "Ext Sales",
		V2.EXT_AVG_COGS_AMOUNT  AS  "Ext AC",
		V2.PRICE_CODE  			AS  "Pr CD",
		V2.PRICE_CATEGORY  		AS  "Price Cat",
		V2.UM  					AS  "UM",
		V2.LIST_PRICE  			AS  "List Price",
		V2.MAIN_CUSTOMER_NK  	AS  "Main Cust#",
		V2.CUSTOMER_NK  		AS  "Cust #",
		V2.CUSTOMER_NAME  		AS  "Customer Name",
		V2.CUSTOMER_TYPE  		AS  "Cust Type",
		V2.ORDER_ENTRY_DATE  	AS  "Order Entry"


FROM PR_VICT2_CUST_12MO V2
INNER JOIN BRANCH_CONTACTS BC
ON TO_CHAR(V2.ACCOUNT_NUMBER) = TO_CHAR(BC.ACCOUNT_NK)

WHERE BC.DISTRICT            IN (	'C10', 'C11', 'C12')

	AND v2.TYPE_OF_SALE 		= 	'Counter'
	
	AND v2.discount_group_nk IN (	'1834',
									'1836',
									'3123',
									'3169',
									'3170',
									'3173',
									'3176',
									'3385',
									'3386',
									'4011',
									'4131',
									'4165',
									'4171',
									'4274',
									'4309',
									'4357',
									'6580',
									'6582')
;
