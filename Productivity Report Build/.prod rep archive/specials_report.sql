 /*Selects the midwest branches 
	from the full query residing in schema 
	from "pr_vict2_cust_12mo.sql"  */

SELECT DISTINCT
	/*CASE
		WHEN SP.account_number = '1480'
		THEN ohv.ohval_bu
		ELSE SP.account_name
	END "Branch Name",	*/
	SP.account_name,
	sp.account_number "BR #",
	--SP.oml_assoc_ini "OML Ini",
	sp.writer "Writer",
	sp.oml_assoc_name assoc_Name,
	--SP.price_column "PC",
	SP.warehouse_number "Ship Wh",
	SP.invoice_number_nk "Inv #",
	--SP.ship_via_name "Via",
	--SP.order_code "Order Code",
	--SP.customer_nk "Cust #", 
	--SP.customer_name "Cust Name",
	SP.alt1_code "Alt 1",
	SP.product_name "Product",
	SP.status "ST",
	SP.um "U/M",
	SP.discount_group_nk "DG",
	dg.DISCOUNT_GROUP_NAME "DG Name",
	SP.shipped_qty "Shpd",
	--SP.unit_net_price_amount "Unit Net",
	--ROUND(SP.ext_avg_cogs_amount / SP.shipped_qty, 2) "Unit AC",
/*CASE 
    WHEN SP.ext_avg_cogs_amount = 0 then 0
    WHEN SP.ext_sales_amount = 0 then 0
    ELSE ROUND((SP.ext_sales_amount - SP.ext_avg_cogs_amount) / SP.ext_sales_amount, 4)
END "GP %",*/
	--SP.matrix_price "Matrix",
	--ROUND(SP.unit_net_price_amount - SP.matrix_price, 2) "Matrix Var",
	SP.ext_sales_amount "Ext Net",
	SP.ext_avg_cogs_amount "Ext AC",
	SP.TYPE_OF_SALE "Sale Type"
	/*SP.unit_inv_cost "Unit Inv",
	SP.replacement_cost "Unit Rep",
	SP.list_price "List",
	SP.order_entry_date "Ord Date",
	SP.price_formula "Form",
	SP.price_code "PrCd",
	SP.price_category_ovr "Pr Cat Override",
	SP.type_of_sale "Sale Type",
	SP.ref_bid_number "Bid #",
	SP.source_system "Source",
	SP.invoice_line_number "Inv Line",
	SP.manufacturer "Mfg#",
	SP.pr_ovr "Pr Ovr",
	SP.pr_ovr_basis "Pr Ovr Basis",
	SP.gr_ovr "Grp Ovr"*/
	
FROM	AAE0376.PR_VICT2_CUST_12MO SP
	-- LEFT OUTER JOIN AAA6863.ohval_breakout ohv
--		ON SP.warehouse_number = ohv.warehouse_number_nk
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION dg
		ON SP.discount_group_nk = dg.discount_group_nk
	-- LEFT OUTER JOIN AAF1046.branch_contacts bc
	-- 	ON SP.account_number = bc.account_nk
	INNER JOIN
           SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON ( SP.ACCOUNT_NUMBER = SWD.ACCOUNT_NUMBER_NK )
	
WHERE SP.STATUS IN ('SP-', 'SP')
	AND SP.ext_sales_amount >= 0
	-- SP.price_category  IN ('TOOLS', 'MANUAL', 'QUOTE')
	-- AND NVL (SP.price_category_ovr, 'N/A') NOT IN ('OVERRIDE')
	-- AND SP.account_number IN ('20', '1480')
	-- AND SP.price_code <> 'C'
	-- AND UPPER (SP.price_formula) <> 'SPEC'
	-- AND UPPER (SP.alt1_code) <> 'APPDEP'
	
	-- AND UPPER(bc.rpc) = 'SOUTHERN'
	-- AND UPPER(bc.rpc) = 'WESTERN'
	-- AND UPPER(bc.rpc) = 'ATLANTIC'
	-- AND UPPER(bc.rpc) = 'MIDWEST'	
	
	-- AND NOT UPPER(SP.alt1_code) LIKE('SP-%')
		AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
																																			'D10', 'D11', 'D12', 'D13', 
																																			'D14', 'D30', 'D31', 'D32', 
																																			'D50', 'D51', 'D53'
																																		 	)
			)
ORDER BY 
	SP.account_number ASC,
	SP.discount_group_nk ASC,
	SP.alt1_code ASC
	--SP.customer_name ASC
	;