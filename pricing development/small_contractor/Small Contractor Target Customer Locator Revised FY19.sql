--** updated rollup to main to eliminate job customer type from grouping 11/10/17

--


--AS
   SELECT CUST.*,
          ROUND (R12M_NET_BILLINGS / SLS_MONTHS, 2) AVG_MO_SLS,
          ROUND (R12M_NET_BILLINGS / SLS_MONTHS * 12, 2) ANNUALIZED_SLS----,
          --ROUND (MAIN_12M_SLS_TOTAL / SLS_MONTHS, 2) MAIN_AVG_MO_SLS,
          --ROUND (MAIN_12M_SLS_TOTAL / SLS_MONTHS * 12, 2) MAIN_ANNUALIZED_SLS
     FROM (SELECT DISTINCT
                  k.DIVISION_NAME REGION,
                  k.REGION_NAME DISTRICT,
                  A.ACCOUNT_NAME ACCT,
                  A.ACCOUNT_NUMBER_NK ACCT_NK,
                  G.SALESREP_NAME SALESREP,
                  A.MAIN_CUSTOMER_NK MAIN_CUST_NK,
                  --a.CUSTOMER_NK,
                  --b.CUSTOMER_GK MAIN_CUST_GK,
                  --a.CUSTOMER_TYPE,
                  b.customer_Name AS MAIN_CUST_NAME,
                  b.customer_type AS MAIN_CUST_TYPE,
                  B.BMI_REPORT_CUST_TYPE MAIN_BMI_REP_CTYPE,
                  e.business_group AS MAIN_CTYPE_BUSGRP,
                  NVL (f.business_Group, e.business_group)
                     AS BMI_MAIN_CTYPE_BUSGRP,
                  b.PRICE_COLUMN PC,
                  MAX (A.LAST_SALE) LAST_SALE,
                  b.ACCOUNT_SETUP_DATE ACCT_SETUP,
                  CASE
                     WHEN (SYSDATE - b.ACCOUNT_SETUP_DATE) > 335
                     THEN
                        12
                     ELSE
                        ROUND ( ( (SYSDATE - b.ACCOUNT_SETUP_DATE) / 30) + 1,
                               0)
                  END
                     SLS_MONTHS,
                  CASE
                     WHEN g.EMPLOYEE_NUMBER_NK IS NULL
                     THEN
                        'H/U'
                     WHEN (   l.TITLE_DESC LIKE '%O/S%'
                           OR l.TITLE_DESC LIKE 'Out Sales%'
                           OR l.TITLE_DESC LIKE 'Sales Rep%')
                     THEN
                        'O/S'
                     ELSE
                        'H/A'
                  END
                     AS HOUSE_FLAG,
                  a.JOB_COUNT,
                  b.CUSTOMER_ALPHA,
                  /*C.BUSINESS_GROUP AS CUST_TYPE_BUSGRP,
                  NVL (D.BUSINESS_GROUP, c.BUSINESS_GROUP)
                     AS BMI_CUST_TYPE_BUSGRP,
                  B.MAIN_CUSTOMER_NK,
                  b.customer_Name AS MAIN_CUSTOMER_NAME,
                  b.customer_type AS MAIN_CUST_TYPE,
                  B.BMI_REPORT_CUST_TYPE MAIN_BMI_REPORT_CUST_TYPE,
                  e.business_group AS MAIN_CUST_TYPE_BUSGRP,
                  NVL (f.business_Group, e.business_group)
                     AS BMI_MAIN_CUST_TYPE_BUSGRP,*/
                  SUM (h.R12M_NET_BILLINGS_AMT) R12M_NET_BILLINGS,
                 -- i.ROLL_12M_SLS MAIN_12M_SLS_TOTAL,
                  b.CUSTOMER_STATUS CUST_STATUS,
                  b.CREDIT_CODE,
                  b.CREDIT_LIMIT,
                  CASE WHEN b.CREDIT_LIMIT>0 THEN (b.CREDIT_LIMIT*12)-i.ROLL_12M_SLS ELSE 0 END AS CREDIT_POTENTIAL,
                  b.BRANCH_WAREHOUSE_NUMBER CUST_WHSE,
                  j.CHURN_SEGMENT CHURN_STATUS,
                  NVL (j.MAX_CHANNEL_SALES  , 'COUNTER') PREF_CHANNEL
             FROM (SELECT a.*,
                          SUM (
                             CASE WHEN a.JOB_YN = 'Y' THEN 1 ELSE 0 END)
                          OVER (
                             PARTITION BY a.ACCOUNT_NAME, a.MAIN_CUSTOMER_NK)
                             AS JOB_COUNT
                     FROM dw_Fei.active_customer_mvw a) a,
                  dw_fei.customer_dimension b,
                  --USER_SHARED.BG_CUSTTYPE_XREF c,
                  --USER_SHARED.BG_CUSTTYPE_XREF d,
                  USER_SHARED.BG_CUSTTYPE_XREF e,
                  USER_SHARED.BG_CUSTTYPE_XREF f,
                  dw_Fei.salesrep_dimension g,
                  PROF_MART.CTS_CUST_SUMMARY h,
                  SALES_MART.BG_CUBE_CUST_DATA i,
                  AAK7642.MAINRFM j,
                  EBUSINESS.SALES_DIVISIONS k,
                  DW_FEI.EMPLOYEE_DIMENSION l
            WHERE     A.MAIN_CUSTOMER_NK = b.CUSTOMER_NK
                  AND A.ACCOUNT_NUMBER_NK = B.ACCOUNT_NUMBER_NK
                  --AND a.customer_type = C.CUSTOMER_TYPE
                  --AND A.BMI_REPORT_CUST_TYPE = d.customer_Type(+)
                  AND b.customer_type = e.customer_type
                  AND B.BMI_REPORT_CUST_TYPE = f.customer_type(+)
                  AND A.ACCOUNT_NUMBER_NK = g.account_number_nk
                  AND A.SALESMAN_CODE = G.SALESREP_NK
                  AND A.CUSTOMER_GK = H.CUSTOMER_GK(+)
                  AND b.CUSTOMER_GK = i.CUSTOMER_GK(+) --trying different joins here
                  AND A.MAIN_CUSTOMER_NK = j.MAIN_CUSTOMER_NK(+)
                  AND a.ACCOUNT_NUMBER_NK = j.ACCOUNT_NUMBER_NK(+)
                  AND j.SCORE_DATE = (SELECT MAX (SCORE_DATE) FROM AAK7642.MAINRFM)
                  AND g.EMPLOYEE_NUMBER_NK = l.EMPLOYEE_TRILOGIE_NK(+)
                  AND a.ACCOUNT_NAME = k.ACCOUNT_NAME
                 --  AND A.ACCOUNT_NAME IN ('ATLANTA')
                 AND A.PRICE_COLUMN IN ('001',
                                         '002',
                                         '003',
                                         '006',
                                         '007',
                                         '008',
                                         '011',
                                         '012',
                                         '013',
                                         '070',
                                         '071',
                                         '020',
                                         '021',
                                         '022',
                                         '301',
                                         '302',
                                         '303',
                                         '306',
                                         '307',
                                         '308',
                                         '506',
                                         '507',
                                         '508',
                                         '706',
                                         '707',
                                         '708',
                                         '570',
                                         '571',
                                         '770',
                                         '771')
                  AND b.CUSTOMER_TYPE IN ('P_PLUMBCON_SML',
                                          'C_PLBGHVAC_SML',
                                          'M_COMMPLBG_SML')
                  AND SUBSTR (k.DIVISION_NAME, 0, 4) IN ('NORT',
                                                         'SOUT',
                                                         'EAST',
                                                         'WEST')
                  --AND A.CUSTOMER_TYPE NOT IN ('O_BRCHACCT', 'O_INTRBRNCH')
                  AND a.AR_GL_NUMBER = '1300'
               /*   AND (   (    a.account_setup_date < '1/1/2017'
                           AND a.last_sale > '1/1/2017')
                       OR (    a.account_setup_date > '1/1/2017'
                           AND a.last_sale IS NOT NULL)
                       OR a.account_setup_date > '8/1/2017')*/
                  AND a.delete_date IS NULL
                  AND b.delete_Date IS NULL
                 /* AND NVL (j.MAX_CHAN_SALES_C12M, 'COUNTER') IN ('COUNTER',
                                                                 'SHOWROOM',
                                                                 'TRUCK',
                                                                 'MULTIPLE')*/
           GROUP BY A.ACCOUNT_NAME,
                    A.ACCOUNT_NUMBER_NK,
                    G.SALESREP_NAME,
                    --a.CUSTOMER_NK,
                    --a.CUSTOMER_GK,
                    A.MAIN_CUSTOMER_NK,
                    --a.CUSTOMER_TYPE,
                  --  a.BMI_REPORT_CUST_TYPE,
                    b.CUSTOMER_GK,
                    b.CUSTOMER_NAME,
                    b.CUSTOMER_TYPE,
                    b.BMI_REPORT_CUST_TYPE,
                    b.PRICE_COLUMN,
                    b.ACCOUNT_SETUP_DATE,
                    CASE
                       WHEN g.EMPLOYEE_NUMBER_NK IS NULL
                       THEN
                          'H/U'
                       WHEN (   l.TITLE_DESC LIKE '%O/S%'
                             OR l.TITLE_DESC LIKE 'Out Sales%'
                             OR l.TITLE_DESC LIKE 'Sales Rep%')
                       THEN
                          'O/S'
                       ELSE
                          'H/A'
                    END,
                    a.JOB_COUNT,
                    b.CUSTOMER_ALPHA,
                    e.business_group,
                    NVL (f.business_Group, e.business_group),
                   i.ROLL_12M_SLS,
                    b.CUSTOMER_STATUS,
                    b.CREDIT_CODE,
                    b.CREDIT_LIMIT,
                    b.BRANCH_WAREHOUSE_NUMBER,
                    j.CHURN_SEGMENT,
                    k.DIVISION_NAME,
                    k.REGION_NAME,
                    --H.R12M_NET_BILLINGS_AMT,
                    NVL (j.MAX_CHANNEL_SALES  , 'COUNTER')) CUST