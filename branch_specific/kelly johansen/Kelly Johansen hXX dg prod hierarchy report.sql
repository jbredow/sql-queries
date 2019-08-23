SELECT bg_hier.DISCOUNT_GROUP_GK,
       CASE
          WHEN pcat.EOM_YEARMONTH BETWEEN 201810 AND 201812
          THEN
             '10/18-12/19'
          WHEN pcat.EOM_YEARMONTH BETWEEN 201901 AND 201903
          THEN
             '01/19-03/19'
          WHEN pcat.EOM_YEARMONTH BETWEEN 201904 AND 201906
          THEN
             '04/18-06/19'
       END
          TPD,
       swd.DIVISION_NAME,
       swd.REGION_NAME,
       swd.ACCOUNT_NAME,
       bg_hier.DESCRIPTION,
       bg_hier.HILEV,
       bg_hier.DET1,
       bg_hier.DET2,
       bg_hier.DET3,
       CASE WHEN ihf.WRITER LIKE 'h%' THEN 'HOMEOWNER' ELSE 'OTHER' END
          WRITER_TYPE,
       SUM (pcat.EXT_SALES_AMOUNT)
          AS SUM_EXT_SALES_AMOUNT,
       SUM (pcat.CORE_ADJ_AVG_COST)
          AS SUM_CORE_ADJ_AVG_COST,
       SUM (pcat.SHIPPED_QTY)
          AS SUM_SHIPPED_QTY
FROM (((PRICE_MGMT.PR_PRICE_CAT_HIST pcat
        INNER JOIN SALES_MART.SALES_WAREHOUSE_DIM swd
           ON (pcat.WAREHOUSE_NUMBER = swd.WAREHOUSE_NUMBER_NK))
       INNER JOIN DW_FEI.PRODUCT_DIMENSION prod
          ON (pcat.PRODUCT_GK = prod.PRODUCT_GK))
      INNER JOIN USER_SHARED.BUSGRP_PROD_HIERARCHY bg_hier
         ON (prod.DISCOUNT_GROUP_NK = bg_hier.DISCOUNT_GROUP_NK))
     INNER JOIN DW_FEI.INVOICE_HEADER_FACT ihf
        ON (ihf.INVOICE_NUMBER_GK = pcat.INVOICE_NUMBER_GK)
WHERE     pcat.EOM_YEARMONTH BETWEEN '201810' AND '201906'
      AND (SUBSTR (swd.REGION_NAME, 1, 3) IN ('D02', 'D20', 'S97'))
GROUP BY bg_hier.DISCOUNT_GROUP_GK,
         CASE
            WHEN pcat.EOM_YEARMONTH BETWEEN 201810 AND 201812
            THEN
               '10/18-12/19'
            WHEN pcat.EOM_YEARMONTH BETWEEN 201901 AND 201903
            THEN
               '01/19-03/19'
            WHEN pcat.EOM_YEARMONTH BETWEEN 201904 AND 201906
            THEN
               '04/18-06/19'
         END,
         swd.DIVISION_NAME,
         swd.REGION_NAME,
         swd.ACCOUNT_NAME,
         bg_hier.DESCRIPTION,
         bg_hier.HILEV,
         bg_hier.DET1,
         bg_hier.DET2,
         bg_hier.DET3,
         CASE WHEN ihf.WRITER LIKE 'h%' THEN 'HOMEOWNER' ELSE 'OTHER' END;