-- Please press Visualize Query context menu item to synchronize query and diagram after editing.

SELECT TPD.FISCAL_YEAR_TO_DATE
          AS TPD,
       SWD.DIVISION_NAME
          AS REGION,
       SWD.REGION_NAME
          AS DISTRICT,
       IHF.ACCOUNT_NUMBER
          AS ACCT_NK,
       SWD.ACCOUNT_NAME,
       IHF.YEARMONTH,
       DECODE (IHF.SALE_TYPE,
               '1', 'Our Truck',
               '2', 'Counter',
               '3', 'Direct',
               '4', 'Counter',
               '5', 'Credit Memo',
               '6', 'Showroom',
               '7', 'Showroom Direct',
               '8', 'eBusiness')
          AS TYPE_OF_SALE,
       EMP.TITLE_DESC,
       REPS.SALESREP_NK,
       REPS.SALESREP_NAME,
       CASE
          WHEN REPS.EMPLOYEE_NUMBER_NK IS NULL
          THEN
             'H/U'
          WHEN (   EMP.TITLE_DESC LIKE '%O/S%'
                OR EMP.TITLE_DESC LIKE 'Out Sales%'
                OR EMP.TITLE_DESC LIKE 'Sales Rep%')
          THEN
             'O/S'
          ELSE
             'H/A'
       END
          AS HOUSE_FLAG,
       NVL (PROD.DISCOUNT_GROUP_NK, 'SP-')
          AS DISCOUNT_GROUP_NK,
       COUNT (ILF.INVOICE_LINE_NUMBER)
          AS LINES,
       SUM (ILF.EXT_AVG_COGS_AMOUNT)
          AS AVG_COGS,
       SUM (ILF.EXT_ACTUAL_COGS_AMOUNT)
          AS INVOICE_COGS,
       SUM (ILF.EXT_SALES_AMOUNT)
          AS SALES,
       SUM (ILF.CORE_ADJ_AVG_COST)
          AS CORE_ADJ_AC,
       SUM (ILF.CORE_ADJ_AVG_COST)
          CORE_ADJ_AVG_COGS,
       SUM (
          CASE
             WHEN ILF.SUM_MV_CLAIM_AMOUNT > 0
             THEN
                ILF.CORE_ADJ_AVG_COST
             WHEN CORE.SUBLINE_COST IS NOT NULL AND CORE.SUBLINE_QTY IS NULL
             THEN
                  CORE.SUBLINE_COST
                * ILF.SHIPPED_QTY
                / NVL (PROD.SELL_PACKAGE_QTY, 1)
             ELSE
                ILF.EXT_AVG_COGS_AMOUNT
          END)
          CORE_COST_SUBTOTAL
FROM (((((((DW_FEI.INVOICE_HEADER_FACT IHF
            INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
               ON (IHF.YEARMONTH = TPD.YEARMONTH))
           INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
              ON     (ILF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK)
                 AND (ILF.YEARMONTH = IHF.YEARMONTH))
          RIGHT OUTER JOIN DW_FEI.INVOICE_LINE_CORE_FACT CORE
             ON     (CORE.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK)
                AND (CORE.INVOICE_LINE_NUMBER = ILF.INVOICE_LINE_NUMBER))
         RIGHT OUTER JOIN DW_FEI.PRODUCT_DIMENSION PROD
            ON (ILF.PRODUCT_GK = PROD.PRODUCT_GK))
        INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
           ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK))
       INNER JOIN DW_FEI.SALESREP_DIMENSION REPS
          ON     (CUST.ACCOUNT_NUMBER_NK = REPS.ACCOUNT_NUMBER_NK)
             AND (CUST.SALESMAN_CODE = REPS.SALESREP_NK))
      RIGHT OUTER JOIN DW_FEI.EMPLOYEE_DIMENSION EMP
         ON (EMP.EMPLOYEE_TRILOGIE_NK = REPS.EMPLOYEE_NUMBER_NK))
     INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
        ON (IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK)
WHERE     NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
      AND TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
      AND IHF.IC_FLAG = 0
      AND ILF.SHIPPED_QTY <> 0
      AND IHF.PO_WAREHOUSE_NUMBER IS NULL
      AND SWD.DIVISION_NAME IN ('EAST REGION',
                                'HVAC REGION',
                                'NORTH CENTRAL REGION',
                                'SOUTH CENTRAL REGION',
                                'WEST REGION'                              --,
                                             --'WATERWORKS REGION'
                                             )
      --AND IHF.ACCOUNT_NUMBER = '1480'
GROUP BY TPD.FISCAL_YEAR_TO_DATE,
         SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         IHF.ACCOUNT_NUMBER,
         SWD.ACCOUNT_NAME,
         IHF.YEARMONTH,
         DECODE (IHF.SALE_TYPE,
                 '1', 'Our Truck',
                 '2', 'Counter',
                 '3', 'Direct',
                 '4', 'Counter',
                 '5', 'Credit Memo',
                 '6', 'Showroom',
                 '7', 'Showroom Direct',
                 '8', 'eBusiness'),
         EMP.TITLE_DESC,
         REPS.SALESREP_NK,
         REPS.SALESREP_NAME,
         CASE
            WHEN REPS.EMPLOYEE_NUMBER_NK IS NULL
            THEN
               'H/U'
            WHEN (   EMP.TITLE_DESC LIKE '%O/S%'
                  OR EMP.TITLE_DESC LIKE 'Out Sales%'
                  OR EMP.TITLE_DESC LIKE 'Sales Rep%')
            THEN
               'O/S'
            ELSE
               'H/A'
         END,
         NVL (PROD.DISCOUNT_GROUP_NK, 'SP-');