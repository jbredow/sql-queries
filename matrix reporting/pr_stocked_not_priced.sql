--CREATE OR REPLACE FORCE VIEW "AAD9606"."BRANCH_STOCK_SKUS_ACCT" ("ITEM_GK", "PRODUCT_NK", "ACCOUNT_NAME", "ALT1_CODE", "PROD_DESC", "OBS", "OBS_DATE", "HAS_MASTER_LIST", "AVG_BRANCH_LIST", "LIST_ALIGNED", "STOCKING_WHSES", "WHSE_HAS_LIST", "ANNUAL_DMD", "EXT_VALUE", "EXT_ON_HAND", "AVG_WHSE_COST", "UM_CODE", "YEARMONTH", "MSTR_LIST", "PRIOR_MSTR_LIST", "MSTR_BASIS_2", "UPC_CODE", "VENDOR_CODE", "DISC_GRP", "DISCOUNT_GROUP_NAME", "LINEBUY_NK", "LINEBUY_NAME", "MFR", "MFR_NAME") AS

SELECT STOCK_DGS.YEARMONTH,
       STOCK_DGS.ACCOUNT_NAME,
       STOCK_DGS.ACCT,
       STOCK_DGS.DISC_GRP,
       STOCK_DGS.DISCOUNT_GROUP_NAME,
       STOCK_DGS.STOCKING_WHSES,
       STOCK_DGS.STOCK_SKUS,
       STOCK_DGS.EXT_VALUE,
       COUNT (PRICED_DGS.PC) COLUMNS_LOADED
  FROM (SELECT WPF.YEARMONTH,
               SWD.ACCOUNT_NAME,
               WPF.ACCOUNT_NUMBER_NK ACCT,
               PROD.DISCOUNT_GROUP_NK DISC_GRP,
               DISC_GRP.DISCOUNT_GROUP_NAME,
               COUNT (DISTINCT WPF.WAREHOUSE_NUMBER_NK) STOCKING_WHSES,
               COUNT (DISTINCT WPF.PRODUCT_NK) STOCK_SKUS,
               SUM (WPF.EXTENDED_VALUE) EXT_VALUE
          FROM SALES_MART.WAREHOUSE_PRODUCT_FACT_CURMON WPF,
               SALES_MART.SALES_WAREHOUSE_DIM SWD,
               DW_FEI.PRODUCT_DIMENSION PROD,
               DW_FEI.DISCOUNT_GROUP_DIMENSION DISC_GRP
         WHERE     WPF.WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK
               AND NVL (WPF.STATUS_TYPE, 'STOCK') IN
                      ('STOCK', 'NN', 'NV', 'S', 'NQ')
               AND WPF.PRODUCT_NK = PROD.PRODUCT_NK
               AND PROD.DISCOUNT_GROUP_NK = DISC_GRP.DISCOUNT_GROUP_NK
               AND WPF.ACCOUNT_NUMBER_NK = 226
        			 --AND SWD.ACCOUNT_NAME NOT LIKE 'INT%'

        GROUP BY WPF.YEARMONTH,
                 SWD.ACCOUNT_NAME,
                 WPF.ACCOUNT_NUMBER_NK,
                 PROD.DISCOUNT_GROUP_NK,
                 DISC_GRP.DISCOUNT_GROUP_NAME) STOCK_DGS
       LEFT OUTER JOIN
       (SELECT SWD.ACCOUNT_NAME,
               PR_DIM.BRANCH_NUMBER_NK ACCT,
               PR_DIM.PRICE_COLUMN PC,
               NVL (PR_DIM.DISC_GROUP, PROD.DISCOUNT_GROUP_NK) DISC_GRP,
               DGRP.DISCOUNT_GROUP_NAME,
               COUNT (PR_DIM.MASTER_PRODUCT_NK) PROD_OVR_COUNT
          FROM DW_FEI.PRICE_DIMENSION PR_DIM,
               DW_FEI.PRODUCT_DIMENSION PROD,
               DW_FEI.DISCOUNT_GROUP_DIMENSION DGRP,
               EBUSINESS.SALES_DIVISIONS SWD
         WHERE     PR_DIM.BRANCH_NUMBER_NK <> '39'
               AND PR_DIM.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK
               AND PR_DIM.MASTER_PRODUCT_NK = PROD.PRODUCT_NK(+)
               AND NVL (PR_DIM.DISC_GROUP, PROD.DISCOUNT_GROUP_NK) =
                      DGRP.DISCOUNT_GROUP_NK
               -- AND PR_DIM.PRICE_TYPE IN ('P')
               AND PR_DIM.DELETE_DATE IS NULL
               AND NVL (PR_DIM.MULTIPLIER, 0) <> 0
               AND PR_DIM.BRANCH_NUMBER_NK IN ( 215, 1550 )
        GROUP BY PR_DIM.PRICE_COLUMN,
                 PR_DIM.BRANCH_NUMBER_NK,
                 SWD.ACCOUNT_NAME,
                 PR_DIM.DISC_GROUP,
                 PROD.DISCOUNT_GROUP_NK,
                 DGRP.DISCOUNT_GROUP_NAME) PRICED_DGS
          ON     STOCK_DGS.ACCT = PRICED_DGS.ACCT
             AND STOCK_DGS.DISC_GRP = PRICED_DGS.DISC_GRP
 WHERE PRICED_DGS.ACCT || PRICED_DGS.DISC_GRP IS NULL
GROUP BY STOCK_DGS.YEARMONTH,
         STOCK_DGS.ACCOUNT_NAME,
         STOCK_DGS.ACCT,
         STOCK_DGS.DISC_GRP,
         STOCK_DGS.DISCOUNT_GROUP_NAME,
         STOCK_DGS.STOCKING_WHSES,
         STOCK_DGS.STOCK_SKUS,
         STOCK_DGS.EXT_VALUE