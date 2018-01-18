DROP TABLE AAE0376.SHOWROOM_SLS;
CREATE TABLE AAE0376.SHOWROOM_SLS
AS 
SELECT 
       REGION,
       SELL_ACCOUNT_NAME ACCT_NAME,
       ACCOUNT_NUMBER_NK ACCT_NUM,
       DISCOUNT_GROUP_NK DG, 
       DISCOUNT_GROUP_NK_NAME DG_NAME, 
       PRODUCT_NK PROD,
       PRICE_COLUMN PC,
       CUSTOMER_TYPE CUST_TYPE,
       CHANNEL_TYPE CHANNEL, 
       FYTD,
       SALES_TYPE,
       EX_SALES,
       EX_COGS,
       MATRIX_SALES,
       MATRIX_COGS,
       /*ROUND (
          CASE
             WHEN MATRIX_SALES > 0
             THEN
                (MATRIX_SALES - MATRIX_COGS) / MATRIX_SALES
             ELSE
                0
          END,
          3)
          MATRIX_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN MATRIX_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          MATRIX_UTIL,*/
       OVERRIDE_SALES,
       OVERRIDE_COGS,
       /*ROUND (
          CASE
             WHEN OVERRIDE_SALES > 0
             THEN
                (OVERRIDE_SALES - OVERRIDE_COGS) / OVERRIDE_SALES
             ELSE
                0
          END,
          3)
          OVERRIDE_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN OVERRIDE_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          OVERRIDE_UTIL,*/
       MANUAL_SALES,
       MANUAL_COGS,
       /*ROUND (
          CASE
             WHEN MANUAL_SALES > 0
             THEN
                (MANUAL_SALES - MANUAL_COGS) / MANUAL_SALES
             ELSE
                0
          END,
          3)
          MANUAL_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN MANUAL_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          MANUAL_UTIL,*/
       
        CREDITS_SALES,
       CREDITS_COGS,
       SP_SALES,
       SP_COGS
       
       /*ROUND (
          CASE
             WHEN SP_SALES > 0 THEN (SP_SALES - SP_COGS) / SP_SALES
             ELSE 0
          END,
          3)
          SP_GP_PCT,
       ROUND (
          CASE
             WHEN OUTBOUND_SALES > 0 THEN SP_SALES / OUTBOUND_SALES
             ELSE 0
          END,
          3)
          SP_UTIL,*/
  FROM (SELECT SLS.SELL_DISTRICT REGION,
       SLS.SELL_ACCOUNT_NAME,
       SLS.ACCOUNT_NUMBER_NK,
       SLS.SALES_TYPE,
       SLS.DISCOUNT_GROUP_NK, 
       SLS.DISCOUNT_GROUP_NK_NAME,
       SLS.PRODUCT_NK,
       SLS.PRICE_COLUMN,
       SLS.CUSTOMER_TYPE,
       SLS.CHANNEL_TYPE, 
               TPD.FISCAL_YEAR_TO_DATE FYTD,
               NVL (SUM (SLS.EXT_SALES_AMOUNT), 0) EX_SALES,
               NVL (SUM (SLS.EXT_AVG_COGS_AMOUNT), 0) EX_COGS,
               /* MATRIX */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
                             ('MATRIX', 'MATRIX_BID')
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  MATRIX_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
                             ('MATRIX', 'MATRIX_BID')
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  MATRIX_COGS,
               /* CONTRACT */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
                             'OVERRIDE'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  OVERRIDE_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) =
                             'OVERRIDE'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  OVERRIDE_COGS,
               /* MANUAL */
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
                             ('MANUAL', 'QUOTE', 'TOOLS')
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  MANUAL_SALES,
               SUM (
                  CASE
                     WHEN NVL (PRICE_SUB_CATEGORY, PRICE_CATEGORY) IN
                             ('MANUAL', 'QUOTE', 'TOOLS')
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  MANUAL_COGS,
               /* SPECIALS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'SPECIAL'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  SP_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'SPECIAL'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  SP_COGS,
               /* CREDITS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'CREDITS'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  CREDITS_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY = 'CREDITS'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  CREDITS_COGS,
               /* CREDITS */
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY <> 'CREDITS'
                     THEN
                        SLS.EXT_SALES_AMOUNT
                     ELSE
                        0
                  END)
                  OUTBOUND_SALES,
               SUM (
                  CASE
                     WHEN PRICE_CATEGORY <> 'CREDITS'
                     THEN
                        SLS.EXT_AVG_COGS_AMOUNT
                     ELSE
                        0
                  END)
                  OUTBOUND_COGS
          FROM SALES_MART.PRICE_MGMT_DATA_DET SLS
               INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
                  ON SLS.YEARMONTH = TPD.YEARMONTH
               INNER JOIN AAE0376.SHOW_DGS DISC
                  ON SLS.DISCOUNT_GROUP_NK = DISC."Showroom DG"
         WHERE     TPD.FISCAL_YEAR_TO_DATE IS NOT NULL
               AND SLS.IC_FLAG = 'REGULAR'
               --AND SLS.ACCOUNT_NUMBER_NK = '1300'
               AND SLS.SELL_DISTRICT LIKE ('%BLENDED%')
               --AND SLS.CHANNEL_TYPE LIKE ('%SHOW%')
             /*  AND SLS.SALESREP_NAME NOT LIKE ('%HOUSE%')
               AND SLS.SALESREP_NAME NOT LIKE ('%COSTING%')
               AND SLS.SALESMAN_CODE NOT IN ('%1%', '%2%', '%3%', '%4%', '%5%', '%6%', '%7%', '%8%', '%9%')*/
         GROUP BY SLS.SELL_DISTRICT,
       SLS.SELL_ACCOUNT_NAME,
       SLS.ACCOUNT_NUMBER_NK,
       SLS.SALES_TYPE,
       SLS.DISCOUNT_GROUP_NK, 
       SLS.DISCOUNT_GROUP_NK_NAME, 
       SLS.PRODUCT_NK,
       SLS.PRICE_COLUMN,
       SLS.CUSTOMER_TYPE,
       SLS.CHANNEL_TYPE,
       TPD.FISCAL_YEAR_TO_DATE
                 );
