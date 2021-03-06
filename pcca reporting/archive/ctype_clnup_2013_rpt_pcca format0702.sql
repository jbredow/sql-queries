SELECT	PCCU.ACCOUNT_NAME "Account Name", 
		PCCU.CUST_NK "Cust #",
		PCCU.CUSTOMER_ALPHA "Cust Alpha",
		PCCU.CUSTOMER_NAME "Customer Name",
		PCCU.MAIN_CUST_NK "Main Cust #",
		PCCU.SALES_12M "Sales 12M",
		PCCU.LAST_SALE "Last Sale",
		PCCU.PC_ALIGN "PC Align",
		--add customer type section
		PCCU.CTYPE "Cust Type",
		NULL AS "New Ctype",
		PCCU.CTYPE_CATEGORY "Ctype Cat",
		PCCU.CTYPE_SUB_CAT "Ctype Sub Cat",
		PCCU.MAIN_CTYPE "Main Ctype",
		--CHECK IF CTYPE IS ALIGNED WITH MAIN
		CASE WHEN PCCU.CTYPE = PCCU.MAIN_CTYPE 
			THEN 'Y' ELSE 'N' 
		END
			AS "Main Ctype Aligned",		
		--add price column section
		PCCU.PC "PC",
		NULL AS NEW_PC,
		PCCU.PC_NAME "PC Name",
		PCCU.PC_CATEGORY "PC Cat",
		PCCU.PC_SUB_CAT "PC Sub Cat",
		PCCU.MAIN_PC "Main PC",
		--CHECK IF COLUMN IS ALIGNED WITH MAIN
		CASE WHEN PCCU.PC = PCCU.MAIN_PC 
			THEN 'Y' ELSE 'N' 
		END
			AS "Main PC Aligned",		
		--other info
		PCCU.MSTR_TYPE "Master Type",
		PCCU.MSTR_CUSTNO "Master Cust #",
		PCCU.MSTR_CUST_NAME "Cust Name",
		PCCU.CUST_STATUS "Cust St",		
		PCCU.HOUSE "House",
		PCCU.BRANCH_KOB "BR KOB",
		PCCU.KOB_ALIGN "KOB Align",
		PCCU.WHSE "Whse",
		PCCU.CREDIT_CODE "Cr Cd",
		PCCU.CREDIT_LIMIT "Cr Limit",
		PCCU.CROSS_ACCT "Cross Acct",
		PCCU.CROSS_CUST "Cross Cust",
		PCCU.SETUP_DATE "Setup Date",
		PCCU.SLSM_CODE "Slsm Code",
		PCCU.SLSM_NAME "Slsm Name",
		PCCU.ACCT_NK "Acct #",
		PCCU."JOB"
	FROM (SELECT DISTINCT C.CUST_GK,
				C.BRANCH_KOB,
				C.KOB_ALIGN,
				C.ACCOUNT_NAME,
				C.HOUSE,
				C.CUST_NK,
				C.CUSTOMER_NAME,
				C.JOB,
				C.MAIN_CUST_NK,
				C.SALES_12M,
				C.LAST_SALE,
				C.PC_ALIGN,
				C.PC,
				NULL AS NEW_PC,
				C.PC_NAME,
				CD.PRICE_COLUMN AS MAIN_PC,
				C.PC_CATEGORY,
				C.PC_SUB_CAT,
				C.CTYPE,
				NULL AS NEW_CTYPE,
				C.CTYPE_CATEGORY,
				C.CTYPE_SUB_CAT,
				CD.CUSTOMER_TYPE AS MAIN_CTYPE,
				C.SIC_CATEGORY,
				C.SIC_SUB_CAT,
				C.WHSE,
				C.MSTR_TYPE,
				C.MSTR_CUSTNO,
				C.MSTR_CUST_NAME,
				C.CUSTOMER_ALPHA,
				C.CUST_STATUS,
				C.CREDIT_CODE,
				C.CREDIT_LIMIT,
				C.CROSS_ACCT,
				C.CROSS_CUST,
				C.SETUP_DATE,
				C.SLSM_CODE,
				C.SLSM_NAME,
				C.ACCT_NK,
				C.RPC
			FROM AAD9606.CTYPE_REVIEW_2013 C,
				(--SELECT MAIN CUSTOMER INFORMATION FROM THE CUSTOMER DIMENSION
				SELECT DISTINCT ACCOUNT_NAME,
								MAIN_CUSTOMER_NK,
								PRICE_COLUMN,
								CUSTOMER_TYPE
				FROM DW_FEI.CUSTOMER_DIMENSION
				WHERE DELETE_DATE IS NULL AND JOB_YN = 'N') CD
			WHERE C.ACCOUNT_NAME = CD.ACCOUNT_NAME
				AND C.MAIN_CUST_NK = CD.MAIN_CUSTOMER_NK) PCCU
	WHERE PCCU.RPC IN (
						--'Atlantic'--,
						'Midwest'--,
						--'Southern'--,
						--'Western'
						)
	ORDER BY	PCCU.ACCOUNT_NAME ASC,
			PCCU.PC ASC,
			PCCU.CUSTOMER_NAME ASC;