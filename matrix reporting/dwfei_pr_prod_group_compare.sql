/* drops the matrix overrides and compares them to the pcg price*/
SELECT pd_grp.BRANCH_NUMBER_NK AS BU,
       CONTACTS.ALIAS AS BU_NAME,
       pd_grp.PRICE_TYPE AS PTYPE,
       pd_grp.PROD_DG AS DG,
       pd_grp.PRICE_COLUMN AS PC,
       pd_grp.ALT1_CODE AS ALT,
       pd_grp.PRODUCT_NAME AS PROD_DESC,
	   pd_grp.list_price,
       pd_grp.BASIS AS PBasis,
       pd_grp.OPERATOR_USED AS POperator,
       pd_grp.MULTIPLIER AS PFactor,
       price2.GR_BASIS AS GBasis,
       price2.GR_OPER AS GOperator,
       price2.GR_MULT AS GFactor,
       pd_grp.LAST_UPDATE UPDATE_DATE
  FROM  AAF1046.BRANCH_CONTACTS CONTACTS,
      (   SELECT PRICE.PRICE_COLUMN,
                 PRICE.PRICE_TYPE,
                 PRICE.DISC_GROUP,
                 PRICE.PRICE_ID,
                 PRICE.MASTER_PRODUCT_NK,
                 PRICE.BASIS,
                 PRICE.OPERATOR_USED,
                 PRICE.MULTIPLIER,
                 PRICE.BRANCH_NUMBER_NK,
                 PRICE.LAST_UPDATE,
				 prod.list_price,
                 PROD.DISCOUNT_GROUP_NK PROD_DG,
                 PROD.ALT1_CODE,
                 PROD.PRODUCT_NAME 
            FROM DW_FEI.PRICE_DIMENSION PRICE, DW_FEI.PRODUCT_DIMENSION PROD
           WHERE     PRICE.MASTER_PRODUCT_NK = PROD.PRODUCT_NK
                 AND PRICE.DELETE_DATE IS NULL
                 --AND PROD.DELETE_DATE IS NULL
                 AND PROD.DISCOUNT_GROUP_NK IN (
						'4763', '4764', '4765', '4766', 
						'4767', '4768', '4769', '4770', 
						'4771', '4772')
					) pd_grp
       LEFT OUTER JOIN
          (SELECT PRICE.PRICE_COLUMN GR_PC,
                  PRICE.PRICE_TYPE GR_TYPE,
                  PRICE.DISC_GROUP GR_DG,
                  PRICE.PRICE_ID GR_ID,
                  PRICE.BASIS GR_BASIS,
                  PRICE.OPERATOR_USED GR_OPER,
                  PRICE.MULTIPLIER GR_MULT,
                  PRICE.BRANCH_NUMBER_NK GR_BRANCH,
                  PRICE.LAST_UPDATE GR_LAST_UPD
				  price
             FROM dw_fei.price_dimension PRICE
            WHERE     PRICE.price_type IN 'G'
                  AND PRICE.disc_group IN ('4763', '4764', '4765', '4766', 
                  '4767', '4768', '4769', '4770', '4771', '4772')
                  AND PRICE.delete_date IS NULL) price2
       ON     pd_grp.branch_number_nk = price2.GR_BRANCH
          AND pd_grp.price_column = price2.GR_PC
          AND pd_grp.PROD_DG = price2.GR_DG
 WHERE  CONTACTS.RPC IN ('Midwest')
	  AND contacts.account_nk = pd_grp.BRANCH_NUMBER_NK
	  
	  AND pd_grp.PRICE_COLUMN NOT IN
		  (23, 170, 171, 172, 173, 175, 180, 181, 182, 183, 190, 191, 192, 193, 205)
ORDER BY pd_grp.BRANCH_NUMBER_NK, pd_grp.PRICE_COLUMN
;