/* 
	use for weekly manual reports #toolbox
   updated w/  CORE_ADJ_AVG_COST
      added    MAN.PRICE_CATEGORY_OVR_PR,
               MAN.PRICE_CATEGORY_OVR_GR
 */

SELECT SWD.DIVISION_NAME "Region",
       SWD.REGION_NAME "District",
       MAN.ACCOUNT_NAME "Account Name",
       MAN.ACCOUNT_NUMBER "Br #",
       -- MAN.OML_ASSOC_INI "OML INI",
       MAN.WRITER "Writer",
       MAN.ASSOC_NAME "Associate Name",
       MAN.PRICE_COLUMN "PC",
       MAN.WAREHOUSE_NUMBER "Sell Wh",
       MAN.INVOICE_NUMBER_NK "Inv #",
       MAN.SHIP_VIA_NAME "VIA",
       MAN.INVOICE_LINE_NUMBER "Inv Line",
       MAN.ORDER_CODE "Order Code",
       MAN.ORDER_CHANNEL "Order Channel",
       MAN.CUSTOMER_NK "Cust #",
       MAN.CUSTOMER_NAME "Customer Name",
       MAN.ALT1_CODE "ALT 1",
       MAN.PRODUCT_NAME "PRODUCT",
       MAN.STATUS "ST",
       MAN.UM "U/M",
       MAN.DISCOUNT_GROUP_NK "DG",
       MAN.SHIPPED_QTY "Shpd",
       MAN.UNIT_NET_PRICE_AMOUNT "Unit Net",
       ROUND (MAN.EXT_AVG_COGS_AMOUNT / MAN.SHIPPED_QTY, 2) "Unit AC",
       CASE
          WHEN MAN.EXT_AVG_COGS_AMOUNT = 0
          THEN
             0
          WHEN MAN.EXT_SALES_AMOUNT = 0
          THEN
             0
          ELSE
             ROUND (
                  (MAN.EXT_SALES_AMOUNT - MAN.EXT_AVG_COGS_AMOUNT)
                / MAN.EXT_SALES_AMOUNT,
                4)
       END
          "GP %",
       MAN.MATRIX_PRICE "Matrix Price",
       ROUND (MAN.UNIT_NET_PRICE_AMOUNT - MAN.MATRIX_PRICE, 2) "Matrix Var",
       MAN.EXT_SALES_AMOUNT "Ext Net",
       MAN.CORE_ADJ_AVG_COST "Ext AC",
       --MAN.EXT_AVG_COGS_AMOUNT "EXT AC",
       MAN.UNIT_INV_COST "Unit Inv",
       MAN.REPLACEMENT_COST "Unit Rep",
       MAN.LIST_PRICE "List",
       MAN.ORDER_ENTRY_DATE "Ord Date",
       MAN.PRICE_FORMULA "Form",
       MAN.PRICE_CODE "PrCd",
       --MAN.PRICE_CATEGORY_OVR "PR CAT OVERRIDE",
       MAN.TYPE_OF_SALE "Sales Channel",
       MAN.REF_BID_NUMBER "Bid #",
       MAN.SOURCE_SYSTEM "Source",
       MAN.MASTER_VENDOR_NAME "Mfg",
       NULL "Pr Ovr Basis",
       MAN.DISCOUNT_GROUP_NAME "DG Description",
       MAN.COPY_SOURCE_HIST,
       MAN.INVOICE_DATE "Invoice Date",
       MAN.SALESREP_NK "Slsm",
       MAN.SALESREP_NAME "Sales Rep Name",
       MAN.CUSTOMER_TYPE "Cutomer Type",
       BG_CT.BUSINESS_GROUP "Bus Broup",
       BG_CT.CUSTOMER_GROUP "Cust Group",
       MAN.PR_OVR "Pr Ovr",
       MAN.GR_OVR "Gr Ovr",
       MAN.BASE_GROUP_FORM "Base Group Form",
       MAN.JOB_GROUP_FORM "Job Group Form",
       MAN.BASE_PROD_FORM "Base Prod Form",
       MAN.JOB_PROD_FORM "Job Prod Form"
  FROM AAA6863.PR_VICT2_MANUAL_1WK_CCORS_PBI MAN
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON MAN.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
			 
			 LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG_CT
			 		ON (MAN.CUSTOMER_TYPE = BG_CT.CUSTOMER_TYPE)
			 LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG_CT
          ON (MAN.CUSTOMER_TYPE = BG_CT.CUSTOMER_TYPE)
			 
 WHERE     COALESCE (MAN.PRICE_CATEGORY_OVR_PR,
                     MAN.PRICE_CATEGORY_OVR_GR,
                     MAN.PRICE_CATEGORY) IN ('TOOLS',
                                             'MANUAL',
                                             'QUOTE',
                                             'OTH/ERROR')
       --AND MAN.ACCOUNT_NUMBER = '2000'  --IN ('480', '190', '61', '1550')
       AND LENGTH (MAN.PRICE_FORMULA) <> 7
       AND MAN.PRICE_CODE <> 'C'
       AND UPPER (MAN.PRICE_FORMULA) <> 'SPEC'
       AND UPPER (MAN.ALT1_CODE) <> 'APPDEP'
			 AND NOT MAN.WAREHOUSE_NUMBER IN ( '90',
																				 '288',
																				 '464',
																				 '533',
																				 '761',
																				 '5351',
																				 '8090',
																				 '9009',
																				 '2920',
																				 '2934')
       --AND (MAN.ACCOUNT_NAME NOT LIKE ('INT%'))
       /*AND (MAN.ACCOUNT_NAME NOT IN ('TRINIDAD',
                                        'BARBADOS',
                                        'PANAMA',
                                        'CARIBBEAN'))*/
       /*AND (MAN.WAREHOUSE_NUMBER = '5350' 
			 			OR (SUBSTR (SWD.REGION_NAME, 1, 3) IN ('D10',
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
																									 'D59')
																									 ))*/
       AND NOT UPPER (MAN.ALT1_CODE) LIKE ('SP-%')
ORDER BY MAN.ACCOUNT_NAME,
       MAN.WRITER, 
       MAN.CUSTOMER_NAME;