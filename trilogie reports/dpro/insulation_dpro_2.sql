/* Misc / Other DG's  */
SELECT DISTINCT 
	whse.account_number_nk "Br #",
	whse.account_name "Branch",
	wpf.warehouse_nk "Wh#",
	whse.warehouse_name "Whse Name",
	wpf.discount_group_nk "DG",
	dg.discount_group_name "DG Desc",
	NVL(bdg.raw_disc_to_cost, NULL) "DTC",
	wpf.linebuy "Line",
	wpf.product_nk "Product#",
	prod.alt1_code "Alt1",
	NVL(wpf.status_type, 'Stock') "ST",
	prod.long_description "Item Description",
	NVL(prod.list_price, NULL) "M List",
	NVL(wpf.list_pr, NULL) "List",
	CASE
		WHEN wpf.new_list = wpf.rep_cost
		THEN NULL
		ELSE NVL(wpf.new_list, NULL)
	END
		"New List",
	wpf.basis_2 "Basis 2",
	wpf.basis_3 "Basis 3",
	wpf.basis_4 "Basis 4",
	wpf.basis_5 "Basis 5",
	wpf.basis_6 "Basis 6",
	wpf.basis_7 "Basis 7",
	wpf.basis_8 "Basis 8",
	wpf.basis_9 "Basis 9",
	NVL(wpf.rep_cost, NULL) "Rep",
	NVL(wpf.whse_avg_cost_amount, NULL) "AC", 
	NVL(wpf.pi_cost, NULL) "PI",
	NVL(wpf.demand_12_months, NULL) "Demand",
	NVL(wpf.on_hand_qty, NULL) "OHB",
	wpf.unit_of_measurement "UM",
	prod.upc_code "UPC",
	prod.vendor_code "Vend Code",
	prod.manufacturer "Manufacturer",
	prod.obs_date "Obs Date"
	
		--update AAA6863.OTHER_MISC_DG OTHER to change lineup of DG's
FROM
	dw_fei.warehouse_product_fact wpf,  
	aaa6863.other_misc_dg other,
	dw_fei.discount_group_dimension dg,
	dw_fei.branch_disc_group_dimension bdg,
	dw_fei.warehouse_dimension whse,
	dw_fei.product_dimension prod,
	aaa6863.branch_contacts bc
	
  WHERE 	wpf.discount_group_nk  IN (
				'5487', '5489', '5491', '5493', '5494', '5496', '5497', 
				'5500', '5503', '5529', '5544', '5545', '5546', '5547', 
				'5548', '5559', '5561', '5635', '5636', '5637')
	AND wpf.warehouse_gk = whse.warehouse_gk
	AND wpf.discount_group_nk = dg.discount_group_nk
	AND whse.account_number_nk = bc.account_nk
	AND prod.product_gk = wpf.product_gk
	AND (wpf.yearmonth =
			TO_NUMBER (TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')))
	/*AND NVL (wpf.STATUS_TYPE, 'STOCK') IN
		   ('STOCK', 'NN', 'NV', 'S', 'NQ')*/
	AND bdg.account_name = whse.account_name
	AND bdg.branch_disc_group_nk = wpf.discount_group_nk
	AND bc.rpc = 'Midwest'
	AND bc.district IN ('C10', 'C11', 'C12')
	--AND whse.account_number_nk IN ('116')
	--AND wpf.warehouse_nk IN ('945', '141')  --testing
    --AND wpf.new_list IS NOT NULL
	
ORDER BY 
	whse.account_number_nk ASC,
	whse.account_name ASC,
	wpf.warehouse_nk ASC,
	wpf.discount_group_nk ASC,
	prod.alt1_code ASC 
;