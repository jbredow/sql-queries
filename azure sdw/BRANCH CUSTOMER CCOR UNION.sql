SELECT *
FROM (SELECT O.[OVERRIDES_KEY],
             C.[CUSTOMER_ACCT],
             C.[CUSTOMER_ID],
             C.[CUST_NAME],
             C.[CUST_ALPHA],
			 C.[PRICE_CLASS_CODE] CUST_PC,
             O.[OVERRIDES_TYPE],
             O.[OVERRIDES_ITEM_ID]
                AS DGROUP,
             DG.[DISC_GROUP_DESC]
                AS GROUP_DESC,
             H.DET6
                AS PRIM_VDR,
             NULL
                AS VEN_ALPHA,
             NULL
                AS MPID,
             NULL
                ALT1_CODE,
             NULL
                PRODUCT_DESC,
             O.[PRICE_FORMULA1]
                AS FORMULA,
             SUBSTRING (O.[PRICE_FORMULA1], 1, 1)
                AS BASIS,
             CASE
                WHEN O.[PRICE_FORMULA1] LIKE '*%' THEN '$'
                WHEN O.[PRICE_FORMULA1] LIKE 'LX%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '2X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '3X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '5X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '6X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '7X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '9X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE 'CX%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE 'L-%' THEN '-'
                ELSE NULL
             END
                AS OPERATOR,
             CASE
                WHEN O.[PRICE_FORMULA1] LIKE '*%'
                THEN
                   SUBSTRING (O.[PRICE_FORMULA1], 2, 99)
                ELSE
                   SUBSTRING (O.[PRICE_FORMULA1], 3, 99)
             END
                AS MULT,
             O.[OVERRIDES_CUST_ID]
                AS CUST_ID,
             O.[EXPIRES_DATE],
             O.[CNTRT_UPD_DATE]
                AS LAST_UPDATE,
             O.[COST_REBATE]
                AS "START_DATE",
             O.[DELETED_ON_DATE]
                OVR_DELETED,
             O.[DB_INSERT_TS]
                MP_INSERT,
             NULL
                MP_DELETED
      FROM [ODS_STG].[OVERRIDES] O
           INNER JOIN [ODS_STG].[CUSTOMER] C
              ON concat (O.[OVERRIDES_ACCT], '*', O.[OVERRIDES_CUST_ID]) =
                 C.[CUSTOMER_KEY]
           LEFT OUTER JOIN [ODS_STG].[DISC_GROUP] DG
              ON O.[OVERRIDES_ITEM_ID] = DG.[DISC_GROUP_ID]
           LEFT OUTER JOIN DWFEI_STG.BUSGRP_PROD_HIERARCHY H
              ON O.[OVERRIDES_ITEM_ID] = H.DISCOUNT_GROUP_NK
      WHERE OVERRIDES_TYPE = 'G' --AND OVERRIDES_CUST_ID = '391'
      UNION
      SELECT O.[OVERRIDES_KEY],
             C.[CUSTOMER_ACCT],
             C.[CUSTOMER_ID],
             C.[CUST_NAME],
             C.[CUST_ALPHA],
			 C.[PRICE_CLASS_CODE] CUST_PC,
             O.[OVERRIDES_TYPE],
             MP.[DISC_GROUP_ID]
                AS DGROUP,
             DG.[DISC_GROUP_DESC]
                AS GROUP_DESC,
             MP.[PRIM_VENDOR_ID]
                AS PRIM_VDR,
             MV.[VENDOR_ALPHA]
                AS VEN_ALPHA,
             O.[OVERRIDES_ITEM_ID]
                AS MPID,
             MP.[V_ALT_CODE1]
                ALT1_CODE,
             MP.[PRODUCT_DESC]
                PRODUCT_DESC,
             O.[PRICE_FORMULA1]
                AS FORMULA,
             SUBSTRING (O.[PRICE_FORMULA1], 1, 1)
                AS BASIS,
             CASE
                WHEN O.[PRICE_FORMULA1] LIKE '*%' THEN '$'
                WHEN O.[PRICE_FORMULA1] LIKE 'LX%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '2X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '3X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '5X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '6X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '7X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE '9X%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE 'CX%' THEN 'X'
                WHEN O.[PRICE_FORMULA1] LIKE 'L-%' THEN '-'
                ELSE NULL
             END
                AS OPERATOR,
             CASE
                WHEN O.[PRICE_FORMULA1] LIKE '*%'
                THEN
                   SUBSTRING (O.[PRICE_FORMULA1], 2, 99)
                ELSE
                   SUBSTRING (O.[PRICE_FORMULA1], 3, 99)
             END
                AS MULT,
             O.[OVERRIDES_CUST_ID]
                AS CUST_ID,
             O.[EXPIRES_DATE],
             O.[CNTRT_UPD_DATE]
                AS LAST_UPDATE,
             --PWHSE.[PRICE],
             --whsems.[OVERRIDE_WHSE]
             --    AS MWHSE,
             O.[COST_REBATE]
                AS "START_DATE",
             O.[DELETED_ON_DATE]
                OVR_DELETED,
             O.[DB_INSERT_TS]
                MP_INSERT,
             MP.DELETED_ON_DATE
                MP_DELETED
      FROM [ODS_STG].[OVERRIDES] O
           INNER JOIN [ODS_STG].[MASTER_PRODUCT] MP
              ON O.[OVERRIDES_ITEM_ID] = MP.[MASTER_PRODUCT_ID]
           INNER JOIN [ODS_STG].[CUSTOMER] C
              ON concat (O.[OVERRIDES_ACCT], '*', O.[OVERRIDES_CUST_ID]) =
                 C.[CUSTOMER_KEY]
           INNER JOIN [ODS_STG].[DISC_GROUP] DG
              ON MP.[DISC_GROUP_ID] = DG.[DISC_GROUP_ID]
           INNER JOIN [ODS_STG].[MASTER_VENDOR] MV
              ON MP.[PRIM_VENDOR_ID] = MV.[MASTER_VENDOR_ID]
      WHERE OVERRIDES_TYPE = 'P') X

WHERE CUST_ID = '2069'
AND CUSTOMER_ACCT = 'ANCHORAGE'
