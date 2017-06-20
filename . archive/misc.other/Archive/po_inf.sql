
SELECT 	bvd.vendor_gk "Vendor",
		bvd.vendor_name "Vendor Name",
		ili.alt_code_used "Alt Code",
		ili.customer_account_gk,
		ili.customer_nk,
		ili.formula "Formula",
		ili.i_cost,
		ili.i_price,
		ili.i_sell_whse,
		ili.i_ship_whse,
		ili.po_tag "Tag.Qty",
		ili.product_gk "Product GK",
		ili.product_nk "Product NK",
		ili.raw_cost,
		ili.raw_price,
		phf.branch_vendor_gk "Vendor GK",
		phf.branch_vendor_nk "Vendor NK",
		phf.entered_by "Written By",
		phf.po_date "PO Date",
		phf.po_date_yearmonth "PO Date YM",
		phf.po_number_nk "PO Number",
		phf.po_type "Type",
		phf.warehouse_number_nk "Whse",
		plf.ext_line_cost "Amount",
		plf.ordered_qty "Ord Qty",
		plf.per "Per",
		plf.po_gk "PO GK",
		plf.unit_cost "Cost",
		vrdf.remote_owner "Remote Owner",
		vrdf.repln_contact "Rpln Buyer",
		wdm.account_name "Account",
		wdm.account_number_nk "Account NK",
		wdm.warehouse_name "Whse Name",
		wpf.basis_2,
		wpf.basis_3,
		wpf.basis_4,
		wpf.basis_5,
		wpf.basis_6,
		wpf.basis_7,
		wpf.basis_8,
		wpf.basis_9,
		wpf.demand_12_months "Demand",
		wpf.discount_group_nk "DG",
		wpf.linebuy "Linebuy",
		wpf.list_pr "LIST",
		wpf.new_list "New List",
		wpf.product_desc "Description",
		wpf.rank_type "RANK",
		wpf.rep_cost "REP",
		wpf.status_type "Status",
		wpf.unit_of_measurement "U/M",
		wpf.whse_avg_cost_amount "Average Cost"

FROM 	dw_fei.integrated_lineitems ili,
		dw_fei.warehouse_product_fact wpf,
		dw_fei.po_line_fact plf,
		dw_fei.po_header_fact phf,
		dw_fei.branch_vendor_dimension bvd,
		dw_fei.vrs_repln_desc_fact vrdf,
		dw_fei.warehouse_dimension wdm

WHERE 	ili.product_nk = wpf.product_nk
		AND wpf.product_nk = plf.product_nk
		AND plf.po_gk = phf.po_gk
		AND phf.warehouse_number_nk = wdm.warehouse_number_nk
		AND phf.branch_vendor_nk = bvd.vendor_nk
		AND vrdf.account_number_nk = wdm.account_number_nk
		AND phf.po_date = 
			TO_DATE('201303','yyyy/mm')
ORDER BY wdm.account_name,
		wpf.discount_group_nk,
		ili.alt_code_used;