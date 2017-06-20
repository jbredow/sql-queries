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
       

		SUM (po_line.RECEIVED_QTY),
		SUM (po_line.ORDERED_QTY),
		COUNT (po_line.PO_LINE_NUMBER) AS line_count
  
  FROM DW_FEI.PO_HEADER_FACT po_hdr
		
		INNER JOIN DW_FEI.PO_LINE_FACT po_line
			ON (po_hdr.PO_GK = po_line.PO_GK)
		INNER JOIN (SELECT *
                    FROM DW_FEI.BRANCH_VENDOR_DIMENSION
					WHERE     ap_div IN '1'
                          AND BR_IC_EDI_WHSE IS NULL) br_vdr
			ON (po_hdr.BRANCH_VENDOR_GK = br_vdr.VENDOR_GK)
		
		INNER JOIN DW_FEI.PRODUCT_DIMENSION product
			ON (po_line.PRODUCT_GK = product.PRODUCT_GK)
		
		INNER JOIN DW_FEI.LINE_BUY_DIMENSION line_dim
			ON (product.LINEBUY_GK = line_dim.LINEBUY_GK)
		
		INNER JOIN DW_FEI.WAREHOUSE_DIMENSION whse_dim
			ON (po_hdr.WAREHOUSE_NUMBER_GK = whse_dim.WAREHOUSE_GK)
		
		INNER JOIN (SELECT *
		FROM DW_FEI.WAREHOUSE_PRODUCT_FACT
		
		--most current complete audited month.
		--WHERE YEARMONTH = (SELECT MAX (YEARMONTH)

		FROM DW_FEI.WAREHOUSE_PRODUCT_FACT)) wpf
			ON (PO_LINE.PRODUCT_GK = wpf.PRODUCT_GK
		AND PO_LINE.WAREHOUSE_NUMBER_GK = WPF.WAREHOUSE_GK)
		WHERE                
		--PO_HDR.receipt_yearmonth = '201208' AND '201303'
		--excludes fei branches
			po_line.po_date_yearmonth = '201303'
		--not in can be removed to only include 
		AND 	po_line.warehouse_number_nk NOT IN
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
       AND 	po_hdr.WAREHOUSE_NUMBER_NK NOT IN
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
       AND po_hdr.PO_TYPE IN 'S'
       AND whse_dim.account_name = 'kc'  /* remove for production */
	   AND line_dim.LINEBUY_NK IN (
			'94', '135', '168', '183', '199', '200', '208', '213', '222', '224', '234', '235', 
			'246', '257', '262', '263', '276', '280', '295', '298', '302', '310', '326', '342', 
			'410', '460', '550', '554', '572', '580', '584', '594', '596', '598', '600', '604', 
			'614', '624', '647', '660', '680', '682', '692', '703', '714', '748', '752', '755', 
			'757', '760', '858', '860', '861', '862', '865', '867', '870', '872', '874', '876', 
			'887', '922', '927', '935', '939', '959', '961', '962', '963', '967', '970', '974', 
			'975', '991', '996', '1002', '1040', '1052', '1088', '1091', '1100', '1101', '1102', 
			'1110', '1111', '1233', '1247', '1261', '1329', '1337', '1368', '1398', '1401', 
			'1446', '1451', '1452', '1460', '1502', '1503', '1585', '1590', '1608', '1615', 
			'1777', '1797', '1800', '1808', '1818', '1825', '1831', '1837', '1843', '1844', 
			'1845', '1846', '2030', '3013', '3478', '3500', '3501', '3502', '3505', '3507', 
			'3508', '3514', '3517', '3535', '3552', '3560', '3561', '3563', '3564', '3572', 
			'3573', '3574', '3575', '3576', '3577', '3580', '3589', '3590', '3595', '3600', 
			'3604', '3605', '3607', '3609', '3616', '3619', '3625', '3626', '3628', '3634', 
			'3640', '3643', '3644', '3648', '4020', '4291', '4292', '4293', '4295', '4297', 
			'4615', '4617', '4622', '4628', '4851', '4879', '5099', '5563', '5999', '6166', 
			'6438', '6567', '6727', '6833', '7598', '7600', '7730', '7767', '7768', '7769', 
			'7845', '7846', '8045')
GROUP BY whse_dim.WAREHOUSE_NUMBER_NK,
         whse_dim.ACCOUNT_NAME,
		 br_vdr.VENDOR_NK,
         br_vdr.VENDOR_NAME,
         br_vdr.MASTER_VENDOR_VIP_NK,
         line_dim.LINEBUY_NK,
         line_dim.LINEBUY_NAME,
         product.PRODUCT_NK,
         product.PRODUCT_NAME,
         product.UNIT_OF_MEASURE,
         product.DISCOUNT_GROUP_NK,
         po_hdr.PO_TYPE,
         br_vdr.VENDOR_GK;