SELECT SWD.DIVISION_NAME,
       SWD.REGION_NAME,
       PRICE.BRANCH_NUMBER_NK,
       SWD.ALIAS_NAME,
       PRICE.DISC_GROUP,
       COUNT ( DISTINCT PRICE.PRICE_COLUMN ) AS PC_COUNT
  FROM     EBUSINESS.SALES_DIVISIONS SWD
       INNER JOIN
           DW_FEI.PRICE_DIMENSION PRICE
       ON ( SWD.ACCOUNT_NUMBER_NK = PRICE.BRANCH_NUMBER_NK )
 WHERE ( PRICE.DELETE_DATE IS NULL )
       ---AND ( PRICE.BRANCH_NUMBER_NK = '215' )
       AND ( SUBSTR ( SWD.REGION_NAME,
                     1,
                     3
            ) IN
                    ( 'D10',
                     'D11',
                     'D12',
                     'D13',
                     'D14',
                     'D30',
                     'D31',
                     'D32',
                     'D50',
                     'D51',
                     'D53' ) )
GROUP BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         PRICE.BRANCH_NUMBER_NK,
         SWD.ALIAS_NAME,
         PRICE.DISC_GROUP
ORDER BY PRICE.BRANCH_NUMBER_NK ASC,
         PRICE.DISC_GROUP ASC;