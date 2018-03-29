SELECT CUSTOMERS.ACCOUNT_NUMBER_NK "BU#",
  CUSTOMERS.ACCOUNT_NAME "BU Name",
  --CUSTOMERS.SALESREP_GK,
  CUSTOMERS.SALESREP_NK "Sales INI",
  (CUSTOMERS.ACCOUNT_NUMBER_NK || '-' || CUSTOMERS.SALESREP_NK) "PPE INI",
  CUSTOMERS.SALESREP_NAME "Sales Rep Name",
  CUSTOMERS.SHOWROOM_FLAG "SR?",
  CUSTOMERS.HOUSE_ACCT_FLAG "HA?",
  CUSTOMERS.OUTSIDE_SALES_FLAG "OS?",
  CUSTOMERS.NUM_CUSTS "Cust#",
  CCORS.NUM_CCORS "CCOR#",  
  CUSTOMERS.INSERT_TIMESTAMP "Date Created"
FROM
  (SELECT SR.ACCOUNT_NUMBER_NK,
  SR.ACCOUNT_NAME,
  SR.SALESREP_GK,
  SR.SALESREP_NK,
  SR.SALESREP_NAME,
  SR.SHOWROOM_FLAG,
  SR.HOUSE_ACCT_FLAG,
  SR.OUTSIDE_SALES_FLAG,
  COUNT(CUST.CUSTOMER_GK) NUM_CUSTS,
  SR.INSERT_TIMESTAMP

FROM DW_FEI.SALESREP_DIMENSION SR
  LEFT JOIN DW_FEI.CUSTOMER_DIMENSION CUST
  ON (SR.ACCOUNT_NUMBER_NK = CUST.ACCOUNT_NUMBER_NK AND SR.SALESREP_NK = CUST.SALESMAN_CODE)

WHERE (SYSDATE - SR.INSERT_TIMESTAMP) < 7
  AND CUST.DELETE_DATE IS NULL
  
  
GROUP BY SR.ACCOUNT_NUMBER_NK,
  SR.ACCOUNT_NAME,
  SR.SALESREP_GK,
  SR.SALESREP_NK,
  SR.SALESREP_NAME,
  SR.SHOWROOM_FLAG,
  SR.HOUSE_ACCT_FLAG,
  SR.OUTSIDE_SALES_FLAG,
  SR.INSERT_TIMESTAMP) CUSTOMERS
  
INNER JOIN
  
(SELECT SR.ACCOUNT_NUMBER_NK,
  SR.ACCOUNT_NAME,
  SR.SALESREP_GK,
  SR.SALESREP_NK,
  SR.SALESREP_NAME,
  SR.SHOWROOM_FLAG,
  SR.HOUSE_ACCT_FLAG,
  SR.OUTSIDE_SALES_FLAG,
  COUNT(COD.CUSTOMER_GK) NUM_CCORS,
  SR.INSERT_TIMESTAMP

FROM DW_FEI.SALESREP_DIMENSION SR
  LEFT JOIN DW_FEI.CUSTOMER_DIMENSION CUST
  ON (SR.ACCOUNT_NUMBER_NK = CUST.ACCOUNT_NUMBER_NK AND SR.SALESREP_NK = CUST.SALESMAN_CODE)
  LEFT JOIN DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
  ON (CUST.CUSTOMER_GK = COD.CUSTOMER_GK)

WHERE (SYSDATE - SR.INSERT_TIMESTAMP) < 7
  AND COD.DELETE_DATE IS NULL
  
  
GROUP BY SR.ACCOUNT_NUMBER_NK,
  SR.ACCOUNT_NAME,
  SR.SALESREP_GK,
  SR.SALESREP_NK,
  SR.SALESREP_NAME,
  SR.SHOWROOM_FLAG,
  SR.HOUSE_ACCT_FLAG,
  SR.OUTSIDE_SALES_FLAG,
  SR.INSERT_TIMESTAMP) CCORS
  
ON (CUSTOMERS.ACCOUNT_NUMBER_NK = CCORS.ACCOUNT_NUMBER_NK AND CUSTOMERS.SALESREP_GK = CCORS.SALESREP_GK AND CUSTOMERS.SALESREP_NAME = CCORS.SALESREP_NAME);