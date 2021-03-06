CREATE OR REPLACE FORCE VIEW PRICE_MGMT.PR_PRICE_CAT_RPT_VW
AS
   SELECT S.ROLL12MONTHS,
          S.FISCAL_YEAR_TO_DATE,
          S.EOM_YEARMONTH,
          W.DIVISION_NAME REGION,
          W.REGION_NAME DISTRICT,
          W.ACCOUNT_NUMBER_NK ACCT_NK,
          W.ACCOUNT_NAME,
          A.AREA,
          A.RPT_NAME AREA_NAME,
          S.WHSE,
          S.PRICE_COLUMN PC,
          S.CUST_BUS_GRP,
          S.ORDER_CHANNEL,
          S.DISC_GRP,
          S.DISCOUNT_GROUP_NAME,
          S.WRITER,
          S.REP_INIT,
          S.SALESREP_NAME,
          S.MAIN_CUST,
          S.CUSTOMER_NAME,
          S.PRICE_CATEGORY,
          S.EXT_SALES_AMT,
          S.INVOICE_LINES,
          S.AVG_COGS_AMT,
          S.CORE_COGS_AMT,
          S.INVOICE_COGS_AMT
   FROM PRICE_MGMT.PR_PRICE_CAT_RPT_SUMS S
        LEFT OUTER JOIN PRICE_MGMT.RPT_AREA_VW A ON TO_CHAR (S.WHSE) = A.WHSE
        LEFT OUTER JOIN SALES_MART.SALES_WAREHOUSE_DIM W
           ON TO_CHAR (S.WHSE) = W.WAREHOUSE_NUMBER_NK;

GRANT SELECT ON PRICE_MGMT.PR_PRICE_CAT_RPT_VW TO PUBLIC;