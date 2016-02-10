SELECT STATS.DIST,
      STATS .ACCOUNT_NUMBER_NK BR_NO,
      STATS.DISC_GROUP DG,
      STATS.NAT_PC,
      STATS.PC_COUNT,
      CCOR.GROUP_CCOR,
      CCOR.PROD_CCOR,
      CCOR.COST_CCOR,
      DPRO.OHB,
      DPRO.DEMAND,
      SALES.EX_SALES,
      SALES.EX_AC

FROM (  SELECT DISTINCT
              SUBSTR (SWD.REGION_NAME, 1, 3) DIST,
              SWD.ACCOUNT_NUMBER_NK,
              PRICE.DISC_GROUP,
              NAT_PC.PRICE_COLUMN AS NAT_PC,
              COUNT (PRICE.MULTIPLIER) PC_COUNT
          FROM    (   AAA6863.NAT_BU_PRICE_COLUMNS NAT_PC
                  RIGHT OUTER JOIN
                      EBUSINESS.SALES_DIVISIONS SWD
                  ON (NAT_PC.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK))
              LEFT OUTER JOIN
                  DW_FEI.PRICE_DIMENSION PRICE
              ON (PRICE.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK)
        WHERE     (PRICE.DELETE_DATE IS NULL)
              --AND (SWD.ACCOUNT_NUMBER_NK = '520')
              AND (PRICE.PRICE_TYPE = 'G')
              AND (PRICE.PRICE_COLUMN <> '000')
              AND (PRICE.PRICE_COLUMN <> '0')
              AND (PRICE.DELETE_DATE IS NULL)
              AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                          ('D10', 'D11', 'D12', 'D13', 'D14', 'D30', 'D31', 'D32'))
        GROUP BY SWD.REGION_NAME,
                SWD.ACCOUNT_NUMBER_NK,
                PRICE.DISC_GROUP,
                NAT_PC.PRICE_COLUMN
      ) STATS
    LEFT OUTER JOIN
         ( SELECT X.BR_NO,
                  X.DG_NK,
                  SUM (CASE WHEN X.OVERRIDE_TYPE = 'P' THEN 1 ELSE 0 END) PROD_CCOR,
                  SUM (CASE WHEN X.OVERRIDE_TYPE = 'G' THEN 1 ELSE 0 END) GROUP_CCOR,
                  SUM (CASE WHEN X.OVERRIDE_TYPE = 'C' THEN 1 ELSE 0 END) COST_CCOR
              FROM (SELECT CCOR.BRANCH_NUMBER_NK BR_NO,
                          PROD.ALT1_CODE,
                          CCOR.CUSTOMER_GK,
                          TO_NUMBER (PROD.DISCOUNT_GROUP_GK) DG_NK,
                          CCOR.OVERRIDE_TYPE
                      FROM    DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
                          INNER JOIN
                              DW_FEI.PRODUCT_DIMENSION PROD
                          ON (CCOR.MASTER_PRODUCT = PROD.PRODUCT_NK)
                    WHERE     (CCOR.BRANCH_NUMBER_NK = '520')
                          AND (CCOR.OVERRIDE_TYPE = 'P')
                          AND (CCOR.DELETE_DATE IS NULL)
                    UNION
                    SELECT CCOR.BRANCH_NUMBER_NK BR_NO,
                          NULL AS ALT1_CODE,
                          CCOR.CUSTOMER_GK,
                          TO_NUMBER (CCOR.DISC_GROUP) DG_NK,
                          CCOR.OVERRIDE_TYPE
                      FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
                    WHERE     (CCOR.BRANCH_NUMBER_NK = '520')
                          AND (CCOR.OVERRIDE_TYPE = 'G')
                          AND (CCOR.DELETE_DATE IS NULL)
                    UNION
                    SELECT CCOR.BRANCH_NUMBER_NK BR_NO,
                          PROD.ALT1_CODE,
                          CCOR.CUSTOMER_GK,
                          TO_NUMBER (PROD.DISCOUNT_GROUP_NK) DG_NK,
                          CCOR.OVERRIDE_TYPE
                      FROM (   DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
                            INNER JOIN
                              DW_FEI.PRODUCT_DIMENSION PROD
                            ON (CCOR.MASTER_PRODUCT = PROD.PRODUCT_NK))
                    WHERE     (CCOR.OVERRIDE_TYPE = 'C')
													AND (CCOR.BRANCH_NUMBER_NK = '520')
                          AND (CCOR.DELETE_DATE IS NULL)) X
            GROUP BY X.BR_NO, X.DG_NK
        ) CCOR
      ON  STATS.ACCOUNT_NUMBER_NK = CCOR.BR_NO
        AND  STATS.DISC_GROUP =  CCOR.DG_NK
        
    LEFT OUTER JOIN
          (  SELECT DISTINCT
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
                          ('D10', 'D11', 'D12', 'D13', 'D14', 'D30', 'D31', 'D32'))
                  --AND (SWD.ACCOUNT_NUMBER_NK = '520')
            			--AND (WPF.DISCOUNT_GROUP_NK = '3915')
            GROUP BY SWD.ACCOUNT_NUMBER_NK, PROD.DISCOUNT_GROUP_NK
        ) DPRO
      ON  STATS.ACCOUNT_NUMBER_NK = DPRO.ACCOUNT_NUMBER_NK
        AND  STATS.DISC_GROUP =  DPRO.DISCOUNT_GROUP_NK
        
    LEFT OUTER JOIN
          ( SELECT DISTINCT
                  PM_DET.ACCOUNT_NUMBER_NK,
                  PM_DET.DISCOUNT_GROUP_NK,
                  SUM (PM_DET.EXT_SALES_AMOUNT) EX_SALES,
                  SUM (PM_DET.EXT_AVG_COGS_AMOUNT) EX_AC
              FROM    (   SALES_MART.PRICE_MGMT_DATA_DET PM_DET
                      INNER JOIN
                          SALES_MART.TIME_PERIOD_DIMENSION TPD
                      ON (PM_DET.YEARMONTH = TPD.YEARMONTH))
                  RIGHT OUTER JOIN
                      EBUSINESS.SALES_DIVISIONS SWD
                  ON (SWD.ACCOUNT_NUMBER_NK = PM_DET.OLD_ACCOUNT_NUMBER_NK)
            WHERE     (TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS')
                  AND IC_FLAG = 'REGULAR'
                  --AND (PM_DET.ACCOUNT_NUMBER_NK = '520')
                  AND ( SUBSTR (SWD.REGION_NAME, 1, 3) IN
                                      ( 'D10', 'D11', 'D12', 'D13', 'D14', 'D30', 'D31', 'D32' ))
            GROUP BY PM_DET.YEARMONTH,
                    PM_DET.ACCOUNT_NUMBER_NK,
                    PM_DET.DISCOUNT_GROUP_NK 
        ) SALES
      ON  STATS.ACCOUNT_NUMBER_NK = SALES.ACCOUNT_NUMBER_NK
        AND  STATS.DISC_GROUP =  SALES.DISCOUNT_GROUP_NK

ORDER BY 
      STATS.DIST,
      STATS.ACCOUNT_NUMBER_NK,
      STATS.DISC_GROUP ASC

;