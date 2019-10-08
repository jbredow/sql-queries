SELECT TPD.FISCAL_YEAR_TO_DATE,
       SWD.DIVISION_NAME
          AS REGION,
       SWD.REGION_NAME
          AS DISTRICT,
       SWD.ACCOUNT_NUMBER_NK
          AS ACCOUNT_NUMBER,
       SWD.ACCOUNT_NAME,
       PC_HIST.YEARMONTH,
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
       PC_HIST.INVOICE_LINE_NUMBER
          AS LINES,
       PC_HIST.EXT_AVG_COGS_AMOUNT
          AS AVG_COGS,
       PC_HIST.EXT_ACTUAL_COGS_AMOUNT
          INVOICE_COGS,
       PC_HIST.EXT_SALES_AMOUNT
          SALES,
       PC_HIST.CORE_ADJ_AVG_COST,
       ILCF.CLAIM_AMOUNT,
       SUM (
          CASE
             WHEN     ILCF.SUBLINE_COST IS NOT NULL
                  AND NVL (ILCF.CLAIM_AMOUNT, 0) = 0
                  AND ILCF.COST_CODE_IND = 'C'
             THEN
                  ILF.EXT_AVG_COGS_AMOUNT
                - (  ILCF.SUBLINE_COST
                   * ILF.SHIPPED_QTY
                   / NVL (PROD.SELL_PACKAGE_QTY, 1))
             ELSE
                0
          END)
          COST_ONLY_ADJ,
       SUM (
            ILF.EXT_AVG_COGS_AMOUNT
          - NVL (ILF.CORE_ADJ_AVG_COST, ILF.EXT_AVG_COGS_AMOUNT))
          CORE_COST_DELTA
FROM ((((((((PRICE_MGMT.PR_PRICE_CAT_HIST PC_HIST
             INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON (PC_HIST.YEARMONTH = TPD.YEARMONTH))
            INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
               ON (PC_HIST.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK))
           INNER JOIN PRICE_MGMT.PR_SLS_WHSE_DIM SWD
              ON (PC_HIST.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK))
          INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
             ON     (PC_HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK)
                AND (PC_HIST.YEARMONTH = IHF.YEARMONTH))
         INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
            ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK))
        INNER JOIN DW_FEI.SALESREP_DIMENSION REPS
           ON     (CUST.ACCOUNT_NUMBER_NK = REPS.ACCOUNT_NUMBER_NK)
              AND (CUST.SALESMAN_CODE = REPS.SALESREP_NK))
       INNER JOIN DW_FEI.EMPLOYEE_DIMENSION EMP
          ON (EMP.EMPLOYEE_TRILOGIE_NK = REPS.EMPLOYEE_NUMBER_NK))
      INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
         ON (PC_HIST.PRODUCT_GK = PROD.PRODUCT_GK))
     INNER JOIN DW_FEI.INVOICE_LINE_CORE_FACT ILCF
        ON     (PC_HIST.INVOICE_NUMBER_GK = ILCF.INVOICE_NUMBER_GK)
           AND (ILCF.INVOICE_LINE_NUMBER = ILF.INVOICE_LINE_NUMBER)
WHERE     (TPD.FISCAL_YEAR_TO_DATE IS NOT NULL)
      AND IHF.PO_WAREHOUSE_NUMBER IS NULL
      AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
      AND IHF.IC_FLAG = 0
      AND SWD.DIVISION_NAME IN ('EAST REGION',
                                'HVAC REGION',
                                'NORTH CENTRAL REGION',
                                'SOUTH CENTRAL REGION',
                                'CENTRAL REGION',
                                --'WATERWORKS REGION',
                                'WEST REGION')
GROUP BY TPD.FISCAL_YEAR_TO_DATE,
         SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         PC_HIST.YEARMONTH,
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
         NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
         PC_HIST.INVOICE_LINE_NUMBER,
         PC_HIST.EXT_AVG_COGS_AMOUNT,
         PC_HIST.EXT_ACTUAL_COGS_AMOUNT,
         PC_HIST.EXT_SALES_AMOUNT,
         PC_HIST.CORE_ADJ_AVG_COST,
         ILCF.CLAIM_AMOUNT;