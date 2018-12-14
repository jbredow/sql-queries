
DELETE FROM PRICE_MGMT.PR_PRICE_CAT_HIST_2 P_CAT
WHERE     (P_CAT.YEARMONTH BETWEEN 201707 AND 201712)
      AND (P_CAT.CUSTOMER_ACCOUNT_GK = 137161729)
      AND (P_CAT.EXT_SALES_AMOUNT > 700000 OR P_CAT.EXT_SALES_AMOUNT < -700000);

COMMIT;