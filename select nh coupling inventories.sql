SELECT P.PRODUCT_ACCT,
       MP.DISC_GROUP_ID,
       DG.DISCOUNT_GROUP_NAME,
       P.PRODUCT_KEY,
       P.PRODUCT_ID,
       LEFT (P.PRODUCT_ID, (CHARINDEX ('*', P.PRODUCT_ID)) - 1)
       --right(P.PRODUCT_ID,len(P.PRODUCT_ID)- CHARINDEX('*',P.PRODUCT_ID)) 
	      MPID,
       RIGHT (P.PRODUCT_ID,
              LEN (P.PRODUCT_ID) - CHARINDEX ('*', P.PRODUCT_ID))
          WHSE,
       MP.V_ALT_CODE1,
       MP.VENDOR_PROD_CODE,
       MP.PRODUCT_DESC,
       ROUND (P.RPLC_COST_AMT, 2)
          RPLC_COST_AMT,
       V_RPLC_CHG_DATE,
       ROUND (P.AVG_COST_AMT, 2)
          AVG_COST_AMT,
       ROUND (P.ON_HAND_BAL, 0)
          ON_HAND_BAL,
       ROUND (P.AVG_DEMAND_AMT, 2)
          DEMAND,
       ROUND (P.V_BASIS_L, 2)
          BR_LIST,
       P.V_LAST_PRICE_CHG_DATE,
       ROUND (P.V_BASIS_2, 2)
          BASIS_2,
       ROUND (P.V_LAST_RPLC_COST_AMT, 2)
          LAST_RPLC_COST_AMT,
       V_LAST_RPLC_CHG_DATE
FROM [ODS_STG].[PRODUCT] P
     INNER JOIN [ODS_STG].[MASTER_PRODUCT] MP
        ON LEFT (P.PRODUCT_ID, CHARINDEX ('*', P.PRODUCT_ID) - 1) =
          -- right(P.PRODUCT_ID,len(P.PRODUCT_ID)- CHARINDEX('*',P.PRODUCT_ID)) =
		   MP.MASTER_PRODUCT_ID
     INNER JOIN [DWFEI_STG].[DISCOUNT_GROUP_DIMENSION] DG
        ON MP.DISC_GROUP_ID = DG.DISCOUNT_GROUP_NK
WHERE  --   P.ON_HAND_BAL > 0
P.AVG_COST_AMT IS NOT NULL
      AND LTRIM (MP.DISC_GROUP_ID) IN ('1261','1262','4139','4149','4702','7137')
      AND CHARINDEX ('*', P.PRODUCT_ID) > 2
	  AND P.PRODUCT_ID NOT LIKE '%NS%'
	  --AND PRODUCT_ACCT IN ('GARDEN','DALLAS','DETROIT')
	  



