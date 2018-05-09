SELECT DISTINCT PM_DET.DISCOUNT_GROUP_NK,
       PM_DET.DISCOUNT_GROUP_NK_NAME,
       SUM (PM_DET.EXT_SALES_AMOUNT) EXT_SALES,
       SUM (PM_DET.EXT_AVG_COGS_AMOUNT) EXT_AVG_COGS
       
  FROM SALES_MART.PRICE_MGMT_DATA_DET PM_DET
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (PM_DET.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
 WHERE     (PM_DET.YEARMONTH BETWEEN 201704 AND 201803)
              
       AND ( SUBSTR ( SWD.DIVISION_NAME, 1, 4 ) IN ( 
			 	    'EAST', 'NORT', 'SOUT', 'WEST'
  				 ) )
       
GROUP BY PM_DET.YEARMONTH,
         SWD.REGION_NAME,
         PM_DET.DISCOUNT_GROUP_NK,
         PM_DET.DISCOUNT_GROUP_NK_NAME