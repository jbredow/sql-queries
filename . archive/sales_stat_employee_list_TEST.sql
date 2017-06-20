;WITH CTE AS
(
SELECT REG, DIST, ACCT_NK, BRANCH, LOGON, WH_NK, TRILOGIE_NK, PSOFT_NK, INIT, ASSOC_NAME, TITLE_CODE, TITLE_DESC, UPD_TS, EMAIL()
	OVER (PARTITION BY ( USER_LOGON ORDER BY UPD_TS DESC)
	FROM
	
	SELECT DISTINCT
       CASE
			 		WHEN SWD.DIVISION_NAME = 'NORTH CENTRAL REGION' THEN
							'NC'
					WHEN SWD.DIVISION_NAME = 'SOUTH CENTRAL REGION' THEN
							'SC'
					WHEN SWD.DIVISION_NAME = 'WATERWORKS REGION' THEN
							'WW'
					ELSE 
							SWD.DIVISION_NAME
			 END
					AS REG,
       SUBSTR ( SWD.REGION_NAME, 1 ,3 ) AS DIST,
       SWD.ACCOUNT_NUMBER_NK AS ACCT_NK,
       SWD.ACCOUNT_NAME AS BRANCH,
			 EMP_DIM.USER_LOGON AS LOGON,
       SWD.WAREHOUSE_NUMBER_NK AS WH_NK,
       EMP_DIM.EMPLOYEE_TRILOGIE_NK AS TRILOGIE_NK,
       EMP_DIM.EMPLOYEE_PSOFT_NK AS PSOFT_NK,
       EMP_DIM.INITIALS AS INIT,
       EMP_DIM.ASSOC_NAME,
			 EMP_DIM.TITLE_CODE,
			 EMP_DIM.TITLE_DESC,
			 -- EMP_DIM.INSERT_TIMESTAMP INS_TS,
			 EMP_DIM.UPDATE_TIMESTAMP UPD_TS,
       EMP_DIM.EMAIL
			 -- SWD.ACCOUNT_NUMBER_NK || '^' || EMP_DIM.INITIALS
  FROM    DW_FEI.EMPLOYEE_DIMENSION EMP_DIM
       INNER JOIN
          SALES_MART.SALES_WAREHOUSE_DIM SWD
       ON (EMP_DIM.WAREHOUSE_ASSIGNED_NK = SWD.WAREHOUSE_NUMBER_NK)
 WHERE (EMP_DIM.DELETE_DATE IS NULL)
    AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
			 	 'D10', 'D11', 'D12', 'D13', 
				 'D14', 'D30', 'D31', 'D32', 
				 'D50', 'D51', 'D53'
				 ))
	ORDER BY
			 SWD.DIVISION_NAME,
       SUBSTR ( SWD.REGION_NAME, 1 ,3 ),
       SWD.ACCOUNT_NUMBER_NK,
       SWD.WAREHOUSE_NUMBER_NK,
       EMP_DIM.INITIALS,
       EMP_DIM.EMPLOYEE_PSOFT_NK,
			 EMP_DIM.UPDATE_TIMESTAMP DESC
	)
	SELECT REG, DIST, ACCT_NK, BRANCH, LOGON, WH_NK, TRILOGIE_NK, PSOFT_NK, INIT, ASSOC_NAME, TITLE_CODE, TITLE_DESC, UPD_TS, EMAIL
	FROM CTE
	WHERE RNUM=1
		;