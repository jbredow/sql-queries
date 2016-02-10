SELECT * 
FROM (
	SELECT DISTINCT 
		CUST.ACCOUNT_NAME 				AS "Branch",
		IHF.CUSTOMER_NUMBER_NK          AS "Cust No",
		CUST.CUSTOMER_NAME              AS "Customer Name",
		IHF.INVOICE_NUMBER_NK           AS "Inv #",
		IHF.INVOICE_DATE                AS "Inv Date",
		IHF.PO_NUMBER                   AS PO#,
		CUST.JOB_YN                     AS "Job?",
		IHF.JOB_NAME                    AS "Job Name/Notes",
		NVL(WPF.DISCOUNT_GROUP_NK, SP_PROD.SPECIAL_DISC_GROUP)  AS DG,
		NVL(ILF.PRODUCT_NUMBER_NK, SP_PROD.SPECIAL_PRODUCT_NK) "Product #",
		NVL(PD.ALT1_CODE, SP_PROD.ALT_CODE) "Alt 1",
		PD.VENDOR_CODE            		AS "Vend Cd",
		PD.PRODUCT_NAME           		AS "Product Description",
		ILF.ORDERED_QTY           		AS "Ord Quan",
		ILF.SHIPPED_QTY           		AS "Ship Quan",
		ILF.EXT_SALES_AMOUNT      		AS "Ext Sales",
		ILF.UNIT_NET_PRICE_AMOUNT 		AS "Discounted Price Each",
		NVL(ILF.LIST_PRICE, NULL) 		AS "List Price",
		CASE
			WHEN ILF.LIST_PRICE > 0
			THEN ROUND(ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE, 3)
			ELSE 0
		END               AS "Calc Mult",
		ILF.PRICE_FORMULA AS "Formula",
		CASE
			WHEN ILF.LIST_PRICE > 0
			THEN 1 - ROUND(ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE, 3)
			ELSE NULL
		END                    AS "Calc Disc",
		MVD.MASTER_VENDOR_NAME AS "Manufacturer",
		CASE
			WHEN IPF.PAID_METHOD = 'VI'
			THEN 'P-Card'
			ELSE NULL
		END
		AS P_CARD
		
	FROM DW_FEI.INVOICE_HEADER_FACT IHF
		LEFT JOIN DW_FEI.INVOICE_LINE_FACT ILF
			ON IHF.INVOICE_NUMBER_GK    = ILF.INVOICE_NUMBER_GK
			AND ILF.CUSTOMER_ACCOUNT_GK = IHF.CUSTOMER_ACCOUNT_GK
		LEFT JOIN DW_FEI.CUSTOMER_DIMENSION CUST
			ON CUST.CUSTOMER_NK        = IHF.CUSTOMER_NUMBER_NK
			AND CUST.ACCOUNT_NUMBER_NK = IHF.ACCOUNT_NUMBER

		LEFT JOIN DW_FEI.PRODUCT_DIMENSION PD
			ON PD.PRODUCT_GK = ILF.PRODUCT_GK
		LEFT JOIN DW_FEI.WAREHOUSE_PRODUCT_FACT WPF
			ON WPF.PRODUCT_GK              = PD.PRODUCT_GK
			AND IHF.SHIP_FROM_WAREHOUSE_GK = WPF.WAREHOUSE_GK
		LEFT JOIN DW_FEI.BRANCH_VENDOR_DIMENSION BVD
			ON IHF.BRANCH_VENDOR_GK   = BVD.VENDOR_GK
			AND BVD.ACCOUNT_NUMBER_NK = IHF.ACCOUNT_NUMBER
		LEFT JOIN DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
			ON ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK
		LEFT JOIN DW_FEI.MASTER_VENDOR_DIMENSION MVD
			ON PD.MANUFACTURER = MVD.MASTER_VENDOR_NK
		LEFT JOIN DW_FEI.INVOICE_PAYMETHOD_FACT IPF
			ON IPF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK

	WHERE ILF.SHIPPED_QTY   <> 0
		AND IHF.YEARMONTH BETWEEN '201404' AND '201405'

	ORDER BY CUST.ACCOUNT_NAME,
		CUST.CUSTOMER_NAME,
		NVL(WPF.DISCOUNT_GROUP_NK, SP_PROD.SPECIAL_DISC_GROUP),
		NVL(PD.ALT1_CODE, SP_PROD.ALT_CODE)) INV
WHERE INV.DG IN('0552',
				'0554',
				'0555',
				'0558',
				'0564',
				'0876',
				'0877',
				'5853',
				'5854')
        AND INV."Branch" IN ('NASH', 'OHVAL')
		;