SELECT bdg.account_name "BU",
	bdg.account_number_nk, "BU#",
	bdg.branch_disc_group_nk "DG",
	bdg.disc_to_cost "DTC",
	bdg.raw_disc_to_cost "RAW",
	bdg.rep_cost_factor "Factor",
	bdg.rep_cost_ok "OK"
	
FROM dw_fei.branch_disc_group_dimension bdg
	INNER JOIN dw_fei.discount_group_dimension dg
		ON dg.discount_group_gk = bdg.branch_discount_group_gk

WHERE bdg.account_name = 'KC';

