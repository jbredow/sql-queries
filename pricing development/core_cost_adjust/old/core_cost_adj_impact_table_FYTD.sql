/*
		
*/
DROP TABLE AAA6863.PR_CORE_COST_ADJUST_FYTD;

CREATE TABLE AAA6863.PR_CORE_COST_ADJUST_FYTD

AS
   SELECT SWD.DIVISION_NAME,
          SWD.REGION_NAME,
          IHF.ACCOUNT_NUMBER,
          SWD.ACCOUNT_NAME,
          IHF.YEARMONTH,
          DECODE (ihf.SALE_TYPE,
                  '1', 'Our Truck',
                  '2', 'Counter',
                  '3', 'Direct',
                  '4', 'Counter',
                  '5', 'Credit Memo',
                  '6', 'Showroom',
                  '7', 'Showroom Direct',
                  '8', 'eBusiness')
             TYPE_OF_SALE,
          IHF.WRITER,
          CUST.SALESMAN_CODE,
          REPS.SALESREP_NAME,
          EMP.TITLE_DESC,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-') DISCOUNT_GROUP_NK,
          COUNT (ILF.INVOICE_LINE_NUMBER) LINES,
          SUM (ILF.EXT_AVG_COGS_AMOUNT) AVG_COGS,
          SUM (ILF.EXT_ACTUAL_COGS_AMOUNT) INVOICE_COGS,
          SUM (ILF.EXT_SALES_AMOUNT) SALES,
          SUM (ILF.CORE_ADJ_AVG_COST) CORE_ADJ_AVG_COGS,
          SUM (
             CASE
                WHEN ILF.SUM_MV_CLAIM_AMOUNT > 0
                THEN
                   ILF.CORE_ADJ_AVG_COST
                WHEN     CORE.SUBLINE_COST IS NOT NULL
                     AND CORE.SUBLINE_QTY IS NULL
                THEN
                     CORE.SUBLINE_COST
                   * ILF.SHIPPED_QTY
                   / NVL (PROD.SELL_PACKAGE_QTY, 1)
                ELSE
                   ILF.EXT_AVG_COGS_AMOUNT
             END)
             CORE_COST_SUBTOTAL
     FROM DW_FEI.INVOICE_HEADER_FACT IHF,
          DW_FEI.INVOICE_LINE_FACT ILF,
          DW_FEI.INVOICE_LINE_CORE_FACT CORE,
          DW_FEI.PRODUCT_DIMENSION PROD,
          DW_FEI.CUSTOMER_DIMENSION CUST,
          DW_FEI.SALESREP_DIMENSION REPS,
          DW_FEI.EMPLOYEE_DIMENSION EMP,
          SALES_MART.SALES_WAREHOUSE_DIM SWD,
					SALES_MART.TIME_PERIOD_DIMENSION TPD,
					DW_FEI.INVOICE_PAYMETHOD_FACT IPF
					--SALES_MART.TIME_PERIOD_DIMENSION TPD
					--DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
    WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK --AND ILF.PRODUCT_STATUS = 'SP'
          AND IHF.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK
          AND ILF.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK
          AND ILF.INVOICE_LINE_NUMBER = CORE.INVOICE_LINE_NUMBER
          AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
					AND IPF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
          --AND IHF.ACCOUNT_NUMBER = '1271'
          --AND IHF.YEARMONTH = TPD.YEARMONTH
          AND CUST.ACCOUNT_NUMBER_NK = REPS.ACCOUNT_NUMBER_NK
          AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
          AND REPS.EMPLOYEE_NUMBER_NK = EMP.EMPLOYEE_TRILOGIE_NK
          --AND TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
          AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
          AND IHF.IC_FLAG = 0
          AND ILF.SHIPPED_QTY <> 0
          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
/*        AND IHF.YEARMONTH = ILF.YEARMONTH
          AND IHF.YEARMONTH = CORE.YEARMONTH
          AND ILF.YEARMONTH = CORE.YEARMONTH
          AND TPD.YEARMONTH = CORE.YEARMONTH*/
					AND TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
					/*AND ILF.YEARMONTH BETWEEN TO_CHAR ( TRUNC ( SYSDATE
																													- NUMTOYMINTERVAL ( 12,
																																						'MONTH'
																														),
																													'MONTH'
																									),
																									'YYYYMM'
																				)
																		AND TO_CHAR ( TRUNC ( SYSDATE,
																													'MM'
																									)
																									- 1,
																									'YYYYMM'
																					)
								AND IHF.YEARMONTH  BETWEEN TO_CHAR ( TRUNC ( SYSDATE
																														- NUMTOYMINTERVAL ( 12,
																																							'MONTH'
																															),
																														'MONTH'
																										),
																										'YYYYMM'
																					)
																			AND  TO_CHAR ( TRUNC ( SYSDATE,
																														'MM'
																										)
																										- 1,
																										'YYYYMM'
																						)*/

					AND REPS.OUTSIDE_SALES_FLAG = 'Y'
          AND IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
					
					--AND SWD.DIVISION_NAME = 'EAST REGION'
					
          AND SWD.DIVISION_NAME IN ('EAST REGION',
                                    'HVAC REGION',
                                    'NORTH CENTRAL REGION',
                                    'SOUTH CENTRAL REGION',
                                    --'WATERWORKS REGION',
                                    'WEST REGION')
   GROUP BY IHF.ACCOUNT_NUMBER,
            SWD.ACCOUNT_NAME,
            IHF.YEARMONTH,
            DECODE (ihf.SALE_TYPE,
                    '1', 'Our Truck',
                    '2', 'Counter',
                    '3', 'Direct',
                    '4', 'Counter',
                    '5', 'Credit Memo',
                    '6', 'Showroom',
                    '7', 'Showroom Direct',
                    '8', 'eBusiness'),
            IHF.WRITER,
            CUST.SALESMAN_CODE,
            REPS.SALESREP_NAME,
            EMP.TITLE_DESC,
            PROD.DISCOUNT_GROUP_NK,
            SWD.DIVISION_NAME,
            SWD.REGION_NAME;
						
--GRANT SELECT ON AAA6863.PR_CORE_COST_ADJUST_FYTD;
