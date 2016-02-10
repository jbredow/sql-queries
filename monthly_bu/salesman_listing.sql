SELECT SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DIST,
       SLS_REP.ACCOUNT_NUMBER_NK AS BR_NO,
       SLS_REP.ACCOUNT_NAME AS BR_NAME,
       SLS_REP.SALESREP_NK AS SLS_REP_INIT,
       SLS_REP.SALESREP_NAME AS SLS_REP_NAME,
       SLS_REP.EMPLOYEE_NUMBER_NK AS EMP_NO,
       SLS_REP.SHOWROOM_FLAG AS SHOWROOM,
       SLS_REP.HOUSE_ACCT_FLAG AS HOUSE,
       SLS_REP.OUTSIDE_SALES_FLAG AS OUTSIDE
  FROM     DW_FEI.SALESREP_DIMENSION SLS_REP
       INNER JOIN
           EBUSINESS.SALES_DIVISIONS SWD
       ON ( SLS_REP.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )
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
                 'D53',
								 'D59') )
GROUP BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SLS_REP.ACCOUNT_NUMBER_NK,
         SLS_REP.ACCOUNT_NAME,
         SLS_REP.SALESREP_NK,
         SLS_REP.SALESREP_NAME,
         SLS_REP.EMPLOYEE_NUMBER_NK,
         SLS_REP.SHOWROOM_FLAG,
         SLS_REP.HOUSE_ACCT_FLAG,
         SLS_REP.OUTSIDE_SALES_FLAG
ORDER BY SWD.DIVISION_NAME,
				 SWD.REGION_NAME,
				 SLS_REP.ACCOUNT_NAME,
				 SLS_REP.SALESREP_NK