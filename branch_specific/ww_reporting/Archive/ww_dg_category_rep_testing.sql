/* run for the monthly WW core products report. */

DROP TABLE AAA6863.WW_DG_CAT_12MO;

CREATE TABLE AAA6863.WW_DG_CAT_12MO AS

SELECT ihf.account_number,
			cust.account_name,
			ihf.yearmonth,
			CASE
				WHEN  ihf.channel_type IN ('H3', 'H7', 'O3', 'O7') 
					THEN 'Direct'
				ELSE 'Stock'
			END
				AS channel,
			CASE
				WHEN ilf.product_gk IS NOT NULL
				THEN prod.discount_group_nk
				ELSE sp_prod.special_disc_group
			END
				AS discount_group_nk,
			ihf.order_code,
			SUM(ilf.ext_avg_cogs_amount) AS ac,
			SUM(ilf.ext_sales_amount) AS sales
			  
		FROM dw_fei.invoice_header_fact ihf,
			dw_fei.invoice_line_fact ilf,
			dw_fei.product_dimension prod,
			dw_fei.customer_dimension cust,
			dw_fei.special_product_dimension sp_prod,
			aaa6863.branch_contacts bc
			
		WHERE  ihf.invoice_number_gk = ilf.invoice_number_gk 
			AND ihf.account_number = '3083'
			AND ihf.customer_account_gk = cust.customer_gk
			AND DECODE (ilf.discount_group_nk, '5799',1,
									'5835',1,
									'5895',1,
									'6474',1,
									'6069',1,
									'6279',1,
									'5838',1,
									'5944',1,
									'6476',1,
									'6044',1,
									'6251',1,
									'5943',1,
									'5955',1,
									'6466',1,
									'6146',1,
									'5929',1,
									'5890',1,
									'6055',1,
									'6467',1,
									'6115',1,
									'5935',1,
									'5863',1,
									'6062',1,
									'6037',1,
									'6073',1,
									'5871',1,
									'6480',1,
									'6140',1,
									'6198',1,
									'6481',1,
									'6105',1,
									'6264',1,0) = 1
			AND DECODE(cust.ar_gl_number,
									'1320',1,
									'1360',1,
									'1380',1,
									'1400',1,
									'1401',1,
									'1500',1,
									'4000',1,
									'7100',1,0) = 0
			AND cust.ar_gl_number IS NOT NULL
			AND NVL (ihf.consign_type, UPPER('N/A')) NOT IN 'R'
			AND ilf.product_gk = prod.product_gk(+)
			AND ilf.special_product_gk = sp_prod.special_product_gk(+)
			AND ihf.ic_flag = 0
			AND ilf.shipped_qty <> 0
			AND ihf.po_warehouse_number IS NULL
			AND ilf.yearmonth BETWEEN TO_CHAR (
											TRUNC (
												SYSDATE
												- NUMTOYMINTERVAL (
														12,
												'MONTH'),
											'MONTH'),
										'YYYYMM')
					AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
			AND ihf.yearmonth BETWEEN TO_CHAR (
											TRUNC (
												SYSDATE
												- NUMTOYMINTERVAL (
													12,
												'MONTH'),
											'MONTH'),
										'YYYYMM')
					AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
			AND bc.district IN ('W50', 'W51', 'W52', 'W53', 'W54')
		GROUP BY 
			ihf.account_number,
			cust.account_name,
			ihf.yearmonth,
			CASE
				WHEN  ihf.channel_type IN ('H3', 'H7', 'O3', 'O7') 
					THEN 'Direct'
				ELSE 'Stock'
			END,
			CASE
				WHEN ilf.product_gk IS NOT NULL
				THEN prod.discount_group_nk
				ELSE sp_prod.special_disc_group
			END,
			ihf.order_code
	;