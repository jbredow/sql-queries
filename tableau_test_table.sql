TRUNCATE TABLE AAA6863.PR_SM_TABLEAU_TEST;

DROP TABLE AAA6863.PR_SM_TABLEAU_TEST;

CREATE TABLE AAA6863.PR_SM_TABLEAU_TEST
AS

SELECT DISTINCT PM_DET.YEARMONTH,
                SWD.DIVISION_NAME,
                SWD.REGION_NAME,
                SWD.ACCOUNT_NAME,
                SWD.ACCOUNT_NUMBER_NK,
                SWD.WAREHOUSE_NAME,
                SWD.WAREHOUSE_NUMBER_NK,
                PM_DET.DISCOUNT_GROUP_NK,
                PM_DET.DISCOUNT_GROUP_NK_NAME,
                PM_DET.ALT1_CODE_AND_PRODUCT_NAME,
                PM_DET.PRICE_COLUMN,
                PM_DET.IC_FLAG,
                PM_DET.WRITER,
                PM_DET.PRODUCT_TYPE,
                PM_DET.PRICE_CATEGORY,
                PM_DET.PRICE_SUB_CATEGORY,
                PM_DET.CUSTOMER_TYPE,
                SUM (PM_DET.EXT_SALES_AMOUNT) EX_SALES,
                SUM (PM_DET.EXT_AVG_COGS_AMOUNT) EX_AVG_COGS
  FROM SALES_MART.PRICE_MGMT_DATA_DET PM_DET
       INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
          ON (PM_DET.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK)
 WHERE     (PM_DET.YEARMONTH = 201802)
       AND (SWD.ACCOUNT_NUMBER_NK = '2000')
       AND (PM_DET.IC_FLAG = 'REGULAR')
GROUP BY PM_DET.CUSTOMER_TYPE,
         PM_DET.PRICE_SUB_CATEGORY,
         PM_DET.PRICE_CATEGORY,
         PM_DET.PRODUCT_TYPE,
         PM_DET.WRITER,
         PM_DET.IC_FLAG,
         PM_DET.PRICE_COLUMN,
         PM_DET.ALT1_CODE_AND_PRODUCT_NAME,
         PM_DET.DISCOUNT_GROUP_NK_NAME,
         PM_DET.DISCOUNT_GROUP_NK,
         SWD.WAREHOUSE_NUMBER_NK,
         SWD.WAREHOUSE_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         SWD.REGION_NAME,
         SWD.DIVISION_NAME,
         PM_DET.YEARMONTH
      ;
    