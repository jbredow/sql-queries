SELECT br_vdr.VENDOR_NK,
		br_vdr.VENDOR_NAME,
		br_vdr.MASTER_VENDOR_VIP_NK,
       
		line_dim.LINEBUY_NK,
		line_dim.LINEBUY_NAME,
       
		product.PRODUCT_NK,
		product.PRODUCT_NAME,
		product.UNIT_OF_MEASURE,
		product.DISCOUNT_GROUP_NK,
       
		po_hdr.PO_TYPE,
       
		whse_dim.WAREHOUSE_NUMBER_NK,
		whse_dim.ACCOUNT_NAME,
       
		SUM (po_line.EXT_LINE_COST) AS ext_line_cost,
		--SUM (po_line.EXT_RECEIVED_VOLUME_CF) AS recd_vol,
		--SUM (po_line.EXT_RECEIVED_WEIGHT_LB) AS recd_wgt,
		SUM (
			CASE
				WHEN (po_line.ORDERED_QTY = po_line.RECEIVED_QTY) THEN 1
				ELSE 0
			END)
				AS lines_filled,
		SUM (
			CASE
				WHEN po_line.ACTUAL_SHIP_DATE <= po_hdr.REQUESTED_SHIP_DATE
				THEN
					CASE
						WHEN (po_line.ORDERED_QTY = po_line.RECEIVED_QTY) THEN 1
						ELSE 0
					END
				ELSE
					0
			END)
				AS filled_on_time,
		SUM (po_line.RECEIVED_QTY),
		SUM (po_line.ORDERED_QTY),
		COUNT (po_line.PO_LINE_NUMBER) AS line_count
FROM aaa6863.other_misc_dg other,
  DW_FEI.PO_HEADER_FACT po_hdr
	INNER JOIN DW_FEI.PO_LINE_FACT po_line
		ON (po_hdr.PO_GK = po_line.PO_GK)
	INNER JOIN (SELECT *
					FROM DW_FEI.BRANCH_VENDOR_DIMENSION
						WHERE     ap_div IN '1'
							AND account_name IN ('DIST')
							AND BR_IC_EDI_WHSE IS NULL) br_vdr
		ON (po_hdr.BRANCH_VENDOR_GK = br_vdr.VENDOR_GK)
	INNER JOIN DW_FEI.PRODUCT_DIMENSION product
		ON (po_line.PRODUCT_GK = product.PRODUCT_GK)
	INNER JOIN DW_FEI.LINE_BUY_DIMENSION line_dim
		ON (product.LINEBUY_GK = line_dim.LINEBUY_GK)
	INNER JOIN DW_FEI.WAREHOUSE_DIMENSION whse_dim
		ON (po_hdr.WAREHOUSE_NUMBER_GK = whse_dim.WAREHOUSE_GK)
  WHERE                --PO_HDR.receipt_yearmonth BETWEEN '201208' AND '201303'
       --excludes fei branches
		po_line.receipt_yearmonth BETWEEN '201304' AND '201305'
		/* AND po_line.warehouse_number_nk IN
							('295',
							'321',
							'979',
							'423',
							'474',
							'533',
							'625',
							'796',
							'986',
							'321',
							'761')
		AND po_hdr.WAREHOUSE_NUMBER_NK IN
							('295',
							'321',
							'979',
							'423',
							'474',
							'533',
							'625',
							'796',
							'986',
							'321',
							'761') */
		AND po_hdr.PO_TYPE IN 'S'
		--AND line_dim.LINEBUY_NK IN ('6377', '7791', '7122')
		AND product.discount_group_nk IN (other.dg_nk)
GROUP BY br_vdr.VENDOR_NK,
		br_vdr.VENDOR_NAME,
		br_vdr.MASTER_VENDOR_VIP_NK,
		line_dim.LINEBUY_NK,
		line_dim.LINEBUY_NAME,
		product.PRODUCT_NK,
		product.PRODUCT_NAME,
		product.UNIT_OF_MEASURE,
		product.DISCOUNT_GROUP_NK,
		po_hdr.PO_TYPE,
		whse_dim.WAREHOUSE_NUMBER_NK,
		whse_dim.ACCOUNT_NAME,
		br_vdr.VENDOR_GK
--ORDER BY br_vdr.MASTER_VENDOR_VIP_NK ASC
;