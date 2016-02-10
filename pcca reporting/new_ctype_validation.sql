--CREATE TABLE AAD9606.PR_CTYPE_CONVERSION_REVISED

--AS

SELECT SWD.DIVISION_NAME REGION,
       SUBSTR (SWD.REGION_NAME, 1, 3) DISTRICT,
       CTYPE.CUSTOMER_TYPE,
       CUST.ACCOUNT_NUMBER_NK,
       CUST.ACCOUNT_NAME,
       CTYPE."CUSTOMER_TYPE _FUTURE" CTYPE_FUTURE,
       CASE
          WHEN CTYPE.CUSTOMER_TYPE || PRICE_COLUMN IN
                  ('P_PLBGCON006',
                   'P_PLBGCON007',
                   'P_PLBGCON008',
                   'P_PLBGCON009')
          THEN
             'P_PLUMBCON_NEW'
          ELSE
             NULL
       END
          CTYPE_HQ,
       CTYPE.TYPE_OBS,
       CTYPE.BUSINESS_GROUP,
       CTYPE.NEW_BUSINESS_GROUP,
       CUST.CUSTOMER_NK,
       CUST.CUSTOMER_NAME,
       CUST.PRICE_COLUMN,
       CUST.SALESMAN_CODE,
       CUST.MSTR_TYPE,
       MAX (CUST.LAST_SALE) LAST_SALE,
       SUM (NVL (SLS.ROLL_12M_SLS, 0)) ROLL_12M_SLS,
       CUST.JOB_YN
  FROM (AAD9606.PR_CTYPE_CONVERT CTYPE
        INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
           ON (CTYPE.CUSTOMER_TYPE = CUST.CUSTOMER_TYPE))
       LEFT OUTER JOIN SALES_MART.BG_CUBE_CUST_DATA SLS
          ON (CUST.CUSTOMER_GK = SLS.CUSTOMER_GK)
       INNER JOIN
       EBUSINESS.SALES_DIVISIONS SWD
          ON (CUST.ACCOUNT_NUMBER_NK =
                 SWD.ACCOUNT_NUMBER_NK  
              AND CUST.ACCOUNT_NAME =
                 SWD.ACCOUNT_NAME   )
WHERE     (CUST.ACCOUNT_NAME <> 'DIST')
       AND (CUST.DELETE_DATE IS NULL)
       --AND CUST.ACCOUNT_NAME = 'LAKEWOOD'
--AND (SLS.ROLL_12M_SLS > 0 OR CUST.LAST_SALE > '7/1/2014')
	AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                  ( 'D10', 'D11', 'D12', 'D13', 'D14', 'D30', 'D31', 'D32',
									  'D50', 'D51', 'D53', 'D59' ))
GROUP BY SWD.DIVISION_NAME,
         SUBSTR (SWD.REGION_NAME, 1, 3),
         CTYPE.CUSTOMER_TYPE,
         CTYPE."CUSTOMER_TYPE _FUTURE",
         CASE
            WHEN CTYPE.CUSTOMER_TYPE || PRICE_COLUMN IN
                    ('P_PLBGCON006',
                     'P_PLBGCON007',
                     'P_PLBGCON008',
                     'P_PLBGCON009')
            THEN
               'P_PLUMBCON_NEW'
            ELSE
               NULL
         END,
         CTYPE.TYPE_OBS,
         CTYPE.BUSINESS_GROUP,
         CTYPE.NEW_BUSINESS_GROUP,
         --CUST.ACTIVE_ACCOUNT_NUMBER_NK,
         CUST.ACCOUNT_NUMBER_NK,
         --CUST.ACTIVE_ACCOUNT_NAME,
         CUST.ACCOUNT_NAME,
         --CUST.ACTIVE_CUSTOMER_NK,
         CUST.CUSTOMER_NK,
         CUST.CUSTOMER_NAME,
         CUST.MSTR_TYPE,
         CUST.JOB_YN,
         CUST.PRICE_COLUMN,
         CUST.SALESMAN_CODE
