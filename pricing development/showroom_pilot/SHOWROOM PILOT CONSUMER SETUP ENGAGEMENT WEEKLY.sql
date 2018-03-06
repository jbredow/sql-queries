-- query pulls weekly totals of all showroom consumer setups vs consumer setups with sales
-- consumer defined as E_ENDUSER in PC 024, 025

SELECT ALIAS_NAME,
       SETUP_YW,
       TO_CHAR (START_DATE, 'MM/DD/YYYY')
          START_DATE,
          PILOT_LIVE,
       CASE
          WHEN SETUP_YW = '2017AVG' THEN ROUND (CONSUMER_SETUPS / 52, 0)
          ELSE CONSUMER_SETUPS
       END
          CONSUMER_SETUPS,
       CASE
          WHEN SETUP_YW = '2017AVG' THEN ROUND (CONSUMERS_ACTIVE / 52, 0)
          ELSE CONSUMERS_ACTIVE
       END
          CONSUMERS_ACTIVE,
       CONSUMER_ENGAGEMENT
FROM (SELECT SD.ALIAS_NAME,
             CASE
                WHEN TO_CHAR (P.ACCOUNT_SETUP_DATE, 'YYYY') = '2017'
                THEN
                   '2017AVG'
                ELSE
                   TO_CHAR (P.ACCOUNT_SETUP_DATE, 'YYYYWW')
             END
                SETUP_YW,
             MIN (P.ACCOUNT_SETUP_DATE)
                START_DATE,
             CASE
                WHEN     P.ACCOUNT_NAME IN ('ORL', 'PHOENIX')
                     AND P.ACCOUNT_SETUP_DATE > '02/13/2018'
                THEN
                   'Y'
                WHEN     P.ACCOUNT_NAME IN ('PLYMOUTH')
                     AND P.ACCOUNT_SETUP_DATE >= '03/01/2018'
                THEN
                   'Y'
                ELSE
                   'N'
             END
                AS PILOT_LIVE,
             COUNT (P.CUSTOMER_GK)
                AS CONSUMER_SETUPS,
             COUNT (P.LAST_SALE)
                AS CONSUMERS_ACTIVE,
             ROUND (COUNT (P.LAST_SALE) / COUNT (P.CUSTOMER_GK), 3)
                CONSUMER_ENGAGEMENT
      FROM AAD9606.PR_PILOT_END_USER P
      INNER JOIN EBUSINESS.SALES_DIVISIONS SD
      ON P.ACCOUNT_NAME = SD.ACCOUNT_NAME
      WHERE P.SETUP_YM > '201701' AND P.PRICE_COLUMN IN ('024', '025')
      GROUP BY SD.ALIAS_NAME,
               CASE
                  WHEN TO_CHAR (P.ACCOUNT_SETUP_DATE, 'YYYY') = '2017'
                  THEN
                     '2017AVG'
                  ELSE
                     TO_CHAR (P.ACCOUNT_SETUP_DATE, 'YYYYWW')
               END,
               CASE
                WHEN     P.ACCOUNT_NAME IN ('ORL', 'PHOENIX')
                     AND P.ACCOUNT_SETUP_DATE > '02/13/2018'
                THEN
                   'Y'
                WHEN     P.ACCOUNT_NAME IN ('PLYMOUTH')
                     AND P.ACCOUNT_SETUP_DATE >= '03/01/2018'
                THEN
                   'Y'
                ELSE
                   'N'
             END)