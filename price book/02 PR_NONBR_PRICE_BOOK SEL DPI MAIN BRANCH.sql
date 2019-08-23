--STEP 2 
--BUILD OUT PRICING FROM DIST MATRIX
--CHANGE TO PERSONAL SCHEMA
--SPECIFY MAIN BRANCH ACCOUNT IN WHERE CLAUSE

TRUNCATE TABLE AAD9606.PR_NONBR_PRICE_BOOK;

INSERT INTO AAD9606.PR_NONBR_PRICE_BOOK
   (SELECT PR_DIM.PRICE_COLUMN,
           --PR_DIM.DISC_GROUP,
           --PR_DIM.MASTER_PRODUCT_NK,
           PR_DIM.BRANCH_NUMBER_NK,
           PR_DIM.LAST_UPDATE,
           -- PR_DIM.DELETE_DATE,
           --PR_DIM.PRICE_TYPE,
           --PR_DIM.PRICE_ID,
           WPF.PRODUCT_NK,
           WPF.PRODUCT_DESC,
           WPF.ALT1,
           WPF.DISCOUNT_GROUP_NK,
           --PRODUCT_DIMENSION.BASIS_2,
           CUST.ACCOUNT_NAME,
           CUST.ACCOUNT_NUMBER_NK,
           CUST.CUSTOMER_GK,
           CUST.CUSTOMER_NK,
           CUST.CUSTOMER_NAME,
           WPF.LIST_PR,
           WPF.BASIS2,
           WPF.BASIS3,
           WPF.BASIS4,
           WPF.BASIS5,
           WPF.BASIS6,
           WPF.BASIS7,
           WPF.BASIS8,
           WPF.BASIS9,
           WPF.PPQ1,
           WPF.PPQ2,
           WPF.PPQ3,
           WPF.DEMAND,
           WPF.ONHAND,
           WPF.AVAIL,
           WPF.NETAVAIL,
           WPF.ORDER_METHOD,
           WPF.AVGCOST,
           WPF.REPCOST,
           MAX (
              CASE
                 WHEN PRICE_TYPE = 'G'
                 THEN
                    PR_DIM.BASIS || PR_DIM.OPERATOR_USED || PR_DIM.MULTIPLIER
                 ELSE
                    NULL
              END)
              GRP_FORMULA,
           MAX (
              CASE
                 WHEN PRICE_TYPE = 'G'
                 THEN
                    DECODE (
                       CONCAT (PR_DIM.BASIS, PR_DIM.OPERATOR_USED),
                       'LX', ROUND (WPF.LIST_PR * PR_DIM.MULTIPLIER, 3),
                       '2X', ROUND (WPF.BASIS2 * PR_DIM.MULTIPLIER, 3),
                       '3X', ROUND (WPF.BASIS3 * PR_DIM.MULTIPLIER, 3),
                       '4X', ROUND (WPF.BASIS4 * PR_DIM.MULTIPLIER, 3),
                       '9X', ROUND (WPF.BASIS9 * PR_DIM.MULTIPLIER, 3),
                       'L-', ROUND (
                                  WPF.LIST_PR
                                - (WPF.LIST_PR * PR_DIM.MULTIPLIER),
                                3),
                       '2-', ROUND (
                                  WPF.BASIS2
                                - (WPF.LIST_PR * PR_DIM.MULTIPLIER),
                                3),
                       'CX', ROUND (
                                  (DECODE (wpf.REPCOST,
                                           NULL, WPF.AVGCOST,
                                           WPF.REPCOST))
                                * PR_DIM.MULTIPLIER,
                                3),
                       '$', PR_DIM.MULTIPLIER,
                       0)
                 ELSE
                    NULL
              END)
              AS BASIS_PRICE_GRP
    FROM (SELECT ACCOUNT_NAME,
                 ACCOUNT_NUMBER_NK,
                 CUSTOMER_GK,
                 CUST_NK CUSTOMER_NK,
                 CUSTOMER_NAME,
                 PRICE_COLUMN,
                 BRANCH_NK
          FROM PRICE_MGMT.PR_DIST_BR_PC
  -- ********* SPECIFY MAIN BRANCH ACCOUNT *************        
          WHERE BRANCH_NK = 107
          ) CUST
         INNER JOIN DW_FEI.PRICE_DIMENSION PR_DIM
            ON (    CUST.PRICE_COLUMN = PR_DIM.PRICE_COLUMN
                AND CUST.ACCOUNT_NUMBER_NK = PR_DIM.BRANCH_NUMBER_NK)
         INNER JOIN                  --PULL DC STOCK ITEMS FROM PRIOR MONTHEND
                    AAD9606.PR_NONBR_WPF WPF
            ON (   PR_DIM.DISC_GROUP = WPF.DISCOUNT_GROUP_NK
                OR PR_DIM.MASTER_PRODUCT_NK = WPF.PRODUCT_NK)
    WHERE PR_DIM.BRANCH_NUMBER_NK = '39'                         --MAIN BRANCH
                                         AND PR_DIM.DELETE_DATE IS NULL
    GROUP BY PR_DIM.PRICE_COLUMN,
             --PR_DIM.DISC_GROUP,
             --PR_DIM.MASTER_PRODUCT_NK,
             PR_DIM.LAST_UPDATE,
             WPF.DISCOUNT_GROUP_NK,
             PR_DIM.BRANCH_NUMBER_NK,
             WPF.PRODUCT_NK,
             WPF.PRODUCT_DESC,
             WPF.ALT1,
             CUST.ACCOUNT_NAME,
             CUST.ACCOUNT_NUMBER_NK,
             CUST.CUSTOMER_GK,
             CUST.CUSTOMER_NK,
             CUST.CUSTOMER_NAME,
             WPF.LIST_PR,
             WPF.BASIS2,
             WPF.BASIS3,
             WPF.BASIS4,
             WPF.BASIS5,
             WPF.BASIS6,
             WPF.BASIS7,
             WPF.BASIS8,
             WPF.BASIS9,
             WPF.DEMAND,
             WPF.ONHAND,
             WPF.AVAIL,
             WPF.NETAVAIL,
             WPF.ORDER_METHOD,
             WPF.PPQ1,
             WPF.PPQ2,
             WPF.PPQ3,
             WPF.AVGCOST,
             WPF.REPCOST);

COMMIT;