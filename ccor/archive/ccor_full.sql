/* PRODUCT OVERRIDES */
SELECT 
	bc.district,
	bc.alias,
	cod.customer_gk,
	cod.customer_nk,
	prod.alt1_code,
	cod.master_product,
	CASE
		WHEN COD.BASIS = '$' 
	THEN cod.operator_used || cod.multiplier
		ELSE cod.basis || cod.operator_used || cod.multiplier
	END 
		AS FORMULA,
	cod.override_type
	job.job_name,
	job.job_desc,
	job.job_loc

FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION cod,
	AAF1046.branch_contacts bc,
	dw_fei.jobs_fact job
	LEFT OUTER JOIN dw_fei.product_dimension prod
		ON prod.product_nk = cod.master_product

WHERE bc.rpc in('Midwest')
	AND cod.branch_number_nk = bc.account_nk
	AND cod.delete_date IS NULL
	--AND cod.expire_date IS NULL
	AND bc.account_nk IN (13)
	AND cod.customer_nk IN('2342')
	
	AND UPPER(cod.override_type) NOT IN UPPER('C')

ORDER BY bc.district,
	bc.account_name,
	cod.customer_nk;