/*
		testing...
 */
SELECT DISTINCT SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DISTRICT,
       SWD.ACCOUNT_NUMBER_NK AS BRANCH_NK,
       SWD.ACCOUNT_NAME AS ALIAS,
       CUST.CUSTOMER_NK,
			 CUST.CUSTOMER_GK,
       CUST.CUSTOMER_NAME,
       CUST.MAIN_CUSTOMER_NK,
			 CUST.CUSTOMER_TYPE,
			 NVL(BG_CT.BUS_GRP,'OTHER') BUS_GRP,
       POA_HDR.DRAWER,
       POA_HDR.APPLY_TO,
       POA_HDR.ENTRY_DATE,
       POA_HDR.COMMENTS,
       POA_LINE.PAID_BY,
       POA_LINE.AMOUNT_PAID,
       POA_LINE.INSERT_TIMESTAMP,
       POA_LINE.UPDATE_TIMESTAMP,
       CUST.TERMS,
       CUST.CREDIT_CODE,
       CUST.CREDIT_LIMIT,
       POA_LINE.PAY_KEY_NK,
       POA_LINE.LINE_NUMBER_NK,
			 SALES.PRICE_CATEGORY,
			 SUM (SALES.EXT_SALES_AMOUNT) EX_SALES,
			 SUM (SALES.EXT_AVG_COGS_AMOUNT) EX_AC
  FROM    (   (   DW_FEI.BR_PAY_ON_ACCT_HEADER_FACT POA_HDR
               INNER JOIN
                  DW_FEI.BR_PAY_ON_ACCT_LINE_FACT POA_LINE
               ON     (POA_HDR.ACCOUNT_NUMBER_NK = POA_LINE.ACCOUNT_NUMBER_NK)
                  AND (POA_HDR.PAY_KEY_NK = POA_LINE.PAY_KEY_NK)
                  AND (POA_HDR.CUSTOMER_GK = POA_LINE.CUSTOMER_GK))
           INNER JOIN
              SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON (SWD.WAREHOUSE_NUMBER_NK = POA_HDR.WAREHOUSE_NUMBER_NK))
       INNER JOIN
          DW_FEI.CUSTOMER_DIMENSION CUST
       ON (CUST.CUSTOMER_GK = POA_HDR.CUSTOMER_GK)
		INNER JOIN
				AAD9606.BUSGRP_CTYPE BG_CT
		ON BG_CT.CUSTOMER_TYPE = CUST.CUSTOMER_TYPE
		LEFT OUTER JOIN (
						SELECT PM_DET.ACCOUNT_NUMBER_NK,
									PM_DET.CUSTOMER_GK,
									PM_DET.EXT_SALES_AMOUNT,
									PM_DET.EXT_AVG_COGS_AMOUNT,
									PM_DET.PRICE_CATEGORY
							FROM    SALES_MART.TIME_PERIOD_DIMENSION TPD
									INNER JOIN
											SALES_MART.PRICE_MGMT_DATA_DET PM_DET
									ON (TPD.YEARMONTH = PM_DET.YEARMONTH)
						WHERE (TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS')
									AND (PM_DET.IC_FLAG = 'REGULAR')
										 ) SALES
								
								ON CUST.CUSTOMER_GK = SALES.CUSTOMER_GK
									AND SWD.ACCOUNT_NUMBER_NK = SALES.ACCOUNT_NUMBER_NK
									
 WHERE (SWD.ACCOUNT_NUMBER_NK IN('20', '2000'))
 			 AND POA_LINE.INSERT_TIMESTAMP >= ADD_MONTHS( TRUNC (SYSDATE, 'mm'), -6)
       AND POA_LINE.INSERT_TIMESTAMP < TRUNC (SYSDATE, 'mm') -1
 
 GROUP BY SWD.DIVISION_NAME,
       SWD.REGION_NAME,
       SWD.ACCOUNT_NUMBER_NK,
       SWD.ACCOUNT_NAME,
       CUST.CUSTOMER_NK,
			 CUST.CUSTOMER_GK,
       CUST.CUSTOMER_NAME,
       CUST.MAIN_CUSTOMER_NK,
			 CUST.CUSTOMER_TYPE,
			 NVL(BG_CT.BUS_GRP,'OTHER'),
       POA_HDR.DRAWER,
       POA_HDR.APPLY_TO,
       POA_HDR.ENTRY_DATE,
       POA_HDR.COMMENTS,
       POA_LINE.PAID_BY,
       POA_LINE.AMOUNT_PAID,
       POA_LINE.INSERT_TIMESTAMP,
       POA_LINE.UPDATE_TIMESTAMP,
       CUST.TERMS,
       CUST.CREDIT_CODE,
       CUST.CREDIT_LIMIT,
       POA_LINE.PAY_KEY_NK,
       POA_LINE.LINE_NUMBER_NK,
			 SALES.PRICE_CATEGORY
;