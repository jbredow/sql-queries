SELECT DISTINCT
       PC_COUNT.DIVISION_NAME,
       PC_COUNT.REGION_NAME,
       PC_COUNT.BRANCH_NUMBER_NK,
       PC_COUNT.DISC_GROUP,
       COUNT ( PC_COUNT.PRICE_COLUMN ) PC_COUNT,
			 MAX ( PC_COUNT.UPDATE_TIMESTAMP ) UPD,
       MIN ( PC_COUNT.INSERT_TIMESTAMP ) INS
  FROM ( SELECT PRICE.BRANCH_NUMBER_NK,
                SLS.SALES,
                SWD.REGION_NAME,
                SWD.DIVISION_NAME,
                PRICE.DISC_GROUP,
                PRICE.PRICE_COLUMN,
								PRICE.UPDATE_TIMESTAMP,
								PRICE.INSERT_TIMESTAMP
           FROM     SALES_MART.SALES_WAREHOUSE_DIM SWD
                  INNER JOIN
                    DW_FEI.PRICE_DIMENSION PRICE
                  ON ( SWD.WAREHOUSE_NUMBER_NK = PRICE.BRANCH_NUMBER_NK )
                INNER JOIN
                  ( SELECT DISTINCT
                           PM_DET.ACCOUNT_NUMBER_NK,
                           PM_DET.DISCOUNT_GROUP_NK,
													 
                           SUM ( PM_DET.EXT_SALES_AMOUNT ) SALES
                      FROM   (  SALES_MART.PRICE_MGMT_DATA_DET PM_DET
                              LEFT OUTER JOIN
                                SALES_MART.SALES_WAREHOUSE_DIM SWD
                              ON ( PM_DET.ACCOUNT_NUMBER_NK =
                                    SWD.WAREHOUSE_NUMBER_NK ))
                           RIGHT OUTER JOIN
                             SALES_MART.TIME_PERIOD_DIMENSION TPD
                           ON ( TPD.YEARMONTH = PM_DET.YEARMONTH )
                     WHERE ( PM_DET.IC_FLAG = 'REGULAR' )
                    --AND ( PM_DET.ACCOUNT_NUMBER_NK = '2000' )
                    GROUP BY PM_DET.IC_FLAG,
                             PM_DET.ACCOUNT_NUMBER_NK,
                             PM_DET.DISCOUNT_GROUP_NK,
														 SWD.REGION_NAME,
                						 SWD.DIVISION_NAME
														 		) SLS
                ON SLS.ACCOUNT_NUMBER_NK = PRICE.BRANCH_NUMBER_NK
                   AND SLS.DISCOUNT_GROUP_NK = PRICE.DISC_GROUP
          WHERE ( PRICE.DELETE_DATE IS NULL ) --AND ( PRICE.BRANCH_NUMBER_NK = '2000' )
                AND ( PRICE.DISC_GROUP IS NOT NULL ) ) PC_COUNT
 WHERE ( SUBSTR ( PC_COUNT.REGION_NAME,
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
       AND PC_COUNT.SALES = 0
GROUP BY PC_COUNT.DIVISION_NAME,
       PC_COUNT.REGION_NAME,
       PC_COUNT.BRANCH_NUMBER_NK,
       PC_COUNT.DISC_GROUP,
       -- COUNT ( PC_COUNT.PRICE_COLUMN ) PC_COUNT,
       PC_COUNT.SALES
ORDER BY PC_COUNT.BRANCH_NUMBER_NK, PC_COUNT.DISC_GROUP;