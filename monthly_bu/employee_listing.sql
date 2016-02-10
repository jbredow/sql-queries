/* drop monthly to update shared file
	 X:\Lists\employee_Listing_####.xlsm*/

SELECT DISTINCT
			 SWD.DIVISION_NAME REGION,
       SUBSTR ( SWD.REGION_NAME,
               1,
               3
       )
           DIST,
       SWD.ACCOUNT_NAME,
       SWD.ACCOUNT_NUMBER_NK BR_NO,
       EMPL.WAREHOUSE_NUMBER_NK WH_NO,
       EMPL.EMPLOYEE_TRILOGIE_NK TRILOGY_NO,
       EMPL.ASSOC_NAME EMP_NAME,
       EMPL.EMPLOYEE_PSOFT_NK PSOFT_NO,
       EMPL.INITIALS INIT,
       EMPL.EMAIL USER_EMAIL,
       EMPL.USER_LOGON LOGON,
       EMPL.TITLE_CODE TITLE_CODE,
       EMPL.TITLE_DESC "TITLE",
			 EMPL.PS_DEPARTMENT PS_DEPT,
			 EMPL.UPDATE_TIMESTAMP UPDATED,
			 EMPL.INSERT_TIMESTAMP INSERTED
  FROM     (    DW_FEI.WAREHOUSE_DIMENSION WAREHOUSE_DIMENSION
            INNER JOIN
                DW_FEI.EMPLOYEE_DIMENSION EMPL
            ON ( WAREHOUSE_DIMENSION.WAREHOUSE_NUMBER_NK =
                    EMPL.WAREHOUSE_NUMBER_NK ))
       INNER JOIN
           EBUSINESS.SALES_DIVISIONS SWD
       ON ( WAREHOUSE_DIMENSION.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )
 WHERE ( EMPL.DELETE_DATE IS NULL )
 			 
       AND ( SUBSTR ( SWD.REGION_NAME,
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
										
			 
ORDER BY SWD.DIVISION_NAME,
         SUBSTR ( SWD.REGION_NAME,
                 1,
                 3
         ),
         SWD.ACCOUNT_NUMBER_NK,
         EMPL.ASSOC_NAME;