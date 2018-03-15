DROP TABLE AAK9658.WHSE_CUST_LIST;
CREATE TABLE AAK9658.WHSE_CUST_LIST
AS
SELECT MEGA.WHSE,
       MEGA.REG_ACCT_NAME,
       MEGA.REG_ACCT_NUM,
       MEGA.NEW_ACCT_NAME,
       MEGA.ACCT_NUM,
       MEGA.PC,
       CUST.ACCOUNT_NAME,
       CUST.CUSTOMER_GK,
       CUST.CUSTOMER_NK,
       CUST.CUSTOMER_NAME,
       CUST.MAIN_CUSTOMER_NK,
       CUST.PRICE_COLUMN,
       CUST.LAST_SALE,
       CUST.JOB_YN,
       CUST.OLD_ACCOUNT_NAME,
       CUST.BRANCH_WAREHOUSE_NUMBER,
       CUST.CROSS_ACCT,
       CUST.CROSS_CUSTOMER_NK,
       CUST.DELETE_DATE
  FROM AAE0376.MEGA_BRANCHES MEGA
       INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
          ON (MEGA.WHSE = CUST.BRANCH_WAREHOUSE_NUMBER)
WHERE     MEGA.WHSE IN ('1722','354') --/////Warehouse Number Here////
       /*AND (CUST.PRICE_COLUMN NOT IN
               ('020',
                '021',
                '024',
                '025',
                '170',
                '171',
                '172',
                '173',
                '180',
                '181',
                '182',
                '183',
                '190',
                '191',
                '192',
                '193',
                'C'))*/
       AND (CUST.DELETE_DATE IS NULL);
