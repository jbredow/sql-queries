SELECT SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DISTRICT,
       SWD.ACCOUNT_NAME,
       PO_HF.WAREHOUSE_NUMBER_NK AS WHSE_NK,
       PO_HF.PO_NUMBER_NK,
       PO_HF.PO_TYPE,
       PO_LF.PO_LINE_NUMBER,
       PROD.DISCOUNT_GROUP_NK AS DG_NK,
       DG_DIM.DISCOUNT_GROUP_NAME,
       PO_LF.PRODUCT_NK,
       PROD.ALT1_CODE,
       PROD.PRODUCT_NAME,
       PROD.LIST_PRICE,
       PO_LF.RECEIPT_DATE,
       PO_LF.RECEIVED_QTY,
       PO_LF.UNIT_COST
       -- PO_LF.RECEIPT_YEARMONTH
  FROM   (  (  (  ( DW_FEI.PO_LINE_FACT PO_LF
                INNER JOIN
                  DW_FEI.PRODUCT_DIMENSION PROD
                ON ( PO_LF.PRODUCT_GK = PROD.PRODUCT_GK ))
             INNER JOIN
               DW_FEI.PO_HEADER_FACT PO_HF
             ON ( PO_LF.PO_GK = PO_HF.PO_GK ))
          INNER JOIN
            SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON ( SWD.WAREHOUSE_NUMBER_NK = PO_HF.WAREHOUSE_NUMBER_NK ))
       INNER JOIN
         DW_FEI.DISCOUNT_GROUP_DIMENSION DG_DIM
       ON ( PROD.DISCOUNT_GROUP_NK = DG_DIM.DISCOUNT_GROUP_NK ))
			 
	
	WHERE ( SUBSTR ( SWD.REGION_NAME, 1, 3 ) IN ( 
			 	 	  'D10', 'D11', 'D12', 'D14',
				    'D30', 'D31', 'D32', 
				    'D50', 'D51', 'D53'
				 ) )
			AND DG_DIM.DISCOUNT_GROUP_NK IN ( '4562', '4554', '4244', '5737', '4915', '5037' )
			AND PO_LF.RECEIPT_YEARMONTH BETWEEN '201602' AND '201608'
			/* AND PO_LF.RECEIPT_YEARMONTH BETWEEN TO_CHAR ( TRUNC ( SYSDATE
																																									- NUMTOYMINTERVAL ( 7,
																																																		'MONTH'
																																										),
																																									'MONTH'
																																					),
																																					'YYYYMM'
																																)
																														AND TO_CHAR ( TRUNC ( SYSDATE,
																																									'MM'
																																					)
																																					- 1,
																																					'YYYYMM'*/
	;