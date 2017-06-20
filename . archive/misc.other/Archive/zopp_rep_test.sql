SELECT DISTINCT 
	bdgd.account_name,
	bdgd.account_number_nk	,	
	--pohf.warehouse_number_gk,
	pohf.warehouse_number_nk,
	--prod.discount_group_gk,
	prod.discount_group_nk	,
	--bdgd.branch_disc_group_gk,
	bdgd.branch_disc_group_nk,

	bvd.vendor_name,
	bvd.vendor_nk,
	prod.alt1_code,
	prod.product_name,
	polf.per,
	--DEMAND??,
	--STATUS??,

	bdgd.disc_to_cost,
	--calculated DTC,
	prod.list_price,
	--REP COST,
	polf.unit_cost,
	pohf.po_number_nk,
	pohf.po_date,
	--caluclated difference $,
	--calculated difference %,
	pohf.po_type,
	pohf.entered_by,
	
	polf.po_line_number,
	polf.received_qty

FROM DW_FEI.BRANCH_DISC_GROUP_DIMENSION bdgd,
	DW_FEI.PRODUCT_DIMENSION prod,
	DW_FEI.BRANCH_VENDOR_DIMENSION bvd,
	
	DW_FEI.PO_HEADER_FACT pohf
	LEFT	 OUTER	JOIN	 DW_FEI.PO_LINE_FACT polf
		ON pohf.po_number_nk = polf.po_number_nk
	
WHERE polf.product_gk = prod.product_gk
	AND prod.discount_group_gk = bdgd.branch_disc_group_nk
	AND bvd.vendor_nk = pohf.branch_vendor_nk
;