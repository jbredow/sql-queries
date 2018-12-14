DROP TABLE AAA6863.PR_CORE_YOY2_CS;

CREATE TABLE AAA6863.PR_CORE_YOY2_CS

AS 

   SELECT TPD.FISCAL_YEAR_TO_DATE TPD,
          SWD.DIVISION_NAME REGION,
          SWD.REGION_NAME DISTRICT,
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
          
					EMP.TITLE_DESC,
					REPS.SALESREP_NK,
					REPS.SALESREP_NAME,
					
					CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NULL
             THEN
                'H/U'
             WHEN (   EMP.TITLE_DESC LIKE '%O/S%'
                   OR EMP.TITLE_DESC LIKE 'Out Sales%'
                   OR EMP.TITLE_DESC LIKE 'Sales Rep%')
             THEN
                'O/S'
             ELSE
                'H/A'
          END
             AS HOUSE_FLAG,
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
             CORE_COST_SUBTOTAL,
          SUM (ILF.EXT_WEIGHT_LB) WEIGHT
          
     FROM DW_FEI.INVOICE_HEADER_FACT IHF,
          DW_FEI.INVOICE_LINE_FACT ILF,
          DW_FEI.INVOICE_LINE_CORE_FACT CORE,
          DW_FEI.PRODUCT_DIMENSION PROD,
          DW_FEI.CUSTOMER_DIMENSION CUST,
          DW_FEI.SALESREP_DIMENSION REPS,
          DW_FEI.EMPLOYEE_DIMENSION EMP,
          SALES_MART.SALES_WAREHOUSE_DIM SWD,
          SALES_MART.TIME_PERIOD_DIMENSION TPD
    --DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
    WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK 
          --AND ILF.PRODUCT_STATUS = 'SP'
          --AND IHF.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK(+)
          AND ILF.INVOICE_NUMBER_GK = CORE.INVOICE_NUMBER_GK(+)
          AND ILF.INVOICE_LINE_NUMBER = CORE.INVOICE_LINE_NUMBER(+)
          AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
          --AND IHF.ACCOUNT_NUMBER = '52'
          AND IHF.YEARMONTH = TPD.YEARMONTH
          AND CUST.ACCOUNT_NUMBER_NK = REPS.ACCOUNT_NUMBER_NK
          AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
          AND REPS.EMPLOYEE_NUMBER_NK = EMP.EMPLOYEE_TRILOGIE_NK(+)
          AND TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
          AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
          AND IHF.IC_FLAG = 0
          AND ILF.SHIPPED_QTY <> 0
          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
          AND IHF.YEARMONTH = ILF.YEARMONTH
          --AND IHF.YEARMONTH = CORE.YEARMONTH
          --AND ILF.YEARMONTH = CORE.YEARMONTH
          AND IHF.YEARMONTH IN ('201703', '201803')
          AND ILF.YEARMONTH IN ('201703', '201803')
          --AND REPS.OUTSIDE_SALES_FLAG = 'Y'
          --AND SWD.ACCOUNT_NAME = 'ATLANTA'
          AND PROD.DISCOUNT_GROUP_NK = '0001' /*IN ('0001',
'0002',
'0003',
'0004',
'0005',
'0006',
'0007',
'0008',
'0009',
'0010',
'0011',
'0012',
'0013',
'0014',
'0015',
'0016',
'0017',
'0018',
'0019',
'0020',
'0021',
'0022',
'0023',
'0024',
'0025',
'0026',
'0027',
'0028',
'0029',
'0036',
'0037',
'0038',
'0039',
'0040',
'0041',
'0042',
'0043',
'0044',
'0045',
'0046',
'0047',
'0048',
'0049',
'0050',
'0051',
'0052',
'0053',
'0054',
'0055',
'0056',
'0057',
'0058',
'0059',
'0060',
'0061',
'0062',
'0063',
'0064',
'0065',
'0066',
'0067',
'0068',
'0069',
'0070',
'0071',
'0072',
'0073',
'0077',
'0081',
'0082',
'0083',
'0086',
'0089',
'0095',
'0100',
'0102',
'0105',
'0108',
'0110',
'0112',
'0113',
'0115',
'0116',
'0145',
'0181',
'0185',
'0215',
'0216',
'0217',
'0218',
'0255',
'0378',
'0509',
'0510',
'0993',
'2646',
'6921',
'6922',
'6923',
'6924',
'6925',
'6926',
'6927',
'6928',
'7050',
'7128',
'7165',
'7459',
'7804',
'7805',
'7811',
'7812',
'9010',
'9011',
'9012',
'9013',
'9014',
'9015',
'9016',
'9017',
'9018'
)*/
          
          AND IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
          /*AND SWD.DIVISION_NAME IN (
                                    'EAST REGION',
                                    'HVAC REGION',
                                    'NORTH CENTRAL REGION',
                                    'SOUTH CENTRAL REGION',
                                    'WEST REGION'       --,
                                    --'WATERWORKS REGION'
                                    )*/
   GROUP BY TPD.FISCAL_YEAR_TO_DATE ,
          SWD.DIVISION_NAME ,
          SWD.REGION_NAME ,
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
             ,
          
					EMP.TITLE_DESC,
					REPS.SALESREP_NK,
					REPS.SALESREP_NAME,
					
					CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NULL
             THEN
                'H/U'
             WHEN (   EMP.TITLE_DESC LIKE '%O/S%'
                   OR EMP.TITLE_DESC LIKE 'Out Sales%'
                   OR EMP.TITLE_DESC LIKE 'Sales Rep%')
             THEN
                'O/S'
             ELSE
                'H/A'
          END,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-')
          
          /*COUNT (ILF.INVOICE_LINE_NUMBER) LINES,
          
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
             CORE_COST_SUBTOTAL*/
		;