/* create vict2 replacement file
added select statement to remove non-manual transactions.
added salesman
*/
SELECT * FROM
	(SELECT SP_HIST.*,
			CASE
			   WHEN SP_HIST.ORDER_ENTRY_DATE BETWEEN NVL (
														PR_OVR.INSERT_TIMESTAMP,
														GR_OVR.INSERT_TIMESTAMP)
												 AND NVL (PR_OVR.EXPIRE_DATE,
														  GR_OVR.EXPIRE_DATE)
			   THEN
					CASE
						WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A')
						THEN
							CASE
								WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT BETWEEN PR_OVR.MULTIPLIER
																		  - .01
																	  AND PR_OVR.MULTIPLIER
																		  + .01
								THEN
								  'OVERRIDE'
								WHEN SP_HIST.PRICE_FORMULA =
									   NVL (PR_OVR.FORMULA, GR_OVR.FORMULA)
								THEN
								  'OVERRIDE'
								ELSE
								  SP_HIST.PRICE_CATEGORY
							END
						ELSE
							SP_HIST.PRICE_CATEGORY
					END
			END
			   PRICE_CATEGORY_OVR,
			PR_OVR.FORMULA PR_OVR,
			PR_OVR.BASIS PR_OVR_BASIS,
			GR_OVR.FORMULA GR_OVR,
			NVL (PR_OVR.INSERT_TIMESTAMP, GR_OVR.INSERT_TIMESTAMP) CCOR_CREATE,
			NVL (PR_OVR.EXPIRE_DATE, GR_OVR.EXPIRE_DATE) CCOR_EXPIRE,
			LB.LINEBUY_NAME,
			DG.DISCOUNT_GROUP_NAME,
			MV.MASTER_VENDOR_NAME
	   FROM (SELECT CUST.ACCOUNT_NAME,
					IHF.ACCOUNT_NUMBER,
					IHF.WAREHOUSE_NUMBER,
					IHF.INVOICE_NUMBER_NK,
					ILF.INVOICE_LINE_NUMBER,
					IHF.OML_ASSOC_NAME,
					SLS.SALESREP_NAME,
					NVL (IHF.WRITER, IHF.OML_ASSOC_INI) WRITER,
					CASE
						WHEN NVL (IHF.WRITER, IHF.OML_ASSOC_INI) = IHF.OML_ASSOC_INI
							THEN
							IHF.OML_ASSOC_NAME
						WHEN SUBSTR (
							NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
							0,
							1)
							|| SUBSTR (
							NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
							-1) =
							SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
							|| SUBSTR (IHF.OML_ASSOC_INI, -1)
							THEN
							IHF.OML_ASSOC_NAME
						ELSE
						NULL
					END
					ASSOC_NAME,

					DECODE (IHF.SALE_TYPE,
							'1', 'Our Truck',
							'2', 'Counter',
							'3', 'Direct',
							'4', 'Counter',
							'5', 'Credit Memo',
							'6', 'Showroom',
							'7', 'Showroom Direct',
							'8', 'eBusiness') TYPE_OF_SALE,
					IHF.SHIP_VIA_NAME,
					
					CASE
					   WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.PRODUCT_NK
					   ELSE SP_PROD.SPECIAL_PRODUCT_NK
					END
					   AS PRODUCT_NK,
					CASE
					   WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.ALT1_CODE
					   ELSE SP_PROD.ALT_CODE
					END
					   AS ALT1_CODE,
					CASE
					   WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.PRODUCT_NAME
					   ELSE SP_PROD.SPECIAL_PRODUCT_NAME
					END
					   AS PRODUCT_NAME,
					CASE WHEN ILF.PRODUCT_GK IS NOT NULL THEN 'SP' ELSE 'SP-' END
					   AS SP_TYPE,
					ILF.PRODUCT_STATUS,
					CASE
					   WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.MANUFACTURER
					   ELSE SP_PROD.PRIMARY_VNDR
					END
					   AS MANUFACTURER,
					CASE
					   WHEN ILF.PRODUCT_GK IS NOT NULL
					   THEN
						  PROD.DISCOUNT_GROUP_NK
					   ELSE
						  SP_PROD.SPECIAL_DISC_GROUP
					END
					   AS DISCOUNT_GROUP_NK,
					CASE
					   WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.LINEBUY_NK
					   ELSE SP_PROD.SPECIAL_LINE
					END
					   AS LINEBUY_NK,
					ILF.SHIPPED_QTY,
					ILF.EXT_AVG_COGS_AMOUNT,
					ILF.EXT_SALES_AMOUNT,
					CASE
						WHEN IHF.order_code = 'IC'
						THEN
							'CREDITS'
						WHEN IHF.order_code = 'SP'
						THEN
							'SPECIALS'						
						WHEN ilf.price_code IN ('%', '$', 'N', 'F', 'B', 'PO')
						THEN
							'TOOLS'					
						WHEN ilf.price_code = 'Q'
						THEN
							'QUOTE'
						WHEN REGEXP_LIKE (ilf.price_code, '[0-9]?[0-9]?[0-9]')
						THEN
							'MATRIX'
						WHEN ilf.price_code IN ('FC', 'PM')
						THEN
							'MATRIX'
						WHEN ilf.price_code LIKE 'M%'
						THEN
							'MATRIX'
						WHEN ilf.price_formula IN ('CPA', 'CPO')
						THEN
							'OVERRIDE'
						WHEN ilf.price_code IN
							   ('PR',
								'GR',
								'CB',
								'GJ',
								'PJ',
								'*G',
								'*P',
								'G*',
								'P*',
								'G',
								'GJ',
								'P')
						THEN
							'OVERRIDE'
						WHEN ilf.price_code IN ('GI', 'GPC', 'HPF', 'HPN', 'NC')
						THEN
							'MANUAL'
						WHEN ilf.price_code = '*E'
						THEN
							'OTH/ERROR'
						WHEN ilf.price_code = 'SKC'
						THEN
							'OTH/ERROR'

						WHEN ilf.price_code IS NULL
						THEN
							'MANUAL'
						WHEN ilf.price_code IN ('R', 'N/A')
						THEN
							CASE
								WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2)
								  - ROUND (NVL (ilf.MATRIX_PRICE, ilf.MATRIX), 2) BETWEEN 0
																					  AND .01
								THEN
									'MATRIX'
								WHEN IHF.CONTRACT_NUMBER IS NOT NULL
								THEN
									'OVERRIDE'
								ELSE
									'MANUAL'
							END
						ELSE
						  'MANUAL'
					END
						AS PRICE_CATEGORY,
					ILF.PRICE_CODE,
					ILF.PRICE_FORMULA,
					ILF.UNIT_NET_PRICE_AMOUNT,
					ILF.UNIT_INV_COST,
					ILF.REPLACEMENT_COST,
					ILF.LIST_PRICE,
					ILF.PO_COST,
					NVL (ILF.MATRIX_PRICE, ILF.MATRIX) MATRIX_PRICE,
					ILF.ORDER_ENTRY_DATE,
					ILF.PROCESS_DATE,
					IHF.CONSIGN_TYPE,
					IHF.ORDER_CODE,
					IHF.REF_BID_NUMBER,
					IHF.SOURCE_ORDER,
					IHF.SOURCE_SYSTEM,
					IHF.CUSTOMER_ACCOUNT_GK,
					CUST.MAIN_CUSTOMER_NK,
					CUST.CUSTOMER_NK,
					CUST.CUSTOMER_NAME,
					CUST.JOB_YN,
					IHF.JOB_NAME,
					IHF.CONTRACT_DESCRIPTION,
					IHF.CONTRACT_NUMBER,
					CUST.PRICE_COLUMN,
					CUST.CUSTOMER_TYPE
			FROM DW_FEI.INVOICE_HEADER_FACT IHF,
				DW_FEI.INVOICE_LINE_FACT ILF,
				DW_FEI.PRODUCT_DIMENSION PROD,
				DW_FEI.CUSTOMER_DIMENSION CUST,
				DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD,
				DW_FEI.SALESREP_DIMENSION SLS
			WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
				AND IHF.SALESREP_GK = SLS.SALESREP_GK 
				/* AND CUST.ACTIVE_ACCOUNT_NUMBER_NK IN (
					'448','520','1550','1674','3093','226','1020','1657',
					'331','150','56','215','13','100','2000','20','1480',
					'141','1589','78','290','93','185','420','564','216',
					'1869','116','61','190','480','230','454','88','1895',
					'788','1116','1105','1221','1616','2721','3083','8423',
					'2637','1701','1423','3011','1539','1083','1600','1934',
					'1491','2516','1476') */
				AND CUST.ACTIVE_ACCOUNT_NUMBER_NK = '564'
				--AND CUST.ACTIVE_CUSTOMER_NK = '1385'
				AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
				AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
				AND ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK(+)
				AND IHF.IC_FLAG = 0
				AND ILF.SHIPPED_QTY <> 0
				AND IHF.PO_WAREHOUSE_NUMBER IS NULL
				
				AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                        TRUNC (
                                           SYSDATE
                                           - NUMTOYMINTERVAL (3, 'MONTH'),
                                           'MONTH'),
                                        'YYYYMM')
                                 AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                              'YYYYMM')
				AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                        TRUNC (
                                           SYSDATE
                                           - NUMTOYMINTERVAL (3, 'MONTH'),
                                           'MONTH'),
                                        'YYYYMM')
                                 AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                              'YYYYMM')) SP_HIST
					  
			LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
				ON SP_HIST.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
			LEFT OUTER JOIN DW_FEI.LINE_BUY_DIMENSION LB
				ON SP_HIST.LINEBUY_NK = LB.LINEBUY_NK
			LEFT OUTER JOIN DW_FEI.MASTER_VENDOR_DIMENSION MV
				ON SP_HIST.MANUFACTURER = MV.MASTER_VENDOR_NK
			LEFT OUTER JOIN  (SELECT COD.BASIS,
								COD.BRANCH_NUMBER_NK,
								COD.CONTRACT_ID,
								COD.CUSTOMER_GK,
								COD.CUSTOMER_NK,
								COD.DISC_GROUP,
								COD.INSERT_TIMESTAMP,
								COD.EXPIRE_DATE,
								COD.MASTER_PRODUCT,
								COD.MULTIPLIER,
								COD.OPERATOR_USED,
								COD.OVERRIDE_ID_NK,
								COD.OVERRIDE_TYPE,
								   COD.BASIS
								|| COD.OPERATOR_USED
								|| '0'
								|| COD.MULTIPLIER
								   FORMULA
							FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
							WHERE COD.OVERRIDE_TYPE = 'G'
								AND COD.DELETE_DATE IS NULL) GR_OVR
				ON (SP_HIST.DISCOUNT_GROUP_NK = (LTRIM (GR_OVR.DISC_GROUP, '0'))
					AND SP_HIST.ACCOUNT_NUMBER = GR_OVR.BRANCH_NUMBER_NK
					AND SP_HIST.CUSTOMER_ACCOUNT_GK = GR_OVR.CUSTOMER_GK)
			LEFT OUTER JOIN (SELECT COD.BASIS,
								COD.BRANCH_NUMBER_NK,
								COD.CONTRACT_ID,
								COD.CUSTOMER_GK,
								COD.CUSTOMER_NK,
								COD.DISC_GROUP,
								COD.INSERT_TIMESTAMP,
								COD.EXPIRE_DATE,
								COD.MASTER_PRODUCT,
								TO_NUMBER (COD.MULTIPLIER) MULTIPLIER,
								COD.OPERATOR_USED,
								COD.OVERRIDE_ID_NK,
								COD.OVERRIDE_TYPE,
								CASE
									WHEN COD.OPERATOR_USED NOT IN '$'
									THEN
										 COD.BASIS
									  || COD.OPERATOR_USED
									  || '0'
									  || COD.MULTIPLIER
									ELSE
										TO_CHAR (COD.MULTIPLIER)
								END
								   FORMULA
						   FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
						  WHERE COD.OVERRIDE_TYPE = 'P'
								AND COD.DELETE_DATE IS NULL) PR_OVR
			   ON (    SP_HIST.PRODUCT_NK = PR_OVR.MASTER_PRODUCT
				   AND SP_HIST.ACCOUNT_NUMBER = PR_OVR.BRANCH_NUMBER_NK
				   AND SP_HIST.CUSTOMER_ACCOUNT_GK = PR_OVR.CUSTOMER_GK))
	WHERE
		PRICE_CATEGORY IN ('TOOLS', 'MANUAL', 'QUOTE');