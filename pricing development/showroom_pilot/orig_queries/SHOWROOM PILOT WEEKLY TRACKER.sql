CREATE OR REPLACE FORCE VIEW "AAD9606"."PR_SHOW_WEEKLY_SUMMARY"
AS
   SELECT                                                     
          SWD.DIVISION_NAME
             AS REGION,
          SWD.REGION_NAME
             AS DISTRICT,
          DTL.ACCOUNT_NUMBER,
          DTL.ACCOUNT_NAME,
          SWD.ALIAS_NAME,
          DTL.TYPE_OF_SALE,
          CASE
             WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
                  AND DTL.PRICE_COLUMN IN ('020', '024', '025')
             THEN
                'Consumer'
             WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
                  AND DTL.PRICE_COLUMN NOT IN ('020', '024', '025')
             THEN
                'Associated Consumer'
             WHEN BG.CUSTOMER_GROUP IN ('Plumbing', 'Builder', 'Designers')
             THEN
                BG.CUSTOMER_GROUP
             ELSE
                'Other'
          END
             AS PILOT_CUSTOMER_GROUP,
          HIER.DET1,
          CASE
             WHEN HIER.DET1 IN ('FAUCETS - BRASS PRODUCT',
                                'FIXTURES',
                                'BATHING PRODUCTS',
                                'PARTS & ACCY',
                                'KITCHEN SINKS')
             THEN
                'FINISHED_PLUMBING'
             WHEN HIER.DET1 IN ('APPLIANCES',
                                'LIGHTING',
                                'CABINETS AND VANITIES',
                                'HOME AMENITIES',
                                'HARDWARE',
                                'COUNTER SURFACES')
             THEN
                'OTHER_SHOWROOM'
             ELSE
                'OTHER'
          END
             SHOW_PROD_GRP,
          CASE
             WHEN DTL.DISCOUNT_GROUP_NK IN ('1993',
                                            '1994',
                                            '1997',
                                            '1998',
                                            '2001',
                                            '2002',
                                            '2003',
                                            '2007',
                                            '2011',
                                            '2015',
                                            '2019',
                                            '2022',
                                            '2032',
                                            '2033',
                                            '2034',
                                            '2035',
                                            '2036',
                                            '2037',
                                            '2038',
                                            '2041',
                                            '2042',
                                            '2045',
                                            '2049',
                                            '2050',
                                            '2065',
                                            '2066',
                                            '2078',
                                            '2096',
                                            '2098',
                                            '2100',
                                            '2101',
                                            '2102',
                                            '2105',
                                            '2109',
                                            '2110',
                                            '2111',
                                            '2112',
                                            '2113',
                                            '2114',
                                            '2115',
                                            '2116',
                                            '2118',
                                            '2119',
                                            '2122',
                                            '2226',
                                            '2230',
                                            '2231',
                                            '2234',
                                            '2237',
                                            '2238',
                                            '2241',
                                            '2247',
                                            '2253',
                                            '2254',
                                            '2262',
                                            '2263',
                                            '2264',
                                            '2265',
                                            '2266',
                                            '2267',
                                            '2269',
                                            '2270',
                                            '2271',
                                            '2272',
                                            '2273',
                                            '2274',
                                            '2277',
                                            '2278',
                                            '2279',
                                            '2281',
                                            '2282',
                                            '2326',
                                            '2333',
                                            '2610',
                                            '2611',
                                            '2707',
                                            '2720',
                                            '2730',
                                            '2908',
                                            '2909',
                                            '2937',
                                            '2942',
                                            '2943',
                                            '2944',
                                            '2946',
                                            '2954',
                                            '2984',
                                            '2985',
                                            '2989',
                                            '2990',
                                            '2993',
                                            '3019',
                                            '3140',
                                            '3142',
                                            '3165',
                                            '3183',
                                            '3184',
                                            '3185',
                                            '3186',
                                            '3189',
                                            '3191',
                                            '3195',
                                            '3200',
                                            '3202',
                                            '3205',
                                            '3208',
                                            '3210',
                                            '3212',
                                            '3214',
                                            '3215',
                                            '3217',
                                            '3433',
                                            '3704',
                                            '3711',
                                            '3717',
                                            '3719',
                                            '3720',
                                            '3723',
                                            '3734',
                                            '3736',
                                            '3737',
                                            '3743',
                                            '3744',
                                            '3746',
                                            '3748',
                                            '3749',
                                            '3751',
                                            '3754',
                                            '3756',
                                            '3759',
                                            '3765',
                                            '3766',
                                            '3783',
                                            '3788',
                                            '3789',
                                            '3792',
                                            '3794',
                                            '3795',
                                            '3796',
                                            '3797',
                                            '3809',
                                            '3816',
                                            '3818',
                                            '3819',
                                            '3820',
                                            '3822',
                                            '3827',
                                            '3830',
                                            '3833',
                                            '3834',
                                            '3842',
                                            '3850',
                                            '3858',
                                            '3870',
                                            '3872',
                                            '3881',
                                            '3884',
                                            '3885',
                                            '3889',
                                            '3891',
                                            '3900',
                                            '3910',
                                            '3919',
                                            '3922',
                                            '3946',
                                            '4031',
                                            '4043',
                                            '4044',
                                            '4046',
                                            '4050',
                                            '4252',
                                            '4258',
                                            '4278',
                                            '4573',
                                            '4574',
                                            '4575',
                                            '4577',
                                            '5732',
                                            '6883',
                                            '8020',
                                            '8031',
                                            '8504')
             THEN
                'Y'
             ELSE
                'N'
          END
             AS PILOT_PROD,
          CASE
             WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017' THEN '2017AVG'
             ELSE TO_CHAR (DTL.PROCESS_DATE, 'YYYYWW')
          END
             YYYYWW,
          CASE
             WHEN     DTL.ACCOUNT_NAME IN ('ORL', 'PHOENIX')
                  AND DTL.PROCESS_DATE > '02/13/2018'
             THEN
                'Y'
             WHEN     DTL.ACCOUNT_NAME IN ('PLYMOUTH')
                  AND DTL.PROCESS_DATE >= '03/01/2018'
             THEN
                'Y'
             ELSE
                'N'
          END
             AS PILOT_LIVE,
          COUNT (
             DISTINCT CASE
                         WHEN DTL.INVOICE_NUMBER_NK NOT LIKE '%-%'
                         THEN
                            DTL.INVOICE_NUMBER_NK
                         ELSE
                            NULL
                      END)
             AS INVOICE_CNT,
          COUNT (DTL.INVOICE_LINE_NUMBER)
             AS INVOICE_LINES,
          SUM (
             CASE
                WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
                THEN
                   ROUND (DTL.EXT_AVG_COGS_AMOUNT / 52, 2)
                ELSE
                   DTL.EXT_AVG_COGS_AMOUNT
             END)
             AS OLD_AVG_COGS,
          SUM (
             CASE
                WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
                THEN
                   ROUND (DTL.CORE_ADJ_AVG_COST / 52, 2)
                ELSE
                   DTL.CORE_ADJ_AVG_COST
             END)
             AS AVG_COGS,
          SUM (
             CASE
                WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
                THEN
                   ROUND (DTL.EXT_SALES_AMOUNT / 52, 2)
                ELSE
                   DTL.EXT_SALES_AMOUNT
             END)
             AS EXT_SALES,
          DECODE (DTL.PRICE_CATEGORY,
                  'CREDITS', 'CREDITS',
                  'MANUAL', 'MANUAL',
                  'MATRIX', 'MATRIX',
                  'MATRIX_BID', 'MATRIX',
                  'NDP', 'MATRIX',
                  'OTH/ERROR', 'MANUAL',
                  'OVERRIDE', 'OVERRIDE',
                  'QUOTE', 'MANUAL',
                  'SPECIALS', 'SPECIALS',
                  'TOOLS', 'MANUAL',
                  'MANUAL')
             RPT_PRICE_CATEGORY
   FROM AAK9658.PR_VICT2_CUST_SHWRM DTL
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON (DTL.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK)
        INNER JOIN USER_SHARED.BG_CUSTTYPE_XREF BG
           ON DTL.CUSTOMER_TYPE = BG.CUSTOMER_TYPE
        LEFT OUTER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY HIER
           ON DTL.DISCOUNT_GROUP_NK = HIER.DISCOUNT_GROUP_NK
   GROUP BY DTL.WAREHOUSE_NUMBER,
            DTL.ACCOUNT_NAME,
            DTL.ACCOUNT_NUMBER,
            SWD.ALIAS_NAME,
            SWD.REGION_NAME,
            SWD.DIVISION_NAME,
            DTL.YEARMONTH,
            DTL.TYPE_OF_SALE,
            CASE
               WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
                    AND DTL.PRICE_COLUMN IN ('020', '024', '025')
               THEN
                  'Consumer'
               WHEN     DTL.CUSTOMER_TYPE = 'E_ENDUSER'
                    AND DTL.PRICE_COLUMN NOT IN ('020', '024', '025')
               THEN
                  'Associated Consumer'
               WHEN BG.CUSTOMER_GROUP IN ('Plumbing', 'Builder', 'Designers')
               THEN
                  BG.CUSTOMER_GROUP
               ELSE
                  'Other'
            END,
            CASE
               WHEN TO_CHAR (DTL.PROCESS_DATE, 'YYYY') = '2017'
               THEN
                  '2017AVG'
               ELSE
                  TO_CHAR (DTL.PROCESS_DATE, 'YYYYWW')
            END,
            CASE
               WHEN     DTL.ACCOUNT_NAME IN ('ORL', 'PHOENIX')
                    AND DTL.PROCESS_DATE > '02/13/2018'
               THEN
                  'Y'
               WHEN     DTL.ACCOUNT_NAME IN ('PLYMOUTH')
                    AND DTL.PROCESS_DATE >= '03/01/2018'
               THEN
                  'Y'
               ELSE
                  'N'
            END,
            HIER.DET1,
            CASE
               WHEN HIER.DET1 IN ('FAUCETS - BRASS PRODUCT',
                                  'FIXTURES',
                                  'BATHING PRODUCTS',
                                  'PARTS & ACCY',
                                  'KITCHEN SINKS')
               THEN
                  'FINISHED_PLUMBING'
               WHEN HIER.DET1 IN ('APPLIANCES',
                                  'LIGHTING',
                                  'CABINETS AND VANITIES',
                                  'HOME AMENITIES',
                                  'HARDWARE',
                                  'COUNTER SURFACES')
               THEN
                  'OTHER_SHOWROOM'
               ELSE
                  'OTHER'
            END,
            CASE
               WHEN DTL.DISCOUNT_GROUP_NK IN ('1993',
                                              '1994',
                                              '1997',
                                              '1998',
                                              '2001',
                                              '2002',
                                              '2003',
                                              '2007',
                                              '2011',
                                              '2015',
                                              '2019',
                                              '2022',
                                              '2032',
                                              '2033',
                                              '2034',
                                              '2035',
                                              '2036',
                                              '2037',
                                              '2038',
                                              '2041',
                                              '2042',
                                              '2045',
                                              '2049',
                                              '2050',
                                              '2065',
                                              '2066',
                                              '2078',
                                              '2096',
                                              '2098',
                                              '2100',
                                              '2101',
                                              '2102',
                                              '2105',
                                              '2109',
                                              '2110',
                                              '2111',
                                              '2112',
                                              '2113',
                                              '2114',
                                              '2115',
                                              '2116',
                                              '2118',
                                              '2119',
                                              '2122',
                                              '2226',
                                              '2230',
                                              '2231',
                                              '2234',
                                              '2237',
                                              '2238',
                                              '2241',
                                              '2247',
                                              '2253',
                                              '2254',
                                              '2262',
                                              '2263',
                                              '2264',
                                              '2265',
                                              '2266',
                                              '2267',
                                              '2269',
                                              '2270',
                                              '2271',
                                              '2272',
                                              '2273',
                                              '2274',
                                              '2277',
                                              '2278',
                                              '2279',
                                              '2281',
                                              '2282',
                                              '2326',
                                              '2333',
                                              '2610',
                                              '2611',
                                              '2707',
                                              '2720',
                                              '2730',
                                              '2908',
                                              '2909',
                                              '2937',
                                              '2942',
                                              '2943',
                                              '2944',
                                              '2946',
                                              '2954',
                                              '2984',
                                              '2985',
                                              '2989',
                                              '2990',
                                              '2993',
                                              '3019',
                                              '3140',
                                              '3142',
                                              '3165',
                                              '3183',
                                              '3184',
                                              '3185',
                                              '3186',
                                              '3189',
                                              '3191',
                                              '3195',
                                              '3200',
                                              '3202',
                                              '3205',
                                              '3208',
                                              '3210',
                                              '3212',
                                              '3214',
                                              '3215',
                                              '3217',
                                              '3433',
                                              '3704',
                                              '3711',
                                              '3717',
                                              '3719',
                                              '3720',
                                              '3723',
                                              '3734',
                                              '3736',
                                              '3737',
                                              '3743',
                                              '3744',
                                              '3746',
                                              '3748',
                                              '3749',
                                              '3751',
                                              '3754',
                                              '3756',
                                              '3759',
                                              '3765',
                                              '3766',
                                              '3783',
                                              '3788',
                                              '3789',
                                              '3792',
                                              '3794',
                                              '3795',
                                              '3796',
                                              '3797',
                                              '3809',
                                              '3816',
                                              '3818',
                                              '3819',
                                              '3820',
                                              '3822',
                                              '3827',
                                              '3830',
                                              '3833',
                                              '3834',
                                              '3842',
                                              '3850',
                                              '3858',
                                              '3870',
                                              '3872',
                                              '3881',
                                              '3884',
                                              '3885',
                                              '3889',
                                              '3891',
                                              '3900',
                                              '3910',
                                              '3919',
                                              '3922',
                                              '3946',
                                              '4031',
                                              '4043',
                                              '4044',
                                              '4046',
                                              '4050',
                                              '4252',
                                              '4258',
                                              '4278',
                                              '4573',
                                              '4574',
                                              '4575',
                                              '4577',
                                              '5732',
                                              '6883',
                                              '8020',
                                              '8031',
                                              '8504')
               THEN
                  'Y'
               ELSE
                  'N'
            END,
            DECODE (DTL.PRICE_CATEGORY,
                    'CREDITS', 'CREDITS',
                    'MANUAL', 'MANUAL',
                    'MATRIX', 'MATRIX',
                    'MATRIX_BID', 'MATRIX',
                    'NDP', 'MATRIX',
                    'OTH/ERROR', 'MANUAL',
                    'OVERRIDE', 'OVERRIDE',
                    'QUOTE', 'MANUAL',
                    'SPECIALS', 'SPECIALS',
                    'TOOLS', 'MANUAL',
                    'MANUAL')