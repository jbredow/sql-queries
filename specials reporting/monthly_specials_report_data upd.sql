/* 
	use for monthly reports in toolbox
 */
SELECT DISTINCT

/*
	CASE
		WHEN SP.ACCOUNT_NAME = 'ATLANTA'
		THEN 'ORL'
		ELSE SP.ACCOUNT_NAME
	END
		AS ACCOUNT_NAME,
	CASE
		WHEN SP.ACCOUNT_NUMBER = '107'
		THEN '52'
		ELSE SP.ACCOUNT_NUMBER
	END
		AS ACCOUNT_NUMBER,*/
    
  SP.ACCOUNT_NAME,
  SP.ACCOUNT_NUMBER,
	SP.WRITER WRITER,
	SP.OML_ASSOC_NAME ASSOC_NAME,
	SP.WAREHOUSE_NUMBER SHIP_WH,
	SP.INVOICE_NUMBER_NK INV_NK,
	SP.ALT1_CODE ALT_1,
	SP.PRODUCT_NAME PRODUCT,
	SP.STATUS ST,
	SP.UM "U/M",
	SP.DISCOUNT_GROUP_NK DG,
	DG.DISCOUNT_GROUP_NAME DG_NAME,
	SP.SHIPPED_QTY SHPD,
	SP.EXT_SALES_AMOUNT EXT_NET,
	SP.CORE_ADJ_AVG_COST EXT_AC,
	SP.TYPE_OF_SALE SALE_TYPE,
	SP.ORDER_CODE ORDER_CODE,
	SP.CUSTOMER_NK CUST_#,
	SP.CUSTOMER_NAME CUST_NAME,
	SP.PRICE_FORMULA "FORM",
	SP.PRICE_CODE PRCD,
	KOB.CATEGORY KOB,
	SP.CUSTOMER_TYPE

FROM	PRICE_MGMT.PR_VICT2_CUST_12MO SP
	LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
		ON SP.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
	--LEFT OUTER JOIN AAF1046.BRANCH_CONTACTS BC
	--	ON SP.ACCOUNT_NUMBER = BC.ACCOUNT_NK
	INNER JOIN
			SALES_MART.SALES_WAREHOUSE_DIM SWD
			ON ( SP.ACCOUNT_NUMBER = SWD.ACCOUNT_NUMBER_NK )
	INNER JOIN AAM1365.DG_BY_KOB KOB
			ON KOB.DG_NK = DG.DISCOUNT_GROUP_NK
			
WHERE SP.STATUS IN ('SP-', 'SP')
	AND SP.EXT_SALES_AMOUNT >= 0
  --AND SP.ACCOUNT_NAME IN ('ATLANTA', 'ORL')
	/*AND SP.ACCOUNT_NUMBER IN ('1350',
														'3370',
														'3014',
														'1001',
														'2504',
														'686',
														'3017',
														'3007',
														'109',
														'794',
														'1183',
														'1401',
														'1693',
														'716',
														'1743',
														'3371',
														'3067'
														)*/
	-- AND SP.PRICE_CODE <> 'C'

	/*AND UPPER(BC.RPC) = 'SOUTHERN'
	AND UPPER(BC.RPC) = 'WESTERN'
	AND UPPER(BC.RPC) = 'ATLANTIC'
	AND UPPER(BC.RPC) = 'MIDWEST'*/

	-- AND NOT UPPER(SP.ALT1_CODE) LIKE('SP-%')
	AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN (
        'D01', 'D02', 'D03', 'D04', 'D05', 
        'D10', 'D11', 'D12', 'D13',
        'D14', 'D30', 'D31', 'D32',
        'D41', 'D50', 'D51', 'D53'
      	)
			)
ORDER BY
/*
	CASE
		WHEN SP.ACCOUNT_NUMBER = '107'
		THEN '52'
		ELSE SP.ACCOUNT_NUMBER
	END ASC, */
  SP.ACCOUNT_NUMBER ASC,
	SP.DISCOUNT_GROUP_NK ASC,
	SP.ALT1_CODE ASC
	;