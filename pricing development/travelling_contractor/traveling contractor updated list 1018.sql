SELECT TPD.ROLL12MONTHS,
       SWD.REGION_NAME AS DISTRICT,
       CUST.ACCOUNT_NUMBER_NK AS ACCT_NK,
       CUST.ACCOUNT_NAME AS ALIAS,
       CUST.CUSTOMER_NK AS CUST_NK,
       CUST.CUSTOMER_NAME,
       CUST.MAIN_CUSTOMER_NK AS MAIN_NK,
       CUST.MSTR_CUSTNO AS MASTER_NK,
       CUST.MSTR_CUST_NAME,
       CUST.CROSS_ACCT,
       CUST.CROSS_CUSTOMER_NK AS X_CUST_NK,
       PM_DET.DISCOUNT_GROUP_NK AS DG_NK,
       PM_DET.DISCOUNT_GROUP_NK_NAME,
       PM_DET.PRICE_CATEGORY AS PRICE_CAT,
       SUM (PM_DET.EXT_SALES_AMOUNT),
       SUM (PM_DET.EXT_AVG_COGS_AMOUNT),
       SUM (PM_DET.EXT_ACTUAL_COGS_AMOUNT)
  FROM    (   (   SALES_MART.PRICE_MGMT_DATA_DET PM_DET
               INNER JOIN
                  SALES_MART.SALES_WAREHOUSE_DIM SWD
               ON (PM_DET.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK))
           RIGHT OUTER JOIN
              DW_FEI.CUSTOMER_DIMENSION CUST
           ON (PM_DET.CUSTOMER_GK = CUST.CUSTOMER_GK))
       INNER JOIN
          SALES_MART.TIME_PERIOD_DIMENSION TPD
       ON (PM_DET.YEARMONTH = TPD.YEARMONTH)
 WHERE (CUST.DELETE_DATE IS NULL) 
 	AND (TPD.ROLL12MONTHS IS NOT NULL)
	AND    CUST.MSTR_CUSTNO IN ('468335',
                              '466563',
                              '173988',
                              '127781',
                              '163935',
                              '102007',
                              '294404',
                              '171670',
                              '169158',
                              '470409',
                              '113151',
                              '143312',
                              '158663',
                              '161534',
                              '518089',
                              '579080',
                              '176817',
                              '423888',
                              '126875',
                              '168036'
                              )
GROUP BY CUST.DELETE_DATE,
         TPD.ROLL12MONTHS,
         SWD.REGION_NAME,
         CUST.ACCOUNT_NUMBER_NK,
         CUST.ACCOUNT_NAME,
         CUST.CUSTOMER_NK,
         CUST.CUSTOMER_NAME,
         CUST.MAIN_CUSTOMER_NK,
         CUST.MSTR_CUSTNO,
         CUST.MSTR_CUST_NAME,
         CUST.CROSS_ACCT,
         CUST.CROSS_CUSTOMER_NK,
         PM_DET.DISCOUNT_GROUP_NK,
         PM_DET.DISCOUNT_GROUP_NK_NAME,
         PM_DET.PRICE_CATEGORY