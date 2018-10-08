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
	AND    CUST.CUSTOMER_NK
        || ' - '
        || CUST.CUSTOMER_NAME IN ( '32153 - ARCHER WESTERN CONTRACTORS LTD',
                                  '204617 - BLOX LLC',
                                  '350228 - DYNAMIC SYSTEMS INC',
                                   '52097 - GARNEY COMPANIES INC',
                                  '210008 - HARDY CORPORATION',
                                  '285334 - HARPER LIMBACH LLC',
                                   '51814 - HUGHES BROTHERS CONSTR INC',
                                  '247796 - JESCO INC',
                                  '146575 - MAKSON INCORPORATED',
                                  '146575 - MAKSON INCORPORATED',
                                   '35726 - MURPHY PIPELINE CONTRACTOR INC',
                                   '28413 - OSCAR RENDA CONTRACTING INC',
                                   '31889 - PEPPER-LAWSON WATERWORKS LLC',
                                 '1078306 - R K MECHANICAL INC',
                                  '172064 - R K MECHANICAL INC',
                                   '51682 - REYNOLDS CONSTRUCTION LLC',
                                   '32800 - SANTA CLARA CONSTRUCTION LTD',
                                  '147595 - SOUTHEAST MECHANICAL SYSTEMS',
                                  '147595 - SOUTHEAST MECHANICAL SYSTEMS',
                                  '132038 - THE BRANDT COMPANIES LLC',
                                   '85395 - TOWN OF OAK ISLAND'
                                   '14439 - WHARTON-SMITH INC',
                                   '37624 - WHARTON-SMITH INC'
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