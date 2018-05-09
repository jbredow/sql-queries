SELECT SWD.DIVISION_NAME,
       SWD.REGION_NAME,
       SWD.ACCOUNT_NUMBER_NK,
       SWD.ACCOUNT_NAME,
       SWD.WAREHOUSE_NUMBER_NK,
       SWD.WAREHOUSE_NAME,
       PM_DET.WRITER,
       NVL (EMP.ASSOC_NAME, NULL) WRITER_NAME,
       NVL (EMP.TITLE_DESC, NULL) WRITER_TITLE,
       PM_DET.YEARMONTH,
       PM_DET.PRICE_CATEGORY,
       SUM (PM_DET.EXT_SALES_AMOUNT) AS EXT_SALES,
       SUM (PM_DET.EXT_AVG_COGS_AMOUNT) AS EXT_AVG_COGS
  FROM (SALES_MART.PRICE_MGMT_DATA_DET PM_DET
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM SWD
           ON (PM_DET.SELL_WAREHOUSE_NUMBER_NK = SWD.WAREHOUSE_NUMBER_NK))
       INNER JOIN DW_FEI.EMPLOYEE_DIMENSION_ORIGINAL EMP
          ON     (PM_DET.WRITER = EMP.INITIALS)
             AND (PM_DET.SELL_WAREHOUSE_NUMBER_NK = EMP.WAREHOUSE_ASSIGNED_NK)
 WHERE     (SWD.ACCOUNT_NUMBER_NK IN ('20',
                                      '61',
                                      '1480',
                                      '2000'))
       AND (PM_DET.YEARMONTH = 201803)
       AND (PM_DET.IC_FLAG = 'REGULAR')
GROUP BY SWD.DIVISION_NAME,
         SWD.REGION_NAME,
         SWD.ACCOUNT_NUMBER_NK,
         SWD.ACCOUNT_NAME,
         SWD.WAREHOUSE_NUMBER_NK,
         SWD.WAREHOUSE_NAME,
         PM_DET.WRITER,
         EMP.ASSOC_NAME,
         EMP.TITLE_DESC,
         PM_DET.YEARMONTH,
         PM_DET.IC_FLAG,
         PM_DET.PRICE_CATEGORY