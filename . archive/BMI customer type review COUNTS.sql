SELECT REGION,
       DISTRICT,
       ACCOUNT_NAME,
       CASE
          WHEN JOB_STATUS = 'CLOSED' THEN 'CLOSED_JOB'
          WHEN REVIEW_CATEGORY IS NULL THEN 'NO_ACTION'
          ELSE REVIEW_CATEGORY
       END
          AS REVIEW_TAB,
       COUNT (*) CUSTOMERS,
       SUM (R12M_NET_BILLINGS) R12M_BILLINGS
  FROM (SELECT CASE
                  WHEN     CUSTOMER_TYPE <> BMI_REPORT_CUST_TYPE
                       AND BUSGRP <> BMI_BUSGRP
                  THEN
                     'BMI_BUS_GRP_CONFLICT'
                  WHEN CUSTOMER_TYPE <> BMI_REPORT_CUST_TYPE
                  THEN
                     'BMI_CTYPE_CONFLICT'
                  WHEN     CUSTOMER_TYPE <> MAIN_CUST_TYPE
                       AND BUSGRP <> MAIN_BUSGRP
                  THEN
                     'MAIN_BUS_GRP_CONFLICT'
                  WHEN NVL (BMI_REPORT_CUST_TYPE, CUSTOMER_TYPE) <>
                          NVL (MAIN_BMI_REPORT_CUST_TYPE, MAIN_CUST_TYPE)
                  THEN
                     'MAIN_JOB_TYPE_CONFLICT'
                  WHEN (    JOB_YN = 'Y'
                        AND NVL (BMI_REPORT_CUST_TYPE, CUSTOMER_TYPE) =
                               NVL (MAIN_BMI_REPORT_CUST_TYPE,
                                    MAIN_CUST_TYPE))
                  THEN
                     'MAIN_JOB_TYPE_CONSISTENT'
                  ELSE
                     NULL
               END
                  AS REVIEW_CATEGORY,
               /* CASE
                   WHEN CUST.CUSTOMER_TYPE NOT IN ('E_EMPLOY',
                                                   'O_BRCHACCT',
                                                   'O_INTRBRNCH')
                   THEN
                      'NOT INTERNAL'
                   WHEN CUST.CUSTOMER_TYPE = 'E_EMPLOY' AND CREDIT_LIMIT > 0
                   THEN
                      'EMPL_HAS_CREDIT'
                   ELSE
                      NULL
                END
                   AS PC_C_ISSUES,*/
               /*CASE
                  WHEN CUST.CUSTOMER_TYPE NOT = 'E_EMPLOY' AND

                  THEN
                     'NOT INTERNAL'
                  WHEN CUST.CUSTOMER_TYPE = 'E_EMPLOY' AND CREDIT_LIMIT > 0
                  THEN
                     'EMPL_HAS_CREDIT'
                  ELSE
                     NULL
               END
                  AS EMPLOY_ISSUES,*/
               CUST.*
          FROM (SELECT DISTINCT
                       j.DIVISION_NAME REGION,
                       j.REGION_NAME DISTRICT,
                       A.ACCOUNT_NAME,
                       A.ACCOUNT_NUMBER_NK ACCT_NK,
                       G.SALESREP_NAME,
                       k.TITLE_DESC,
                       A.CUSTOMER_NK,
                       A.CUSTOMER_NAME,
                       A.CUSTOMER_TYPE,
                       A.BMI_REPORT_CUST_TYPE,
                       A.PRICE_COLUMN PC,
                       A.LAST_SALE,
                       A.ACCOUNT_SETUP_DATE ACCT_SETUP_DT,
                       CASE
                          WHEN g.EMPLOYEE_NUMBER_NK IS NULL
                          THEN
                             'H/U'
                          WHEN (   k.TITLE_DESC LIKE '%O/S%'
                                OR k.TITLE_DESC LIKE 'Out Sales%'
                                OR k.TITLE_DESC LIKE 'Sales Rep%')
                          THEN
                             'O/S'
                          ELSE
                             'H/A'
                       END
                          AS HOUSE_FLAG,
                       A.JOB_YN,
                       CASE
                          WHEN COUNT (
                                  a.CUSTOMER_NK)
                               OVER (
                                  PARTITION BY a.ACCOUNT_NAME, a.MAIN_CUSTOMER_NK) =
                                  1
                          THEN
                             'N'
                          ELSE
                             'Y'
                       END
                          AS HAS_JOBS,
                       CASE WHEN a.JOB_YN = 'Y' THEN A.ADDRESS1 ELSE NULL END
                          AS JOB_NAME,
                       A.CUSTOMER_ALPHA CUST_ALPHA,
                       CASE
                          WHEN a.JOB_YN = 'Y' AND A.CUSTOMER_ALPHA LIKE '*%'
                          THEN
                             'CLOSED'
                          WHEN     a.JOB_YN = 'Y'
                               AND A.CUSTOMER_ALPHA NOT LIKE '*%'
                          THEN
                             'OPEN'
                          ELSE
                             NULL
                       END
                          AS JOB_STATUS,
                       DECODE (C.BUSINESS_GROUP,
                               'Commercial', 'COMM',
                               'Commercial MRO', 'CMRO',
                               'HVAC', 'HVAC',
                               'Industrial', 'IND',
                               'Residential - Build/Rem/Consumer', 'RESBRC',
                               'Residential - Trade', 'RESTRD',
                               'Waterworks', 'WW',
                               'OTH')
                          AS BUSGRP,
                       DECODE (NVL (D.BUSINESS_GROUP, c.BUSINESS_GROUP),
                               'Commercial', 'COMM',
                               'Commercial MRO', 'CMRO',
                               'HVAC', 'HVAC',
                               'Industrial', 'IND',
                               'Residential - Build/Rem/Consumer', 'RESBRC',
                               'Residential - Trade', 'RESTRD',
                               'Waterworks', 'WW',
                               'OTH')
                          AS BMI_BUSGRP,
                       B.MAIN_CUSTOMER_NK,
                       b.customer_Name AS MAIN_CUSTOMER_NAME,
                       b.customer_type AS MAIN_CUST_TYPE,
                       B.BMI_REPORT_CUST_TYPE MAIN_BMI_REPORT_CUST_TYPE,
                       b.PRICE_COLUMN MAIN_PC,
                       DECODE (e.business_group,
                               'Commercial', 'COMM',
                               'Commercial MRO', 'CMRO',
                               'HVAC', 'HVAC',
                               'Industrial', 'IND',
                               'Residential - Build/Rem/Consumer', 'RESBRC',
                               'Residential - Trade', 'RESTRD',
                               'Waterworks', 'WW',
                               'OTH')
                          AS MAIN_BUSGRP,
                       DECODE (NVL (f.business_Group, e.business_group),
                               'Commercial', 'COMM',
                               'Commercial MRO', 'CMRO',
                               'HVAC', 'HVAC',
                               'Industrial', 'IND',
                               'Residential - Build/Rem/Consumer', 'RESBRC',
                               'Residential - Trade', 'RESTRD',
                               'Waterworks', 'WW',
                               'OTH')
                          AS BMI_MAIN_BUSGRP,
                       H.R12M_NET_BILLINGS_AMT R12M_NET_BILLINGS,
                       i.ROLL_12M_SLS MAIN_12M_SLS_TOTAL,
                       a.CUSTOMER_STATUS,
                       a.CREDIT_CODE,
                       a.CREDIT_LIMIT
                  FROM dw_Fei.active_customer_mvw a,
                       dw_fei.customer_dimension b,
                       USER_SHARED.BG_CUSTTYPE_XREF c,
                       USER_SHARED.BG_CUSTTYPE_XREF d,
                       USER_SHARED.BG_CUSTTYPE_XREF e,
                       USER_SHARED.BG_CUSTTYPE_XREF f,
                       dw_Fei.salesrep_dimension g,
                       PROF_MART.CTS_CUST_SUMMARY h,
                       SALES_MART.BG_CUBE_CUST_DATA i,
                       EBUSINESS.SALES_DIVISIONS j,
                       DW_FEI.EMPLOYEE_DIMENSION k
                 WHERE     A.MAIN_CUSTOMER_NK = b.customer_nk
                       AND A.ACCOUNT_NUMBER_NK = B.ACCOUNT_NUMBER_NK
                       AND a.customer_type = C.CUSTOMER_TYPE
                       AND A.BMI_REPORT_CUST_TYPE = d.customer_Type(+)
                       AND b.customer_type = e.customer_type
                       AND B.BMI_REPORT_CUST_TYPE = f.customer_type(+)
                       AND A.ACCOUNT_NUMBER_NK = g.account_number_nk
                       AND A.SALESMAN_CODE = G.SALESREP_NK
                       AND A.CUSTOMER_GK = H.CUSTOMER_GK(+)
                       AND A.CUSTOMER_GK = i.CUSTOMER_GK(+)
                       AND a.ACCOUNT_NAME = j.ACCOUNT_NAME
                       AND g.EMPLOYEE_NUMBER_NK = k.EMPLOYEE_TRILOGIE_NK(+)
                       --AND A.PRICE_COLUMN = 'C'
                       --AND a.ACCOUNT_NAME = 'SEATTLE'
                       AND SUBSTR (j.DIVISION_NAME, 0, 4) IN ('NORT',
                                                              'SOUT',
                                                              'EAST',
                                                              'WEST')
                       AND (   (    a.account_setup_date < '1/1/2015'
                                AND a.last_sale > '1/1/2015')
                            OR (    a.account_setup_date > '1/1/2015'
                                AND a.last_sale IS NOT NULL)
                            OR a.account_setup_date > '8/1/2016')
                       AND a.delete_date IS NULL) CUST)
GROUP BY REGION,
         DISTRICT,
         ACCOUNT_NAME,
         CASE
            WHEN JOB_STATUS = 'CLOSED' THEN 'CLOSED_JOB'
            WHEN REVIEW_CATEGORY IS NULL THEN 'NO_ACTION'
            ELSE REVIEW_CATEGORY
         END
ORDER BY DISTRICT,
         ACCOUNT_NAME,
         CASE
            WHEN JOB_STATUS = 'CLOSED' THEN 'CLOSED_JOB'
            WHEN REVIEW_CATEGORY IS NULL THEN 'NO_ACTION'
            ELSE REVIEW_CATEGORY
         END