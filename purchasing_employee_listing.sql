SELECT EMP_DIM.USER_LOGON,
			 SWD.DIVISION_NAME,
       SUBSTR ( SWD.REGION_NAME,
                     1,
                     3
            ) DIST,
       SWD.ACCOUNT_NUMBER_NK BR_NK,
       SWD.ACCOUNT_NAME,
			 EMP_DIM.WAREHOUSE_ASSIGNED_NK WHSE_NK,
       --EMP_DIM.USER_LOGON,
       EMP_DIM.EMPLOYEE_TRILOGIE_NK TRILOGY_NK,
       EMP_DIM.EMPLOYEE_PSOFT_NK PSOFT_NK,
       EMP_DIM.ASSOC_NAME,
       EMP_DIM.INITIALS,
       EMP_DIM.TITLE_CODE,
       EMP_DIM.TITLE_DESC,
       EMP_DIM.EMAIL
  FROM   DW_FEI.EMPLOYEE_DIMENSION EMP_DIM
       INNER JOIN
         SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON ( EMP_DIM.WAREHOUSE_ASSIGNED_NK = SWD.WAREHOUSE_NUMBER_NK )
 WHERE ( EMP_DIM.DELETE_DATE IS NULL ) --AND ( SWD.ACCOUNT_NUMBER_NK = '1480' )
       /* AND ( SUBSTR ( SWD.REGION_NAME,
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
                 'D53' ) ) */
	ORDER BY SWD.DIVISION_NAME,
       SUBSTR ( SWD.REGION_NAME,
                     1,
                     3
            ),
       SWD.ACCOUNT_NUMBER_NK,
       EMP_DIM.ASSOC_NAME
			 ;