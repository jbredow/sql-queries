
CREATE OR REPLACE FORCE VIEW "AAA6863"."PR_DIST_BR_PC" ("ACCOUNT_NAME",
      "MAIN_CUST", "CUST_NK", "CUSTOMER_NAME", "CUSTOMER_ALPHA", "BRANCH_NK",
      "PRICE_COLUMN", "AR_GL") AS
  SELECT                                            
				 --CUST.ACCOUNT_NUMBER_NK,
         CUST.ACCOUNT_NAME,
         CUST.MAIN_CUSTOMER_NK MAIN_CUST,
         CUST.CUSTOMER_NK CUST_NK,
         CUST.CUSTOMER_NAME,
         CUST.CUSTOMER_ALPHA,
         --CUST.CUSTOMER_ALPHA_SORT,
         /* TO_NUMBER (CUST.IC_EDI_BRANCHNO) IC_EDI_BR_NK,
          LTRIM (
             NVL (REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{4}'),
                  REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{3}')),
             '0')
             AS BRANCH,
         NVL (
            LTRIM (
               NVL (REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{4}'),
                    REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{3}')),
               '0'),
            CUST.IC_EDI_BRANCHNO)
            AS BRANCH_NUMBER,*/
          LTRIM (
             COALESCE (CUST.IC_EDI_BRANCHNO,
                       REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{4}'),
                       REGEXP_SUBSTR (CUST.CUSTOMER_NAME, '[[:digit:]]{3}')),
             '0')
             AS BRANCH_NK,
          CUST.PRICE_COLUMN,
          CUST.AR_GL_NUMBER AR_GL
     FROM DW_FEI.CUSTOMER_DIMENSION CUST
    WHERE     CUST.ACCOUNT_NAME = 'DIST'
          AND CUST.CUSTOMER_NAME NOT LIKE '%DO NOT USE%'
          AND CUST.IC_EDI_BRANCHNO NOT IN ('39')
          AND CUST.DELETE_DATE IS NULL
          AND CUST.JOB_YN = 'N'
          AND CUST.CUSTOMER_ALPHA NOT LIKE '@%'
          AND CUST.CUSTOMER_NAME NOT LIKE '%INTEG%'
   ORDER BY TO_NUMBER (CUST.IC_EDI_BRANCHNO) ASC;
	 
  GRANT SELECT ON "AAA6863"."PR_DIST_BR_PC" TO PUBLIC;