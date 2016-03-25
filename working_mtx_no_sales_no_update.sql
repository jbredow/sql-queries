SELECT DISTINCT
       PRICE.BRANCH_NUMBER_NK,
       PRICE.DISC_GROUP,
       COUNT ( DISTINCT PRICE.PRICE_COLUMN ) PC_COUNT
  FROM   SALES_MART.SALES_WAREHOUSE_DIM SWD
       INNER JOIN
         DW_FEI.PRICE_DIMENSION PRICE
       ON ( SWD.ACCOUNT_NUMBER_NK = PRICE.BRANCH_NUMBER_NK )
  WHERE ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
																																						'D10', 'D11', 'D12', 'D13', 
																																						'D14', 'D30', 'D31', 'D32', 
																																						'D50', 'D51', 'D53'
																																				))
	GROUP BY 
	     PRICE.BRANCH_NUMBER_NK,
       PRICE.DISC_GROUP
	;