-- incomplete

SELECT --GP_DATA.YEARMONTH,
       GP_DATA.ORDER_CHANNEL
          AS CHANNEL,
       GP_DATA.DIVISION_NAME AS REGION,
       --GP_DATA.REGION_NAME AS DISTRICT,
       --GP_DATA.ACCOUNT_NUMBER_NK AS ACCOUNT_NUMBER,
       GP_DATA.ACCOUNT_NAME,
       GP_DATA.WAREHOUSE_NUMBER_NK,
       --GP_DATA.WAREHOUSE_NAME,
       --GP_DATA.WRITER AS WRITER_INIT,
       /*GP_DATA.REGION_NAME
       || '*'
       || GP_DATA.ACCOUNT_NUMBER_NK
       || '*'
       || GP_DATA.WRITER
       || GP_DATA.ORDER_CHANNEL
          AS GPTRACK_KEY,*/
       GP_DATA.EXT_SALES_AMOUNT
          AS EXT_SALES,
       GP_DATA.CORE_ADJ_AVG_COST
          AS CORE_COGS,
       GP_DATA.EXT_CORE_GP,
       ROUND (
          (CASE
              WHEN EXT_SALES_AMOUNT > 0 THEN EXT_CORE_GP / EXT_SALES_AMOUNT
              ELSE 0
           END),
          3)
          "Total GP%",
       GP_DATA.TOTAL_INV_LINES,
       GP_DATA.TOTAL_INV_COUNT,
       OUTBOUND_SALES,
       PRICE_MATRIX_SALES,
       PRICE_MATRIX_COST,
       PRICE_MATRIX_GP,
       ROUND (
          (CASE
              WHEN PRICE_MATRIX_SALES > 0
              THEN
                 PRICE_MATRIX_GP / PRICE_MATRIX_SALES
              ELSE
                 0
           END),
          3)
          "Price Matrix GP%",
       ROUND (
          (CASE
              WHEN OUTBOUND_SALES > 0
              THEN
                 PRICE_MATRIX_SALES / OUTBOUND_SALES
              ELSE
                 0
           END),
          3)
          "Price Matrix Use%$",
       ROUND (
          (CASE
              WHEN TOTAL_INV_LINES > 0
              THEN
                 PRICE_MATRIX_LINES / TOTAL_INV_LINES
              ELSE
                 0
           END),
          3)
          "Price Matrix Use%#",
       ROUND (
          (CASE
              WHEN EXT_CORE_GP > 0 THEN PRICE_MATRIX_GP / EXT_CORE_GP
              ELSE 0
           END),
          3)
          "Price Matrix Profit%$",
       PRICE_MATRIX_LINES,
       MATRIX_INVOICE_CNT,
       CONTRACT_SALES,
       CONTRACT_COST,
       CONTRACT_GPP,
       ROUND (
          (CASE
              WHEN CONTRACT_SALES > 0
              THEN
                 CONTRACT_GPP / CONTRACT_SALES
              ELSE
                 0
           END),
          3)
          "Contract GP%",
       ROUND (
          (CASE
              WHEN OUTBOUND_SALES > 0
              THEN
                 CONTRACT_SALES / OUTBOUND_SALES
              ELSE
                 0
           END),
          3)
          "Contract Use%$",
       ROUND (
          (CASE
              WHEN TOTAL_INV_LINES > 0
              THEN
                 CONTRACT_LINES / TOTAL_INV_LINES
              ELSE
                 0
           END),
          3)
          "Contract Use%#",
       ROUND (
          (CASE
              WHEN EXT_CORE_GP > 0 THEN CONTRACT_GPP / EXT_CORE_GP
              ELSE 0
           END),
          3)
          "Contract Profit%$",
       CONTRACT_LINES,
       CONTRACT_INV_CNT,
       MANUAL_SALES,
       MANUAL_COST,
       MANUAL_GP,
       ROUND (
          (CASE
              WHEN MANUAL_SALES > 0 THEN MANUAL_GP / MANUAL_SALES
              ELSE 0
           END),
          3)
          "Manual GP%",
       ROUND (
          (CASE
              WHEN OUTBOUND_SALES > 0
              THEN
                 MANUAL_SALES / OUTBOUND_SALES
              ELSE
                 0
           END),
          3)
          "Manual Use%$",
       ROUND (
          (CASE
              WHEN TOTAL_INV_LINES > 0
              THEN
                 MANUAL_LINES / TOTAL_INV_LINES
              ELSE
                 0
           END),
          3)
          "Manual Use%#",
       ROUND (
          (CASE
              WHEN EXT_CORE_GP > 0 THEN MANUAL_GP / EXT_CORE_GP
              ELSE 0
           END),
          3)
          "Manual Profit%$",
       MANUAL_LINES,
       MANUAL_INV_CNT,
       OTHER_SALES,
       OTHER_COST,
       OTHER_GP,
       ROUND (
          (CASE
              WHEN OTHER_SALES > 0 THEN OTHER_GP / OTHER_SALES
              ELSE 0
           END),
          3)
          "Other GP%",
       ROUND (
          (CASE
              WHEN OUTBOUND_SALES > 0 THEN OTHER_SALES / OUTBOUND_SALES
              ELSE 0
           END),
          3)
          "Other Use%$",
       ROUND (
          (CASE
              WHEN TOTAL_INV_LINES > 0 THEN OTHER_LINES / TOTAL_INV_LINES
              ELSE 0
           END),
          3)
          "Other Use%#",
       ROUND (
          (CASE
              WHEN EXT_CORE_GP > 0 THEN OTHER_GP / EXT_CORE_GP
              ELSE 0
           END),
          3)
          "Other Profit%$",
       OTHER_LINES,
       OTHER_INV_CNT,
       CREDIT_SALES,
       ROUND (
          (CASE
              WHEN OUTBOUND_SALES > 0 THEN CREDIT_SALES / OUTBOUND_SALES
              ELSE 0
           END),
          3)
          "Credits Use%$",
       ROUND (
          (CASE
              WHEN TOTAL_INV_LINES > 0 THEN CREDIT_LINES / TOTAL_INV_LINES
              ELSE 0
           END),
          3)
          "Credits Use%#",
       CREDIT_LINES
       
       
       
FROM (SELECT VICT2.YEARMONTH,
             VICT2.ORDER_CHANNEL,
             SWD.REGION_NAME,
             SWD.DIVISION_NAME,
             SWD.ACCOUNT_NUMBER_NK,
             SWD.ACCOUNT_NAME,
             SWD.WAREHOUSE_NAME,
             SWD.WAREHOUSE_NUMBER_NK,
             --VICT2.WRITER,
             VICT2.PRICE_CATEGORY,
             VICT2.ORIG_PRICE_CATEGORY,
             VICT2.GR_OVR,
             VICT2.PR_OVR,
             CASE
                WHEN     COALESCE (VICT2.PR_OVR,
                                   VICT2.GR_OVR,
                                   VICT2.PRICE_CATEGORY) IN
                            ('MANUAL', 'QUOTE', 'MATRIX_BID')
                     AND VICT2.ORIG_PRICE_CODE IS NOT NULL
                THEN
                   CASE
                      WHEN REGEXP_LIKE (VICT2.ORIG_PRICE_CODE,
                                        '[0-9]?[0-9]?[0-9]')
                      THEN
                         'MATRIX'
                      WHEN VICT2.ORIG_PRICE_CODE IN ('FC', 'PM', 'SPEC')
                      THEN
                         'MATRIX'
                      WHEN VICT2.ORIG_PRICE_CODE LIKE 'M%'
                      THEN
                         'NDP'
                      WHEN VICT2.ORIG_PRICE_CODE IN ('CPA', 'CPO')
                      THEN
                         'OVERRIDE'
                      WHEN VICT2.ORIG_PRICE_CODE IN ('PR',
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
                      WHEN VICT2.ORIG_PRICE_CODE IN ('GI',
                                                     'GPC',
                                                     'HPF',
                                                     'HPN',
                                                     'NC')
                      THEN
                         'MANUAL'
                      WHEN VICT2.ORIG_PRICE_CODE = '*E'
                      THEN
                         'OTH/ERROR'
                      WHEN VICT2.ORIG_PRICE_CODE = 'SKC'
                      THEN
                         'OTH/ERROR'
                      WHEN VICT2.ORIG_PRICE_CODE IN ('%',
                                                     '$',
                                                     'N',
                                                     'F',
                                                     'B',
                                                     'PO')
                      THEN
                         'TOOLS'
                      WHEN VICT2.ORIG_PRICE_CODE IS NULL
                      THEN
                         'MANUAL'
                      ELSE
                         'MANUAL'
                   END
                ELSE
                   COALESCE (VICT2.PR_OVR,
                             VICT2.GR_OVR,
                             VICT2.PRICE_CATEGORY)
             END
                PRICE_CATEGORY_FINAL,
             SUM (VICT2.EXT_SALES_AMOUNT)
                AS EXT_SALES_AMOUNT,
             SUM (VICT2.CORE_ADJ_AVG_COST)
                AS CORE_ADJ_AVG_COST,
             SUM (VICT2.EXT_SALES_AMOUNT) - SUM (VICT2.CORE_ADJ_AVG_COST)
                AS EXT_CORE_GP,
             COUNT (VICT2.INVOICE_LINE_NUMBER)
                AS TOTAL_INV_LINES,
             COUNT (
                DISTINCT CASE
                            WHEN VICT2.INVOICE_NUMBER_NK NOT IN
                                    ('CM%', '%-%')
                            THEN
                               VICT2.INVOICE_NUMBER_NK
                            ELSE
                               NULL
                         END)
                AS TOTAL_INV_COUNT,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                   THEN
                      (VICT2.EXT_SALES_AMOUNT)
                   ELSE
                      0
                END)
                PRICE_MATRIX_SALES,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                   THEN
                      (VICT2.CORE_ADJ_AVG_COST)
                   ELSE
                      0
                END)
                PRICE_MATRIX_COST,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                   THEN
                      (VICT2.EXT_SALES_AMOUNT - VICT2.CORE_ADJ_AVG_COST)
                   ELSE
                      0
                END)
                PRICE_MATRIX_GP,
             COUNT (
                CASE
                   WHEN (    VICT2.PRICE_CATEGORY IN ('MATRIX', 'MATRIX_BID')
                         AND (VICT2.EXT_SALES_AMOUNT > 0))
                   THEN
                      (VICT2.INVOICE_LINE_NUMBER)
                   ELSE
                      NULL
                END)
                PRICE_MATRIX_LINES,
             COUNT (
                DISTINCT CASE
                            WHEN (    VICT2.PRICE_CATEGORY IN
                                         ('MATRIX', 'MATRIX_BID')
                                  AND (VICT2.INVOICE_NUMBER_NK) NOT IN
                                         ('CM%', '%-%'))
                            THEN
                               (VICT2.INVOICE_NUMBER_NK)
                            ELSE
                               NULL
                         END)
                MATRIX_INVOICE_CNT,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN 'OVERRIDE'
                   THEN
                      (VICT2.EXT_SALES_AMOUNT)
                   ELSE
                      0
                END)
                CONTRACT_SALES,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN 'OVERRIDE'
                   THEN
                      (VICT2.CORE_ADJ_AVG_COST)
                   ELSE
                      0
                END)
                CONTRACT_COST,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN 'OVERRIDE'
                   THEN
                      (VICT2.EXT_SALES_AMOUNT - VICT2.CORE_ADJ_AVG_COST)
                   ELSE
                      0
                END)
                CONTRACT_GPP,
             COUNT (
                CASE
                   WHEN (    VICT2.PRICE_CATEGORY IN 'OVERRIDE'
                         AND VICT2.EXT_SALES_AMOUNT > 0)
                   THEN
                      (VICT2.INVOICE_LINE_NUMBER)
                   ELSE
                      NULL
                END)
                CONTRACT_LINES,
             COUNT (
                DISTINCT CASE
                            WHEN (    VICT2.PRICE_CATEGORY IN ('OVERRIDE')
                                  AND (VICT2.INVOICE_NUMBER_NK) NOT IN
                                         ('CM%', '%-%'))
                            THEN
                               (VICT2.INVOICE_NUMBER_NK)
                            ELSE
                               NULL
                         END)
                CONTRACT_INV_CNT,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                   THEN
                      (VICT2.EXT_SALES_AMOUNT)
                   ELSE
                      0
                END)
                MANUAL_SALES,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                   THEN
                      (VICT2.CORE_ADJ_AVG_COST)
                   ELSE
                      0
                END)
                MANUAL_COST,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('MANUAL', 'TOOLS', 'QUOTE')
                   THEN
                      (VICT2.EXT_SALES_AMOUNT - VICT2.CORE_ADJ_AVG_COST)
                   ELSE
                      0
                END)
                MANUAL_GP,
             COUNT (
                CASE
                   WHEN (    VICT2.PRICE_CATEGORY IN
                                ('MANUAL', 'TOOLS', 'QUOTE')
                         AND VICT2.EXT_SALES_AMOUNT > 0)
                   THEN
                      (VICT2.INVOICE_LINE_NUMBER)
                   ELSE
                      NULL
                END)
                MANUAL_LINES,
             COUNT (
                DISTINCT CASE
                            WHEN (    VICT2.PRICE_CATEGORY IN
                                         ('MANUAL', 'TOOLS', 'QUOTE')
                                  AND (VICT2.INVOICE_NUMBER_NK) NOT IN
                                         ('CM%', '%-%'))
                            THEN
                               (VICT2.INVOICE_NUMBER_NK)
                            ELSE
                               NULL
                         END)
                MANUAL_INV_CNT,
             SUM (CASE
                     WHEN VICT2.PRICE_CATEGORY NOT IN ('MATRIX',
                                                       'OVERRIDE',
                                                       'MANUAL',
                                                       'CREDITS',
                                                       'TOOLS',
                                                       'QUOTE',
                                                       'MATRIX_BID',
                                                       'Total')
                     THEN
                        (VICT2.EXT_SALES_AMOUNT)
                     ELSE
                        0
                  END)
                OTHER_SALES,
             SUM (CASE
                     WHEN VICT2.PRICE_CATEGORY NOT IN ('MATRIX',
                                                       'OVERRIDE',
                                                       'MANUAL',
                                                       'CREDITS',
                                                       'TOOLS',
                                                       'QUOTE',
                                                       'MATRIX_BID',
                                                       'Total')
                     THEN
                        (VICT2.CORE_ADJ_AVG_COST)
                     ELSE
                        0
                  END)
                OTHER_COST,
             SUM (CASE
                     WHEN VICT2.PRICE_CATEGORY NOT IN ('MATRIX',
                                                       'OVERRIDE',
                                                       'MANUAL',
                                                       'CREDITS',
                                                       'TOOLS',
                                                       'QUOTE',
                                                       'MATRIX_BID',
                                                       'Total')
                     THEN
                        (VICT2.EXT_SALES_AMOUNT - VICT2.CORE_ADJ_AVG_COST)
                     ELSE
                        0
                  END)
                OTHER_GP,
             COUNT (CASE
                       WHEN VICT2.PRICE_CATEGORY NOT IN ('MATRIX',
                                                         'OVERRIDE',
                                                         'MANUAL',
                                                         'CREDITS',
                                                         'TOOLS',
                                                         'QUOTE',
                                                         'MATRIX_BID',
                                                         'Total')
                       THEN
                          (VICT2.INVOICE_LINE_NUMBER)
                       ELSE
                          NULL
                    END)
                OTHER_LINES,
             COUNT (
                DISTINCT CASE
                            WHEN (    VICT2.PRICE_CATEGORY NOT IN
                                         ('MATRIX',
                                          'OVERRIDE',
                                          'MANUAL',
                                          'CREDITS',
                                          'TOOLS',
                                          'QUOTE',
                                          'MATRIX_BID',
                                          'Total')
                                  AND (VICT2.INVOICE_NUMBER_NK) NOT IN
                                         ('CM%', '%-%'))
                            THEN
                               (VICT2.INVOICE_NUMBER_NK)
                            ELSE
                               NULL
                         END)
                OTHER_INV_CNT,
             ROUND (
                SUM (
                   CASE
                      WHEN VICT2.PRICE_CATEGORY IN ('CREDITS')
                      THEN
                         (VICT2.EXT_SALES_AMOUNT)
                      ELSE
                         0
                   END),
                3)
                CREDIT_SALES,
             COUNT (
                CASE
                   WHEN VICT2.PRICE_CATEGORY IN ('CREDITS')
                   THEN
                      (VICT2.INVOICE_LINE_NUMBER)
                   ELSE
                      0
                END)
                CREDIT_LINES,
             SUM (
                CASE
                   WHEN VICT2.PRICE_CATEGORY NOT IN ('CREDITS', 'Total')
                   THEN
                      (VICT2.EXT_SALES_AMOUNT)
                   ELSE
                      0
                END)
                OUTBOUND_SALES
      FROM PRICE_MGMT.PR_VICT2_CUST_R2MO VICT2
           INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
              ON (VICT2.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK)
      WHERE     (SWD.ACCOUNT_NUMBER_NK = '1480')
            AND (VICT2.YEARMONTH =
                 TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM'))
      GROUP BY VICT2.YEARMONTH,
               VICT2.ORDER_CHANNEL,
               --NULL AS MM,
               SWD.REGION_NAME,
               SWD.ACCOUNT_NUMBER_NK,
               SWD.ACCOUNT_NAME,
               VICT2.WRITER,
               VICT2.PRICE_CATEGORY,
               VICT2.ORIG_PRICE_CATEGORY,
               VICT2.GR_OVR,
               VICT2.PR_OVR,
               CASE
                  WHEN     COALESCE (VICT2.PR_OVR,
                                     VICT2.GR_OVR,
                                     VICT2.PRICE_CATEGORY) IN
                              ('MANUAL', 'QUOTE', 'MATRIX_BID')
                       AND VICT2.ORIG_PRICE_CODE IS NOT NULL
                  THEN
                     CASE
                        WHEN REGEXP_LIKE (VICT2.ORIG_PRICE_CODE,
                                          '[0-9]?[0-9]?[0-9]')
                        THEN
                           'MATRIX'
                        WHEN VICT2.ORIG_PRICE_CODE IN ('FC', 'PM', 'SPEC')
                        THEN
                           'MATRIX'
                        WHEN VICT2.ORIG_PRICE_CODE LIKE 'M%'
                        THEN
                           'NDP'
                        WHEN VICT2.ORIG_PRICE_CODE IN ('CPA', 'CPO')
                        THEN
                           'OVERRIDE'
                        WHEN VICT2.ORIG_PRICE_CODE IN ('PR',
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
                        WHEN VICT2.ORIG_PRICE_CODE IN ('GI',
                                                       'GPC',
                                                       'HPF',
                                                       'HPN',
                                                       'NC')
                        THEN
                           'MANUAL'
                        WHEN VICT2.ORIG_PRICE_CODE = '*E'
                        THEN
                           'OTH/ERROR'
                        WHEN VICT2.ORIG_PRICE_CODE = 'SKC'
                        THEN
                           'OTH/ERROR'
                        WHEN VICT2.ORIG_PRICE_CODE IN ('%',
                                                       '$',
                                                       'N',
                                                       'F',
                                                       'B',
                                                       'PO')
                        THEN
                           'TOOLS'
                        WHEN VICT2.ORIG_PRICE_CODE IS NULL
                        THEN
                           'MANUAL'
                        ELSE
                           'MANUAL'
                     END
                  ELSE
                     COALESCE (VICT2.PR_OVR,
                               VICT2.GR_OVR,
                               VICT2.PRICE_CATEGORY)
               END) GP_DATA;