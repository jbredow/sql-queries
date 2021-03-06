SELECT DISTINCT 
	CUST.ACCOUNT_NAME 	        	AS "Branch",
	IHF.CUSTOMER_NUMBER_NK      	AS "Cust No",
	CUST.CUSTOMER_NAME				AS "Customer Name",
	IHF.INVOICE_NUMBER_NK 			AS "Inv #",
	IHF.INVOICE_DATE      			AS "Inv Date",
	IHF.PO_NUMBER         			AS "PO#",
	CUST.JOB_YN                 	AS "Job?",
	IHF.JOB_NAME          			AS "Job Name/Notes",
	NVL ( ILF.PRODUCT_NUMBER_NK, SP_PROD.SPECIAL_PRODUCT_NK ) "Product #",
	NVL ( PD.ALT1_CODE, SP_PROD.ALT_CODE ) "Alt 1",
	PD.PRODUCT_NAME 		  		AS "Product Description",
	ILF.ORDERED_QTY           		AS "Ord Quan",
	ILF.SHIPPED_QTY           		AS "Ship Quan",
	ILF.EXT_SALES_AMOUNT      		AS "Ext Sales",
	ILF.UNIT_NET_PRICE_AMOUNT 		AS "Discounted Price Each", 
	NVL(ILF.LIST_PRICE, NULL) 		AS "List Price",
	CASE
		WHEN ILF.LIST_PRICE > 0
		THEN ROUND(ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE, 3)
		ELSE 0
	END 							AS "Calc Mult",
	ILF.PRICE_FORMULA 				AS "Formula",
	CASE
		WHEN ILF.LIST_PRICE > 0
		THEN 1 - ROUND(ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE, 3)
		ELSE NULL
	END								AS "Calc Mult",
	NVL ( BVD.VENDOR_NAME, SP_PROD.PRIMARY_VNDR ) "Mfg Name"

FROM DW_FEI.INVOICE_HEADER_FACT IHF
	LEFT JOIN DW_FEI.INVOICE_LINE_FACT ILF
		ON IHF.INVOICE_NUMBER_GK    			= ILF.INVOICE_NUMBER_GK
		AND ILF.CUSTOMER_ACCOUNT_GK 			= IHF.CUSTOMER_ACCOUNT_GK
		
	INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
		ON  CUST.ACCOUNT_NUMBER_NK 				= IHF.ACCOUNT_NUMBER
		AND CUST.CUSTOMER_GK       				= IHF.CUSTOMER_ACCOUNT_GK
		
	INNER JOIN UW_CUSTOMER_LIST
		ON  UW_CUSTOMER_LIST.BR_NK    			= IHF.ACCOUNT_NUMBER
		AND UW_CUSTOMER_LIST.CUST_NK 			= IHF.CUSTOMER_NUMBER_NK
		
	LEFT JOIN DW_FEI.PRODUCT_DIMENSION PD
		ON PD.PRODUCT_GK 						= ILF.PRODUCT_GK
		
	LEFT JOIN DW_FEI.WAREHOUSE_PRODUCT_FACT WPF
		ON WPF.PRODUCT_GK = PD.PRODUCT_GK
		AND IHF.SHIP_FROM_WAREHOUSE_GK          = WPF.WAREHOUSE_GK
		
	INNER JOIN DW_FEI.BRANCH_VENDOR_DIMENSION BVD
		ON IHF.BRANCH_VENDOR_GK                 = BVD.VENDOR_GK
		AND BVD.ACCOUNT_NUMBER_NK 				= IHF.ACCOUNT_NUMBER
    
	LEFT JOIN DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
		ON ILF.SPECIAL_PRODUCT_GK 				= SP_PROD.SPECIAL_PRODUCT_GK

		
WHERE ILF.SHIPPED_QTY <> 0
	AND TRUNC(IHF.PROCESS_DATE) BETWEEN TRUNC(SysDate - 8) 
		AND TRUNC(SysDate - 1)

ORDER BY CUST.ACCOUNT_NAME,
	CUST.CUSTOMER_NAME;