SELECT TPD.ROLL12MONTHS,
       SWD.REGION_NAME AS DISTRICT,
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
       PM_DET.PRICE_CATEGORY,
       SUM (PM_DET.EXT_SALES_AMOUNT),
       SUM (PM_DET.EXT_AVG_COGS_AMOUNT),
       SUM (PM_DET.EXT_ACTUAL_COGS_AMOUNT)
  FROM    (   (   SALES_MART.PRICE_MGMT_DATA_DET PM_DET
               INNER JOIN
                  SALES_MART.SALES_WAREHOUSE_DIM SWD
               ON (PM_DET.SELL_WAREHOUSE_NUMBER_NK =
                      SWD.WAREHOUSE_NUMBER_NK))
           RIGHT OUTER JOIN
              DW_FEI.CUSTOMER_DIMENSION CUST
           ON (PM_DET.CUSTOMER_GK = CUST.CUSTOMER_GK))
       INNER JOIN
          SALES_MART.TIME_PERIOD_DIMENSION TPD
       ON (PM_DET.YEARMONTH = TPD.YEARMONTH)
 WHERE     (TPD.ROLL12MONTHS IS NOT NULL)
       AND (CUST.DELETE_DATE IS NULL)
			 AND ( CUST.CUSTOMER_NK
        || ' - '
        || CUST.CUSTOMER_NAME IN ('177218 - AIRO MECHANICAL LLC',
                                  '127826 - APOLLO SHEET METAL INC',
                                   '30893 - ARCHER WESTERN CONSTRUCTN LLC',
                                   '29126 - ARCHER WESTERN CONTRACTORS LTD',
                                  '240442 - BERNHARD MCC LLC',
                                  '253010 - BROUSSARD PLUMBING INC',
                                  '172631 - COLONIALWEBB CONTRACTORS',
                                  '181759 - COLONIALWEBB CONTRACTORS',
                                  '291260 - FRYMIRE SERVICES INC',
                                   '24701 - GARNEY COMPANIES INC',
                                   '30007 - GARNEY COMPANIES INC',
                                  '210008 - HARDY CORPORATION',
                                  '285334 - HARPER LIMBACH LLC',
                                  '141085 - HORIZON INC',
                                  '115023 - HOSPITALITY PLUMBING INC',
                                   '49722 - HUGHES BROTHERS CONSTR INC',
                                  '134514 - IVEY MECHANICAL COMPANY LLC',
                                  '251058 - IVEY MECHANICAL COMPANY LLC',
                                  '354643 - JENNINGS COMPANY INC',
                                  '189480 - JESCO INC',
                                  '107600 - JOHN E GREEN COMPANY',
                                  '112857 - KK MECHANICAL INC',
                                  '146575 - MAKSON INCORPORATED',
                                  '146575 - MAKSON INCORPORATED',
                                  '112664 - MCC MECHANICAL LLC',
                                  '149492 - MCC MECHANICAL LLC',
                                   '29111 - MURPHY PIPELINE CONTRACTOR INC',
                                   '53496 - MURPHY PIPELINE CONTRACTOR INC',
                                   '31775 - PEPPER-LAWSON WATERWORKS LLC',
                                  '197585 - QUALITY PLUMBING & MECHANICAL',
                                  '229678 - QUALITY PLUMBING & MECHANICAL',
                                  '141889 - R K MECHANICAL INC',
                                  '135219 - R T MOORE CO INC',
                                  '349651 - RLP MECHANICAL CONTRACTORS INC',
                                  '147595 - SOUTHEAST MECHANICAL SYSTEMS',
                                  '147595 - SOUTHEAST MECHANICAL SYSTEMS',
                                   '46916 - TB LANDMARK CONSTRUCTION INC',
                                   '49763 - TB LANDMARK CONSTRUCTION INC',
                                  '121679 - TDINDUSTRIES INC',
                                  '132038 - THE BRANDT COMPANIES LLC',
                                   '46063 - TUCKER PAVING INC',
                                   '46063 - TUCKER PAVING INC',
                                   '94203 - WATER SAVERS LLC',
                                  '1085313 - WATER SAVERS LLC',
                                   '14439 - WHARTON-SMITH INC',
                                   '37624 - WHARTON-SMITH INC',
                                   '49085 - YOUNGS COMMUNICATIONS CO INC'))
GROUP BY TPD.ROLL12MONTHS,
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
       PM_DET.PRICE_CATEGORY;