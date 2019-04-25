/* 
	use for weekly manual reports #toolbox
   updated w/  CORE_ADJ_AVG_COST
      added    MAN.PRICE_CATEGORY_OVR_PR,
               MAN.PRICE_CATEGORY_OVR_GR
 */

SELECT MAN.ACCOUNT_NAME,
       MAN.ACCOUNT_NUMBER "BR #",
       MAN.YEARMONTH,
       MAN.OML_ASSOC_INI "OML INI",
       MAN.WRITER "WRITER",
       MAN.PRICE_COLUMN "PC",
       MAN.WAREHOUSE_NUMBER "SELL WH",
       MAN.INVOICE_NUMBER_NK "INV #",
       MAN.SHIP_VIA_NAME "VIA",
       MAN.INVOICE_LINE_NUMBER "INV LINE",
       MAN.ORDER_CODE "ORDER CODE",
       MAN.CUSTOMER_NK "CUST #",
       MAN.CUSTOMER_NAME "CUST NAME",
       MAN.ALT1_CODE "ALT 1",
       MAN.PRODUCT_NAME "PRODUCT",
       MAN.STATUS "ST",
       MAN.UM "U/M",
       MAN.DISCOUNT_GROUP_NK "DG",
       MAN.SHIPPED_QTY "SHPD",
       MAN.UNIT_NET_PRICE_AMOUNT "UNIT NET",
       ROUND (MAN.EXT_AVG_COGS_AMOUNT / MAN.SHIPPED_QTY, 2) "UNIT AC",
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
       MAN.MATRIX_PRICE "MATRIX",
       ROUND (MAN.UNIT_NET_PRICE_AMOUNT - MAN.MATRIX_PRICE, 2) "MATRIX VAR",
       MAN.EXT_SALES_AMOUNT "EXT NET",
       MAN.CORE_ADJ_AVG_COST "EXT AC",
       --MAN.EXT_AVG_COGS_AMOUNT "EXT AC",
       MAN.UNIT_INV_COST "UNIT INV",
       MAN.REPLACEMENT_COST "UNIT REP",
       MAN.LIST_PRICE "LIST",
       MAN.ORDER_ENTRY_DATE "ORD DATE",
       MAN.PRICE_FORMULA "FORM",
       MAN.PRICE_CODE "PRCD",
       --MAN.PRICE_CATEGORY_OVR "PR CAT OVERRIDE",

       MAN.TYPE_OF_SALE "SALE TYPE",
       MAN.REF_BID_NUMBER "BID #",
       MAN.SOURCE_SYSTEM "SOURCE",
       MAN.MASTER_VENDOR_NAME "MFG",
       --MAN.PR_OVR "PR OVR",
       NULL "PR OVR BASIS",
       --MAN.GR_OVR "GRP OVR",
       MAN.DISCOUNT_GROUP_NAME "DG Description",
       MAN.COPY_SOURCE_HIST,
       MAN.INVOICE_DATE,
       MAN.SALESREP_NK SLSM,
       MAN.SALESREP_NAME "REP. NAME",
       MAN.CUSTOMER_TYPE,
       BG_CT.BUSINESS_GROUP,
       BG_CT.CUSTOMER_GROUP,
       MAN.PR_OVR,
       MAN.GR_OVR,
       MAN.BASE_GROUP_FORM,
       MAN.JOB_GROUP_FORM,
       MAN.BASE_PROD_FORM,
       MAN.JOB_PROD_FORM
  FROM AAM1365.PR_VICT2_MANUAL_1WK_CCORS MAN
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
       AND NOT MAN.YEARMONTH BETWEEN '210803' AND '201808'
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
ORDER BY MAN.ACCOUNT_NUMBER ASC, MAN.CUSTOMER_NAME ASC;