/*
	matt hipp
    final
		0:14:32 duration @ 2000
*/

SELECT STATS.DIST,
       STATS.ACCOUNT_NUMBER_NK BR_NO,
       STATS.DISC_GROUP DG,
       STATS.NAT_PC,
       STATS.PC_COUNT,
       CCOR.GROUP_CCOR,
       CCOR.PROD_CCOR,
       CCOR.COST_CCOR,
       DPRO.OHB,
       DPRO.DEMAND,
       SUM (SALES.EX_SALES) ex_sales,
       SUM (SALES.EX_AC) ex_ac,
       DATES.INSERT_TS,
       DATES.UPDATE_TS
  FROM             (SELECT DISTINCT
                           SUBSTR (SWD.REGION_NAME, 1, 3) DIST,
                           SWD.ACCOUNT_NUMBER_NK,
                           PRICE.DISC_GROUP,
                           NAT_PC.PRICE_COLUMN AS NAT_PC,
                           COUNT (PRICE.MULTIPLIER) PC_COUNT
                      FROM    (   AAA6863.NAT_BU_PRICE_COLUMNS NAT_PC
                               RIGHT OUTER JOIN
                                  EBUSINESS.SALES_DIVISIONS SWD
                               ON (NAT_PC.BRANCH_NUMBER_NK =
                                      SWD.ACCOUNT_NUMBER_NK))
                           LEFT OUTER JOIN
                              DW_FEI.PRICE_DIMENSION PRICE
                           ON (PRICE.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK)
                     WHERE     (PRICE.DELETE_DATE IS NULL)
                           -- AND ( SWD.ACCOUNT_NUMBER_NK = '2000' )
                           -- AND ( PRICE.DISC_GROUP = '3915' )
                           AND (PRICE.PRICE_TYPE = 'G')
                           AND (PRICE.PRICE_COLUMN <> '000')
                           AND (PRICE.PRICE_COLUMN <> '0')
                           AND (PRICE.PRICE_COLUMN <= '175')
                           AND (PRICE.DELETE_DATE IS NULL)
                           AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                                      ('D10',
                                       'D11',
                                       'D12',
                                       'D14',
                                       'D30',
                                       'D31',
                                       'D32'))
                    GROUP BY SWD.REGION_NAME,
                             SWD.ACCOUNT_NUMBER_NK,
                             PRICE.DISC_GROUP,
                             NAT_PC.PRICE_COLUMN) STATS -- 0:1:03 duration @ 2000
                LEFT OUTER JOIN
                   (SELECT COD.BRANCH_NUMBER_NK,
                           NVL (PROD.DISCOUNT_GROUP_NK, COD.DISC_GROUP)
                              DISC_GROUP,
                           SUM(CASE
                                  WHEN COD.OVERRIDE_TYPE = 'P' THEN 1
                                  ELSE 0
                               END)
                              PROD_CCOR,
                           SUM(CASE
                                  WHEN COD.OVERRIDE_TYPE = 'G' THEN 1
                                  ELSE 0
                               END)
                              GROUP_CCOR,
                           SUM(CASE
                                  WHEN COD.OVERRIDE_TYPE = 'C' THEN 1
                                  ELSE 0
                               END)
                              COST_CCOR
                      FROM    DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
                           LEFT OUTER JOIN
                              DW_FEI.PRODUCT_DIMENSION PROD
                           ON (COD.MASTER_PRODUCT = PROD.PRODUCT_NK)
                     WHERE     COD.DELETE_DATE IS NULL
                           -- AND COD.BRANCH_NUMBER_NK IN ('1657', '1550', '1480', '2000' )
                           AND COD.OVERRIDE_TYPE IN ('P', 'C', 'G')
                           AND NVL (COD.EXPIRE_DATE, (SYSDATE + 1)) > SYSDATE
                    GROUP BY COD.BRANCH_NUMBER_NK,
                             NVL (PROD.DISCOUNT_GROUP_NK, COD.DISC_GROUP)) CCOR -- 0:1:23 duration @ 2000
                ON TO_NUMBER (CCOR.BRANCH_NUMBER_NK) =
                      TO_NUMBER (STATS.ACCOUNT_NUMBER_NK)
                   AND TO_NUMBER (CCOR.DISC_GROUP) =
                         TO_NUMBER (STATS.DISC_GROUP)
             LEFT OUTER JOIN
                (SELECT DISTINCT
                        SWD.ACCOUNT_NUMBER_NK,
                        PROD.DISCOUNT_GROUP_NK,
                        SUM (WPF.ON_HAND_QTY) OHB,
                        SUM (WPF.DEMAND_12_MONTHS) DEMAND
                   FROM    (   SALES_MART.WAREHOUSE_PRODUCT_FACT_CURMON WPF
                            RIGHT OUTER JOIN
                               EBUSINESS.SALES_DIVISIONS SWD
                            ON (WPF.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK))
                        INNER JOIN
                           DW_FEI.PRODUCT_DIMENSION PROD
                        ON (PROD.ALT1_CODE = WPF.ALT_CODE)
                  WHERE (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                               ('D10',
                                'D11',
                                'D12',
                                'D14',
                                'D30',
                                'D31',
                                'D32'))
                 -- AND ( SWD.ACCOUNT_NUMBER_NK = '2000' )
                 -- AND ( PROD.DISCOUNT_GROUP_NK = '3915' )
                 GROUP BY SWD.ACCOUNT_NUMBER_NK, PROD.DISCOUNT_GROUP_NK) DPRO -- 0:01:08 duration @ 2000
             ON TO_NUMBER (DPRO.ACCOUNT_NUMBER_NK) =
                   TO_NUMBER (STATS.ACCOUNT_NUMBER_NK)
                AND TO_NUMBER (DPRO.DISCOUNT_GROUP_NK) =
                      TO_NUMBER (CCOR.DISC_GROUP)
          LEFT OUTER JOIN
             (SELECT PM_DET.ACCOUNT_NUMBER_NK,
                     PM_DET.DISCOUNT_GROUP_NK,
                     MAX(CASE
                            WHEN PM_DET.PRICE_CATEGORY IN
                                       ('MATRIX', 'MATRIX_BID')
                            THEN
                               PM_DET.YEARMONTH
                            ELSE
                               NULL
                         END)
                        LAST_PM_SALE,
                     SUM (PM_DET.EXT_SALES_AMOUNT) EX_SALES,
                     SUM (PM_DET.EXT_AVG_COGS_AMOUNT) EX_AC
                FROM (   SALES_MART.PRICE_MGMT_DATA_DET PM_DET
                      INNER JOIN
                         SALES_MART.TIME_PERIOD_DIMENSION TPD
                      ON (PM_DET.YEARMONTH = TPD.YEARMONTH))
               WHERE (TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS')
                     AND (IC_FLAG = 'REGULAR')
                     -- AND (PM_DET.ACCOUNT_NUMBER_NK = '2000')
                     AND SUBSTR (PM_DET.SELL_DISTRICT, 1, 3) IN
                              ('D10', 'D11', 'D12', 'D14', 'D30', 'D31', 'D32')
              GROUP BY PM_DET.ACCOUNT_NUMBER_NK, PM_DET.DISCOUNT_GROUP_NK)
             SALES
          ON TO_NUMBER (SALES.ACCOUNT_NUMBER_NK) =
                TO_NUMBER (STATS.ACCOUNT_NUMBER_NK)
             AND TO_NUMBER (SALES.DISCOUNT_GROUP_NK) =
                   TO_NUMBER (STATS.DISC_GROUP)
       LEFT OUTER JOIN
          (SELECT DISTINCT
                  PRICE.BRANCH_NUMBER_NK,
                  PRICE.DISC_GROUP,
                  MAX (PRICE.INSERT_TIMESTAMP) INSERT_TS,
                  MAX (PRICE.UPDATE_TIMESTAMP) UPDATE_TS,
                  PRICE.DELETE_DATE
             FROM DW_FEI.PRICE_DIMENSION PRICE
            WHERE (PRICE.DELETE_DATE IS NULL)
           -- AND ( PRICE.BRANCH_NUMBER_NK IN ('1657', '1550', '1480', '2000' ))
           -- AND ( PRICE.DISC_GROUP = '3915' )
           GROUP BY PRICE.BRANCH_NUMBER_NK,
                    PRICE.DISC_GROUP,
                    PRICE.DELETE_DATE) DATES
       ON TO_NUMBER (DATES.BRANCH_NUMBER_NK) =
             TO_NUMBER (SALES.ACCOUNT_NUMBER_NK)
          AND TO_NUMBER (DATES.DISC_GROUP) =
                TO_NUMBER (SALES.DISCOUNT_GROUP_NK)
GROUP BY STATS.DIST,
         STATS.ACCOUNT_NUMBER_NK,
         STATS.DISC_GROUP,
         STATS.NAT_PC,
         STATS.PC_COUNT,
         CCOR.GROUP_CCOR,
         CCOR.PROD_CCOR,
         CCOR.COST_CCOR,
         DPRO.OHB,
         DATES.INSERT_TS,
         DATES.UPDATE_TS,
         DPRO.DEMAND
ORDER BY STATS.DIST, STATS.ACCOUNT_NUMBER_NK, STATS.DISC_GROUP ASC;