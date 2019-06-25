/* 
	  from AAA6863.GP_TRACKER_13MO GP_DATA
*/
 
SELECT 
	CASE	
		WHEN UPPER(GP_DATA.TYPE_OF_SALE) = 'SHOWROOM DIRECT' 
		THEN 'Showroom'
		ELSE GP_DATA.TYPE_OF_SALE
	END	
		"Sale Type",
	CASE
		WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
		WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
		WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
		ELSE GP_DATA.REGION
	END
		"Region",
	ACCT.ACCOUNT_NAME,
	GP_DATA.WAREHOUSE_NUMBER_NK WHSE,
	
	SUM (
		GP_DATA.SLS_SUBTOTAL
		+ GP_DATA.SLS_FREIGHT
		+ GP_DATA.SLS_MISC
		+ GP_DATA.SLS_RESTOCK)
					"Total Sales",
	SUM (GP_DATA.SLS_SUBTOTAL) "Sales, Sub-Total",
	SUM (GP_DATA.SLS_FREIGHT) "Sales, Freight",
	SUM (GP_DATA.SLS_MISC) "Sales, Misc",
	SUM (GP_DATA.SLS_RESTOCK) "Sales, Restock",
	SUM (
		GP_DATA.AVG_COST_SUBTOTAL
		+ GP_DATA.AVG_COST_FREIGHT
		+ GP_DATA.AVG_COST_MISC)
			"Total Cost",
	SUM (GP_DATA.AVG_COST_SUBTOTAL) "Cost, Sub-Total",
	SUM (GP_DATA.AVG_COST_FREIGHT) "Cost, Freight",
	SUM (GP_DATA.AVG_COST_MISC) "Cost, Misc",
	SUM (
		(GP_DATA.SLS_SUBTOTAL
			+ GP_DATA.SLS_FREIGHT
			+ GP_DATA.SLS_MISC
			+ GP_DATA.SLS_RESTOCK)
		- ( GP_DATA.AVG_COST_SUBTOTAL
			+ GP_DATA.AVG_COST_FREIGHT
			+ GP_DATA.AVG_COST_MISC))
				"Total GP$",
	ROUND (
		SUM (
			(  GP_DATA.SLS_SUBTOTAL
				+ GP_DATA.SLS_FREIGHT
				+ GP_DATA.SLS_MISC
				+ GP_DATA.SLS_RESTOCK)
			- (  GP_DATA.AVG_COST_SUBTOTAL
				+ GP_DATA.AVG_COST_FREIGHT
				+ GP_DATA.AVG_COST_MISC))
		/ SUM (
				CASE
					WHEN 
					GP_DATA.SLS_SUBTOTAL
					+ GP_DATA.SLS_FREIGHT
					+ GP_DATA.SLS_MISC
					+ GP_DATA.SLS_RESTOCK > 0
					THEN
					GP_DATA.SLS_SUBTOTAL
					+ GP_DATA.SLS_FREIGHT
					+ GP_DATA.SLS_MISC
					+ GP_DATA.SLS_RESTOCK
					ELSE 1
				END ),
	3)
		"Total GP%",
	SUM (GP_DATA.INVOICE_LINES) "Total # Lines",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
			THEN(GP_DATA.EXT_SALES)
			ELSE 0
		END)
			"Price Matrix Sales",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
			THEN (GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"Price Matrix Cost",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
			THEN(GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"Price Matrix GP$",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
				THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
				THEN
					CASE
						WHEN GP_DATA.EXT_SALES > 0 
						THEN (GP_DATA.EXT_SALES)
						ELSE 1
					END
				ELSE 1
		END),
	3)
		"Price Matrix GP%",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
				THEN (GP_DATA.EXT_SALES)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.SLS_SUBTOTAL > 0 
				THEN GP_DATA.SLS_SUBTOTAL
				ELSE 1
			END),
	3)
		"Price Matrix Use%$",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
				THEN (GP_DATA.INVOICE_LINES)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.INVOICE_LINES > 0 
				THEN GP_DATA.INVOICE_LINES
				ELSE 1
			END),
		3)
			"Price Matrix Use%#",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
				THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.ROLLUP = 'Total'
				THEN
					CASE
						WHEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs) > 0
						THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
						ELSE 1
					END
				ELSE 1
			END),
		3)
			"Price Matrix Profit%$",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID', 'NDP')
			THEN (GP_DATA.INVOICE_LINES)
			ELSE 0
		END)
			"Price Matrix # Lines",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
			THEN (GP_DATA.EXT_SALES)
			ELSE 0
		END)
			"Contract Sales",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
			THEN (GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"Contract Cost",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
			THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"Contract GP$",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
				THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
				THEN
					CASE
						WHEN GP_DATA.EXT_SALES > 0 THEN (GP_DATA.EXT_SALES)
						ELSE 1
					END
				ELSE
					1
			END),
		3)
			"Contract GP%",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
				THEN (GP_DATA.EXT_SALES)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.SLS_SUBTOTAL > 0 THEN GP_DATA.SLS_SUBTOTAL
				ELSE 1
			END),
		3)
			"Contract Use%$",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
				THEN (GP_DATA.INVOICE_LINES)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.INVOICE_LINES > 0 
				THEN GP_DATA.INVOICE_LINES
				ELSE 1
			END),
		3)
			"Contract Use%#",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
				THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.ROLLUP = 'Total'
				THEN
					CASE
						WHEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs) > 0
						THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
						ELSE 1
					END
				ELSE 1
			END),
		3)
			"Contract Profit%$",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN 'OVERRIDE'
			THEN (GP_DATA.INVOICE_LINES)
			ELSE 0
		END)
			"Contract # Lines",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
			THEN (GP_DATA.EXT_SALES)
			ELSE 0
		END)
			"Manual Sales",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
			THEN (GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"Manual Cost",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
			THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"Manual GP$",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
				THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
				THEN
					CASE
						WHEN GP_DATA.EXT_SALES > 0 
						THEN (GP_DATA.EXT_SALES)
						ELSE 1
					END
				ELSE 1
			END),
		3)
			"Manual GP%",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
				THEN (GP_DATA.EXT_SALES)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.SLS_SUBTOTAL > 0 
				THEN GP_DATA.SLS_SUBTOTAL
				ELSE 1
			END),
		3)
			"Manual Use%$",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
				THEN (GP_DATA.INVOICE_LINES)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.INVOICE_LINES > 0 
				THEN GP_DATA.INVOICE_LINES
				ELSE 1
			END),
		3)
			"Manual Use%#",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
				THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.ROLLUP = 'Total'
				THEN
					CASE
						WHEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs) > 0
						THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
						ELSE 1
					END
				ELSE 1
			END),
		3)
			"Manual Profit%$",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
			THEN (GP_DATA.INVOICE_LINES)
			ELSE 0
		END)
			"Manual # Lines",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY NOT IN
				('MATRIX',
				'OVERRIDE',
				'MANUAL',
				'CREDITS',
        'NDP', 
				'TOOLS',
				'QUOTE',
				'MATRIX_BID',
				'Total')
			THEN (GP_DATA.EXT_SALES)
			ELSE 0
		END)
			"Other Sales",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY NOT IN
				('MATRIX',
				'OVERRIDE',
				'MANUAL',
				'CREDITS',
				'TOOLS',
        'NDP', 
				'QUOTE',
				'MATRIX_BID',
				'Total')
			THEN (GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"OtherCost",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY NOT IN
				('MATRIX',
				'OVERRIDE',
				'MANUAL',
				'CREDITS',
				'TOOLS',
        'NDP', 
				'QUOTE',
				'MATRIX_BID',
				'Total')
			THEN (GP_DATA.EXT_SALES-GP_DATA.core_avg_cogs)
			ELSE 0
		END)
			"OtherGP$",
	ROUND(
		SUM(
			CASE
				WHEN GP_DATA.PRICE_CATEGORY NOT IN
					('MATRIX',
					'OVERRIDE',
					'MANUAL',
					'CREDITS',
					'TOOLS',
          'NDP', 
					'QUOTE',
					'MATRIX_BID',
					'Total')
				THEN (GP_DATA.EXT_SALES-GP_DATA.core_avg_cogs)
				ELSE 0
			END)
		/SUM(
		CASE
			WHEN GP_DATA.PRICE_CATEGORY NOT IN
				('MATRIX',
				'OVERRIDE',
				'MANUAL',
				'CREDITS',
				'TOOLS',
        'NDP', 
				'QUOTE',
				'MATRIX_BID',
				'Total')
			THEN
				CASE
					WHEN GP_DATA.EXT_SALES>0
					THEN(GP_DATA.EXT_SALES)
					ELSE 1
				END
			ELSE 1
		END),
	3)
		"OtherGP%",
	ROUND(
		SUM(
			CASE
				WHEN GP_DATA.PRICE_CATEGORY NOT IN
					('MATRIX',
					'OVERRIDE',
					'MANUAL',
					'CREDITS',
					'TOOLS',
          'NDP', 
					'QUOTE',
					'MATRIX_BID',
					'Total')
				THEN (GP_DATA.EXT_SALES)
				ELSE 0
			END)
			/SUM(
				CASE
					WHEN GP_DATA.SLS_SUBTOTAL>0
					THEN GP_DATA.SLS_SUBTOTAL
					ELSE 1
				END),
		3)
			"OtherUse%$",
	ROUND(
		SUM(
			CASE
				WHEN GP_DATA.PRICE_CATEGORY NOT IN
					('MATRIX',
					'OVERRIDE',
					'MANUAL',
					'CREDITS',
					'TOOLS',
          'NDP', 
					'QUOTE',
					'MATRIX_BID',
					'Total')
				THEN (GP_DATA.INVOICE_LINES)
				ELSE 0
			END)
			/SUM(
				CASE
					WHEN GP_DATA.INVOICE_LINES>0
					THEN GP_DATA.INVOICE_LINES
					ELSE 1
				END),
			3)
				"OtherUse%#",
   ROUND (
	  SUM (
		 CASE
			WHEN GP_DATA.PRICE_CATEGORY NOT IN
					('MATRIX',
					 'OVERRIDE',
					 'MANUAL',
					 'CREDITS',
					 'TOOLS',
           'NDP', 
					 'QUOTE',
					 'MATRIX_BID',
					 'Total')
			THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
			ELSE 0
		END)
		/ SUM (
			CASE
				WHEN GP_DATA.ROLLUP = 'Total'
				THEN
					CASE
						WHEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs) > 0
						THEN (GP_DATA.EXT_SALES - GP_DATA.core_avg_cogs)
						ELSE 1
					END
				ELSE 1
			END),
		3)
			"Other Profit%$",
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY NOT IN
				('MATRIX',
				'OVERRIDE',
				'MANUAL',
				'CREDITS',
				'TOOLS',
        'NDP', 
				'QUOTE',
				'MATRIX_BID',
				'Total')
			THEN (GP_DATA.INVOICE_LINES)
			ELSE 0
		END)
		  "Other # Lines",
  SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
				THEN(GP_DATA.EXT_SALES)
				ELSE	0
			END) "Credit Sales",
	ROUND (
		SUM (
			CASE
				WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
				THEN(GP_DATA.EXT_SALES)
				ELSE	0
			END)
		/ SUM (
			CASE
				WHEN GP_DATA.SLS_SUBTOTAL > 0 
				THEN GP_DATA.SLS_SUBTOTAL
				ELSE 1
			END),
	3)
		"Credits Use%$",
	ROUND (
	SUM (
		CASE
			WHEN GP_DATA.PRICE_CATEGORY IN ('CREDITS')
			THEN	(GP_DATA.INVOICE_LINES)
			ELSE 0
		END)
	/ SUM (
		CASE
			WHEN GP_DATA.INVOICE_LINES > 0 
			THEN GP_DATA.INVOICE_LINES
			ELSE 1
		END),
	3)
		"Credits Use%#",
	SUM (GP_DATA.SLS_FREIGHT - GP_DATA.AVG_COST_FREIGHT)
		"Freight Profit (Loss)",
  SUM (
             CASE
                WHEN GP_DATA.PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
                THEN
                   (GP_DATA.EXT_SALES)
                ELSE
                   0
             END)
             "Outbound Sales"

FROM  PRICE_MGMT.GP_TRACKER_13MO GP_DATA,

		(SELECT WD.ACCOUNT_NAME, WD.ACCOUNT_NUMBER_NK, WD.WAREHOUSE_NUMBER_NK
          FROM AAD9606.PR_SLS_WHSE_DIM WD
         GROUP BY WD.ACCOUNT_NAME, 
				 					WD.ACCOUNT_NUMBER_NK, 
									WD.WAREHOUSE_NUMBER_NK
							) ACCT
							
	WHERE GP_DATA.ACCOUNT_NUMBER = ACCT.ACCOUNT_NUMBER_NK(+)
		AND GP_DATA.WAREHOUSE_NUMBER_NK = ACCT.WAREHOUSE_NUMBER_NK
		AND GP_DATA.YEARMONTH = TO_CHAR (
                                   TRUNC (
                                    SYSDATE
                                    - NUMTOYMINTERVAL (
                                       1,
                                       'MONTH'),
                                    'MONTH'),
                                   'YYYYMM')
 	
	HAVING SUM (GP_DATA.SLS_SUBTOTAL) <> 0

GROUP BY 
	CASE	
		WHEN UPPER(GP_DATA.TYPE_OF_SALE) = 'SHOWROOM DIRECT' 
		THEN 'Showroom'
		ELSE GP_DATA.TYPE_OF_SALE
	END,
	CASE
		WHEN GP_DATA.REGION IS NULL THEN ACCT.ACCOUNT_NAME
		WHEN GP_DATA.REGION = 'EAST' THEN 'EASTERN'
		WHEN GP_DATA.REGION = 'WEST' THEN 'WESTERN'
		ELSE GP_DATA.REGION
	END,
	ACCT.ACCOUNT_NAME,
	GP_DATA.WAREHOUSE_NUMBER_NK

ORDER BY GP_DATA.WAREHOUSE_NUMBER_NK
;