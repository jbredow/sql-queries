TRUNCATE TABLE AAA6863.PR_CORE_YOY_FW;

DROP TABLE AAA6863.PR_CORE_YOY_FW;

CREATE TABLE AAA6863.PR_CORE_YOY_FW
NOLOGGING
AS
SELECT TPD.FISCAL_YEAR_TO_DATE
          AS TPD,
       SWD.DIVISION_NAME
          AS REGION,
       SWD.REGION_NAME
          AS DISTRICT,
       SWD.ACCOUNT_NUMBER_NK,
       SWD.ACCOUNT_NAME,
       P_CAT.EOM_YEARMONTH,
       DECODE (IHF.SALE_TYPE,
               '1', 'Our Truck',
               '2', 'Counter',
               '3', 'Direct',
               '4', 'Counter',
               '5', 'Credit Memo',
               '6', 'Showroom',
               '7', 'Showroom Direct',
               '8', 'eBusiness')
          TYPE_OF_SALE,
       IHF.SALE_TYPE,
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
       SUM (P_CAT.EXT_AVG_COGS_AMOUNT)
          AS AVG_COGS,
       SUM (P_CAT.EXT_ACTUAL_COGS_AMOUNT)
          AS INVOICE_COGS,
       SUM (P_CAT.EXT_SALES_AMOUNT)
          AS EXT_SALES_AMOUNT,
       SUM (P_CAT.CORE_ADJ_AVG_COST)
          AS CORE_ADJ_AVG_COST,
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
FROM ((((((((PRICE_MGMT.PR_PRICE_CAT_HIST P_CAT
             INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON (P_CAT.EOM_YEARMONTH = TPD.YEARMONTH))
            LEFT OUTER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
               ON (P_CAT.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK))
           LEFT OUTER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
              ON     (IHF.INVOICE_NUMBER_GK = P_CAT.INVOICE_NUMBER_GK)
                 AND (IHF.EOM_YEARMONTH = P_CAT.EOM_YEARMONTH))
          
          INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
             ON     (ILF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK)
                AND (ILF.PRODUCT_GK = P_CAT.PRODUCT_GK)
                AND (ILF.EOM_YEARMONTH = IHF.EOM_YEARMONTH))
         
         INNER JOIN DW_FEI.INVOICE_LINE_CORE_FACT CORE
            ON     (CORE.INVOICE_LINE_NUMBER = ILF.INVOICE_LINE_NUMBER)
               AND (CORE.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK))
        
        LEFT OUTER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
           ON (P_CAT.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK))
       
       INNER JOIN DW_FEI.SALESREP_DIMENSION REPS
          ON     (CUST.ACCOUNT_NUMBER_NK = REPS.ACCOUNT_NUMBER_NK)
             AND (CUST.SALESMAN_CODE = REPS.SALESREP_NK))
      INNER JOIN DW_FEI.EMPLOYEE_DIMENSION EMP
         ON (REPS.EMPLOYEE_NUMBER_NK = EMP.EMPLOYEE_TRILOGIE_NK))
     INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
        ON (P_CAT.PRODUCT_GK = PROD.PRODUCT_GK)
WHERE     NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
      --AND IHF.ACCOUNT_NUMBER = '52'
      AND IHF.IC_FLAG = 0
      AND IHF.PO_WAREHOUSE_NUMBER IS NULL
      AND SWD.DIVISION_NAME IN ('EAST REGION',
                                'HVAC REGION',
                                'CENTRAL REGION',
                                'WEST REGION'      --,
                                --'WATERWORKS REGION'
                                             )
GROUP BY TPD.FISCAL_YEAR_TO_DATE,
         SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         P_CAT.EOM_YEARMONTH,
         DECODE (IHF.SALE_TYPE,
                 '1', 'Our Truck',
                 '2', 'Counter',
                 '3', 'Direct',
                 '4', 'Counter',
                 '5', 'Credit Memo',
                 '6', 'Showroom',
                 '7', 'Showroom Direct',
                 '8', 'eBusiness'),
         IHF.SALE_TYPE,
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