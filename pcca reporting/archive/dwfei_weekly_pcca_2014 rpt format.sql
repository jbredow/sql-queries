--CREATE TABLE AAD9606.CTYPE_REVIEW_2013

--AS

SELECT DISTINCT *
  FROM (SELECT NEW_CUST.CUSTOMER_GK CUST_GK,
               NEW_CUST.BRANCH_KOB,
               NEW_CUST.KOB_ALIGNED KOB_ALIGN,
               --NEW_CUST.ACCT_NK,
               NEW_CUST.ACCOUNT_NAME,
               NEW_CUST.HOUSE_ACCT HOUSE,
               NEW_CUST.MAIN_CUSTOMER_NK MAIN_CUST_NK,
               NEW_CUST.CUSTOMER_NK CUST_NK,
               NEW_CUST.CUSTOMER_NAME,
               NEW_CUST.JOB_YN JOB,
               NEW_CUST.MAIN_CUST_SLS_12M SALES_12M,
               NEW_CUST.LAST_SALE,
               NEW_CUST.COLUMN_ALIGNED PC_ALIGN,
               NEW_CUST.PRICE_COLUMN PC,
               NULL AS NEW_PC,
               NULL AS PC_APPRV,
               NEW_CUST.COLUMN_DEFINITION PC_NAME,
               NEW_CUST.COLUMN_CATEGORY PC_CATEGORY,
               NEW_CUST.COLUMN_SUBCATEGORY PC_SUB_CAT,
               NEW_CUST.CUSTOMER_TYPE CTYPE,
               NULL AS NEW_CTYPE,
               NULL AS CTYPE_APPRV,
               NULL AS RSN_CODE,
               NEW_CUST.CTYPE_CATEGORY,
               NEW_CUST.CTYPE_SUBCATEGORY CTYPE_SUB_CAT,
               --NEW_CUST.PC_NUM,
               NEW_CUST.PC_TRIM,
               NULL AS MIN_PC,
               NULL AS MAX_PC,
               NEW_CUST.BUSINESS_GROUP SIC_CATEGORY,
               NEW_CUST.CUSTOMER_SEGMENT SIC_SUB_CAT,
               NEW_CUST.GSA_LINK,
               NEW_CUST.REVIEW_GSA,
               NEW_CUST.WHSE,
               --NEW_CUST.ADDRESS1,
               --NEW_CUST.ADDRESS2,
               --NEW_CUST.MSTR_CTYPE_ALIGNED MSTR_ALIGN,
               NEW_CUST.MSTR_TYPE,
               NEW_CUST.MSTR_CUSTNO,
               NEW_CUST.MSTR_CUST_NAME,
               NEW_CUST.CUSTOMER_ALPHA,
               NEW_CUST.CUSTOMER_STATUS CUST_STATUS,
               NEW_CUST.CREDIT_CODE,
               --NEW_CUST.CREDIT_LIMIT,
               -- NEW_CUST.AR_GL_NUMBER AR_GL,
               NEW_CUST.CROSS_ACCT,
               NEW_CUST.CROSS_CUSTOMER_NK CROSS_CUST,
               NEW_CUST.SETUP_DATE,
               NEW_CUST.DW_INSERT_TIMESTAMP,
               --NEW_CUST.DW_UPDATE_TIMESTAMP,
               NEW_CUST.SALESMAN_CODE SLSM_CODE,
               NEW_CUST.SALESREP_NAME SLSM_NAME,
               NEW_CUST.SEC_SLSM,
               --NEW_CUST.TAX_JURISDICTION TAX_JUR,
               NEW_CUST.RPC,
               NEW_CUST.RPC_MGR,
               NEW_CUST.RPC_MGR_EMAIL,
               NEW_CUST.DISTRICT_OPS_MGR DISTR_OPS_MGR,
               NEW_CUST.DISTR_OPS_MGR_EMAIL
          FROM (SELECT                                              --DISTINCT
                      NVL (PS_HIERARCHY.KIND_OF_BUSINESS, N'OTHER')
                          BRANCH_KOB,
                       CUST.ACCOUNT_NUMBER_NK ACCT_NK,
                       CUST.ACCOUNT_NAME,
                       CUST.SALESMAN_CODE,
                       REP.SALESREP_NAME,
                       CUST.SEC_SLSM,
                       CUST.CUSTOMER_GK,
                       CUST.MAIN_CUSTOMER_NK,
                       CUST.CUSTOMER_NK,
                       CUST.CUSTOMER_NAME,
                       CUST.CUSTOMER_ALPHA,
                       CUST.CUSTOMER_TYPE,
                       CUST.ADDRESS1,
                       CUST.ADDRESS2,
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
                       CUST.GSA_LINK,
                       --Check Customer type for GSA_LINK='N' customers, if GOVT_FEDERAL, then REVIEW_GSA='Y'
                       CASE
                          WHEN NVL (CUST.GSA_LINK, 'N') = 'N'
                          THEN
                             CASE
                                WHEN CUST.CUSTOMER_TYPE = 'GOVT_FEDERAL'
                                THEN
                                   'Y'
                                WHEN CUST.PRICE_COLUMN IN ('204', '205')
                                THEN
                                   'Y'
                                ELSE
                                   'N'
                             END
                          ELSE
                             'N'
                       END
                          AS REVIEW_GSA,
                       CASE
                          WHEN CUST.MSTR_TYPE IS NOT NULL
                          THEN
                             CASE
                                WHEN CUST.CUSTOMER_TYPE = CUST.MSTR_TYPE
                                THEN
                                   'Y'
                                ELSE
                                   'N'
                             END
                          ELSE
                             'N/A'
                       END
                          AS MSTR_CTYPE_ALIGNED,
                       CASE
                          WHEN CUST.PRICE_COLUMN IN 'C' THEN 'N'
                          WHEN PC_CT_XREF.CUSTOMER_TYPE IS NOT NULL THEN 'Y'
                          ELSE 'N'
                       END
                          AS COLUMN_ALIGNED,
                       CASE
                          WHEN PS_HIERARCHY.PBU IN '04_FF'
                          THEN
                             CASE
                                WHEN PC_CT_XREF.SUB_CATEGORY IN
                                        'FIRE_PROTECTION'
                                THEN
                                   'Y'
                                ELSE
                                   'N'
                             END
                          ELSE
                             CASE
                                WHEN PS_HIERARCHY.PBU IN
                                        ('06_WW', '05_HV', '07_PV')
                                THEN
                                   CASE
                                      WHEN DECODE (PS_HIERARCHY.PBU,
                                                   '06_WW', 'WW',
                                                   '05_HV', 'HVAC',
                                                   '07_PV', N'CIGB') =
                                              PC_CT_XREF.CATEGORY
                                      THEN
                                         'Y'
                                      ELSE
                                         'N'
                                   END
                                ELSE
                                   'N/A'
                             END
                       END
                          KOB_ALIGNED,
                       NVL (PC_DEF.COLUMN_NAME, 'INVALID') COLUMN_DEFINITION,
                       NVL (PC_DEF.CATEGORY, 'INVALID') COLUMN_CATEGORY,
                       NVL (PC_DEF.SUB_CATEGORY, 'INVALID')
                          COLUMN_SUBCATEGORY,
                       CTYPE1.CATEGORY CTYPE_CATEGORY,
                       CTYPE1.SUB_CATEGORY CTYPE_SUBCATEGORY,
                       --TO_NUMBER (LTRIM (CUST.PRICE_COLUMN, '0')) PC_NUM,
                       TO_CHAR (LTRIM (CUST.PRICE_COLUMN, '0')) PC_TRIM,
                       --PC_CT_XREF.MIN_COLUMN,
                       --PC_CT_XREF.MAX_COLUMN,


                       --PC_CT_XREF.ALTERNATE,
                       CUST.AR_GL_NUMBER,
                       CUST.CUSTOMER_STATUS,
                       CUST.LAST_SALE,
                       CUST.CREDIT_CODE,
                       CUST.CREDIT_LIMIT,
                       CUST.TAX_JURISDICTION,
                       BG_CUBE.BUSINESS_GROUP,
                       BG_CUBE.CUSTOMER_SEGMENT,
                       BG_CUBE.ROLL_12M_SLS MAIN_CUST_SLS_12M,
                       CUST.BRANCH_WAREHOUSE_NUMBER WHSE,
                       CUST.CROSS_ACCT,
                       CUST.CROSS_CUSTOMER_NK,
                       TO_CHAR (TRUNC (CUST.ACCOUNT_SETUP_DATE),
                                'MM/DD/YYYY')
                          SETUP_DATE,
                       TO_CHAR (TRUNC (CUST.UPDATE_TIMESTAMP), 'MM/DD/YYYY')
                          DW_UPDATE_TIMESTAMP,
                       TO_CHAR (TRUNC (CUST.INSERT_TIMESTAMP), 'MM/DD/YYYY')
                          DW_INSERT_TIMESTAMP,
                       REP.RPC,
                       REP.RPC_MGR,
                       INITCAP (
                          SUBSTR (REP.RPC_MGR,
                                  1,
                                  (INSTR (REP.RPC_MGR, ' ', 1) - 1)))
                       || '.'
                       || INITCAP (
                             SUBSTR (REP.RPC_MGR,
                                     (INSTR (REP.RPC_MGR, ' ', 1)) + 1))
                       || '@ferguson.com'
                          RPC_MGR_EMAIL,
                       REP.DISTRICT_OPS_MGR,
                       INITCAP (
                          SUBSTR (REP.DISTRICT_OPS_MGR,
                                  1,
                                  (INSTR (REP.DISTRICT_OPS_MGR, ' ', 1) - 1)))
                       || '.'
                       || INITCAP (
                             SUBSTR (
                                REP.DISTRICT_OPS_MGR,
                                (INSTR (REP.DISTRICT_OPS_MGR, ' ', 1)) + 1))
                       || '@ferguson.com'
                          DISTR_OPS_MGR_EMAIL
                  FROM DW_FEI.CUSTOMER_DIMENSION CUST
                       LEFT OUTER JOIN SCORECARD1.PS_HIERARCHY PS_HIERARCHY
                          ON TO_CHAR (CUST.BRANCH_WAREHOUSE_NUMBER) =
                                TO_CHAR (
                                   LTRIM (PS_HIERARCHY.WAREHOUSE_NUMBER_NK,
                                          '0'))
                       LEFT OUTER JOIN (SELECT REPS.ACCOUNT_NUMBER_NK ACCT,
                                               REPS.ACCOUNT_NAME,
                                               REPS.SALESREP_NK,
                                               MAX (REPS.SALESREP_NAME)
                                                  SALESREP_NAME,
                                               REPS.HOUSE_ACCT_FLAG,
                                               CONT.RPC,
                                               CONT.RPC_MGR,
                                               CONT.DISTRICT_OPS_MGR
                                          FROM DW_FEI.SALESREP_DIMENSION REPS,
                                               AAD9606.BRANCH_CONTACTS_FULL CONT
                                         WHERE REPS.ACCOUNT_NUMBER_NK =
                                                  CONT.ACCOUNT_NK(+)
                                        GROUP BY REPS.ACCOUNT_NAME,
                                                 REPS.ACCOUNT_NUMBER_NK,
                                                 REPS.SALESREP_NK,
                                                 REPS.HOUSE_ACCT_FLAG,
                                                 CONT.RPC,
                                                 CONT.RPC_MGR,
                                                 CONT.DISTRICT_OPS_MGR) REP
                          ON (CUST.SALESMAN_CODE = REP.SALESREP_NK)
                             AND (CUST.ACCOUNT_NUMBER_NK = REP.ACCT)
                       LEFT OUTER JOIN AAD9606.PR_COLUMN_TYPE_XREF_2014 PC_CT_XREF
                          ON ( (CUST.CUSTOMER_TYPE = PC_CT_XREF.CUSTOMER_TYPE)
                              AND TO_CHAR (LTRIM (CUST.PRICE_COLUMN, '0')) =
                                     TO_CHAR (
                                        LTRIM (PC_CT_XREF.PRICE_COLUMN, '0')))
                       LEFT OUTER JOIN (SELECT DISTINCT PRICE_COLUMN,
                                                        COLUMN_NAME,
                                                        CATEGORY,
                                                        SUB_CATEGORY
                                          FROM AAD9606.
                                               PR_COLUMN_TYPE_XREF_2014) PC_DEF
                          ON (TO_CHAR (LTRIM (CUST.PRICE_COLUMN, '0')) =
                                 TO_CHAR (LTRIM (PC_DEF.PRICE_COLUMN, '0')))
                       LEFT OUTER JOIN (SELECT DISTINCT CATEGORY,
                                                        SUB_CATEGORY,
                                                        CUSTOMER_TYPE,
                                                        CTYPE_DEFINITION
                                          FROM AAD9606.
                                               PR_CTYPE_STRATEGY_NEW WHERE "EXCEPTION" IS NULL) CTYPE1
                          ON (CUST.CUSTOMER_TYPE = CTYPE1.CUSTOMER_TYPE)
                       LEFT OUTER JOIN SALES_MART.BG_CUBE_CUST_DATA BG_CUBE
                          ON CUST.CUSTOMER_GK = BG_CUBE.CUSTOMER_GK
                 WHERE (CUST.DELETE_DATE IS NULL)
                       AND CUST.CUSTOMER_TYPE NOT IN
                              ('O_INTRBRNCH', 'O_BRCHACCT', 'O_CASH')
                       AND CUST.PRICE_COLUMN NOT IN 'C'       
                       --AND CUST.PRICE_COLUMN NOT IN 'C'
                       --AND NVL (CUST.LAST_SALE, CUST.ACCOUNT_SETUP_DATE) >
                       --       TRUNC (SYSDATE - 183)
                       AND TRUNC (
                              NVL (CUST.ACCOUNT_SETUP_DATE, CUST.INSERT_TIMESTAMP)) BETWEEN
                              TRUNC (SYSDATE - 7) AND  TRUNC (SYSDATE)
                       AND CUST.ACCOUNT_NAME NOT IN 'DIST'
                       AND CUST.ACCOUNT_NAME NOT LIKE 'INT%'
                       AND REP.RPC IS NOT NULL /*AND (TRUNC (CUST.ACCOUNT_SETUP_DATE) BETWEEN TRUNC (
                                                                                                                                                    SYSDATE - 8)
                                                                                                                                             AND TRUNC (
                                                                                                                                                    SYSDATE - 1))*/
                GROUP BY NVL (PS_HIERARCHY.KIND_OF_BUSINESS, N'OTHER'),
                         CUST.ACCOUNT_NUMBER_NK,
                         CUST.ACCOUNT_NAME,
                         CUST.SALESMAN_CODE,
                         REP.SALESREP_NAME,
                         CUST.SEC_SLSM,
                         CUST.CUSTOMER_GK,
                         CUST.MAIN_CUSTOMER_NK,
                         CUST.CUSTOMER_NK,
                         CUST.CUSTOMER_NAME,
                         CUST.CUSTOMER_ALPHA,
                         CUST.CUSTOMER_TYPE,
                         CUST.ADDRESS1,
                         CUST.ADDRESS2,
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
                         END,
                         CUST.GSA_LINK,
                         --Check Customer type for GSA_LINK='N' customers, if GOVT_FEDERAL, then REVIEW_GSA='Y'
                         CASE
                            WHEN NVL (CUST.GSA_LINK, 'N') = 'N'
                            THEN
                               CASE
                                  WHEN CUST.CUSTOMER_TYPE = 'GOVT_FEDERAL'
                                  THEN
                                     'Y'
                                  WHEN CUST.PRICE_COLUMN IN ('204', '205')
                                  THEN
                                     'Y'
                                  ELSE
                                     'N'
                               END
                            ELSE
                               'N'
                         END,
                         CASE
                            WHEN CUST.MSTR_TYPE IS NOT NULL
                            THEN
                               CASE
                                  WHEN CUST.CUSTOMER_TYPE = CUST.MSTR_TYPE
                                  THEN
                                     'Y'
                                  ELSE
                                     'N'
                               END
                            ELSE
                               'N/A'
                         END,
                         CASE
                            WHEN CUST.PRICE_COLUMN IN 'C'
                            THEN
                               'N'
                            WHEN PC_CT_XREF.CUSTOMER_TYPE IS NOT NULL
                            THEN
                               'Y'
                            ELSE
                               'N'
                         END,
                         CASE
                            WHEN PS_HIERARCHY.PBU IN '04_FF'
                            THEN
                               CASE
                                  WHEN PC_CT_XREF.SUB_CATEGORY IN
                                          'FIRE_PROTECTION'
                                  THEN
                                     'Y'
                                  ELSE
                                     'N'
                               END
                            ELSE
                               CASE
                                  WHEN PS_HIERARCHY.PBU IN
                                          ('06_WW', '05_HV', '07_PV')
                                  THEN
                                     CASE
                                        WHEN DECODE (PS_HIERARCHY.PBU,
                                                     '06_WW', 'WW',
                                                     '05_HV', 'HVAC',
                                                     '07_PV', N'CIGB') =
                                                PC_CT_XREF.CATEGORY
                                        THEN
                                           'Y'
                                        ELSE
                                           'N'
                                     END
                                  ELSE
                                     'N/A'
                               END
                         END,
                         PC_DEF.COLUMN_NAME,
                         PC_DEF.CATEGORY,
                         PC_DEF.SUB_CATEGORY,
                         CTYPE1.CATEGORY,
                         CTYPE1.SUB_CATEGORY,
                         TO_CHAR (LTRIM (CUST.PRICE_COLUMN, '0')),
                         PC_CT_XREF.CTYPE_DEFINITION,
                         CUST.AR_GL_NUMBER,
                         CUST.CUSTOMER_STATUS,
                         CUST.LAST_SALE,
                         CUST.CREDIT_CODE,
                         CUST.CREDIT_LIMIT,
                         CUST.TAX_JURISDICTION,
                         BG_CUBE.BUSINESS_GROUP,
                         BG_CUBE.CUSTOMER_SEGMENT,
                         BG_CUBE.ROLL_12M_SLS,
                         CUST.BRANCH_WAREHOUSE_NUMBER,
                         CUST.CROSS_ACCT,
                         CUST.CROSS_CUSTOMER_NK,
                         TO_CHAR (TRUNC (CUST.ACCOUNT_SETUP_DATE),
                                  'MM/DD/YYYY'),
                         TO_CHAR (TRUNC (CUST.UPDATE_TIMESTAMP),
                                  'MM/DD/YYYY'),
                         TO_CHAR (TRUNC (CUST.INSERT_TIMESTAMP),
                                  'MM/DD/YYYY'),
                         REP.RPC,
                         REP.RPC_MGR,
                         INITCAP (
                            SUBSTR (REP.RPC_MGR,
                                    1,
                                    (INSTR (REP.RPC_MGR, ' ', 1) - 1)))
                         || '.'
                         || INITCAP (
                               SUBSTR (REP.RPC_MGR,
                                       (INSTR (REP.RPC_MGR, ' ', 1)) + 1))
                         || '@ferguson.com',
                         REP.DISTRICT_OPS_MGR,
                         INITCAP (
                            SUBSTR (
                               REP.DISTRICT_OPS_MGR,
                               1,
                               (INSTR (REP.DISTRICT_OPS_MGR, ' ', 1) - 1)))
                         || '.'
                         || INITCAP (
                               SUBSTR (
                                  REP.DISTRICT_OPS_MGR,
                                  (INSTR (REP.DISTRICT_OPS_MGR, ' ', 1)) + 1))
                         || '@ferguson.com') NEW_CUST
        --WHERE --NEW_CUST.HOUSE_ACCT = 'N' --                   AND NEW_CUST.JOB_YN = 'N'
        /*AND (   NEW_CUST.COLUMN_ALIGNED = 'N'
             OR NEW_CUST.CTYPE_CATEGORY IS NULL
             OR NEW_CUST.REVIEW_GSA = 'Y'
             OR NEW_CUST.KOB_ALIGNED = 'N')*/
        GROUP BY NEW_CUST.ACCOUNT_NAME,
                 --NEW_CUST.ACCT_NK,
                 --NEW_CUST.AR_GL_NUMBER,
                 NEW_CUST.BRANCH_KOB,
                 NEW_CUST.BUSINESS_GROUP,
                 NEW_CUST.COLUMN_ALIGNED,
                 NEW_CUST.COLUMN_CATEGORY,
                 NEW_CUST.COLUMN_DEFINITION,
                 NEW_CUST.COLUMN_SUBCATEGORY,
                 NEW_CUST.CREDIT_CODE,
                 --NEW_CUST.CREDIT_LIMIT,
                 NEW_CUST.CROSS_ACCT,
                 NEW_CUST.CROSS_CUSTOMER_NK,
                 NEW_CUST.CTYPE_CATEGORY,
                 NEW_CUST.CTYPE_SUBCATEGORY,
                 NEW_CUST.CUSTOMER_ALPHA,
                 NEW_CUST.CUSTOMER_GK,
                 NEW_CUST.CUSTOMER_NAME,
                 NEW_CUST.CUSTOMER_NK,
                 NEW_CUST.CUSTOMER_SEGMENT,
                 NEW_CUST.CUSTOMER_STATUS,
                 NEW_CUST.CUSTOMER_TYPE,
                 NEW_CUST.DISTR_OPS_MGR_EMAIL,
                 NEW_CUST.DISTRICT_OPS_MGR,
                 NEW_CUST.DW_INSERT_TIMESTAMP,
                 --NEW_CUST.DW_UPDATE_TIMESTAMP,
                 NEW_CUST.GSA_LINK,
                 NEW_CUST.HOUSE_ACCT,
                 NEW_CUST.JOB_YN,
                 NEW_CUST.KOB_ALIGNED,
                 NEW_CUST.LAST_SALE,
                 NEW_CUST.MAIN_CUST_SLS_12M,
                 NEW_CUST.MAIN_CUSTOMER_NK,
                 --NEW_CUST.MAX_COLUMN,
                 --NEW_CUST.MIN_COLUMN,
                 --NEW_CUST.MSTR_CTYPE_ALIGNED,
                 NEW_CUST.MSTR_CUST_NAME,
                 NEW_CUST.MSTR_CUSTNO,
                 NEW_CUST.MSTR_TYPE,
                 NEW_CUST.PRICE_COLUMN,
                 NEW_CUST.REVIEW_GSA,
                 --NEW_CUST.ADDRESS1,
                 --NEW_CUST.ADDRESS2,
                 NEW_CUST.RPC,
                 NEW_CUST.RPC_MGR,
                 NEW_CUST.RPC_MGR_EMAIL,
                 NEW_CUST.SALESMAN_CODE,
                 NEW_CUST.SALESREP_NAME,
                 --NEW_CUST.TAX_JURISDICTION,
                 NEW_CUST.SEC_SLSM,
                 NEW_CUST.SETUP_DATE,
                 --NEW_CUST.PC_NUM,
                 NEW_CUST.PC_TRIM,
                 NEW_CUST.WHSE
        ORDER BY NEW_CUST.BRANCH_KOB ASC,
                 NEW_CUST.ACCOUNT_NAME ASC,
                 NEW_CUST.PRICE_COLUMN ASC,
                 NEW_CUST.CTYPE_CATEGORY ASC,
                 NEW_CUST.CTYPE_SUBCATEGORY ASC,
                 NEW_CUST.CUSTOMER_NAME ASC)
 --WHERE PC_ALIGN = 'N' OR KOB_ALIGN = 'N'
ORDER BY RPC, ACCOUNT_NAME, PC
;
--GRANT SELECT ON AAD9606.CTYPE_REVIEW_2013 TO PUBLIC;