SELECT DISTINCT
       ACCOUNT_NAME,
       MAIN_CUST_NK,
       CUST_NK,
       CUSTOMER_NAME,
       DISC_GRP,
       MPID,
       SKU,
       LIST_PRICE,
       NET,
       DISC,
       OVERRIDE_ID_NK,
       BASIS,
       OPER,
       MULTIPLIER,
       EXPIRE_DATE
       DELTA,
       ACCOUNT_NAME || '*' || MAIN_CUST_NK || '**P#' || MPID FLYER_CCOR_ID,
       '$' || NET FLYER_FORM
  FROM ( (SELECT PCCA.ACCOUNT_NAME,
                 PCCA.MAIN_CUST_NK,
                 PCCA.CUST_NK,
                 PCCA.CUSTOMER_NAME,
                 FLYER.DISC_GRP,
                 FLYER.MPID,
                 FLYER.SKU,
                 FLYER.LIST_PRICE,
                 FLYER.NET,
                 FLYER.DISC,
                 CCOR.OVERRIDE_ID_NK,
                 CCOR.BASIS,
                 CCOR.OPERATOR_USED OPER,
                 CCOR.MULTIPLIER,
                 CASE
                    WHEN CCOR.OPERATOR_USED = '$'
                    THEN
                       FLYER.NET - CCOR.MULTIPLIER
                    WHEN CCOR.OPERATOR_USED = '-'
                    THEN
                       CCOR.MULTIPLIER - FLYER.DISC
                    WHEN CCOR.OPERATOR_USED = 'X'
                    THEN
                       (1 - FLYER.DISC) - CCOR.MULTIPLIER
                    ELSE
                       NULL
                 END
                    AS DELTA,
                 CCOR.EXPIRE_DATE
            FROM AAD9606.PR_HVAC_PROMO_PCCA PCCA
                 INNER JOIN DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
                    ON (PCCA.MAIN_CUST_NK = CCOR.CUSTOMER_NK)
                 INNER JOIN AAD9606.PR_HVAC_PARTS_FLYER FLYER
                    ON (FLYER.MPID = CCOR.MASTER_PRODUCT)
                 INNER JOIN
                 AAD9606.PR_HVAC_FLYER_LOGONS PR_HVAC_FLYER_LOGONS
                    ON (    PR_HVAC_FLYER_LOGONS."PROGRAM REGION" =
                               FLYER.REGION
                        AND PR_HVAC_FLYER_LOGONS.ACCT = CCOR.BRANCH_NUMBER_NK
                        AND PCCA.ACCOUNT_NAME =
                               PR_HVAC_FLYER_LOGONS.ACCT_NAME)
           WHERE CCOR.DELETE_DATE IS NULL)
        UNION
        (SELECT PCCA.ACCOUNT_NAME,
                PCCA.MAIN_CUST_NK,
                PCCA.CUST_NK,
                PCCA.CUSTOMER_NAME,
                FLYER.DISC_GRP,
                FLYER.MPID,
                FLYER.SKU,
                FLYER.LIST_PRICE,
                FLYER.NET,
                FLYER.DISC,
                CCOR.OVERRIDE_ID_NK,
                CCOR.BASIS,
                CCOR.OPERATOR_USED OPER,
                CCOR.MULTIPLIER,
                CASE
                   WHEN CCOR.OPERATOR_USED = '-'
                   THEN
                      CCOR.MULTIPLIER - FLYER.DISC
                   WHEN CCOR.OPERATOR_USED = 'X'
                   THEN
                      (1 - FLYER.DISC) - CCOR.MULTIPLIER
                   ELSE
                      NULL
                END
                   AS DELTA,
                CCOR.EXPIRE_DATE
           FROM AAD9606.PR_HVAC_PROMO_PCCA PCCA
                INNER JOIN DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
                   ON (PCCA.MAIN_CUST_NK = CCOR.CUSTOMER_NK)
                INNER JOIN AAD9606.PR_HVAC_PARTS_FLYER FLYER
                   ON (FLYER.DISC_GRP = CCOR.DISC_GROUP)
                INNER JOIN
                AAD9606.PR_HVAC_FLYER_LOGONS PR_HVAC_FLYER_LOGONS
                   ON (    PR_HVAC_FLYER_LOGONS."PROGRAM REGION" =
                              FLYER.REGION
                       AND PR_HVAC_FLYER_LOGONS.ACCT = CCOR.BRANCH_NUMBER_NK
                       AND PCCA.ACCOUNT_NAME = PR_HVAC_FLYER_LOGONS.ACCT_NAME)
          WHERE CCOR.BASIS = 'L' AND CCOR.DELETE_DATE IS NULL))
 WHERE DELTA > 0