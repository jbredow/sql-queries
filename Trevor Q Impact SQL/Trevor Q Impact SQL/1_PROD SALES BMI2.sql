DROP TABLE AAA6863.BMI2_PROD_SALES;

CREATE TABLE AAA6863.BMI2_PROD_SALES
AS
   SELECT DTL.ACCOUNT_NUMBER_NK,
          DTL.DISCOUNT_GROUP_NK,
          DTL.DISCOUNT_GROUP_NK_NAME,
          DTL.PRICE_COLUMN,
          CUST.CUSTOMER_GK MAIN_CUSTOMER_GK,
          CUST.MAIN_CUSTOMER_NK,
          CUST.CUSTOMER_NAME,
          DTL.PRODUCT_NK, --******EITHER DTL.PRODUCT_NK OR JOIN ON PRODUCT NK TO CUSTOM SKU LIST BELOW*****
          DTL.ALT1_CODE_AND_PRODUCT_NAME,
          SUM (DTL.SHIPPED_QTY) AS TOTAL_QTY,
          SUM (DTL.EXT_SALES_AMOUNT) AS TOTAL_EXT_SALES,
          SUM (DTL.EXT_AVG_COGS_AMOUNT) AS TOTAL_EXT_AVG_COGS,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'MATRIX' THEN DTL.SHIPPED_QTY
                ELSE NULL
             END)
             AS MATRIX_QTY,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'MATRIX' THEN DTL.EXT_SALES_AMOUNT
                ELSE NULL
             END)
             AS MATRIX_SLS,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'MATRIX'
                THEN
                   DTL.EXT_AVG_COGS_AMOUNT
                ELSE
                   NULL
             END)
             AS MATRIX_AVG_COGS,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'MANUAL' THEN DTL.SHIPPED_QTY
                ELSE NULL
             END)
             AS MANUAL_QTY,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'MANUAL' THEN DTL.EXT_SALES_AMOUNT
                ELSE NULL
             END)
             AS MANUAL_SLS,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'MANUAL'
                THEN
                   DTL.EXT_AVG_COGS_AMOUNT
                ELSE
                   NULL
             END)
             AS MANUAL_AVG_COGS,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'OVERRIDE' THEN DTL.SHIPPED_QTY
                ELSE NULL
             END)
             AS CCOR_QTY,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'OVERRIDE'
                THEN
                   DTL.EXT_SALES_AMOUNT
                ELSE
                   NULL
             END)
             AS CCOR_SLS,
          SUM (
             CASE
                WHEN DTL.PRICE_CATEGORY = 'OVERRIDE'
                THEN
                   DTL.EXT_AVG_COGS_AMOUNT
                ELSE
                   NULL
             END)
             AS CCOR_AVG_COGS
   FROM SALES_MART.PRICE_MGMT_DATA_DET DTL
        INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
           ON (DTL.MAIN_CUSTOMER_GK = CUST.CUSTOMER_GK)
   --INNER JOIN AAK9658.WHSE_CUST_LIST WHSE --/////******PULLS CUSTOMER LIST ASSOC W/ SPECIFIC WHSE(S)////
   --ON DTL.MAIN_CUSTOMER_GK = WHSE.CUSTOMER_GK
   --INNER JOIN AAE0376.FERG_COM_NEW_SKUS FERG--****IF USING ONLY CUSTOM SKU LIST INSERT HERE****
   --ON DTL.PRODUCT_NK = FERG.PRODUCT_NK
   WHERE  ( DTL.YEARMONTH BETWEEN TO_CHAR (
								TRUNC(
									SYSDATE
										- NUMTOYMINTERVAL (
												3,
												'MONTH'),
										'MONTH'),
									'YYYYMM')
							AND
								(TO_CHAR (TRUNC( SYSDATE, 'MM') -1,
										'YYYYMM'))
						)
							
	 			 --AND (DTL.YEARMONTH BETWEEN '201703' AND '201708')
         --AND (DTL.SELL_REGION_NAME IN ('EAST REGION', 'NORTH CENTRAL REGION', 'SOUTH CENTRAL REGION', 'WEST REGION'))
      		AND DTL.ACCOUNT_NUMBER_NK = '501'
         AND (DTL.PRICE_COLUMN IN ('011', '012', '013'))
         AND (DTL.IC_FLAG = 'REGULAR')
         AND (DTL.PRICE_CATEGORY IN ('MATRIX', 'MANUAL', 'OVERRIDE'))
   GROUP BY DTL.ACCOUNT_NUMBER_NK,
            DTL.DISCOUNT_GROUP_NK,
            DTL.DISCOUNT_GROUP_NK_NAME,
            DTL.PRICE_COLUMN,
            CUST.CUSTOMER_GK,
            CUST.MAIN_CUSTOMER_NK,
            CUST.CUSTOMER_NAME,
            DTL.PRODUCT_NK,
            DTL.ALT1_CODE_AND_PRODUCT_NAME
;