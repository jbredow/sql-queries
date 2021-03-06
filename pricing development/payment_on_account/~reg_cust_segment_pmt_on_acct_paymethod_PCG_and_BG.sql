/*
		pm_data
    regional customer segment pmt on account paymethod summary
	>>	using for BOTH PC and BG
	  
		>> SALES_MART.PRICE_MGMT_DATA_DET
*/

SELECT SWD.DIVISION_NAME AS REGION,
       SWD.REGION_NAME AS DISTRICT,
       SWD.ACCOUNT_NUMBER_NK AS BRANCH_NK,
       SWD.ACCOUNT_NAME AS ALIAS,
       CUST.CUSTOMER_NK,
       CUST.CUSTOMER_GK,
       CUST.CUSTOMER_NAME,
       CUST.MAIN_CUSTOMER_NK,
       CUST.CUSTOMER_TYPE,
-- change below
       NVL (BG_CT.BUS_GRP, 'OTHER') BUS_GRP,
       NVL (PC."PriceColGroup",'OTHER') PC_GROUP,
-- end change
       /* POA_HDR.DRAWER,
        POA_HDR.APPLY_TO,
        POA_HDR.ENTRY_DATE,
        POA_HDR.COMMENTS,*/
       DECODE (POA_LINE.PAID_BY,
                'AX', 'CC',
                'DI', 'CC',
                'MC', 'CC',
                'VI', 'CC',
                'CASH_CHK')
           PAID_BY,
       SUM (CASE
               WHEN POA_LINE.PAID_BY IN ('AX',
                                         'DI',
                                         'MC',
                                         'VI')
               THEN
                  POA_LINE.AMOUNT_PAID
               ELSE
                  0
            END)
          CC_PAID,
       SUM (CASE
               WHEN POA_LINE.PAID_BY NOT IN ('AX',
                                             'DI',
                                             'MC',
                                             'VI')
               THEN
                  POA_LINE.AMOUNT_PAID
               ELSE
                  0
            END)
          CASH_CHK_PAID,
       --  POA_LINE.INSERT_TIMESTAMP,
       --  POA_LINE.UPDATE_TIMESTAMP,
       CUST.TERMS,
       CUST.CREDIT_CODE,
       CUST.CREDIT_LIMIT,
       CUST.CUSTOMER_STATUS CUST_STATUS,
       EX_SALES,
       EX_COGS,
       MATRIX_SALES,
       MATRIX_COGS,
       OVERRIDE_SALES,
       OVERRIDE_COGS,
       MANUAL_SALES,
       MANUAL_COGS,
       CREDITS_SALES,
       CREDITS_COGS,
       SP_SALES,
       SP_COGS,
       OUTBOUND_SALES
  FROM DW_FEI.CUSTOMER_DIMENSION CUST
       
			 INNER JOIN DW_FEI.BR_PAY_ON_ACCT_LINE_FACT POA_LINE
          ON (CUST.CUSTOMER_GK = POA_LINE.CUSTOMER_GK)
       
			 INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (POA_LINE.WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
       
			 INNER JOIN AAD9606.BUSGRP_CTYPE BG_CT
          ON (CUST.CUSTOMER_TYPE = BG_CT.CUSTOMER_TYPE)
       
			 INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
          ON TO_CHAR (POA_LINE.INSERT_TIMESTAMP, 'YYYYMM') = TPD.YEARMONTH
       
			 INNER JOIN AAD9606.PPE_DIM_PRICE_COLUMN PC
          ON (CUST.PRICE_COLUMN = PC."PriceColumnNumber")
					
			 LEFT OUTER JOIN
       (SELECT SLS.ACCOUNT_NUMBER_NK,
               SLS.CUSTOMER_GK,
               NVL (SUM (SLS.EXT_SALES_AMOUNT), 0) EX_SALES,
               NVL (SUM (SLS.EXT_AVG_COGS_AMOUNT), 0) EX_COGS,
               /* MATRIX */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MATRIX',
                                                                       'MATRIX_BID')
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  MATRIX_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MATRIX',
                                                                       'MATRIX_BID')
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  MATRIX_COGS,
               /* CONTRACT */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
                             'OVERRIDE'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  OVERRIDE_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
                             'OVERRIDE'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  OVERRIDE_COGS,
               /* MANUAL */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MANUAL',
                                                                       'QUOTE',
                                                                       'TOOLS')
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  MANUAL_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN ('MANUAL',
                                                                       'QUOTE',
                                                                       'TOOLS')
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  MANUAL_COGS,
               /* SPECIALS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'SPECIAL'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  SP_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'SPECIAL'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  SP_COGS,
               /* CREDITS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'CREDITS'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  CREDITS_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'CREDITS'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  CREDITS_COGS,
               /* CREDITS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY <> 'CREDITS'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  OUTBOUND_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY <> 'CREDITS'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  OUTBOUND_COGS
          FROM SALES_MART.PRICE_MGMT_DATA_DET SLS
               INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                  ON (SLS.YEARMONTH = TPD.YEARMONTH)
         WHERE                      -- TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
              TPD  .FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
               AND SLS.IC_FLAG = 'REGULAR'
               --AND SLS.ACCOUNT_NUMBER_NK IN ('20', '2000')
        GROUP BY SLS.ACCOUNT_NUMBER_NK, SLS.CUSTOMER_GK) SALES
          ON CUST.CUSTOMER_GK = SALES.CUSTOMER_GK
 WHERE     TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
 			 --AND SWD.ACCOUNT_NUMBER_NK IN ('20', '2000')
       --AND TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
			 AND CUST.CREDIT_CODE <> 'COD'
          
GROUP BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         CUST.CUSTOMER_NK,
         CUST.CUSTOMER_GK,
         CUST.CUSTOMER_NAME,
         CUST.MAIN_CUSTOMER_NK,
         CUST.CUSTOMER_TYPE,
         NVL (BG_CT.BUS_GRP, 'OTHER'),
				 NVL (PC."PriceColGroup",'OTHER'),
         DECODE (POA_LINE.PAID_BY,
                  'AX', 'CC',
                  'DI', 'CC',
                  'MC', 'CC',
                  'VI', 'CC',
                  'CASH_CHK'),
         CUST.TERMS,
         CUST.CREDIT_CODE,
         CUST.CREDIT_LIMIT,
         CUST.CUSTOMER_STATUS,
         EX_SALES,
         EX_COGS,
         MATRIX_SALES,
         MATRIX_COGS,
         OVERRIDE_SALES,
         OVERRIDE_COGS,
         MANUAL_SALES,
         MANUAL_COGS,
         CREDITS_SALES,
         CREDITS_COGS,
         SP_SALES,
         SP_COGS,
         OUTBOUND_SALES
	;