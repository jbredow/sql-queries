/* 
	use for monthly reports in toolbox
	AAE0376 - Jenn
	AAD9606 - Leigh
	AAA6863 - Joe
 */

SELECT MAN.ACCOUNT_NAME,
       MAN.ACCOUNT_NUMBER "BR #",
       MAN.OML_ASSOC_INI "OML INI",
       MAN.WRITER "WRITER",
       MAN.PRICE_COLUMN "PC",
       MAN.WAREHOUSE_NUMBER "SHIP WH",
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
       MAN.EXT_AVG_COGS_AMOUNT "EXT AC",
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
       MAN.INVOICE_DATE "INV_DATE",
       MAN.SALESREP_NK SLSM,
       MAN.SALESREP_NAME "REP. NAME"
  FROM AAD9606.PR_VICT2_MANUAL_2WK MAN
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON MAN.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
 WHERE     MAN.PRICE_CATEGORY IN ('TOOLS',
                                  'MANUAL',
                                  'QUOTE',
                                  'OTH/ERROR')
       --AND MAN.ACCOUNT_NUMBER IN ('480', '190', '61', '1550')
       AND LENGTH (MAN.PRICE_FORMULA) <> 7
       AND MAN.PRICE_CODE <> 'C'
       AND UPPER (MAN.PRICE_FORMULA) <> 'SPEC'
       AND UPPER (MAN.ALT1_CODE) <> 'APPDEP'
       AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN ('D10',
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
                                               'D59'))
       AND NOT UPPER (MAN.ALT1_CODE) LIKE ('SP-%')
ORDER BY MAN.ACCOUNT_NUMBER ASC, MAN.CUSTOMER_NAME ASC;