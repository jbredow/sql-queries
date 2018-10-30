SELECT    PR.ACCOUNT_NAME
       || '*'
       || PC
       || '*'
       || PTYPE
       || '#'
       || CASE WHEN PTYPE = 'G' THEN DISC_GROUP ELSE PRODUCT_NK END
          PR_KEY,
       REGION,
       DISTRICT,
       PR.ACCT_NK,
       PR.ACCOUNT_NAME,
       PR.PC,
       PTYPE,
       DISC_GROUP,
       DG.DISCOUNT_GROUP_NAME,
       PRODUCT_NK,
       ALT1_CODE,
       PRODUCT_NAME,
       BASIS,
       OPER,
       MULT,
       LAST_UPDATE
FROM (SELECT SD.DIVISION_NAME REGION,
             SD.REGION_NAME DISTRICT,
             SD.ACCOUNT_NUMBER_NK ACCT_NK,
             SD.ACCOUNT_NAME,
             PR.PRICE_COLUMN PC,
             PR.PRICE_TYPE PTYPE,
             NVL (PROD.DISCOUNT_GROUP_NK, PR.DISC_GROUP) DISC_GROUP,
             PROD.PRODUCT_NK,
             PROD.ALT1_CODE,
             PROD.PRODUCT_NAME,
             PR.BASIS,
             PR.OPERATOR_USED OPER,
             PR.MULTIPLIER MULT,
             PR.LAST_UPDATE
      FROM DW_FEI.PRICE_DIMENSION PR
           INNER JOIN PRICE_MGMT.SALES_DIVISIONS SD
              ON (PR.BRANCH_NUMBER_NK = SD.ACCOUNT_NUMBER_NK)
           LEFT OUTER JOIN DW_FEI.PRODUCT_DIMENSION PROD
              ON (PR.MASTER_PRODUCT_NK = PROD.PRODUCT_NK)
      WHERE PR.DELETE_DATE IS NULL) PR
     LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
        ON (PR.DISC_GROUP = DG.DISCOUNT_GROUP_NK)
WHERE PR.DISC_GROUP IN ('0144',
                        '0182',
                        '0206',
                        '0207',
                        '0210',
                        '0211',
                        '0238',
                        '0240',
                        '0241',
                        '0251',
                        '0252',
                        '0316',
                        '7661',
                        '7662',
                        '7663',
                        '7667',
                        '7668',
                        '7670',
                        '7671',
                        '7672',
                        '7674',
                        '7675',
                        '7676',
                        '7677',
                        '7678',
                        '7682',
                        '7684',
                        '7687',
                        '7688',
                        '7693',
                        '7700',
                        '7701',
                        '7703',
                        '7711',
                        '9026',
                        '9027',
                        '9137',
                        '9138')