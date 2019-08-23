-- PULL DC PRICE BOOK FOR NON TRILOGIE FERGUSON BUSINESS
-- This script is run in sequence after building out tables of dpi for specified main branch
-- Pulls all available Matrix Pricing and Customer Overrides for stock DC items

-- Written by Leigh North 2019.07.09 -- Ext. 6924

SELECT X.ACCT_NK,
       --X.CUSTOMER_GK,
       X.CUSTOMER_NK,
       TRANSLATE (X.CUSTOMER_NAME, ',/"', ' ')
          CUSTOMER_NAME,
       X.PC,
       PROD.PRODUCT_NK
          MASTER_PRODUCT_NK,
       TRANSLATE (PROD.PRODUCT_NAME, ',/"', ' ')
          PRODUCT_NAME,
       PROD.DISCOUNT_GROUP_NK
          DISC_GRP,
       TRANSLATE (DG.DISCOUNT_GROUP_NAME, ',/"', ' ')
          DISCOUNT_GROUP_NAME,
       PROD.ALT1_CODE,
       TRANSLATE (PROD.VENDOR_CODE, ',/"', ' ')
          VENDORCODE,
       PROD.LINEBUY_NK,
       PROD.MANUFACTURER,
       TRANSLATE (VEND.MASTER_VENDOR_NAME, ',/"', ' ')
          MASTER_VENDOR_NAME,
       PROD.OBSOLETE_FLAG,
       PROD.SUBSTITUTES,
       PROD.UNIT_OF_MEASURE,
       PROD.LIST_PRICE
          MASTER_LIST,
       X.LIST_PR
          LISTPRICE,
       X.BASIS2,
       X.BASIS3,
       X.BASIS4,
       X.BASIS5,
       X.BASIS6,
       X.BASIS7,
       X.BASIS8,
       X.BASIS9,
       X.REPCOST,
       X.AVGCOST,
       COALESCE (X.CCOR_PROD_FORM,
                 X.CCOR_GRP_FORM,
                 X.PROD_FORMULA,
                 X.GRP_FORMULA)
          FORMULA,
       CASE
          WHEN X.CONTRACT_PRICE_PROD > 0 THEN 'OP'
          WHEN X.CONTRACT_PRICE_GRP > 0 THEN 'OG'
          WHEN X.BASIS_PRICE_PROD > 0 THEN 'PP'
          WHEN X.BASIS_PRICE_GRP > 0 THEN 'PG'
          ELSE 'NA'
       END
          PRICE_SRC,
       -- SIMULATE THE PRICING HIERARCHY TO PULL THE FIRST VALID PRICE
       COALESCE (X.CONTRACT_PRICE_PROD,
                 X.CONTRACT_PRICE_GRP,
                 X.BASIS_PRICE_PROD,
                 X.BASIS_PRICE_GRP)
          BASIS_PRICE,
       -- SHOW DIFFERENT SOD PRICE FROM THE 'SODONLY' SUBQUERY BELOW
       -- OTHERWISE FOLLOW THE PRICING HIERARCHY
       COALESCE (
          X.SOD_FORM,
          CASE
             WHEN X.BASIS_PRICE_PROD <> .01 THEN X.PROD_FORMULA
             ELSE NULL
          END,
          X.GRP_FORMULA)
          SOD_FORMULA,
       COALESCE (
          X.SOD_PRICE,
          CASE
             WHEN X.BASIS_PRICE_PROD <> .01 THEN X.BASIS_PRICE_PROD
             ELSE NULL
          END,
          X.BASIS_PRICE_GRP)
          SOD_BASIS_PRICE,
       X.ORDER_METHOD,
       X.NETAVAIL,
       X.PPQ1
          PPQ1_EA_PACK,
       X.PPQ2
          PPQ2_CASE,
       X.PPQ3
          PPQ3_PALLET,
       PROD.UPC_CODE
FROM (SELECT DISTINCT
             MPB.BRANCH_NUMBER_NK
                ACCT_NK,
             MPB.ACCOUNT_NAME
                ACCT_NAME,
             MPB.PRICE_COLUMN
                PC,
             MPB.CUSTOMER_GK,
             MPB.CUSTOMER_NK,
             MPB.CUSTOMER_NAME,
             MPB.DISCOUNT_GROUP_NK
                DISC_GRP,
             MPB.PRODUCT_NK
                MPID,
             MPB.ALT1,
             MPB.PRODUCT_DESC,
             MPB.LIST_PR,
             MPB.BASIS2,
             MPB.BASIS3,
             MPB.BASIS4,
             MPB.BASIS5,
             MPB.BASIS6,
             MPB.BASIS7,
             MPB.BASIS8,
             MPB.BASIS9,
             MPB.ORDER_METHOD,
             MPB.PPQ1,
             MPB.PPQ2,
             MPB.PPQ3,
             MPB.NETAVAIL,
             MPB.REPCOST,
             MPB.AVGCOST,
             PBO.BASIS || PBO.OPERATOR_USED || PBO.MULTIPLIER
                PROD_FORMULA,
             DECODE (
                CONCAT (PBO.BASIS, PBO.OPERATOR_USED),
                'LX', ROUND (MPB.LIST_PR * PBO.MULTIPLIER, 3),
                '2X', ROUND (MPB.BASIS2 * PBO.MULTIPLIER, 3),
                '3X', ROUND (MPB.BASIS3 * PBO.MULTIPLIER, 3),
                '4X', ROUND (MPB.BASIS4 * PBO.MULTIPLIER, 3),
                '9X', ROUND (MPB.BASIS9 * PBO.MULTIPLIER, 3),
                'L-', ROUND (MPB.LIST_PR - (MPB.LIST_PR * PBO.MULTIPLIER), 3),
                '2-', ROUND (MPB.BASIS2 - (MPB.LIST_PR * PBO.MULTIPLIER), 3),
                'CX', ROUND (
                           (DECODE (MPB.REPCOST,
                                    NULL, MPB.AVGCOST,
                                    MPB.REPCOST))
                         * PBO.MULTIPLIER,
                         3),
                '$$', PBO.MULTIPLIER,
                '$', PBO.MULTIPLIER,
                NULL)
                AS BASIS_PRICE_PROD,
             PBO.LAST_UPDATE
                PBO_UPDATE,
             MPB.GRP_FORMULA,
             MPB.BASIS_PRICE_GRP,
             MPB.LAST_UPDATE
                GRP_UPDATE,
             COD.BASIS || COD.OPERATOR_USED || COD.MULTIPLIER
                CCOR_PROD_FORM,
             DECODE (
                CONCAT (COD.BASIS, COD.OPERATOR_USED),
                'LX', ROUND (MPB.LIST_PR * COD.MULTIPLIER, 3),
                '2X', ROUND (MPB.BASIS2 * COD.MULTIPLIER, 3),
                '3X', ROUND (MPB.BASIS3 * COD.MULTIPLIER, 3),
                '4X', ROUND (MPB.BASIS4 * COD.MULTIPLIER, 3),
                '9X', ROUND (MPB.BASIS9 * COD.MULTIPLIER, 3),
                'L-', ROUND (MPB.LIST_PR - (MPB.LIST_PR * COD.MULTIPLIER), 3),
                '2-', ROUND (MPB.BASIS2 - (MPB.LIST_PR * COD.MULTIPLIER), 3),
                'CX', ROUND (
                           (DECODE (MPB.REPCOST,
                                    NULL, MPB.AVGCOST,
                                    MPB.REPCOST))
                         * COD.MULTIPLIER,
                         3),
                '$$', COD.MULTIPLIER,
                NULL)
                AS CONTRACT_PRICE_PROD,
             COD.INSERT_TIMESTAMP
                PROD_INSERT,
             COD.EXPIRE_DATE
                PROD_EXPIRE,
             COD.UPDATE_TIMESTAMP
                PROD_UPDATE,
             COD_G.BASIS || COD_G.OPERATOR_USED || COD_G.MULTIPLIER
                CCOR_GRP_FORM,
             DECODE (
                CONCAT (COD_G.BASIS, COD_G.OPERATOR_USED),
                'LX', ROUND (MPB.LIST_PR * COD_G.MULTIPLIER, 3),
                '2X', ROUND (MPB.BASIS2 * COD_G.MULTIPLIER, 3),
                '3X', ROUND (MPB.BASIS3 * COD_G.MULTIPLIER, 3),
                '4X', ROUND (MPB.BASIS4 * COD_G.MULTIPLIER, 3),
                '9X', ROUND (MPB.BASIS9 * COD_G.MULTIPLIER, 3),
                'L-', ROUND (MPB.LIST_PR - (MPB.LIST_PR * COD_G.MULTIPLIER),
                             3),
                '2-', ROUND (MPB.BASIS2 - (MPB.LIST_PR * COD_G.MULTIPLIER),
                             3),
                'CX', ROUND (
                           (DECODE (MPB.REPCOST,
                                    NULL, MPB.AVGCOST,
                                    MPB.REPCOST))
                         * COD_G.MULTIPLIER,
                         3),
                '$$', COD_G.MULTIPLIER,
                NULL)
                AS CONTRACT_PRICE_GRP,
             COD_G.INSERT_TIMESTAMP
                GRP_INSERT,
             COD_G.EXPIRE_DATE
                GRP_EXPIRE,
             COD_G.UPDATE_TIMESTAMP
                CCOR_GRP_UPDATE,
             SOD.BASIS || SOD.OPERATOR_USED || SOD.MULTIPLIER
                SOD_FORM,
             DECODE (
                CONCAT (SOD.BASIS, SOD.OPERATOR_USED),
                'LX', ROUND (MPB.LIST_PR * SOD.MULTIPLIER, 3),
                '2X', ROUND (MPB.BASIS2 * SOD.MULTIPLIER, 3),
                '9X', ROUND (MPB.BASIS9 * SOD.MULTIPLIER, 3),
                'L-', ROUND (MPB.LIST_PR - (MPB.LIST_PR * SOD.MULTIPLIER), 3),
                '2-', ROUND (MPB.BASIS2 - (MPB.LIST_PR * SOD.MULTIPLIER), 3),
                'CX', ROUND (
                           (DECODE (MPB.REPCOST,
                                    NULL, MPB.AVGCOST,
                                    MPB.REPCOST))
                         * SOD.MULTIPLIER,
                         3),
                '$$', SOD.MULTIPLIER,
                NULL)
                AS SOD_PRICE,
             SOD.INSERT_TIMESTAMP
                SOD_INSERT,
             SOD.EXPIRE_DATE
                SOD_EXPIRE,
             SOD.UPDATE_TIMESTAMP
      FROM AAD9606.PR_NONBR_PRICE_BOOK MPB
           -- PULL IN PRODUCT LEVEL MATRIX PRICING
           LEFT OUTER JOIN AAD9606.PR_DIST_NONTRIL_PBO PBO
              ON     MPB.PRODUCT_NK = PBO.MASTER_PRODUCT_NK
                 AND MPB.ACCOUNT_NUMBER_NK = PBO.ACCOUNT_NUMBER_NK
                 AND MPB.CUSTOMER_NK = PBO.CUSTOMER_NK
           -- PULL IN PRODUCT LEVEL BASE CONTRACT PRICING
           LEFT OUTER JOIN
           (SELECT *
            FROM AAD9606.PR_DIST_NONBR_CCOR
            WHERE CONTRACT_ID IS NULL AND OVERRIDE_TYPE = 'P') COD
              ON     MPB.PRODUCT_NK = COD.MASTER_PRODUCT
                 AND MPB.ACCOUNT_NUMBER_NK = COD.BRANCH_NUMBER_NK
                 AND MPB.CUSTOMER_NK = COD.CUSTOMER_NK
           -- PULL IN GROUP LEVEL BASE CONTRACT PRICING
           LEFT OUTER JOIN
           (SELECT *
            FROM AAD9606.PR_DIST_NONBR_CCOR
            WHERE CONTRACT_ID IS NULL AND OVERRIDE_TYPE = 'G') COD_G
              ON     MPB.DISCOUNT_GROUP_NK = COD_G.DISC_GROUP
                 AND MPB.ACCOUNT_NUMBER_NK = COD_G.BRANCH_NUMBER_NK
                 AND MPB.CUSTOMER_NK = COD_G.CUSTOMER_NK
           -- PULL IN SOD PRICING WHERE AVAILABLE
           LEFT OUTER JOIN
           (SELECT *
            FROM AAD9606.PR_DIST_NONBR_CCOR
            WHERE CONTRACT_ID = 'SODONLY' AND OVERRIDE_TYPE = 'G') SOD
              ON     MPB.DISCOUNT_GROUP_NK = SOD.DISC_GROUP
                 AND MPB.ACCOUNT_NUMBER_NK = SOD.BRANCH_NUMBER_NK
                 AND MPB.CUSTOMER_NK = SOD.CUSTOMER_NK) X
     INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
        ON TO_CHAR (X.MPID) = PROD.PRODUCT_NK
     INNER JOIN DW_FEI.MASTER_VENDOR_DIMENSION VEND
        ON PROD.MANUFACTURER = VEND.MASTER_VENDOR_NK
     INNER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
        ON PROD.DISCOUNT_GROUP_GK = DG.DISCOUNT_GROUP_GK
/*WHERE (   GREATEST (
             COALESCE (X.PROD_UPDATE, X.PROD_INSERT, TO_DATE ('01/01/1971')),
             COALESCE (X.CCOR_GRP_UPDATE,
                       X.GRP_INSERT,
                       TO_DATE ('01/01/1971')),
             COALESCE (X.PBO_UPDATE, TO_DATE ('01/01/1971')),
             COALESCE (X.GRP_UPDATE, TO_DATE ('01/01/1971')),
             TO_DATE (NVL (PROD.UPDATE_TIMESTAMP, PROD.INSERT_TIMESTAMP))) >=
             (SYSDATE - 1)
       OR X.SELL_LAST_UPDATE >= (SYSDATE - 1))*/
ORDER BY X.CUSTOMER_NK ASC, X.DISC_GRP ASC, X.ALT1 ASC