select *
from PRICE_MGMT.PR_VICT2_CUST_R2MO x
where x.PRICE_CATEGORY_FINAL IS NULL
AND x.ACCOUNT_NAME = 'OHVAL';