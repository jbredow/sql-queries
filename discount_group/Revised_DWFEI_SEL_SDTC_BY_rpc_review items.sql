SELECT DISTINCT                           --PR_MFG_DG_XREF.MASTER_VENDOR_NAME,
       CONTACTS.RPC,
       DC_SDTC.DIVISION_NAME,
       DC_SDTC.REGION_NAME,
       DC_SDTC.ACCOUNT_NAME,
       DC_SDTC.BRANCH_NK,
       DC_SDTC.CUSTOMER_ALPHA,
       DC_SDTC.CUSTOMER_NAME,
       DC_SDTC.PC,
       DC_SDTC.DISC_GRP,
       DC_SDTC.DISCOUNT_GROUP_NAME,
       DC_SDTC.BASIS,
       DC_SDTC.OPER,
       DC_SDTC.MULT_MODE DC_MULT,
       DC_SDTC.BR_SDTC BR_SDTC_REC,
       BR_DG.RAW_DISC_TO_COST RAW_SDTC_CURR,
       TO_CHAR (DC_SDTC.LAST_UPDATE, 'MM/DD/YY') LAST_DC_UPDATE,
       DC_DG.STOCK_SKUS,
       OVR.PROD_OVR_COUNT OVR_SKUS,
       ROUND (
          CASE
             WHEN DC_DG.STOCK_SKUS > 0
             THEN
                OVR.PROD_OVR_COUNT / DC_DG.STOCK_SKUS
             ELSE
                0
          END,
          3)
          PCT_OVR,
       NVL(PRICE2.PCLOADED,'NOT LOADED') BUPCs_Loaded,
       DC_SDTC.BUMP,
       BR_DG.DISC_TO_COST BUMPED_SDTC,
       CASE
          WHEN DC_SDTC.DISC_GRP IN
                  ('1199',
                   '1205',
                   '1209',
                   '1213',
                   '1215',
                   '1219',
                   '1220',
                   '1224',
                   '1228',
                   '1229',
                   '4767',
                   '4768',
                   '4772',
                   '4786',
                   '5038')
          THEN
             'LOCAL BUY'
          WHEN DC_SDTC.DISC_GRP IN
                  ('492',
                   '493',
                   '496',
                   '499',
                   '1534',
                   '1536',
                   '1708',
                   '1709',
                   '1710',
                   '1711',
                   '4058',
                   '4062',
                   '4064',
                   '4066',
                   '4076')
          THEN
             'FAB 70 OFF'
       END
          AS NOTES
  FROM AAD9606.PR_DC_SRC_SDTC DC_SDTC
       INNER JOIN AAD9606.DC_STOCK_DGS_V DC_DG
          ON (LTRIM (DC_SDTC.DISC_GRP, '0') = LTRIM (DC_DG.DC_STK_DG, '0'))
       LEFT OUTER JOIN DW_FEI.BRANCH_DISC_GROUP_DIMENSION BR_DG
          ON (DC_SDTC.ACCOUNT_NAME = BR_DG.ACCOUNT_NAME
              AND DC_SDTC.DISC_GRP = BR_DG.BRANCH_DISC_GROUP_NK)
       LEFT OUTER JOIN AAD9606.PR_DIST_PROD_OVR OVR
          ON (DC_SDTC.PC = OVR.PC AND DC_SDTC.DISC_GRP = OVR.DISC_GRP)
       INNER JOIN USER_SHARED.BRANCH_CONTACTS CONTACTS
          ON (DC_SDTC.BRANCH_NK = CONTACTS.ACCOUNT_NUMBER_NK)
       LEFT JOIN
       (SELECT PRICE.BRANCH_NUMBER_NK,
          PRICE.DISC_GROUP,
          COUNT(PRICE.PRICE_COLUMN) PCLOADED

          FROM DW_FEI.PRICE_DIMENSION PRICE

        WHERE PRICE.DELETE_DATE IS NULL
          AND PRICE.PRICE_TYPE = 'G'

        GROUP BY PRICE.BRANCH_NUMBER_NK,
          PRICE.DISC_GROUP) PRICE2
          ON (DC_SDTC.BRANCH_NK = PRICE2.BRANCH_NUMBER_NK AND DC_SDTC.DISC_GRP = PRICE2.DISC_GROUP)
          
          
 WHERE     --UPPER(RPC) = UPPER(:RPC_REGION) 
 --AND (PR_MFG_DG_XREF.MASTER_VENDOR_NAME LIKE '%' || :VENDOR_NAME || '%')
       BR_DG.RAW_DISC_TO_COST <> DC_SDTC.BR_SDTC
       AND DC_SDTC.MULT_MODE < 1
       AND DC_SDTC.DISCOUNT_GROUP_NAME NOT LIKE '%OTHER%'
       AND DC_SDTC.DISCOUNT_GROUP_NAME NOT LIKE '%MISC%'
       AND DC_SDTC.DISCOUNT_GROUP_NAME NOT LIKE '%DISCONTINUED%'
ORDER BY CONTACTS.RPC ASC,
         DC_SDTC.REGION_NAME ASC,
         DC_SDTC.ACCOUNT_NAME ASC,
         DC_SDTC.DISC_GRP ASC