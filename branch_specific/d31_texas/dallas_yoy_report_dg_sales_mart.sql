SELECT TPD.ROLL12MONTHS    AS TPD,
  PM_DET.SELL_ACCOUNT_NAME AS ACCOUNT_NAME,
  PM_DET.ACCOUNT_NUMBER_NK AS ACCOUNT_NK,
  PM_DET.OLD_ACCOUNT_NUMBER_NK,
  PM_DET.ACTIVE_ACCOUNT_NUMBER_NK,
  PM_DET.DISCOUNT_GROUP_NK DG_NK,
	PM_DET.DISCOUNT_GROUP_NK_NAME,
  PM_DET.PRICE_CATEGORY,
  SUM(PM_DET.EXT_SALES_AMOUNT),
  SUM(PM_DET.EXT_AVG_COGS_AMOUNT)
FROM SALES_MART.PRICE_MGMT_DATA_DET PM_DET
INNER JOIN SALES_MART.TIME_PERIOD_DIMENSION TPD
ON TPD.YEARMONTH = PM_DET.YEARMONTH
INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
ON PM_DET.CUSTOMER_GK         = CUST.CUSTOMER_GK
WHERE TPD.ROLL12MONTHS       IS NOT NULL
AND PM_DET.ACCOUNT_NUMBER_NK IN ('61', '116', '190', '454', '480', '1869')
GROUP BY TPD.ROLL12MONTHS,
  TPD.ROLL12MONTHS,
  PM_DET.SELL_ACCOUNT_NAME,
  PM_DET.ACCOUNT_NUMBER_NK,
  PM_DET.OLD_ACCOUNT_NUMBER_NK,
  PM_DET.ACTIVE_ACCOUNT_NUMBER_NK,
  PM_DET.DISCOUNT_GROUP_NK,
	PM_DET.DISCOUNT_GROUP_NK_NAME,
  PM_DET.PRICE_CATEGORY
	;