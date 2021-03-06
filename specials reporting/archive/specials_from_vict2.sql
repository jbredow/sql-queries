 /*Selects the midwest branches 
	from the full query residing in schema 
	from "pr_vict2_cust_12mo.sql"  */
SELECT SPECIALS.* FROM (
SELECT DISTINCT
	CASE
		WHEN man.account_number = '1480'
		THEN ohv.ohval_bu
		ELSE man.account_name
	END "Branch Name",	
	man.account_number "BR #",
	man.oml_assoc_ini "OML Ini",
	man.writer "Writer",
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
	man.um "U/M",
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
	dg.discount_group_name "DG"

FROM DW_FEI.EMPLOYEE_DIMENSION emp,
	AAA6863.pr_vict2_cust_1mo_1113 man
	LEFT OUTER JOIN AAA6863.ohval_breakout ohv
		ON man.warehouse_number = ohv.warehouse_number_nk
	LEFT OUTER JOIN AAA6863.branch_contacts bc
		ON man.account_number = bc.account_nk
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION dg
		ON man.discount_group_nk = dg.discount_group_nk
	
WHERE UPPER(bc.rpc) = 'MIDWEST'	
	--AND UPPER(bc.rpc) = 'SOUTHERN'
	--AND UPPER(bc.rpc) = 'WESTERN'
	--AND UPPER(bc.rpc) = 'ATLANTIC'
	AND MAN.ACCOUNT_NAME = EMP.ACCOUNT_NAME
	
	--AND man.price_category  IN ('TOOLS', 'MANUAL', 'QUOTE')
	--AND NVL (man.price_category_ovr, 'N/A') NOT IN ('OVERRIDE')
	AND man.account_number IN ('150')
	AND man.price_code <> 'C'
	AND man.status IN ('SP', 'SP-')
	AND UPPER (man.price_formula) <> 'SPEC'
	AND UPPER (man.alt1_code) <> 'APPDEP'

ORDER BY man.account_number ASC,
	ohv.ohval_bu ASC,
	man.customer_name ASC) SPECIALS


	WHERE
	
	;