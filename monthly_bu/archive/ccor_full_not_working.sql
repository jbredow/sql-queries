/* PRODUCT OVERRIDES 
	not working yet...  duplicates group overrides*/
SELECT ccor.branch_number_nk BR_NO,
	ccor.customer_nk CUST_NO,
	cd.customer_name CUSTOMER_NAME,
	jobs.job_name,
	jobs.job_desc,
	cd.branch_warehouse_number WHSE,
	cd.main_customer_nk MAIN_CUST,
	ccor.override_id_nk,
	ccor.override_type OVR_TYPE,
	NVL(dg.discount_group_nk, 'n/a') AS DG,
	NVL(prod.linebuy_nk, 'n/a') AS LB,
	NVL(ccor.master_product, 'n/a') AS PRODUCT,
	NVL(prod.product_name, dg.discount_group_name) AS DEF,
	NVL (prod.alt1_code ,ccor.disc_group) AS ALT_DG,
	NVL (ccor.basis, 'n/a') AS BAS,
	NVL (ccor.operator_used, 'n/a') AS OP,
	ccor.multiplier AS MULT,
	ccor.qty_1 AS QTY,
	ccor.max_pur_qty AS MAX_PUR,
	ccor.cost_rebate AS COST_REBATE,
	NVL (cd.salesman_code, 'n/a') AS SLSM,
	ccor.expire_date AS EXP_DATE,
	ccor.last_update AS LAST_UPDATE

FROM  dw_fei.customer_dimension cd,
	DW_FEI.discount_group_dimension dg,
  
	dw_fei.customer_override_dimension ccor
	LEFT OUTER JOIN DW_FEI.product_dimension prod
		ON prod.product_nk = ccor.master_product
	LEFT OUTER JOIN DW_FEI.jobs_fact jobs
		ON jobs.customer_gk = ccor.customer_gk
  
WHERE ccor.delete_date IS NULL
	AND ccor.branch_number_nk IN (13)
	AND ccor.customer_nk IN('2342')
	AND UPPER(ccor.override_type) NOT IN 'C'
	AND cd.customer_gk = ccor.customer_gk
	--AND prod.discount_group_nk = ccor.disc_group
	--AND ccor.override_type = 'P'

ORDER BY
	ccor.customer_nk,
	ccor.disc_group ASC
  ;