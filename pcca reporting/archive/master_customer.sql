--selects all customers in a branch associated with a master customer
SELECT cd.account_name,
	cd.account_number_nk,
	cd.customer_type,
	cd.email_address,
	cd.job_yn,
	cd.main_customer_nk,
	cd.mstr_cust_name,
	cd.mstr_custno,
	cd.price_column,
	cd.salesman_code
FROM dw_fei.customer_dimension cd
WHERE cd.mstr_custno = '59051'
	;