--selects all customers in a branch with incorrect customer types
SELECT cd.account_name,
	cd.account_number_nk,
	cd.customer_name,
	cd.customer_type,
	NULL AS new_type,
	cd.job_yn,
	cd.main_customer_nk,
	cd.mstr_custno,
	cd.price_column,
	NULL AS new_pc
FROM DW_FEI.customer_dimension cd
	LEFT OUTER JOIN aaa6863.branch_contacts bc
		ON cd.account_number_nk = bc.account_nk
WHERE UPPER(bc.rpc) = 'MIDWEST'
	AND cd.account_number_nk = '3093'
	AND cd.customer_type IN ('T_EDUC_PRIVATE', 
                              'GOVT_LOCAL_EDUC', 
                              'GOVT_STATE_EDUC')
	AND UPPER(cd.customer_name) LIKE ('SIMON%')
	AND cd.delete_date IS NULL
ORDER BY cd.account_name
;