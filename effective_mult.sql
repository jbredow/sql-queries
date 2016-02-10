/*
	effective mult
*/

SELECT BRANCH_NO,
       MAIN_CUST,
       CUST_NO,
       DISC_GROUP,
       PRODUCT,
       BASIS,
       OP,
       VAL,
       MULT
  FROM ( 
	SELECT DISTINCT
                CCOR.BRANCH_NUMBER_NK AS BRANCH_NO,
                CUST.MAIN_CUSTOMER_NK AS MAIN_CUST,
                CCOR.CUSTOMER_NK AS CUST_NO,
                CCOR.DISC_GROUP AS DISC_GROUP,
                NULL AS PRODUCT,
                CCOR.BASIS AS BASIS,
                CCOR.OPERATOR_USED AS OP,
                CCOR.MULTIPLIER AS VAL,
                CASE
                  WHEN CCOR.OPERATOR_USED = '-' THEN 1 - CCOR.MULTIPLIER
                  WHEN CCOR.OPERATOR_USED = 'X' THEN CCOR.MULTIPLIER
                  WHEN CCOR.OPERATOR_USED = '+' THEN 1 + CCOR.MULTIPLIER
                  ELSE 0
                END
                  MULT
           FROM   (  DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
                   LEFT OUTER JOIN
                     DW_FEI.CUSTOMER_DIMENSION CUST
                   ON ( CCOR.CUSTOMER_GK = CUST.CUSTOMER_GK ))
                RIGHT OUTER JOIN
                  EBUSINESS.SALES_DIVISIONS SWD
                ON ( SWD.ACCOUNT_NUMBER_NK = CCOR.BRANCH_NUMBER_NK )
          WHERE     ( CCOR.BRANCH_NUMBER_NK = '1020' )
                AND ( CCOR.DELETE_DATE IS NULL )
                AND ( CCOR.OVERRIDE_TYPE = 'G' )
                AND ( CCOR.BASIS IS NOT NULL )
         ORDER BY CCOR.BRANCH_NUMBER_NK,
                  CUST.MAIN_CUSTOMER_NK,
                  CCOR.CUSTOMER_NK,
                  CCOR.DISC_GROUP )
UNION
( SELECT DISTINCT
         CCOR.BRANCH_NUMBER_NK AS BRANCH_NO,
         CUST.MAIN_CUSTOMER_NK AS MAIN_CUST,
         CCOR.CUSTOMER_NK AS CUST_NO,
         PROD.DISCOUNT_GROUP_NK AS DISC_GROUP,
         CCOR.MASTER_PRODUCT AS PRODUCT,
         CCOR.BASIS AS BASIS,
         CCOR.OPERATOR_USED AS OP,
         CCOR.MULTIPLIER AS VAL,
         CASE
           WHEN CCOR.OPERATOR_USED = '-' THEN 1 - CCOR.MULTIPLIER
           WHEN CCOR.OPERATOR_USED = 'X' THEN CCOR.MULTIPLIER
           WHEN CCOR.OPERATOR_USED = '+' THEN 1 + CCOR.MULTIPLIER
           ELSE 0
         END
           MULT
   FROM   (  (  DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCOR
              INNER JOIN
                DW_FEI.PRODUCT_DIMENSION PROD
              ON ( CCOR.MASTER_PRODUCT = PROD.PRODUCT_NK ))
           LEFT OUTER JOIN
             DW_FEI.CUSTOMER_DIMENSION CUST
           ON ( CCOR.CUSTOMER_GK = CUST.CUSTOMER_GK ))
        RIGHT OUTER JOIN
          EBUSINESS.SALES_DIVISIONS SWD
        ON ( SWD.ACCOUNT_NUMBER_NK = CCOR.BRANCH_NUMBER_NK )
  WHERE     ( CCOR.BRANCH_NUMBER_NK = '1020' )
        AND ( CCOR.BASIS IS NOT NULL )
        AND ( CCOR.BASIS <> '$' )
        AND ( CCOR.DELETE_DATE IS NULL )
        AND ( CCOR.OVERRIDE_TYPE = 'P' ) );