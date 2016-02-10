--SQL Dashboard Script for One BU and one price column with group with form data
SELECT MATRIX.RPC, 
      MATRIX.BRANCH_NUMBER_NK BU_NUM,
      MATRIX.ALIAS BU_NAME,
      MATRIX.DISC_GROUP DG,
      MATRIX.DISCOUNT_GROUP_NAME DG_DESCRIPT,      
      MATRIX.RAW_DISC_TO_COST SDTC,
      MATRIX.PRICE_TYPE,      
      MATRIX.PRICE_COLUMN PC,    
      MATRIX.BASIS B,
      MATRIX.OPERATOR_USED O,    
      MATRIX.MULTIPLIER FACTOR,
      --Need to code effective multiplier
      
      --Sales Data           
      NVL(SALES.OVERALL_SALES,0) OVERALL_SALES,
      NVL(SALES.OUTBOUND_SALES,0) OUTBOUND_SALES,
      NVL(SALES.MATRIX_SALES,0) MATRIX_SALES,
      NVL(SALES.CCOR_SALES,0) CCOR_SALES,
      NVL(SALES.MANUAL_SALES,0) MANUAL_SALES,
      NVL(SALES.SPECIAL_SALES,0) SPECIAL_SALES,
      NVL(SALES.CREDIT_SALES,0) CREDIT_SALES,
      
      --GP$ Data      
      (SALES.OVERALL_SALES - SALES.OVERALL_COST) OVERALL_GP$,
      (SALES.OUTBOUND_SALES - SALES.OUTBOUND_COST) OUTBOUND_GP$,
      (SALES.MATRIX_SALES - SALES.MATRIX_COST) MATRIX_GP$,
      (SALES.CCOR_SALES - SALES.CCOR_COST) CCOR_GP$,
      (SALES.MANUAL_SALES - SALES.MANUAL_COST) MANUAL_GP$,
      (SALES.SPECIAL_SALES - SALES.SPECIAL_COST) SPECIAL_GP$,
      (SALES.CREDIT_SALES - SALES.CREDIT_COST) CREDIT_GP$,
      
      --GP% Percent Data
      
      --Overall GP%
      CASE
        WHEN (SALES.OVERALL_SALES > 0)
          THEN ROUND(((SALES.OVERALL_SALES - SALES.OVERALL_COST)/SALES.OVERALL_SALES),4)
            ELSE
              0
            END
            OVERALL_GP_PERCENT,
      
      --Outbound GP%      
      CASE
        WHEN (SALES.OUTBOUND_SALES > 0)
          THEN ROUND(((SALES.OUTBOUND_SALES - SALES.OUTBOUND_COST)/SALES.OUTBOUND_SALES),4)
            ELSE
              0
            END
            OUTBOUND_GP_PERCENT,
       
       --Matrix GP%
       CASE
        WHEN (SALES.MATRIX_SALES > 0)
          THEN ROUND(((SALES.MATRIX_SALES - SALES.MATRIX_COST)/SALES.MATRIX_SALES),4)
            ELSE
              0
            END
            MATRIX_GP_PERCENT,
      
      --CCOR GP%      
      CASE
        WHEN (SALES.CCOR_SALES > 0)
          THEN ROUND(((SALES.CCOR_SALES - SALES.CCOR_COST)/SALES.CCOR_SALES),4)
            ELSE
              0
            END
            CCOR_GP_PERCENT,
      
      --Manual GP%      
      CASE
        WHEN (SALES.MANUAL_SALES > 0)
          THEN ROUND(((SALES.MANUAL_SALES - SALES.MANUAL_COST)/SALES.MANUAL_SALES),4)
            ELSE
              0
            END
            MANUAL_GP_PERCENT,
      
      --Special GP%      
      CASE
        WHEN (SALES.SPECIAL_SALES > 0)
          THEN ROUND(((SALES.SPECIAL_SALES - SALES.SPECIAL_COST)/SALES.SPECIAL_SALES),4)
            ELSE
              0
            END
            SPECIAL_GP_PERCENT,
      
      --Credit GP%      
      CASE
        WHEN (SALES.CREDIT_SALES > 0)
          THEN ROUND(((SALES.CREDIT_SALES - SALES.CREDIT_COST)/SALES.CREDIT_SALES),4)
            ELSE
              0
            END
            CREDIT_GP_PERCENT,
            
      --Usage Metrics
      --Matrix Usage
      CASE
        WHEN (SALES.OUTBOUND_SALES > 0)
          THEN ROUND((SALES.MATRIX_SALES/SALES.OUTBOUND_SALES),4)
            ELSE
            0
            END
            MATRIX_USAGE,
      
      --CCOR Usage      
      CASE
        WHEN (SALES.OUTBOUND_SALES > 0)
          THEN ROUND((SALES.CCOR_SALES/SALES.OUTBOUND_SALES),4)
            ELSE
            0
            END
            CCOR_USAGE,
      
      --Manual Usage
      CASE
        WHEN (SALES.OUTBOUND_SALES > 0)
          THEN ROUND((SALES.MANUAL_SALES/SALES.OUTBOUND_SALES),4)
            ELSE
            0
            END
            MANUAL_USAGE,
      
      --Special Usage      
      CASE
        WHEN (SALES.OUTBOUND_SALES > 0)
          THEN ROUND((SALES.SPECIAL_SALES/SALES.OUTBOUND_SALES),4)
            ELSE
            0
            END
            SPECIAL_USAGE,
      
      --Credit Usage
      CASE
        WHEN (SALES.OUTBOUND_SALES > 0)
          THEN ROUND((SALES.CREDIT_SALES/SALES.OUTBOUND_SALES),4)
            ELSE
            0
            END
            CREDIT_USAGE,
      
      --Last Update               
      MATRIX.LAST_UPDATE     

FROM (SELECT PRICE.BRANCH_NUMBER_NK,
      CONTACTS.ALIAS,
      DG.DISCOUNT_GROUP_NAME,
      PRICE.DISC_GROUP,
      PRICE.PRICE_TYPE,
      SDTC.RAW_DISC_TO_COST,
      PRICE.PRICE_COLUMN,    
      PRICE.BASIS,
      PRICE.OPERATOR_USED,    
      PRICE.MULTIPLIER,
      PRICE.LAST_UPDATE,
      CONTACTS.RPC 
    
  FROM DW_FEI.PRICE_DIMENSION PRICE
       INNER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG   
       ON PRICE.DISC_GROUP = DG.DISCOUNT_GROUP_NK
       INNER JOIN DW_FEI.BRANCH_DISC_GROUP_DIMENSION SDTC
       ON (SDTC.BRANCH_DISC_GROUP_NK = DG.DISCOUNT_GROUP_NK
           AND SDTC.ACCOUNT_NUMBER_NK = PRICE.BRANCH_NUMBER_NK)
       LEFT JOIN AAF1046.BRANCH_CONTACTS CONTACTS
       ON (CONTACTS.ACCOUNT_NK = PRICE.BRANCH_NUMBER_NK)
  
  WHERE PRICE.DELETE_DATE IS NULL
      AND PRICE.PRICE_TYPE NOT IN ('T')
      AND PRICE.PRICE_TYPE = 'G'
      AND PRICE.PRICE_COLUMN NOT IN ('000')) MATRIX

  LEFT JOIN (SELECT PRICECAT.ACCOUNT_NUMBER_NK,  
      PRICECAT.DISCOUNT_GROUP_NK,
      PRICECAT.DISCOUNT_GROUP_NK_NAME,
      PRICECAT.PRICE_COLUMN,
      
      --PRICECAT Data
     
      SUM(PRICECAT.EXT_SALES_AMOUNT) OVERALL_SALES,
      
      --Total Outbound PRICECAT          
      SUM(
        CASE      
          WHEN (PRICECAT.PRICE_CATEGORY NOT IN ('Total', 'CREDITS')AND PRICECAT.SALES_TYPE NOT IN 'CREDITS' AND PRICECAT.EXT_SALES_AMOUNT >= 0) 
            THEN (PRICECAT.EXT_SALES_AMOUNT)
              ELSE 
                0 
              END) 
              OUTBOUND_SALES,

      
      --Matrix PRICECAT
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('MATRIX','MATRIX_BID')  
              THEN (PRICECAT.EXT_SALES_AMOUNT)
                ELSE
                  0
                END)
                MATRIX_SALES,
          
      --CCOR PRICECAT
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('OVERRIDE') 
              THEN (PRICECAT.EXT_SALES_AMOUNT)
                ELSE
                  0
                END)
                CCOR_SALES,
      
      --Manual PRICECAT          
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')  
              THEN (PRICECAT.EXT_SALES_AMOUNT)
                ELSE
                  0
                END)
                MANUAL_SALES,
      
      --Special PRICECAT          
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('SPECIAL')  
              THEN (PRICECAT.EXT_SALES_AMOUNT)
                ELSE
                  0
                END)
                SPECIAL_SALES,
      
      --Credit PRICECAT          
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('CREDITS')  
              THEN (PRICECAT.EXT_SALES_AMOUNT)
                ELSE
                  0
                END)
                CREDIT_SALES,
      
      --Overall Cost
      SUM(PRICECAT.EXT_ACTUAL_COGS_AMOUNT) OVERALL_COST,
      
      
      --Outbound Cost
      SUM(
        CASE      
          WHEN (PRICECAT.PRICE_CATEGORY NOT IN ('Total', 'CREDITS')AND PRICECAT.SALES_TYPE NOT IN 'CREDITS' AND PRICECAT.EXT_SALES_AMOUNT > 0 ) 
            THEN (PRICECAT.EXT_ACTUAL_COGS_AMOUNT)
              ELSE 
                0 
              END) 
              OUTBOUND_COST,

      
      --Matrix Cost
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('MATRIX','MATRIX_BID')  
              THEN (PRICECAT.EXT_ACTUAL_COGS_AMOUNT)
                ELSE
                  0
                END)
                MATRIX_COST,
          
      --CCOR Cost
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN 'OVERRIDE'  
              THEN (PRICECAT.EXT_ACTUAL_COGS_AMOUNT)
                ELSE
                  0
                END)
                CCOR_COST,
      
      --Manual Cost         
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')  
              THEN (PRICECAT.EXT_ACTUAL_COGS_AMOUNT)
                ELSE
                  0
                END)
                MANUAL_COST,
      
      --Special Cost          
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('SPECIAL')  
              THEN (PRICECAT.EXT_ACTUAL_COGS_AMOUNT)
                ELSE
                  0
                END)
                SPECIAL_COST,
      
      --Credit Cost          
      SUM (
          CASE
            WHEN PRICECAT.PRICE_CATEGORY IN ('CREDITS')  
              THEN (PRICECAT.EXT_ACTUAL_COGS_AMOUNT)
                ELSE
                  0
                END)
                CREDIT_COST
      
      FROM SALES_MART.PRICE_MGMT_DATA_DET PRICECAT
      
      --RPC User indicate Timeframe
      WHERE PRICECAT.YEARMONTH BETWEEN '201408' AND '201410'
      
      GROUP BY PRICECAT.ACCOUNT_NUMBER_NK,  
      PRICECAT.DISCOUNT_GROUP_NK,
      PRICECAT.DISCOUNT_GROUP_NK_NAME,
      PRICECAT.PRICE_COLUMN) SALES
      
    ON (MATRIX.BRANCH_NUMBER_NK = SALES.ACCOUNT_NUMBER_NK
        AND  MATRIX.DISC_GROUP = SALES.DISCOUNT_GROUP_NK
        AND MATRIX.PRICE_COLUMN = SALES.PRICE_COLUMN)
        
--RPC User indicate Channel, Branch, DG, and price columns
/*WHERE MATRIX.RPC = 'Atlantic'
  AND MATRIX.BRANCH_NUMBER_NK IN('1300')
  AND MATRIX.DISC_GROUP = '0504'
  --AND MATRIX.PRICE_COLUMN = '001' */ 
  
GROUP BY MATRIX.RPC,
      MATRIX.BRANCH_NUMBER_NK,
      MATRIX.ALIAS,
      MATRIX.DISC_GROUP,
      MATRIX.DISCOUNT_GROUP_NAME,      
      MATRIX.RAW_DISC_TO_COST,
      MATRIX.PRICE_TYPE,      
      MATRIX.PRICE_COLUMN,    
      MATRIX.BASIS,
      MATRIX.OPERATOR_USED,    
      MATRIX.MULTIPLIER,
      SALES.OVERALL_SALES,
      SALES.OUTBOUND_SALES,
      SALES.MATRIX_SALES,
      SALES.CCOR_SALES,
      SALES.MANUAL_SALES,
      SALES.SPECIAL_SALES,
      SALES.CREDIT_SALES,
      SALES.OVERALL_COST,
      SALES.OUTBOUND_COST,
      SALES.MATRIX_COST,
      SALES.CCOR_COST,
      SALES.MANUAL_COST,
      SALES.SPECIAL_COST,
      SALES.CREDIT_COST,
      MATRIX.LAST_UPDATE      

ORDER BY MATRIX.BRANCH_NUMBER_NK,
  MATRIX.DISC_GROUP,
  MATRIX.PRICE_COLUMN;