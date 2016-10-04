SELECT SWD.REGION_NAME,
       SWD.ALIAS_NAME,
       PHF.WAREHOUSE_NUMBER_NK,
       PHF.PO_NUMBER_NK,
       PHF.PO_TYPE,
       PLF.PO_LINE_NUMBER,
       PROD.UPDATE_TIMESTAMP,
       PROD.DISCOUNT_GROUP_NK,
       PROD.ALT1_CODE,
       PROD.PRODUCT_NK,
       PROD.PRODUCT_NAME,
       PROD.LIST_PRICE,
       PLF.RECEIPT_DATE,
       PLF.RECEIVED_QTY,
       PLF.UNIT_COST
  FROM   (  (  (  DW_FEI.PO_LINE_FACT PLF
             INNER JOIN
               DW_FEI.PRODUCT_DIMENSION PROD
             ON ( PLF.PRODUCT_GK = PROD.PRODUCT_NK ))
          INNER JOIN
            DW_FEI.PO_HEADER_FACT PHF
          ON ( PLF.PO_GK = PHF.PO_GK ))
       INNER JOIN
         SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON ( SWD.WAREHOUSE_NUMBER_NK = PHF.WAREHOUSE_NUMBER_NK ))
 WHERE ( PHF.PO_TYPE = 'S' )
 			 AND  ( SUBSTR ( SWD.REGION_NAME, 1, 3 ) IN ( 
			 	 		'D10', 'D11', 'D12', 'D13', 
				    'D14', 'D30', 'D31', 'D32', 
				    'D50', 'D51', 'D53'
				 ) )

       AND ( PROD.DISCOUNT_GROUP_NK IN (
          																										'8302',
																															'8303',
																															'8304',
																															'8305',
																															'8306',
																															'8307',
																															'8309',
																															'8310',
																															'8313',
																															'8314',
																															'8432'
																															))
       ;