SELECT DISTINCT
/*
		run monthly for kj sor his branch tracker
		3/1/16 updated
*/
       SLS.ACCOUNT_NUMBER ACCT_NK,
       --SLS.WAREHOUSE_NUMBER_NK WH_NK,
       CASE
         WHEN SLS.STATUS = 'SP-' THEN 'SP-'
         WHEN SLS.STATUS = 'SP' THEN 'SP'
         ELSE 'OTHER'
       END
         ST,
       SUM ( SLS.EXT_SALES_AMOUNT ) EX_SALES,
       SUM ( SLS.EXT_AVG_COGS_AMOUNT ) EX_AC
  FROM     ( SELECT ILF.YEARMONTH,
                    IHF.ACCOUNT_NUMBER,
                    SWD.WAREHOUSE_NUMBER_NK,
                    ILF.PRODUCT_STATUS,
                    CASE
                      WHEN ILF.PRODUCT_GK IS NOT NULL
                      THEN
                        NVL ( ILF.PRODUCT_STATUS, 'STOCK' )
                      ELSE
                        'SP-'
                    END
                      AS STATUS,
                    ILF.EXT_SALES_AMOUNT,
                    ILF.EXT_AVG_COGS_AMOUNT
               FROM   (  DW_FEI.INVOICE_HEADER_FACT IHF
                       INNER JOIN
                         SALES_MART.SALES_WAREHOUSE_DIM SWD
                       ON ( IHF.WAREHOUSE_NUMBER = SWD.WAREHOUSE_NUMBER_NK ))
                    INNER JOIN
                      DW_FEI.INVOICE_LINE_FACT ILF
                    ON ( IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK ) ) SLS
         LEFT OUTER JOIN
           SALES_MART.SALES_WAREHOUSE_DIM SWD
         ON SLS.ACCOUNT_NUMBER = SWD.ACCOUNT_NUMBER_NK
       LEFT OUTER JOIN
         SALES_MART.TIME_PERIOD_DIMENSION TD
       ON SLS.YEARMONTH = TD.YEARMONTH
 WHERE ( SUBSTR ( SWD.REGION_NAME,
                 1,
                 3
        ) IN
            ( 'D10',
             'D11',
             'D12',
             'D13',
             'D14',
             'D30',
             'D31',
             'D32',
             'D50',
             'D51',
             'D53',
             'D59' ) )
       --AND ( SLS.YEARMONTH = 201501 )
       AND TD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE'
--AND SLS.ACCOUNT_NUMBER = '2000'

GROUP BY --SLS.WAREHOUSE_NUMBER_NK,
         SLS.ACCOUNT_NUMBER,
         CASE
           WHEN SLS.STATUS = 'SP-' THEN 'SP-'
           WHEN SLS.STATUS = 'SP' THEN 'SP'
           ELSE 'OTHER'
         END;