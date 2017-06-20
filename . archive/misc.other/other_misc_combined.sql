/*   other misc   */
/*   purchase order information   */

SELECT whse_dim.account_name branch,
	whse_dim.warehouse_number_nk wh_no,
	br_vdr.vendor_nk ven_no,
	br_vdr.vendor_name vendor,
	po_line.po_number_nk,
	line_dim.linebuy_nk lb,
	po_hdr.po_date,
	po_hdr.entered_by,
	product.discount_group_nk dg,
	product.alt1_code alt1,
	product.product_nk pid,
	product.product_name,
	product.unit_of_measure um,
	po_line.per,
	po_hdr.po_type,
	po_line.unit_cost,
	po_line.ext_line_cost ext,
	SUM (po_line.received_qty) AS rec_qty,
	SUM (po_line.ordered_qty) AS ord_qty

FROM dw_fei.po_header_fact po_hdr
	INNER JOIN dw_fei.po_line_fact po_line
		ON (po_hdr.po_gk = po_line.po_gk)
	
	INNER JOIN (SELECT *
				FROM dw_fei.branch_vendor_dimension
					WHERE br_ic_edi_whse IS NULL) br_vdr
					ON (po_hdr.branch_vendor_gk = br_vdr.vendor_gk)
	
	INNER JOIN dw_fei.product_dimension	product
		ON (po_line.product_gk = product.product_gk)
	INNER JOIN dw_fei.line_buy_dimension line_dim
		ON (product.linebuy_gk = line_dim.linebuy_gk)
	INNER JOIN dw_fei.warehouse_dimension whse_dim
		ON (po_hdr.warehouse_number_gk = whse_dim.warehouse_gk)
	INNER JOIN aaa6863.other_misc_dg other
		ON (product.discount_group_nk = other.dg_nk)
	INNER JOIN aaa6863.branch_contacts bc
		ON (whse_dim.account_number_nk = bc.account_nk)
    
WHERE	po_hdr.PO_TYPE IN 'S'
	AND po_hdr.po_date_yearmonth =
                  TO_NUMBER (TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM'))
	AND whse_dim.warehouse_number_nk IN ('945', '141')
	AND bc.district IN ('C10', 'C11', 'C12')
	AND bc.account_nk IN ('2000', '13')
	AND product.discount_group_nk IN ('1025',' 1027', '1039', '1052', '1053', '1179',
										'1374', '1395', '1502', '3044', '4055', '4095',
										'4447', '4562', '5102', '5168', '5463', '5635',
										'5636', '5637', '5791', '5793', '5797', '5799',
										'5801', '5805', '5806', '5807', '5808', '5809',
										'5810', '5811', '5819', '5820', '5821', '5835',
										'5836', '5838', '5839', '7807', '8260')
	--AND product.discount_group_nk IN (other.dg_nk) --doesn't work!
	AND bc.rpc = 'Midwest'

GROUP BY whse_dim.account_name,
	whse_dim.warehouse_number_nk,
	br_vdr.vendor_nk,
	br_vdr.vendor_name,
	po_line.po_number_nk,
	line_dim.linebuy_nk,
	po_hdr.po_date,
	po_hdr.entered_by,
	product.discount_group_nk,
	product.alt1_code,
	product.product_nk,
	product.product_name,
	product.unit_of_measure,
	po_line.per,
	po_hdr.po_type,
	po_line.unit_cost,
	po_line.ext_line_cost


ORDER BY whse_dim.ACCOUNT_NAME,
	whse_dim.WAREHOUSE_NUMBER_NK,
	br_vdr.VENDOR_NAME,
	product.DISCOUNT_GROUP_NK,
	product.PRODUCT_NK
;