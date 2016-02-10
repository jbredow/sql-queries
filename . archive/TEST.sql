(
   "CATEGORY",
   "SUB_CATEGORY",
   "COLUMN",
   "COLUMN_NAME",
   "CUSTOMER_TYPE",
   "CTYPE_DEFINITION",
   "CUSTOMER PROFILE DEFINITION",
   "MIN_COLUMN",
   "MAX_COLUMN"
)
AS
   SELECT DISTINCT
/*SELECTS A REFERENCE OF CUST TYPE BY COLUMN*/
          PR_COLUMN_STRATEGY.CATEGORY
          PR_COLUMN_STRATEGY.SUB_CATEGORY
          PR_COLUMN_STRATEGY."COLUMN"
          PR_COLUMN_STRATEGY.COLUMN_NAME
          PR_CTYPE_STRATEGY.CUSTOMER_TYPE
          PR_CTYPE_STRATEGY.CTYPE_DEFINITION
          PR_COLUMN_STRATEGY."CUSTOMER PROFILE DEFINITION"
          MIN (
             PR_COLUMN_STRATEGY."COLUMN")
          OVER (
             PARTITION BY PR_COLUMN_STRATEGY.CATEGORY
                          PR_CTYPE_STRATEGY.CUSTOMER_TYPE)
             MIN_COLUMN
          MAX (
             PR_COLUMN_STRATEGY."COLUMN")
          OVER (
             PARTITION BY PR_COLUMN_STRATEGY.CATEGORY
                          PR_CTYPE_STRATEGY.CUSTOMER_TYPE)
             MAX_COLUMN
     FROM    AAD9606.PR_COLUMN_STRATEGY PR_COLUMN_STRATEGY
          INNER JOIN
             AAD9606.PR_CTYPE_STRATEGY PR_CTYPE_STRATEGY
          ON (PR_COLUMN_STRATEGY.CATEGORY = PR_CTYPE_STRATEGY.CATEGORY)
             AND (PR_COLUMN_STRATEGY.SUB_CATEGORY =
                     PR_CTYPE_STRATEGY.SUB_CATEGORY);

GRANT SELECT ON "AAD9606"."PR_COLUMN_TYPE_XREF" TO PUBLIC
