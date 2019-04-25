/* monthly pcca archive*/
--DROP TABLE AAM1365.A_PCCA_CENT_201904;

CREATE TABLE AAM1365.A_PCCA_CENT_201904 NOLOGGING
AS
  SELECT SUBSTR ( SWD.REGION_NAME,
                 1,
                 3
         )
           DIST,
         CUST.ACCOUNT_NUMBER_NK BR_NO,
         CUST.ACCOUNT_NAME BRANCH,
         CUST.CUSTOMER_ALPHA "ALPHA",
         CUST.GROSS_SALES,
         CUST.CUSTOMER_NK CUST_NO,
         CUST.CUSTOMER_NAME CUST_NAME,
         CUST.MAIN_CUSTOMER_NK MAIN_CUST,
         CUST.KOB_TYPE KOB,
         CUST.CUSTOMER_TYPE C_TYPE,
         CUST.PRIOR_CUSTOMER_TYPE PRIOR_TYPE,
         CUST.BMI_BUDGET_CUST_TYPE,
         CUST.BMI_REPORT_CUST_TYPE,
         CUST.PRICE_COLUMN PC,
         CUST.OLD_PRICE_COLUMN PRIOR_PC,
         CUST.BRANCH_WAREHOUSE_NUMBER WHSE,
         CUST.SALESMAN_CODE SLSM,
         CUST.SEC_SLSM SEC_SLSM,
         CUST.ALT_SLSM ALT_SLSM,
         CUST.MSTR_CUSTNO MSTR_NO,
         CUST.MSTR_CUST_NAME MSTR_NAME,
         CUST.MSTR_TYPE MSTR_TYPE,
         CUST.GSA_LINK GSA,
         CUST.LAST_SALE LAST_SALE,
         CUST.JOB_YN JOB_YN,
         CUST.CROSS_ACCT CROSS_ACCT,
         CUST.CROSS_CUSTOMER_NK CROSS_NO,
				 CUST.TERRITORY
    FROM   DW_FEI.CUSTOMER_DIMENSION CUST
         INNER JOIN
           EBUSINESS.SALES_DIVISIONS SWD
         ON ( CUST.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )
   WHERE ( SUBSTR ( SWD.REGION_NAME,
																														1,
																														3
																										) ) IN
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
																												'D53' )
			AND CUST.DELETE_DATE IS NULL
			-- AND CUST.PRICE_COLUMN BETWEEN '170' AND '193'
			-- AND CUST.PRICE_COLUMN  <> '175'
			/*AND CUST.CUSTOMER_TYPE IN (  'GOVT_AGENT',
																											'GOVT_FEDERAL',
																											'GOVT_LOCAL',
																											'GOVT_STATE',
																											'T_BUSINSER',
																											'T_CHURCH',
																											'T_COMMPROP',
																											'T_EDUCATION',
																											'T_FURNITURE',
																											'T_HEALTH_PRIV',
																											'T_HOTEL',
																											'T_MISCRTL',
																											'T_REALEST',
																											'T_RECREAT',
																											'T_RENOV_HOTEL',
																											'T_RENOV_MULFAM',
																											'T_RESPROP',
																											'T_RESTURNT'
																										)
  AND CUST.ACCOUNT_NUMBER_NK = '2000'*/
	ORDER BY 
				SUBSTR ( SWD.REGION_NAME,
                   1,
                   3
           		), 
					 CUST.ACCOUNT_NAME, 
					 CUST.CUSTOMER_NK;

GRANT SELECT ON AAM1365.A_PCCA_CENT_201904 TO PUBLIC;

SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D10';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D11';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D12';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D14';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D30';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D31';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D32';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST IN ('D50', 'D51', 'D53');
 
/* SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D51';
 
 SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST = 'D53';*/
 
 
/*SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST BETWEEN 'D10' AND 'D14';

SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST BETWEEN 'D30' AND 'D32';

SELECT *
  FROM AAM1365.A_PCCA_CENT_201904 PCCA
 WHERE PCCA.DIST IN ('D50', 'D51', 'D53');*/