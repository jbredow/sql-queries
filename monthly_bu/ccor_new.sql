SELECT DISTINCT SWD.DIVISION_NAME AS REGION,
                SWD.REGION_NAME AS DISTRICT,
                SWD.ACCOUNT_NUMBER_NK AS ACCOUNT_NK,
                SWD.ACCOUNT_NAME,
                CCOR.CUSTOMER_NK,
                CUST.CUSTOMER_NAME,
                CUST.MAIN_CUSTOMER_NK AS MAIN_CUST_NK,
                CUST.JOB_YN,
                CCOR.CONTRACT_ID,
                CCOR.OVERRIDE_ID_NK,
                CCOR.OVERRIDE_TYPE,
                CCOR.DISC_GRP,
                DG_DIM.DISCOUNT_GROUP_NAME,
                PROD_DIM.ALT1_CODE,
                PROD_DIM.PRODUCT_NAME,
                CCOR.EXPIRE_DATE,
                CCOR.BASIS,
                CCOR.OPERATOR_USED,
                CCOR.MULTIPLIER,
                CCOR.LAST_UPDATE,
                CCOR.EFFECTIVE_PROD,
                CCOR.YEARMONTH,
                ROWNUM
FROM (((PRICE_MGMT.BACKUP_CCOR CCOR

        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON (CCOR.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK))
           
       INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
          ON     (CCOR.CUSTOMER_NK = CUST.CUSTOMER_NK)
             AND (CCOR.BRANCH_NUMBER_NK = CUST.ACCOUNT_NUMBER_NK))
             
      INNER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG_DIM
         ON (CCOR.DISC_GRP = DG_DIM.DISCOUNT_GROUP_NK))
         
     INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD_DIM
        ON (PROD_DIM.PRODUCT_NK = CCOR.MASTER_PRODUCT)

WHERE CCOR.YEARMONTH = TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,  'YYYYMM')
    --AND (CCOR.YEARMONTH = '201805'))
    AND (SWD.ACCOUNT_NUMBER_NK  = '2000')  --IN ('1480', '2000')) 
    --AND (CUST.MAIN_CUSTOMER_NK IN ('1234', '5678'))
    --AND (CUST.MAIN_CUSTOMER_NK IN ('1234', '5678'))
    AND (CCOR.DISC_GRP = '1076')
    AND (SUBSTR (SWD.REGION_NAME, 1, 3 ) IN ( 
			 	 'D10', 'D11', 'D12', 'D13', 
			 	 'D14', 'D30', 'D31', 'D32', 
			 	 'D50', 'D51', 'D53'
				 ) )
    AND ROWNUM <= '100'
ORDER BY ROWNUM
    
;