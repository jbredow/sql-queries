--drop TABLE AADA6863.PR_PROMO_REPORT_PCCA

CREATE TABLE AAA6863.PR_PROMO_REPORT_PCCA

AS
   SELECT DISTINCT *
     FROM (SELECT NEW_CUST.PROMO_NAME,
                  NEW_CUST.ACCOUNT_NAME,
                  NEW_CUST.ALIAS_NAME,
                  NEW_CUST.ACCOUNT_NUMBER_NK,
                  NEW_CUST.HOUSE_ACCT ACCT_TYPE,
                  NEW_CUST.MAIN_CUSTOMER_NK MAIN_CUST_NK,
                  NEW_CUST.CUSTOMER_NK CUST_NK,
                  NEW_CUST.CUSTOMER_NAME,
                  NEW_CUST.JOB_YN JOB,
                  NEW_CUST.LAST_SALE,
                  NEW_CUST.PRICE_COLUMN PC,
                  NEW_CUST.CUSTOMER_TYPE CTYPE,
                  NEW_CUST.WHSE,
                  NEW_CUST.MAIN_WHSE,
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
                  MAX (NEW_CUST.SALESREP_NAME) SLSM_NAME,
                  NEW_CUST.SEC_SLSM,
                  NEW_CUST.FLYER_REGION,
                  NEW_CUST.CUSTOMER_GK,
                  NEW_CUST.SIGNUP_DATE
             FROM (SELECT DISTINCT
                          CUST.ACCOUNT_NAME,
                          SD.ALIAS_NAME,
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
                             WHEN REP.OUTSIDE_REP = 'Y' THEN 'O/S'
                             WHEN REP.HOUSE_REP = 'Y' THEN 'H/A'
                             ELSE 'H/U'
                          END
                             HOUSE_ACCT,
                          CUST.AR_GL_NUMBER,
                          CUST.CUSTOMER_STATUS,
                          CUST.LAST_SALE,
                          CUST.CREDIT_CODE,
                          CUST.PRIOR_CUSTOMER_TYPE,
                          CUST.BRANCH_WAREHOUSE_NUMBER WHSE,
                          MAIN_CUST.BRANCH_WAREHOUSE_NUMBER MAIN_WHSE,
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
                          'heatingparts' PROMO_NAME,
                          HVAC.SIGNUP_DATE,
                          -- only need region for hvac customers
                          -- this logic will evolve as we expand the app functionality
                          CASE
                             WHEN LOGONS_WHSE.FLYER_REGION IS NOT NULL
                             THEN
                                LOGONS_WHSE.FLYER_REGION
                             ELSE
                                NVL (LOGONS.FLYER_REGION, 'N/A')
                          END
                             AS FLYER_REGION
                     FROM DW_FEI.ACTIVE_CUSTOMER_MVW CUST
                          LEFT OUTER JOIN
                          (SELECT REPS.ACCOUNT_NAME,
                                  REPS.SALESREP_NK,
                                  MAX (REPS.SALESREP_NAME) SALESREP_NAME,
                                  MAX (REPS.HOUSE_ACCT_FLAG) HOUSE_REP,
                                  MAX (REPS.OUTSIDE_SALES_FLAG) OUTSIDE_REP,
                                  MAX (REPS.SHOWROOM_FLAG) SHOWROOM_REP
                             FROM DW_FEI.SALESREP_DIMENSION REPS
                                  INNER JOIN EBUSINESS.SALES_DIVISIONS SD
                                     ON REPS.ACCOUNT_NAME = SD.ACCOUNT_NAME
                            WHERE     SALESREP_NAME IS NOT NULL
                                  AND SALESREP_NAME <> 'UNKNOWN'
                                  AND EMPLOYEE_NUMBER_NK IS NOT NULL
                           GROUP BY REPS.ACCOUNT_NAME, REPS.SALESREP_NK) REP
                             ON (    CUST.SALESMAN_CODE = REP.SALESREP_NK
                                 AND CUST.ACCOUNT_NAME = REP.ACCOUNT_NAME)
                          INNER JOIN AAD9606.PR_HVAC_SIGNUP_1 HVAC --REPLICATE THIS TABLE IN YOUR SCHEMA
                             ON     CUST.ACCOUNT_NUMBER_NK =
                                       HVAC.ACCOUNT_NUMBER_NK
                                AND CUST.MAIN_CUSTOMER_NK =
                                       HVAC.MAIN_CUSTOMER_NK
                          LEFT OUTER JOIN SALES_MART.SALES_WAREHOUSE_DIM SD
                             ON NVL (CUST.BRANCH_WAREHOUSE_NUMBER,
                                     CUST.ACCOUNT_NUMBER_NK) =
                                   SD.WAREHOUSE_NUMBER_NK
                          LEFT OUTER JOIN DW_FEI.ACTIVE_CUSTOMER_MVW MAIN_CUST
                             ON CUST.ACCOUNT_NAME = MAIN_CUST.ACCOUNT_NAME
                             AND CUST.MAIN_CUSTOMER_NK = MAIN_CUST.CUSTOMER_NK
                          -- these joins pull back the flyer region for hvac customers
                          -- UPDATE SCHEMA AND TABLE NAMES WHERE NECESSARY
                          LEFT OUTER JOIN
                          (SELECT WHSE, "PROGRAM REGION" FLYER_REGION
                             FROM AAC4319.PR_HVAC_FLYER_LOGONS_FALL --MAYBE MOVE TO GENERIC TABLE NAME?
                            WHERE WHSE IS NOT NULL) LOGONS_WHSE
                             ON CUST.BRANCH_WAREHOUSE_NUMBER =
                                   LOGONS_WHSE.WHSE
                          LEFT OUTER JOIN
                          (SELECT ACCT_NAME, "PROGRAM REGION" FLYER_REGION
                             FROM AAC4319.PR_HVAC_FLYER_LOGONS_FALL --MAYBE MOVE TO GENERIC TABLE NAME?
                            WHERE WHSE IS NULL) LOGONS
                             ON NVL (CUST.ACTIVE_ACCOUNT_NAME,
                                     CUST.ACCOUNT_NAME) = LOGONS.ACCT_NAME
                    WHERE CUST.DELETE_DATE IS NULL --AND CUSTOMER_GK = ACTIVE_CUSTOMER_GK
                                                  ) NEW_CUST
           GROUP BY NEW_CUST.ACCOUNT_NAME,
                    NEW_CUST.ALIAS_NAME,
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
                    NEW_CUST.MAIN_WHSE,
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
                    NEW_CUST.SEC_SLSM,
                    NEW_CUST.PROMO_NAME,
                    NEW_CUST.SIGNUP_DATE,
                    NEW_CUST.FLYER_REGION,
                    NEW_CUST.CUSTOMER_GK)
					;