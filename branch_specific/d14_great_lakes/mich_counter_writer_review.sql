SELECT VICT2.ACCOUNT_NUMBER AS BR_NO,
       VICT2.WRITER,
       EMP.ASSOC_NAME,
       EMP.WAREHOUSE_ASSIGNED_NK AS WHSE,
       SUM (VICT2.EXT_SALES_AMOUNT) AS CTR_SALES,
       SUM (VICT2.EXT_SALES_AMOUNT) - SUM (VICT2.EXT_AVG_COGS_AMOUNT)
          AS CTR_GP,
       ROUND ( (SUM (VICT2.EXT_SALES_AMOUNT) - SUM (VICT2.EXT_AVG_COGS_AMOUNT))
              / CASE
                   WHEN SUM (VICT2.EXT_SALES_AMOUNT) > 0
                   THEN
                      SUM (VICT2.EXT_SALES_AMOUNT)
                   ELSE
                      1
                END,
              3
       )
          GP_PCT,
       SUM(CASE
              WHEN VICT2.ALT1_CODE LIKE 'SP-%' THEN VICT2.EXT_SALES_AMOUNT
              ELSE 0
           END)
          SP_SALES,
       SUM(CASE
              WHEN VICT2.ALT1_CODE LIKE 'SP-%'
              THEN
                 (VICT2.EXT_SALES_AMOUNT - VICT2.EXT_AVG_COGS_AMOUNT)
              ELSE
                 0
           END)
          SP_SALES,
			 
			 ROUND ( SUM(CASE
              WHEN VICT2.ALT1_CODE LIKE 'SP-%'
              THEN
                 (VICT2.EXT_SALES_AMOUNT - VICT2.EXT_AVG_COGS_AMOUNT)
              ELSE
                 0
           END)
				 / SUM(CASE
              WHEN VICT2.ALT1_CODE LIKE 'SP-%' THEN VICT2.EXT_SALES_AMOUNT
              ELSE 1
           END), 3 )
					SP_GP,
					
					
       XX.TICKETS,
       XX.LINES
  FROM       AAE0376.PR_VICT2_CUST_12MO VICT2
          LEFT OUTER JOIN
             DW_FEI.EMPLOYEE_DIMENSION EMP
          ON (VICT2.ACCOUNT_NAME = EMP.ACCOUNT_NAME)
             AND (VICT2.WRITER = EMP.INITIALS)
       LEFT OUTER JOIN
          (SELECT VICT.ACCOUNT_NUMBER,
                  VICT.WRITER,
                  COUNT (DISTINCT VICT.INVOICE_NUMBER_NK) AS TICKETS,
                  COUNT (VICT.ACCOUNT_NAME) AS LINES
             FROM AAE0376.PR_VICT2_CUST_12MO VICT
            WHERE (VICT.ACCOUNT_NUMBER = '2000')
                  AND (VICT.TYPE_OF_SALE = 'Counter')
           GROUP BY VICT.ACCOUNT_NUMBER, VICT.WRITER, VICT.TYPE_OF_SALE) XX
       ON VICT2.ACCOUNT_NUMBER = XX.ACCOUNT_NUMBER
          AND VICT2.WRITER = XX.WRITER
 WHERE (VICT2.ACCOUNT_NUMBER = '2000') AND (VICT2.TYPE_OF_SALE = 'Counter')
GROUP BY VICT2.ACCOUNT_NUMBER,
         VICT2.WRITER,
         EMP.ASSOC_NAME,
         EMP.WAREHOUSE_ASSIGNED_NK,
         XX.TICKETS,
         XX.LINES
ORDER BY VICT2.WRITER ASC, EMP.WAREHOUSE_ASSIGNED_NK ASC;