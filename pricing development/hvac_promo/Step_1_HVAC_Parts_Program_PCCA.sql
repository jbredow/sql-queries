--drop TABLE AAD9606.PR_PROMO_REPORT_PCCA

CREATE TABLE AAA3078.PR_PROMO_REPORT_PCCA

AS
   SELECT DISTINCT *
     FROM (SELECT NEW_CUST.PROMO_NAME,
                  NEW_CUST.TIER,
                  NEW_CUST.ACCOUNT_NAME,
                  NEW_CUST.ACCOUNT_NUMBER_NK,
                  NEW_CUST.HOUSE_ACCT HOUSE,
                  NEW_CUST.MAIN_CUSTOMER_NK MAIN_CUST_NK,
                  NEW_CUST.CUSTOMER_NK CUST_NK,
                  NEW_CUST.CUSTOMER_NAME,
                  NEW_CUST.JOB_YN JOB,
                  NEW_CUST.LAST_SALE,
                  NEW_CUST.PRICE_COLUMN PC,
                  NEW_CUST.CUSTOMER_TYPE CTYPE,
                  NEW_CUST.WHSE,
                  NEW_CUST.MSTR_CUSTNO,
                  NEW_CUST.MSTR_CUST_NAME,
                  NEW_CUST.CUSTOMER_ALPHA,
                  NEW_CUST.CUSTOMER_STATUS CUST_STATUS,
                  NEW_CUST.CREDIT_CODE,
                  NEW_CUST.AR_GL_NUMBER AR_GL,
                  NEW_CUST.CROSS_ACCT,
                  NEW_CUST.CROSS_CUSTOMER_NK CROSS_CUST,
                  NEW_CUST.SETUP_DATE,
                  NEW_CUST.SALESMAN_CODE SLSM_CODE,
                  NEW_CUST.SALESREP_NAME SLSM_NAME,
                  NEW_CUST.SEC_SLSM,
                  NEW_CUST.FLYER_REGION,
                  NEW_CUST.CUSTOMER_GK
             FROM (SELECT DISTINCT
                          CUST.ACCOUNT_NAME,
                          CUST.ACCOUNT_NUMBER_NK,
                          CUST.SALESMAN_CODE,
                          REP.SALESREP_NAME,
                          CUST.SEC_SLSM,
                          CUST.CUSTOMER_GK,
                          CUST.MAIN_CUSTOMER_NK,
                          CUST.CUSTOMER_NK,
                          CUST.CUSTOMER_NAME,
                          CUST.CUSTOMER_ALPHA,
                          CUST.CUSTOMER_TYPE,
                          CUST.PRICE_COLUMN,
                          CUST.MSTR_CUSTNO,
                          CUST.MSTR_CUST_NAME,
                          CUST.MSTR_TYPE,
                          CUST.JOB_YN,
                          CASE
                             WHEN LTRIM (CUST.SALESMAN_CODE, '0123456789')
                                     IS NULL
                             THEN
                                'Y'
                             WHEN REP.SALESREP_NAME LIKE '%HOUSE%'
                             THEN
                                'Y'
                             WHEN REP.HOUSE_ACCT_FLAG IS NULL
                             THEN
                                'N'
                             ELSE
                                REP.HOUSE_ACCT_FLAG
                          END
                             AS HOUSE_ACCT,
                          CUST.AR_GL_NUMBER,
                          CUST.CUSTOMER_STATUS,
                          CUST.LAST_SALE,
                          CUST.CREDIT_CODE,
                          CUST.PRIOR_CUSTOMER_TYPE,
                          CUST.BRANCH_WAREHOUSE_NUMBER WHSE,
                          CUST.CROSS_ACCT,
                          CUST.CROSS_CUSTOMER_NK,
                          TO_CHAR (TRUNC (CUST.ACCOUNT_SETUP_DATE),
                                   'MM/DD/YYYY')
                             SETUP_DATE,
                          TO_CHAR (TRUNC (CUST.UPDATE_TIMESTAMP),
                                   'MM/DD/YYYY')
                             DW_UPDATE_TIMESTAMP,
                          TO_CHAR (TRUNC (CUST.INSERT_TIMESTAMP),
                                   'MM/DD/YYYY')
                             DW_INSERT_TIMESTAMP,
                          CUST.OLD_ACCOUNT_NUMBER_NK,
                          CUST.OLD_ACCOUNT_NAME,
                          CUST.OLD_CUSTOMER_NK,
                          CUST.OLD_PRICE_COLUMN,
                          CUST.ACTIVE_ACCOUNT_NUMBER_NK,
                          CUST.ACTIVE_ACCOUNT_NAME,
                          CUST.ACTIVE_CUSTOMER_NK,
                          HVAC.PROMO PROMO_NAME,
                          DECODE (HVAC.TIERID,
                                  1, 'BASE',
                                  2, 'TIER1',
                                  3, 'TIER2',
                                  4, 'TIER3',
                                  5, 'TIER4',
                                  'BASE')
                             AS TIER,
                          -- only need region for hvac customers
                          -- this logic will evolve as we expand the app functionality
                          CASE
                             WHEN HVAC.PROMO = 'hydronics'
                             THEN
                                NULL
                             WHEN     HVAC.PROMO = 'coolingparts'
                                  AND LOGONS_WHSE.FLYER_REGION IS NOT NULL
                             THEN
                                LOGONS_WHSE.FLYER_REGION
                             ELSE
                                NVL (LOGONS.FLYER_REGION, 'N/A')
                          END
                             AS FLYER_REGION
                     FROM DW_FEI.CUSTOMER_DIMENSION CUST
                          LEFT OUTER JOIN
                          (SELECT REPS.ACCOUNT_NAME,
                                  REPS.SALESREP_NK,
                                  MAX (REPS.SALESREP_NAME) SALESREP_NAME,
                                  REPS.HOUSE_ACCT_FLAG
                             FROM DW_FEI.SALESREP_DIMENSION REPS
                           GROUP BY REPS.ACCOUNT_NAME,
                                    REPS.SALESREP_NK,
                                    REPS.HOUSE_ACCT_FLAG) REP
                             ON (    CUST.SALESMAN_CODE = REP.SALESREP_NK
                                 AND CUST.ACCOUNT_NAME = REP.ACCOUNT_NAME)
                          INNER JOIN AAD9606.PR_PROMO_SIGNUPS_1 HVAC
                             ON     CUST.ACCOUNT_NUMBER_NK = HVAC.ACCTNK
                                AND CUST.CUSTOMER_NK = HVAC.CUSTNK
                          -- these joins pull back the flyer region for hvac customers
                          LEFT OUTER JOIN
                          (SELECT WHSE, "PROGRAM REGION" FLYER_REGION
                             FROM AAC4319.PR_HVAC_FLYER_LOGONS_FALL
                            WHERE WHSE IS NOT NULL) LOGONS_WHSE
                             ON CUST.BRANCH_WAREHOUSE_NUMBER =
                                   LOGONS_WHSE.WHSE
                          LEFT OUTER JOIN
                          (SELECT ACCT_NAME, "PROGRAM REGION" FLYER_REGION
                             FROM AAC4319.PR_HVAC_FLYER_LOGONS_FALL
                            WHERE WHSE IS NULL) LOGONS
                             ON CUST.ACCOUNT_NAME = LOGONS.ACCT_NAME)
                  NEW_CUST
           GROUP BY NEW_CUST.ACCOUNT_NAME,
                    NEW_CUST.ACCOUNT_NUMBER_NK,
                    NEW_CUST.HOUSE_ACCT,
                    NEW_CUST.MAIN_CUSTOMER_NK,
                    NEW_CUST.CUSTOMER_NK,
                    NEW_CUST.CUSTOMER_NAME,
                    NEW_CUST.JOB_YN,
                    NEW_CUST.LAST_SALE,
                    NEW_CUST.PRICE_COLUMN,
                    NEW_CUST.CUSTOMER_TYPE,
                    NEW_CUST.WHSE,
                    NEW_CUST.MSTR_CUSTNO,
                    NEW_CUST.MSTR_CUST_NAME,
                    NEW_CUST.CUSTOMER_ALPHA,
                    NEW_CUST.CUSTOMER_STATUS,
                    NEW_CUST.CREDIT_CODE,
                    NEW_CUST.AR_GL_NUMBER,
                    NEW_CUST.CROSS_ACCT,
                    NEW_CUST.CROSS_CUSTOMER_NK,
                    NEW_CUST.SETUP_DATE,
                    NEW_CUST.SALESMAN_CODE,
                    NEW_CUST.SALESREP_NAME,
                    NEW_CUST.SEC_SLSM,
                    NEW_CUST.PROMO_NAME,
                    NEW_CUST.TIER,
                    NEW_CUST.FLYER_REGION,
                    NEW_CUST.CUSTOMER_GK
                    )