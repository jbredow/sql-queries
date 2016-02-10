SELECT SWD.DIVISION_NAME REGION,
       SUBSTR ( SWD.REGION_NAME,
                 1,
                 3
        ) DIST,
       SWD.ALIAS_NAME ALIAS,
       SWD.ACCOUNT_NUMBER_NK BR_NO,
       CUST.ACTIVE_CUSTOMER_NK CUST_NO,
       CUST.CUSTOMER_TYPE C_TYPE,
       CUST.PRICE_COLUMN PC,
       CUST.JOB_YN JOB,
       CUST.MSTR_CUSTNO MSTR_CUST_NO,
       CUST.MSTR_CUST_NAME,
       CUST.CROSS_ACCT,
       CUST.CROSS_CUSTOMER_NK
  FROM   DW_FEI.CUSTOMER_DIMENSION CUST
       INNER JOIN
         EBUSINESS.SALES_DIVISIONS SWD
       ON ( CUST.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )
 WHERE ( SUBSTR ( SWD.REGION_NAME,
                 1,
                 3
        ) IN
            ( 'D10',
             'D11',
             'D12',
             'D13',
             'D14',
             'D30',
             'D31',
             'D32',
             'D50',
             'D51',
             'D53' ) )
       AND CUST.CROSS_ACCT = 'MASTER'
       --AND CUST.CROSS_CUSTOMER_NK = '324'
       --AND CUST.ACTIVE_ACCOUNT_NAME IN ('METRODCHVAC','LYON')
       --AND CUST.MSTR_CUSTNO IN ('263103','125401','373646','196954')
       AND CUST.DELETE_DATE IS NULL
ORDER BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ALIAS_NAME,
         CUST.ACTIVE_CUSTOMER_NK