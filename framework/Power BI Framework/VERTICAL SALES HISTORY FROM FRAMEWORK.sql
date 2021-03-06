--TRUNCATE TABLE AAD9606.PR_SPLY_12MO_SLS;
--DROP TABLE AAD9606.PR_SPLY_12MO_SLS;


   SELECT TPD.ROLL12MONTHS,
          TPD.FISCAL_YEAR_TO_DATE,
          HIST.EOM_YEARMONTH,
          SWD.DIVISION_NAME
             REGION,
          SWD.REGION_NAME
             DISTRICT,
          SWD.ACCOUNT_NAME,
          SWD.ACCOUNT_NUMBER_NK,
          CUST.PRICE_COLUMN,
          NVL (AREA.RPT_NAME, SWD.ACCOUNT_NAME)
             AREA,
          HIST.WAREHOUSE_NUMBER
             WHSE,
          NVL (BG.BUSINESS_GROUP, 'OTHER')
             CUST_BUS_GRP,
          CHAN.ORDER_CHANNEL,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-')
             DISC_GRP,
          DG.DISCOUNT_GROUP_NAME,
          --PROD.PRODUCT_NK,
          --PROD.ALT1_CODE,
          --PROD.PRODUCT_NAME,
          IHF.WRITER,
          CUST.SALESMAN_CODE
             REP_INIT,
          NVL (REPS.SALESREP_NAME, 'UNKNOWN')
             SALESREP_NAME,
          CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL
             THEN
                CUST.MAIN_CUSTOMER_NK
             ELSE
                'HOUSE'
          END
             AS MAIN_CUST,
          CASE
             WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL THEN CUST.CUSTOMER_NAME
             ELSE 'HOUSE UNASSIGNED'
          END
             AS CUSTOMER_NAME,
          DECODE (HIST.PRICE_CATEGORY_FINAL,
                  'MATRIX', 'MATRIX',
                  'MATRIX_BID', 'MATRIX',
                  'NDP', 'MATRIX',
                  'MANUAL', 'MANUAL',
                  'QUOTE', 'MANUAL',
                  'TOOLS', 'MANUAL',
                  'OVERRIDE', 'CCOR',
                  'SPECIALS', 'SP-',
                  HIST.PRICE_CATEGORY_FINAL)
             PRICE_CATEGORY,
          SUM (HIST.EXT_SALES_AMOUNT)
             EXT_SALES_AMT,
          COUNT (HIST.INVOICE_LINE_NUMBER)
             INVOICE_LINES,
          SUM (HIST.EXT_AVG_COGS_AMOUNT)
             AVG_COGS_AMT,
          SUM (HIST.CORE_ADJ_AVG_COST)
             CORE_COGS_AMT,
          SUM (HIST.EXT_ACTUAL_COGS_AMOUNT)
             INVOICE_COGS_AMT
   FROM PRICE_MGMT.PR_PRICE_CAT_HIST HIST
        INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
           ON (    HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
               AND HIST.YEARMONTH = IHF.YEARMONTH)
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON TO_CHAR(HIST.WAREHOUSE_NUMBER) = SWD.WAREHOUSE_NUMBER_NK
        LEFT OUTER JOIN PRICE_MGMT.RPT_AREA_VW AREA
           ON TO_CHAR(HIST.WAREHOUSE_NUMBER) = AREA.WHSE
        --  LEFT OUTER JOIN PRICE_MGMT.MEGA_BRANCHES MEGA
        --     ON IHF.WAREHOUSE_NUMBER = MEGA.WHSE
        -- USE FOR ROLL12MONTH AND FYTD GROUPINGS
        INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
           ON HIST.YEARMONTH = TPD.YEARMONTH
        -- USE FOR CUSTOMER BUS GRP
        INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
           ON HIST.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
        LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
           ON COALESCE (CUST.BMI_BUDGET_CUST_TYPE,
                        CUST.BMI_REPORT_CUST_TYPE,
                        CUST.CUSTOMER_TYPE) =
              BG.CUSTOMER_TYPE
        -- USE FOR SALESREP REPORTING
        LEFT OUTER JOIN PRICE_MGMT.CURRENT_SALESREP REPS
           ON     CUST.ACCOUNT_NAME = REPS.ACCOUNT_NAME
              AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
        -- USE FOR CHANNEL TYPE ANALYSIS
        INNER JOIN SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN
           ON IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK
        -- USE FOR PRODUCT AND DISCOUNT GROUP
        LEFT OUTER JOIN DW_FEI.PRODUCT_DIMENSION PROD
           ON HIST.PRODUCT_GK = PROD.PRODUCT_GK
        LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
           ON PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
   WHERE HIST.YEARMONTH BETWEEN 201808 AND 201811
   
   --TPD.ROLL12MONTHS IS NOT NULL
   --AND           MEGA.REG_ACCT_NAME IN ('TALLAHASSEE','JAX','ORLANDO')
   /*  AND SUBSTR (SWD.DIVISION_NAME, 0, 4) IN ('NORT',
                                              'SOUT',
                                              'EAST',
                                              'WEST')*/
   --AND PROD.DISCOUNT_GROUP_NK IN ( /*LIST DGS HERE '0001','0002', ETC*/ )
   -- AND ILF.PRODUCT_NK IN ('3916528', '7345096', '1203376', '1394851', '1899154', '392227', '4087354', '1395295', '4845558', '7606039', '7218785', '7233816', '4421856', '7608980', '3866980', '3755523', '4811170', '4427169', '7574543', '7062812', '7523517', '6206447', '7190521', '7559530', '3910383', '4828363', '5084195', '2437460', '4570551', '7316654', '4937194', '1855808', '7586061', '4570580', '4570558', '7505772', '4915154', '4160134', '2484038', '7043680', '1260111', '1898659', '3809995', '5164422', '4806721', '7628684', '5082066', '7601488', '4272910', '7238821', '7586081', '7252602', '7607120', '7588514', '7545448', '7546030', '7171559', '7541200', '7541208', '7541265', '7115636', '7638645', '4592952')
   GROUP BY TPD.ROLL12MONTHS,
            TPD.FISCAL_YEAR_TO_DATE,
            --HIST.YEARMONTH,
            HIST.EOM_YEARMONTH,
            SWD.REGION_NAME,
            SWD.DIVISION_NAME,
            SWD.ACCOUNT_NAME,
            SWD.ACCOUNT_NUMBER_NK,
            CUST.PRICE_COLUMN,
            NVL (AREA.RPT_NAME, SWD.ACCOUNT_NAME),
            HIST.WAREHOUSE_NUMBER,
            NVL (BG.BUSINESS_GROUP, 'OTHER'),
            CHAN.ORDER_CHANNEL,
            NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
            DG.DISCOUNT_GROUP_NAME,
            --PROD.PRODUCT_NK,
            --PROD.ALT1_CODE,
            --PROD.PRODUCT_NAME,
            IHF.WRITER,
            CUST.SALESMAN_CODE,
            NVL (REPS.SALESREP_NAME, 'UNKNOWN'),
            DECODE (HIST.PRICE_CATEGORY_FINAL,
                    'MATRIX', 'MATRIX',
                    'MATRIX_BID', 'MATRIX',
                    'NDP', 'MATRIX',
                    'MANUAL', 'MANUAL',
                    'QUOTE', 'MANUAL',
                    'TOOLS', 'MANUAL',
                    'OVERRIDE', 'CCOR',
                    'SPECIALS', 'SP-',
                    HIST.PRICE_CATEGORY_FINAL),
            CASE
               WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL
               THEN
                  CUST.MAIN_CUSTOMER_NK
               ELSE
                  'HOUSE'
            END,
            CASE
               WHEN REPS.EMPLOYEE_NUMBER_NK IS NOT NULL
               THEN
                  CUST.CUSTOMER_NAME
               ELSE
                  'HOUSE UNASSIGNED'
            END