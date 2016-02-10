(SELECT 
		WPF.PRODUCT_GK ITEM_GK,
		WHSE.ACCOUNT_NUMBER_NK ACCT,
		WHSE.ACCOUNT_NAME ACCT_NAME,
		WPF.WAREHOUSE_NK,
		WPF.PRODUCT_NK,
		PROD.ALT1_CODE,
		PROD.PRODUCT_NAME PROD_DESC,
		PROD.OBSOLETE_FLAG OBS,
		PROD.OBS_DATE,
		WPF.STATUS_TYPE,
		(WPF.LIST_PR) BRANCH_LIST,
		BDG.DISC_TO_COST,
		BDG.RAW_DISC_TO_COST,
		CASE
			WHEN WPF.LIST_PR = PROD.LIST_PRICE
			THEN 'Y'
			ELSE 'N'
		END LIST_ALIGNED,
		WPF.BASIS_2,
		WPF.BASIS_3,
		WPF.BASIS_4,
		WPF.BASIS_5,
		WPF.BASIS_6,
		WPF.BASIS_7,
		WPF.BASIS_8,
		WPF.BASIS_9,
		WPF.CUST_ORD_QTY,
		WPF.DEMAND_12_MONTHS,
		WPF.EXTENDED_VALUE,
		WPF.ON_HAND_QTY,
		WPF.UM_CODE,
		WPF.WHSE_AVG_COST_AMOUNT,
		WPF.YEARMONTH,
		PROD.LIST_PRICE MSTR_LIST,
		PROD.PRIOR_LIST_PRICE PRIOR_MSTR_LIST,
		PROD.BASIS_2 MSTR_BASIS_2,
		PROD.UPC_CODE,
		PROD.VENDOR_CODE,
		PROD.DISCOUNT_GROUP_NK DISC_GRP,
		DISC_GRP.DISCOUNT_GROUP_NAME,
		PROD.LINEBUY_NK,
		LINEBUY.LINEBUY_NAME,
		PROD.MANUFACTURER MFR,
		VEND.MASTER_VENDOR_NAME MFR_NAME,
		CORP_PRICE.TYPE_OF_PRICING

FROM 
		DW_FEI.WAREHOUSE_PRODUCT_FACT WPF,
		DW_FEI.WAREHOUSE_DIMENSION WHSE,
		DW_FEI.PRODUCT_DIMENSION PROD,
		DW_FEI.DISCOUNT_GROUP_DIMENSION DISC_GRP,
		DW_FEI.LINE_BUY_DIMENSION LINEBUY,
		DW_FEI.MASTER_VENDOR_DIMENSION VEND,
		AAD9606.VDR_TYPE_OF_PRICING_V CORP_PRICE,
		DW_FEI.BRANCH_DISC_GROUP_DIMENSION BDG,
		BRANCH_CONTACTS
	
WHERE 
		WPF.WAREHOUSE_GK     			= WHSE.WAREHOUSE_GK
		--AND NVL (WPF.STATUS_TYPE, 'STOCK') IN
			   --('STOCK', 'NN', 'NV', 'S', 'NQ')
		--AND WPF.LIST_PR 				<> PROD.LIST_PRICE
		AND WHSE.ACCOUNT_NAME 			IN 'KC'
		--AND PROD.DISCOUNT_GROUP_NK 	IN '7045'
		--AND PROD.LIST_PRICE 			<> 0
		--AND PROD.LIST_PRICE 			= 0
		--AND WHSE.ACCOUNT_NAME 		NOT IN 'DIST'
		--AND WHSE.ACCOUNT_NAME 		NOT LIKE 'INT%'
		--AND PROD.PRODUCT_NAME 		LIKE '%LP%'
		AND WPF.PRODUCT_GK         		= PROD.PRODUCT_GK
		AND PROD.DISCOUNT_GROUP_GK 		= DISC_GRP.DISCOUNT_GROUP_GK
		AND PROD.LINEBUY_GK        		= LINEBUY.LINEBUY_GK
		AND PROD.MANUFACTURER      		= VEND.MASTER_VENDOR_NK
		AND PROD.DISCOUNT_GROUP_GK 		= BDG.DISCOUNT_GROUP_GK
		AND PROD.MANUFACTURER      		= CORP_PRICE.VENDOR_NO(+)
		AND WHSE.ACCOUNT_NUMBER_NK 		= BRANCH_CONTACTS.ACCOUNT_NK
		AND WHSE.ACCOUNT_NUMBER_NK 		= BDG.ACCOUNT_NUMBER_NK
		AND (WPF.YEARMONTH =
				(SELECT MAX (wpf.YEARMONTH)
						FROM DW_FEI.WAREHOUSE_PRODUCT_FACT wpf
						WHERE WPF.YEARMONTH BETWEEN TO_CHAR (
												TRUNC (
												   SYSDATE - 
														NUMTOYMINTERVAL (2, 'MONTH'),
												   'MONTH'),
												'YYYYMM')
                         AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')))
		AND BRANCH_CONTACTS.DISTRICT = IN ('C10','C11','C12')

GROUP BY 
		PF.PRODUCT_GK,
		WHSE.ACCOUNT_NUMBER_NK,
		WHSE.ACCOUNT_NAME,
		WPF.WAREHOUSE_NK,
		WPF.PRODUCT_NK,
		PROD.ALT1_CODE,
		PROD.PRODUCT_NAME,
		PROD.OBSOLETE_FLAG,
		PROD.OBS_DATE,
		WPF.STATUS_TYPE,
		BDG.DISC_TO_COST,
		BDG.RAW_DISC_TO_COST,
		WPF.BASIS_2,
		WPF.BASIS_3,
		WPF.BASIS_4,
		WPF.BASIS_5,
		WPF.BASIS_6,
		WPF.BASIS_7,
		WPF.BASIS_8,
		WPF.BASIS_9,
		WPF.CUST_ORD_QTY,
		WPF.DEMAND_12_MONTHS,
		WPF.EXTENDED_VALUE,
		WPF.ON_HAND_QTY,
		WPF.UM_CODE,
		WPF.WHSE_AVG_COST_AMOUNT,
		WPF.YEARMONTH,
		PROD.LIST_PRICE,
		PROD.PRIOR_LIST_PRICE,
		PROD.BASIS_2,
		PROD.UPC_CODE,
		PROD.VENDOR_CODE,
		PROD.DISCOUNT_GROUP_NK,
		DISC_GRP.DISCOUNT_GROUP_NAME,
		PROD.LINEBUY_NK,
		LINEBUY.LINEBUY_NAME,
		PROD.MANUFACTURER,
		VEND.MASTER_VENDOR_NAME,
		CORP_PRICE.TYPE_OF_PRICING,
		WPF.LIST_PR,
		BRANCH_CONTACTS.DISTRICT
)