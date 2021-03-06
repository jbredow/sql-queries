SELECT DTL.ACCOUNT_NUMBER_NK,
       DTL.IC_FLAG,
       SUM (DTL.EXT_SALES_AMOUNT),
       SUM (DTL.EXT_AVG_COGS_AMOUNT),
       DTL.PRICE_COLUMN
  FROM SALES_MART.PRICE_MGMT_DATA_DET DTL
WHERE     (DTL.YEARMONTH BETWEEN 201408 AND 201412)
       AND (DTL.ACCOUNT_NUMBER_NK = '190')
       AND (DTL.IC_FLAG = 'REGULAR')
GROUP BY DTL.ACCOUNT_NUMBER_NK, DTL.IC_FLAG, DTL.PRICE_COLUMN
;