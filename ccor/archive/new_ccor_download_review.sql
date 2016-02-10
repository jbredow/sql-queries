SELECT * FROM (
			SELECT SWD.DIVISION_NAME REGION,
						SUBSTR ( SWD.REGION_NAME, 1 ,3 ) DIST,
						SWD.ACCOUNT_NUMBER_NK BR_NO,
						SWD.ALIAS_NAME BR_NAME,
						CCORG.CUSTOMER_NK CUST_NO,
						CCORG.CONTRACT_ID,
						CCORG.OVERRIDE_ID_NK,
						CCORG.OVERRIDE_TYPE,
						CCORG.DISC_GROUP DG,
						DISC_GRP.DISCOUNT_GROUP_NAME,
						NULL AS ALT1_CODE,
						NULL AS PRODUCT_NAME,
						CCORG.EXPIRE_DATE,
						CCORG.BASIS BAS,
						CCORG.OPERATOR_USED OP,
						CCORG.MULTIPLIER MULT,
						CCORG.INSERT_TIMESTAMP INSERT_TS,
						CCORG.UPDATE_TIMESTAMP UPDATE_TS,
						CCORG.LAST_UPDATE,
						CCORG.EFFECTIVE_PROD COST_OVR
				FROM     (    DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORG
									INNER JOIN
											DW_FEI.DISCOUNT_GROUP_DIMENSION DISC_GRP
									ON ( CCORG.DISC_GROUP = DISC_GRP.DISCOUNT_GROUP_NK ))
						INNER JOIN
								EBUSINESS.SALES_DIVISIONS SWD
						ON ( CCORG.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )
			WHERE     ( CCORG.OVERRIDE_TYPE = 'G' )
						--AND ( SWD.ACCOUNT_NUMBER_NK = '1674' )
						--AND ( CCORG.DISC_GROUP = '1072' )
						AND ( CCORG.DELETE_DATE IS NULL )
						AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
								'D10', 'D11', 'D12', 'D13', 
								'D14', 'D30', 'D31', 'D32', 
								'D50', 'D51', 'D53'
							))
			
			UNION
			
			SELECT SWD.DIVISION_NAME REGION,
						SUBSTR ( SWD.REGION_NAME, 1 ,3 ) DIST,
						SWD.ACCOUNT_NUMBER_NK BR_NO,
						SWD.ALIAS_NAME BR_NAME,
						CCORP.CUSTOMER_NK CUST_NO,
						CCORP.CONTRACT_ID,
						CCORP.OVERRIDE_ID_NK,
						CCORP.OVERRIDE_TYPE,
						PROD.DISCOUNT_GROUP_NK DG,
						DISC_GRP.DISCOUNT_GROUP_NAME,
						PROD.ALT1_CODE,
						PROD.PRODUCT_NAME,
						CCORP.EXPIRE_DATE,
						CCORP.BASIS BAS,
						CCORP.OPERATOR_USED OP,
						CCORP.MULTIPLIER MULT,
						CCORP.INSERT_TIMESTAMP INSERT_TS,
						CCORP.UPDATE_TIMESTAMP UPDATE_TS,
						CCORP.LAST_UPDATE,
						CCORP.EFFECTIVE_PROD COST_OVR
				FROM     (    (    DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORP
											LEFT OUTER JOIN
													DW_FEI.PRODUCT_DIMENSION PROD
											ON ( CCORP.MASTER_PRODUCT = PROD.PRODUCT_NK ))
									LEFT OUTER JOIN
											EBUSINESS.SALES_DIVISIONS SWD
									ON ( CCORP.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK ))
						INNER JOIN
								DW_FEI.DISCOUNT_GROUP_DIMENSION DISC_GRP
						ON ( DISC_GRP.DISCOUNT_GROUP_NK = PROD.DISCOUNT_GROUP_NK )
			WHERE     ( CCORP.OVERRIDE_TYPE = 'P' )
						--AND ( SWD.ACCOUNT_NUMBER_NK = '1674' )
						--AND ( CCORP.DISC_GROUP = '1072' )
						AND ( CCORP.DELETE_DATE IS NULL )
						AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
								'D10', 'D11', 'D12', 'D13', 
								'D14', 'D30', 'D31', 'D32', 
								'D50', 'D51', 'D53'
							))) CCOR
	WHERE CCOR.DG IN ('6800', 	'6801', 	'6802', 	'6803', 	'6980', 
										'6981', 	'8523', 	'8524', 	'8526', 	'8527', 
										'8528', 	'8529', 	'8599', 	'8600', 	'8697', 
										'8698', 	'8812', 	'8813', 	'8814', 	'8815', 
										'8816', 	'8817', 	'8818', 	'8819', 	'8820', 
										'8821', 	'8822', 	'8823', 	'8824', 	'8825', 
										'8826', 	'8827', 	'8829', 	'8830', 	'8831', 
										'8832', 	'8833', 	'8834', 	'8835', 	'8836', 
										'8838', 	'8839', 	'8840', 	'8841', 	'8842', 
										'8843', 	'8845', 	'8846', 	'8847', 	'8848', 
										'8849', 	'8850', 	'8851', 	'8852', 	'8853', 
										'8854', 	'8855', 	'8856', 	'8857', 	'8858', 
										'8859', 	'8860', 	'8861', 	'8862', 	'8863', 
										'8864', 	'8865', 	'8866', 	'8868', 	'8869', 
										'8870', 	'8871', 	'8872', 	'8873', 	'8874', 
										'8875', 	'8876', 	'8877', 	'8878', 	'8879', 
										'8880', 	'8881', 	'8882', 	'8883', 	'8884', 
										'8885', 	'8886', 	'8888', 	'8889', 	'8892', 
										'8894', 	'8895', 	'8896', 	'8898', 	'8899', 
										'8900', 	'8901', 	'8902', 	'8903', 	'8904', 
										'8905', 	'8906', 	'8907', 	'8908', 	'8909', 
										'8910', 	'8911', 	'8912', 	'8913', 	'8914', 
										'8915', 	'8916', 	'8917', 	'8918', 	'8919', 
										'8922', 	'8925', 	'8929', 	'8930', 	'8931', 
										'8946', 	'8963', 	'8964', 	'8977', 	'8978', 
										'8979' )