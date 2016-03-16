
SELECT SD.DIVISION_NAME REGION,
       SD.REGION_NAME DISTRICT,
       COD.BRANCH_NUMBER_NK ACCT_NK,
       SD.ACCOUNT_NAME,
       CD.CUSTOMER_NK,
       CD.CUSTOMER_NAME,
       CD.PRICE_COLUMN,
       CD.LAST_SALE,
       COD.DISC_GROUP,
			 DGD.DISCOUNT_GROUP_NAME,
       COD.MASTER_PRODUCT,
			 PROD.ALT1_CODE,
			 PROD.LONG_DESCRIPTION,
			 
			 
       COD.CONTRACT_ID,
       CCD.CONTRACT_NAME,
       COD.EXPIRE_DATE,
       COD.BASIS,
       COD.OPERATOR_USED,
       COD.MULTIPLIER,
       COD.EFFECTIVE_PROD,
       --'' AS PM_BASIS,
       --'' AS PM_OPERATOR_USED,
       --'' AS PM_MULTIPLIER,
       COD.OVERRIDE_TYPE,
       COD.MAX_PUR_QTY,
       COD.COST_REBATE,
       COD.FORMULA_2,
       COD.FORMULA_3,
       COD.QTY_1,
       COD.QTY_2,
       --COD.MPD_AMOUNT,
       COD.BUILDER_REBATE,
       COD.EXPRESS_PROD,
       COD.OVERRIDE_ID_NK,
       COD.LAST_UPDATE,
       COD.INSERT_TIMESTAMP,
       COD.UPDATE_TIMESTAMP
  FROM     (    (    (    (    DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
                           LEFT OUTER JOIN
                               DW_FEI.CUSTOMER_DIMENSION CD
                           ON ( COD.CUSTOMER_GK = CD.CUSTOMER_GK ))
                      LEFT OUTER JOIN
                          DW_FEI.CUSTOMER_CONTRACT_DIMENSION CCD
                      ON ( COD.CUSTOMER_GK = CCD.CUSTOMER_GK )
                         AND ( COD.CONTRACT_ID = CCD.CONTRACT_ID ))
                 LEFT OUTER JOIN
                     EBUSINESS.SALES_DIVISIONS SD
                 ON ( COD.BRANCH_NUMBER_NK = SD.ACCOUNT_NUMBER_NK ))
            LEFT OUTER JOIN
                DW_FEI.DISCOUNT_GROUP_DIMENSION DGD
            ON ( DGD.DISCOUNT_GROUP_NK = COD.DISC_GROUP ))
       LEFT OUTER JOIN
           DW_FEI.PRODUCT_DIMENSION PROD
       ON ( PROD.PRODUCT_NK = COD.MASTER_PRODUCT )
			 
WHERE  COD.BRANCH_NUMBER_NK NOT IN ('180', '209', '218', '39')
    AND CD.DELETE_DATE IS NULL
    AND COD.DELETE_DATE IS NULL
    AND COD.OVERRIDE_TYPE <> 'C'
    AND COD.QTY_1 > 0

ORDER BY SD.REGION_NAME ASC,
         COD.BRANCH_NUMBER_NK,
         CD.CUSTOMER_NK,
         CCD.CONTRACT_ID,
         COD.DISC_GROUP,
         COD.MASTER_PRODUCT
