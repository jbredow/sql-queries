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
			AND ilf.discount_group_nk IN (
				'5799', '5835', '5838', '5943', '5890', '5863', '5871', 
				'5895', '5944', '5955', '6055', '6062', '6480', '6481', 
				'6474', '6476', '6466', '6467', '6037', '6140', '6105', 
				'6069', '6044', '6146', '6115', '6073', '6198', '6264', 
				'6279', '6251', '5929', '5935')
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