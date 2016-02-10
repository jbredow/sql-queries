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
	
  WHERE 	DECODE (wpf.discount_group_nk ('0227', 1,
											'1177', 1,
											'1811', 1,
											'1944', 1,
											'1952', 1,
											'4212', 1,
											'5806', 1,
											'5807', 1,
											'5808', 1,
											'5809', 1,
											'5810', 1,
											'5811', 1,
											'5812', 1,
											'5813', 1,
											'5814', 1,
											'5815', 1,
											'5816', 1,
											'5817', 1,
											'5819', 1,
											'5821', 1,
											'5824', 1,
											'5825', 1,
											'5826', 1,
											'5827', 1,
											'5829', 1,
											'5831', 1,
											'5832', 1,
											'5833', 1,
											'5889', 1,
											'6092', 1,
											'6095', 1,
											'6096', 1,
											'6104', 1,
											'8960', 1,
											'8998', 1,
											'8999', 1, 1)
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
	AND bc.district LIKE 'W%'
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