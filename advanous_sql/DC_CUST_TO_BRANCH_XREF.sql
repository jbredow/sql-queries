SELECT                                             --CUST.ACCOUNT_NUMBER_NK,
        CUST.ACCOUNT_NAME,
         CUST.MAIN_CUSTOMER_NK MAIN_CUST,
         CUST.CUSTOMER_NK CUST_NK,
         CUST.CUSTOMER_NAME,
         CUST.CUSTOMER_ALPHA,
         -- searches for 4 or 3 digit number in customer name if not there uses EDI branch#
         LTRIM (
            COALESCE (CUST.IC_EDI_BRANCHNO,
                      REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{4}'),
                      REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{3}')),
            '0')
            AS BRANCH_NK,
         CUST.PRICE_COLUMN,
         CUST.AR_GL_NUMBER AR_GL
    FROM DW_FEI.CUSTOMER_DIMENSION CUST
   WHERE     CUST.ACCOUNT_NAME = 'DIST'
         AND CUST.CUSTOMER_NAME NOT LIKE '%DO NOT USE%'
         AND CUST.IC_EDI_BRANCHNO NOT IN ('39')
         AND CUST.DELETE_DATE IS NULL
         AND CUST.JOB_YN = 'N'
         AND CUST.CUSTOMER_ALPHA NOT LIKE '@%' -- excludes inactive customer locations
         AND CUST.CUSTOMER_NAME NOT LIKE '%INTEG%' -- excludes integrated customer locations
ORDER BY TO_NUMBER (CUST.IC_EDI_BRANCHNO) ASC