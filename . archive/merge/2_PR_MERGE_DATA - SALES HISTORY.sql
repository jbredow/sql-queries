DROP TABLE AAA6863.PR_MERGE_DATA_2;

CREATE TABLE AAA6863.PR_MERGE_DATA_2
AS
   SELECT PR_DATA.SELL_ACCOUNT_NAME ACCOUNT_NAME,
          --NULL KOB,
          --PR_DATA.ACCOUNT_NUMBER,
          PR_DATA.SELL_DISTRICT DISTRICT,
          PR_DATA.SELL_REGION_NAME REGION,
          PR_DATA.SELL_BU_NAME BU_TYPE,
          PR_DATA.MAIN_CUSTOMER_GK,
          PR_DATA.DISCOUNT_GROUP_NK,
          PR_DATA.DISCOUNT_GROUP_NK_NAME,
          --PR_DATA.CHANNEL_TYPE,
          SUM (PR_DATA.TOTAL_LINES) INVOICE_LINES,
          SUM (PR_DATA.EXT_AVG_COGS_AMOUNT) AVG_COGS,
          SUM (PR_DATA.EXT_SALES_AMOUNT) EXT_SALES,
          NVL (PR_DATA.PRICE_SUB_CATEGORY, PR_DATA.PRICE_CATEGORY)
             PRICE_CATEGORY,
          PR_DATA.PRICE_COLUMN
     FROM SALES_MART.PRICE_MGMT_DATA_DET PR_DATA
    WHERE IC_FLAG = 'REGULAR' AND SELL_ACCOUNT_NAME IN ('JACKSON', 'NASH') /*AND DECODE (PRICE_COLUMN,
                                                                                       '000', 1,
                                                                                       'C', 1,
                                                                                       'N/A', 1,
                                                                                       'NA', 1,
                                                                                       0) <> 1*/
          AND PR_DATA.YEARMONTH BETWEEN 201410 AND 201503
   															/*TO_CHAR (
                                    TRUNC (
                                       SYSDATE
                                       - NUMTOYMINTERVAL (
                                            13,
                                            'MONTH'),
                                       'MONTH'),
                                    'YYYYMM')
                             AND TO_CHAR (
                                    TRUNC (SYSDATE, 'MM')
                                    - 1,
                                    'YYYYMM')*/
   GROUP BY PR_DATA.SELL_ACCOUNT_NAME,
            --PR_DATA.ACCOUNT_NUMBER,
            --PR_DATA.SELL_KIND_OF_BUSINESS,
            PR_DATA.SELL_DISTRICT,
            PR_DATA.SELL_REGION_NAME,
            PR_DATA.SELL_BU_NAME,
            PR_DATA.DISCOUNT_GROUP_NK,
            PR_DATA.DISCOUNT_GROUP_NK_NAME,
            PR_DATA.MAIN_CUSTOMER_GK,
            --PR_DATA.CHANNEL_TYPE,
            NVL (PR_DATA.PRICE_SUB_CATEGORY, PR_DATA.PRICE_CATEGORY),
            PR_DATA.PRICE_COLUMN;
					
GRANT SELECT ON AAA6863.PR_MERGE_DATA_2 TO PUBLIC;