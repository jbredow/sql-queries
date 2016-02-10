SELECT *
  FROM (SELECT DISTINCT
               CUST.ACCOUNT_NAME,
               CUST.SALESMAN_CODE,
               REP.SALESREP_NAME,
               CUST.MAIN_CUSTOMER_NK,
               CUST.CUSTOMER_NK,
               CUST.CUSTOMER_NAME,
               CUST.CUSTOMER_ALPHA,
               CUST.CUSTOMER_TYPE,
               CUST.PRICE_COLUMN,
               CUST.MSTR_CUSTNO,
               CUST.MSTR_CUST_NAME,
               CUST.MSTR_TYPE,
               CUST.GSA_LINK,
               --Check Customer type for GSA_LINK='N' customers, if GOVT_FEDERAL, then REVIEW_GSA='Y'
               CASE
                  WHEN NVL (CUST.GSA_LINK, 'N') = 'N'
                  THEN
                     CASE
                        WHEN CUST.CUSTOMER_TYPE = 'GOVT_FEDERAL' THEN 'Y'
                        ELSE 'N'
                     END
                  ELSE
                     'N'
               END
                  AS REVIEW_GSA,
               CUST.JOB_YN,
               CASE
                  WHEN CUST.MSTR_TYPE IS NOT NULL
                  THEN
                     CASE
                        WHEN CUST.CUSTOMER_TYPE = CUST.MSTR_TYPE THEN 'Y'
                        ELSE 'N'
                     END
                  ELSE
                     'N/A'
               END
                  AS MSTR_CTYPE_ALIGNED,
               CASE
                  WHEN TO_CHAR (LTRIM (CUST.PRICE_COLUMN, '0')) BETWEEN TO_CHAR (
                                                                           PC_CT_XREF.MIN_COLUMN)
                                                                    AND TO_CHAR (
                                                                           PC_CT_XREF.MAX_COLUMN)
                  THEN
                     'Y'
                  ELSE
                     'N'
               END
                  AS COLUMN_ALIGNED,
               CUST_TO_BG.BUSGRP SIC_BUSGRP,
               CUST_TO_BG.NEW_BUSGRP SIC_NEW_BUSGRP,
               PC_CT_XREF.CATEGORY CTYPE_CATEGORY,
               PC_CT_XREF.SUB_CATEGORY CTYPE_SUBCATEGORY,
               PC_CT_XREF.MIN_COLUMN,
               PC_CT_XREF.MAX_COLUMN,
               CUST.AR_GL_NUMBER,
               CUST.CUSTOMER_STATUS,
               CUST.LAST_SALE,
               CUST.CREDIT_CODE,
               CUST.CREDIT_LIMIT,
               CUST.TERMS,
               CUST.BRANCH_WAREHOUSE_NUMBER WHSE,
               CUST.RATING,
               CUST.GROSS_SALES,
               CUST.NET_WORTH,
               TO_CHAR (TRUNC (CUST.ACCOUNT_SETUP_DATE), 'MM/DD/YYYY')
                  SETUP_DATE,
               TO_CHAR (TRUNC (CUST.UPDATE_TIMESTAMP), 'MM/DD/YYYY')
                  DW_UPDATE_TIMESTAMP,
               TO_CHAR (TRUNC (CUST.INSERT_TIMESTAMP), 'MM/DD/YYYY')
                  DW_INSERT_TIMESTAMP
          FROM    (   (   DW_FEI.CUSTOMER_DIMENSION CUST
                       INNER JOIN
                          USER_SHARED.CUSTOMER_TO_BUSGRP CUST_TO_BG
                       ON (CUST.CUSTOMER_GK = CUST_TO_BG.CUSTOMER_GK))
                   LEFT OUTER JOIN
                      (SELECT REPS.ACCOUNT_NAME,
                              REPS.SALESREP_NK,
                              MAX (REPS.SALESREP_NAME) SALESREP_NAME
                         FROM DW_FEI.SALESREP_DIMENSION REPS
                       GROUP BY REPS.ACCOUNT_NAME, REPS.SALESREP_NK) REP
                   ON (CUST.SALESMAN_CODE = REP.SALESREP_NK)
                      AND (CUST.ACCOUNT_NAME = REP.ACCOUNT_NAME))
               LEFT OUTER JOIN
                  (SELECT DISTINCT
                          PR_COLUMN_STRATEGY.CATEGORY,
                          PR_COLUMN_STRATEGY.SUB_CATEGORY,
                          PR_COLUMN_STRATEGY."COLUMN",
                          PR_COLUMN_STRATEGY.COLUMN_NAME,
                          PR_CTYPE_STRATEGY.CUSTOMER_TYPE,
                          PR_CTYPE_STRATEGY.CTYPE_DEFINITION,
                          PR_COLUMN_STRATEGY."CUSTOMER PROFILE DEFINITION",
                          MIN (
                             PR_COLUMN_STRATEGY."COLUMN")
                          OVER (
                             PARTITION BY PR_COLUMN_STRATEGY.CATEGORY,
                                          PR_CTYPE_STRATEGY.CUSTOMER_TYPE)
                             MIN_COLUMN,
                          MAX (
                             PR_COLUMN_STRATEGY."COLUMN")
                          OVER (
                             PARTITION BY PR_COLUMN_STRATEGY.CATEGORY,
                                          PR_CTYPE_STRATEGY.CUSTOMER_TYPE)
                             MAX_COLUMN
                     FROM    AAD9606.PR_COLUMN_STRATEGY PR_COLUMN_STRATEGY
                          INNER JOIN
                             AAD9606.PR_CTYPE_STRATEGY PR_CTYPE_STRATEGY
                          ON (PR_COLUMN_STRATEGY.CATEGORY =
                                 PR_CTYPE_STRATEGY.CATEGORY)
                             AND (PR_COLUMN_STRATEGY.SUB_CATEGORY =
                                     PR_CTYPE_STRATEGY.SUB_CATEGORY)) PC_CT_XREF
               ON (CUST.CUSTOMER_TYPE = PC_CT_XREF.CUSTOMER_TYPE)
         WHERE (CUST.DELETE_DATE IS NULL)
               AND (TRUNC (CUST.ACCOUNT_SETUP_DATE) BETWEEN TRUNC (
                                                               SYSDATE - 8)
                                                        AND TRUNC (
                                                               SYSDATE - 1))) NEW_CUST
 WHERE    NEW_CUST.COLUMN_ALIGNED = 'N'
       OR NEW_CUST.CTYPE_CATEGORY IS NULL
       OR NEW_CUST.MSTR_CTYPE_ALIGNED = 'N'
       OR NEW_CUST.REVIEW_GSA = 'Y'