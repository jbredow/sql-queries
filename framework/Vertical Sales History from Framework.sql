--TRUNCATE TABLE AAD9606.PR_SPLY_12MO_SLS;
--DROP TABLE AAD9606.PR_SPLY_12MO_SLS;
CREATE TABLE AAD9606.PR_SPLY_12MO_SLS
NOLOGGING
AS
   SELECT TPD.ROLL12MONTHS,
          SWD.DIVISION_NAME
             REGION,
          SWD.REGION_NAME
             DISTRICT,
          SWD.ACCOUNT_NAME,
          CUST.PRICE_COLUMN,
          --MEGA.REG_ACCT_NAME,
          --IHF.WAREHOUSE_NUMBER WHSE,
          -- NVL(BG.BUSINESS_GROUP,'OTHER') CUST_BUS_GRP,
          -- CHAN.ORDER_CHANNEL,
          NVL (PROD.DISCOUNT_GROUP_NK, 'SP-')
             DISC_GRP,
          DG.DISCOUNT_GROUP_NAME,
          PROD.ALT1_CODE,
          PROD.PRODUCT_NAME,
          -- CUST.SALESMAN_CODE REP_INIT,
          -- NVL(REPS.SALESREP_NAME, 'UNKNOWN') SALESREP_NAME,
          CASE
             WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                HIST.PRICE_CATEGORY_OVR_GR,
                                HIST.PRICE_CATEGORY) IN
                         ('MANUAL', 'QUOTE', 'MATRIX_BID')
                  AND HIST.ORIG_PRICE_CODE IS NOT NULL
             THEN
                CASE
                   WHEN     REGEXP_LIKE (HIST.orig_price_code,
                                         '[0-9]?[0-9]?[0-9]')
                        AND LENGTH (HIST.PRICE_FORMULA) = 7
                   THEN
                      'MATRIX'
                   WHEN HIST.orig_price_code IN ('FC', 'PM', 'spec')
                   THEN
                      'MATRIX'
                   WHEN HIST.orig_price_code LIKE 'M%'
                   THEN
                      'NDP'
                   WHEN HIST.orig_price_code IN ('CPA', 'CPO')
                   THEN
                      'OVERRIDE'
                   WHEN HIST.orig_price_code IN ('PR',
                                                 'GR',
                                                 'CB',
                                                 'GJ',
                                                 'PJ',
                                                 '*G',
                                                 '*P',
                                                 'G*',
                                                 'P*',
                                                 'G',
                                                 'GJ',
                                                 'P')
                   THEN
                      'OVERRIDE'
                   WHEN HIST.orig_price_code IN ('GI',
                                                 'GPC',
                                                 'HPF',
                                                 'HPN',
                                                 'NC')
                   THEN
                      'MANUAL'
                   WHEN HIST.orig_price_code = '*E'
                   THEN
                      'OTH/ERROR'
                   WHEN HIST.orig_price_code = 'SKC'
                   THEN
                      'OTH/ERROR'
                   WHEN HIST.orig_price_code IN ('%',
                                                 '$',
                                                 'N',
                                                 'F',
                                                 'B',
                                                 'PO')
                   THEN
                      'TOOLS'
                   WHEN HIST.orig_price_code IS NULL
                   THEN
                      'MANUAL'
                   ELSE
                      'MANUAL'
                END
             ELSE
                COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                          HIST.PRICE_CATEGORY_OVR_GR,
                          HIST.PRICE_CATEGORY)
          END
             PRICE_CATEGORY_FINAL,
          SUM (HIST.EXT_SALES_AMOUNT)
             EXT_SALES_AMOUNT,
          COUNT (HIST.INVOICE_LINE_NUMBER)
             TOTAL_LINES,
          SUM (HIST.EXT_AVG_COGS_AMOUNT)
             AVG_COGS,
          SUM (HIST.CORE_ADJ_AVG_COST)
             EXT_AVG_COGS_AMOUNT,
          COUNT (DISTINCT IHF.CUSTOMER_ACCOUNT_GK) CUSTOMERS   
   FROM PRICE_MGMT.PR_PRICE_CAT_HIST HIST
        INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
           ON (    HIST.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
               AND HIST.YEARMONTH = IHF.YEARMONTH)
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK
       -- INNER JOIN PRICE_MGMT.MEGA_BRANCHES MEGA
       --    ON IHF.WAREHOUSE_NUMBER = MEGA.WHSE
        -- USE FOR ROLL12MONTH AND FYTD GROUPINGS
        INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
           ON HIST.YEARMONTH = TPD.YEARMONTH
        -- USE FOR CUSTOMER BUS GRP SALESREP REPORTING
           INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
              ON IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
          /*   LEFT OUTER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
              ON CUST.CUSTOMER_TYPE = BG.CUSTOMER_TYPE
             LEFT OUTER JOIN PRICE_MGMT.CURRENT_SALESREP REPS
              ON CUST.ACCCOUNT_NAME = REPS.ACCOUNT_NAME
                AND CUST.SALESMAN_CODE = REPS.SALESREP_NK
              */
        -- USE FOR CHANNEL TYPE ANALYSIS
        /*   INNER JOIN SALES_MART.INVOICE_CHANNEL_DIMENSION CHAN
              ON IHF.INVOICE_NUMBER_GK = CHAN.INVOICE_NUMBER_GK */
        -- USE FOR PRODUCT AND DISCOUNT GROUP
        INNER JOIN DW_FEI.PRODUCT_DIMENSION PROD
           ON HIST.PRODUCT_GK = PROD.PRODUCT_GK
        INNER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
           ON PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
        INNER JOIN AAD9606.XREF_ITEMS_SPLYCOM S
           ON PROD.PRODUCT_NK = S.PRODUCT_NK
   WHERE     TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'
         --AND MEGA.REG_ACCT_NAME IN ('TALLAHASSEE','JAX','ORLANDO')
         AND SUBSTR (SWD.DIVISION_NAME, 0, 4) IN ('NORT',
                                                  'SOUT',
                                                  'EAST',
                                                  'WEST')
   -- AND ILF.PRODUCT_NK IN ('3916528', '7345096', '1203376', '1394851', '1899154', '392227', '4087354', '1395295', '4845558', '7606039', '7218785', '7233816', '4421856', '7608980', '3866980', '3755523', '4811170', '4427169', '7574543', '7062812', '7523517', '6206447', '7190521', '7559530', '3910383', '4828363', '5084195', '2437460', '4570551', '7316654', '4937194', '1855808', '7586061', '4570580', '4570558', '7505772', '4915154', '4160134', '2484038', '7043680', '1260111', '1898659', '3809995', '5164422', '4806721', '7628684', '5082066', '7601488', '4272910', '7238821', '7586081', '7252602', '7607120', '7588514', '7545448', '7546030', '7171559', '7541200', '7541208', '7541265', '7115636', '7638645', '4592952')
   GROUP BY TPD.ROLL12MONTHS,
            SWD.REGION_NAME,
            SWD.DIVISION_NAME,
            SWD.ACCOUNT_NAME,
            CUST.PRICE_COLUMN,
            --MEGA.REG_ACCT_NAME,
            --IHF.WAREHOUSE_NUMBER,
            -- NVL(BG.BUSINESS_GROUP,'OTHER'),
            -- CHAN.ORDER_CHANNEL,
            NVL (PROD.DISCOUNT_GROUP_NK, 'SP-'),
            DG.DISCOUNT_GROUP_NAME,
            PROD.ALT1_CODE,
            PROD.PRODUCT_NAME,
            -- CUST.SALESMAN_CODE,
            -- NVL(REPS.SALESREP_NAME, 'UNKNOWN'),
            CASE
               WHEN     COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                                  HIST.PRICE_CATEGORY_OVR_GR,
                                  HIST.PRICE_CATEGORY) IN
                           ('MANUAL', 'QUOTE', 'MATRIX_BID')
                    AND HIST.ORIG_PRICE_CODE IS NOT NULL
               THEN
                  CASE
                     WHEN     REGEXP_LIKE (HIST.orig_price_code,
                                           '[0-9]?[0-9]?[0-9]')
                          AND LENGTH (HIST.PRICE_FORMULA) = 7
                     THEN
                        'MATRIX'
                     WHEN HIST.orig_price_code IN ('FC', 'PM', 'spec')
                     THEN
                        'MATRIX'
                     WHEN HIST.orig_price_code LIKE 'M%'
                     THEN
                        'NDP'
                     WHEN HIST.orig_price_code IN ('CPA', 'CPO')
                     THEN
                        'OVERRIDE'
                     WHEN HIST.orig_price_code IN ('PR',
                                                   'GR',
                                                   'CB',
                                                   'GJ',
                                                   'PJ',
                                                   '*G',
                                                   '*P',
                                                   'G*',
                                                   'P*',
                                                   'G',
                                                   'GJ',
                                                   'P')
                     THEN
                        'OVERRIDE'
                     WHEN HIST.orig_price_code IN ('GI',
                                                   'GPC',
                                                   'HPF',
                                                   'HPN',
                                                   'NC')
                     THEN
                        'MANUAL'
                     WHEN HIST.orig_price_code = '*E'
                     THEN
                        'OTH/ERROR'
                     WHEN HIST.orig_price_code = 'SKC'
                     THEN
                        'OTH/ERROR'
                     WHEN HIST.orig_price_code IN ('%',
                                                   '$',
                                                   'N',
                                                   'F',
                                                   'B',
                                                   'PO')
                     THEN
                        'TOOLS'
                     WHEN HIST.orig_price_code IS NULL
                     THEN
                        'MANUAL'
                     ELSE
                        'MANUAL'
                  END
               ELSE
                  COALESCE (HIST.PRICE_CATEGORY_OVR_PR,
                            HIST.PRICE_CATEGORY_OVR_GR,
                            HIST.PRICE_CATEGORY)
            END;