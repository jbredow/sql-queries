/*
 		Selects the midwest branches 
		from the full query residing in schema 
		from "pr_vict2_cust_12mo.sql"  
*/

SELECT DISTINCT
	SP.account_name || '^' || SP.invoice_number_nk CAT,
	SP.account_name BU,
	sp.account_number BR#,
	sp.writer "Writer",
	sp.oml_assoc_name assoc_Name,
	SP.warehouse_number "Ship Wh",
	SP.invoice_number_nk "Inv #",
	SP.alt1_code "Alt 1",
	SP.product_name "Product",
	SP.status "ST",
	SP.discount_group_nk "FULL.DG",
	dg.DISCOUNT_GROUP_NAME "DG Name",
	SP.shipped_qty "Shpd",
	SP.ext_sales_amount "Ext Net",	
	SP.ext_avg_cogs_amount "Ext AC",
	SP.YEARMONTH
FROM	AAE0376.PR_VICT2_CUST_12MO SP
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION dg
		ON SP.discount_group_nk = dg.discount_group_nk
	INNER JOIN
           SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON ( SP.ACCOUNT_NUMBER = SWD.ACCOUNT_NUMBER_NK )
	
WHERE SP.STATUS = 'SP-'
	AND SP.ext_sales_amount >= 0
	AND SP.warehouse_number IN (  '226',
																'331',
																'448',
																'451',
																'520',
																'525',
																'749',
																'755',
																'757',
																'1674',
																'1678',
																'1696',
																'3093',
																'3135',
																'3136'
																)
ORDER BY 
	SP.account_number ASC,
	SP.discount_group_nk ASC,
	SP.alt1_code ASC
	;