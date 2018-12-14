SELECT DISTINCT TPD.YEARMONTH,
                SWD.DIVISION_NAME AS REGION,
                SWD.REGION_NAME AS DISTRICT,
                SWD.REGION_NAME AS DISTRICT2,
                SWD.WAREHOUSE_NUM_NAME,
                X.ALT1_CODE_AND_PRODUCT_NAME ALT1_DESC,
                X.PRODUCT_NK,
                X.WRITER,
                X.WRITER AS WRITER2,
                X.PRICE_CATEGORY,
                SUM (X.SHIPPED_QTY) AS SHIPPED,
                SUM (X.EXT_SALES_AMOUNT) AS EXT_SALES,
                SUM (X.EXT_ACTUAL_COGS_AMOUNT) AS EXT_REP_COGS,
          -- MATRIX SALES
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'MATRIX'
              			THEN 
              				( X.EXT_SALES_AMOUNT )
              			ELSE
              				0
              		END )
              			MTX_SALES,
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'MATRIX'
              			THEN 
              				( X.EXT_ACTUAL_COGS_AMOUNT )
              			ELSE
              				0
              		END )
              			MTX_REP_COST,
                SUM (
              		CASE
              			WHEN X.SHIPPED_QTY IN 'MATRIX'
              			THEN 
              				( X.SHIPPED_QTY )
              			ELSE
              				0
              		END )
              			MTX_SHIPPED,
                    
          -- CCOR SALES
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
              			THEN 
              				( X.EXT_SALES_AMOUNT )
              			ELSE
              			0
              		END )
              			CCOR_SALES,
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
              			THEN 
              				( X.EXT_ACTUAL_COGS_AMOUNT )
              			ELSE
              			0
              		END )
              			CCOR_REP_COST,
                SUM (
              		CASE
              			WHEN X.SHIPPED_QTY IN 'OVERRIDE'
              			THEN 
              				( X.SHIPPED_QTY )
              			ELSE
              				0
              		END )
              			CCOR_SHIPPED,
          -- MANUAL SALES
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'MANUAL'
              			THEN 
              				( X.EXT_SALES_AMOUNT )
              			ELSE
              				0
              		END )
              			MANUAL_SALES,
              		SUM (
              			CASE
              			WHEN X.PRICE_CATEGORY IN 'MANUAL'
              			THEN 
              				( X.EXT_ACTUAL_COGS_AMOUNT )
              			ELSE
              				0
              		END )
              			MAN_REP_COST,
                SUM (
              		CASE
              			WHEN X.SHIPPED_QTY IN 'MANUAL'
              			THEN 
              				( X.SHIPPED_QTY )
              			ELSE
              				0
              		END )
              			MANUAL_SHIPPED,
         	-- SPECIAL SALES
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'SPECIAL'
              			THEN 
              				( X.EXT_SALES_AMOUNT )
              			ELSE
              				0
              		END )
              			"SP- SALES",
              		SUM (
              			CASE
              			WHEN X.PRICE_CATEGORY IN 'SPECIAL'
              			THEN 
              				( X.EXT_ACTUAL_COGS_AMOUNT )
              			ELSE
              				0
              		END )
              			SP_REP_COST,
                /*SUM (
              		CASE
              			WHEN X.SHIPPED_QTY IN 'SPECIAL'
              			THEN 
              				( X.SHIPPED_QTY )
              			ELSE
              				0
              		END )
              			SPECIAL_SHIPPED,*/
                
          -- CREDIT SALES
              	SUM (
              		CASE
              			WHEN X.PRICE_CATEGORY IN 'CREDITS'
              			THEN 
              				( X.EXT_SALES_AMOUNT )
              			ELSE
              				0
              		END )
              			CREDITS_SALES,
              		SUM (
              			CASE
              				WHEN X.PRICE_CATEGORY IN 'CREDITS'
              				THEN 
              					( X.EXT_ACTUAL_COGS_AMOUNT )
              				ELSE
              					0
              			END )
              				CR_REP_COST
                
  FROM (SALES_MART.PRICE_MGMT_DATA_DET X
        INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
           ON (X.YEARMONTH = TPD.YEARMONTH))
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (X.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
 WHERE     (X.IC_FLAG = 'REGULAR')
       AND (TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE')
       AND (X.DISCOUNT_GROUP_NK = '9181')
       --AND (X.ACCOUNT_NUMBER_NK = '20')
GROUP BY TPD.YEARMONTH,
         SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.REGION_NAME,
         SWD.WAREHOUSE_NUM_NAME,
         X.WRITER,
         X.WRITER,
         X.IC_FLAG,
         X.PRICE_CATEGORY,
         TPD.FISCAL_YEAR_TO_DATE,
         X.ALT1_CODE_AND_PRODUCT_NAME,
         X.PRODUCT_NK
   ;