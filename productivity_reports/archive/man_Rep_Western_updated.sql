/*Selects the midwest branches 
	from the full query residing in schema 
	from "pr_vict2_cust_12mo.sql"  */

SELECT 	
	man.account_name "Branch Name",	
	man.account_number "BR #",
	man.oml_assoc_ini "OML Ini",
	man.writer "Writer",
	--man.assoc_name "Assoc. Name",
	man.price_column "PC",
	man.warehouse_number "Ship Wh",
	man.invoice_number_nk "Inv #",
	man.ship_via_name "Via",
	man.order_code "Order Code",
	man.customer_nk "Cust #", 
	man.customer_name "Cust Name",
	man.alt1_code "Alt 1",
	man.product_name "Product",
	man.status "ST",
	man.discount_group_nk "DG",
	man.shipped_qty "Shpd",
	man.unit_net_price_amount "Unit Net",
	ROUND(man.ext_avg_cogs_amount / man.shipped_qty, 2) "Unit AC",
CASE 
    WHEN man.ext_avg_cogs_amount = 0 then 0
    WHEN man.ext_sales_amount = 0 then 0
    ELSE ROUND((man.ext_sales_amount - man.ext_avg_cogs_amount) / man.ext_sales_amount, 4)
END "GP %",
	man.matrix_price "Matrix",
	ROUND(man.unit_net_price_amount - man.matrix_price, 2) "Matrix Var",
	man.ext_sales_amount "Ext Net",
	man.ext_avg_cogs_amount "Ext AC",
	man.unit_inv_cost "Unit Inv",
	man.replacement_cost "Unit Rep",
	man.list_price "List",
	man.order_entry_date "Ord Date",
	man.price_formula "Form",
	man.price_code "PrCd",
	man.price_category_ovr "Pr Cat Override",
	man.type_of_sale "Sale Type",
	man.ref_bid_number "Bid #",
	man.source_system "Source",
	man.invoice_line_number "Inv Line",
	man.manufacturer "Mfg#",
	man.pr_ovr "Pr Ovr",
	man.pr_ovr_basis "Pr Ovr Basis",
	man.gr_ovr "Grp Ovr",
	dg.DISCOUNT_GROUP_NAME "DG"

FROM	AAA6863.pr_vict2_lyonsouth_test man

	LEFT OUTER JOIN AAA6863.branch_contacts bc
		ON man.account_number = bc.account_nk
		
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION dg
		ON man.discount_group_nk = dg.discount_group_nk
	
WHERE man.price_category  IN ('TOOLS', 'MANUAL', 'QUOTE')
	AND NVL (man.price_category_ovr, 'N/A') NOT IN ('OVERRIDE')
	--AND man.account_number IN ('13', '100', '1480')	
	--AND UPPER(bc.rpc) = 'SOUTHERN'
	AND UPPER(bc.rpc) = 'WESTERN'
	--AND UPPER(bc.rpc) = 'ATLANTIC'
	--AND UPPER(bc.rpc) = 'MIDWEST'	
	AND NOT UPPER(man.alt1_code) LIKE('SP-%')

ORDER BY 
	man.account_number ASC,
	man.customer_name ASC
	;