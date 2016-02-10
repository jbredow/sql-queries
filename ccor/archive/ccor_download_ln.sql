SELECT *
  FROM ( (SELECT CONTACTS.RPC,
                 CONTACTS.DISTRICT DIST,
                 TO_NUMBER (CCORG.BRANCH_NUMBER_NK) BRANCH_NO,
                 CONTACTS.ALIAS BRANCH_NAME,
                 TO_NUMBER (CCORG.CUSTOMER_NK) CUST_NO,
                 CASE
                    WHEN TO_NUMBER (CUST.MAIN_CUSTOMER_NK) =
                            TO_NUMBER (CCORG.CUSTOMER_NK)
                    THEN NULL
                    ELSE TO_NUMBER (CUST.MAIN_CUSTOMER_NK)
                 END
                    MAIN_NO,
                 CUST.CUSTOMER_NAME,
                 CASE
                    WHEN CUST.MAIN_CUSTOMER_NK = CCORG.CUSTOMER_NK 
										THEN NULL
                    ELSE 'JOB'
                 END
                    "MAIN/JOB",
                 CCORG.CONTRACT_ID,
                 CCORG.OVERRIDE_ID_NK,
                 CCORG.OVERRIDE_TYPE "TYPE",
                 CCORG.DISC_GROUP DG,
                 DG.DISCOUNT_GROUP_NAME,
                 NULL AS ALT1_CODE,
                 NULL AS PRODUCT_NAME,
                 CCORG.EXPIRE_DATE,
                 CCORG.BASIS,
                 CCORG.OPERATOR_USED OP,
                 CCORG.MULTIPLIER DISC,
                 CCORG.INSERT_TIMESTAMP INSERT_TS,
                 CCORG.UPDATE_TIMESTAMP UPDATE_TS,
                 CCORG.LAST_UPDATE,
								 CCORG.EFFECTIVE_PROD
            FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORG,
                 DW_FEI.DISCOUNT_GROUP_DIMENSION DG,
                 AAF1046.BRANCH_CONTACTS CONTACTS,
                 DW_FEI.CUSTOMER_DIMENSION CUST
           WHERE     CCORG.DISC_GROUP = DG.DISCOUNT_GROUP_NK
                 AND CONTACTS.ACCOUNT_NK = CCORG.BRANCH_NUMBER_NK
                 AND CCORG.OVERRIDE_TYPE = 'G'
                 --AND CCORG.EXPIRE_DATE > SYSDATE
                 AND CCORG.DELETE_DATE IS NULL
                 AND CONTACTS.RPC = 'Midwest'
                 AND CUST.CUSTOMER_GK = CCORG.CUSTOMER_GK
          GROUP BY CONTACTS.RPC,
                   CONTACTS.DISTRICT,
                   CCORG.BRANCH_NUMBER_NK,
                   CONTACTS.ALIAS,
                   CCORG.CUSTOMER_NK,
                   CASE
                      WHEN TO_NUMBER (CUST.MAIN_CUSTOMER_NK) =
                              TO_NUMBER (CCORG.CUSTOMER_NK)
                      THEN NULL
                      ELSE TO_NUMBER (CUST.MAIN_CUSTOMER_NK)
                   END,
                   	CUST.CUSTOMER_NAME,
                   CASE
                      WHEN CUST.MAIN_CUSTOMER_NK = CCORG.CUSTOMER_NK
                      THEN
                         NULL
                      ELSE
                         'JOB'
                   END,
                   CCORG.CONTRACT_ID,
                   CCORG.OVERRIDE_ID_NK,
                   CCORG.OVERRIDE_TYPE,
                   CCORG.DISC_GROUP,
                   DG.DISCOUNT_GROUP_NAME,
                   CCORG.EXPIRE_DATE,
                   CCORG.BASIS,
                   CCORG.OPERATOR_USED,
                   CCORG.MULTIPLIER,
                   CCORG.INSERT_TIMESTAMP,
                   CCORG.UPDATE_TIMESTAMP,
                   CCORG.LAST_UPDATE,
								 	 CCORG.EFFECTIVE_PROD)
        UNION
        --Old Product CCORs (12 Month)
        (SELECT CONTACTS.RPC,
                CONTACTS.DISTRICT DIST,
                TO_NUMBER (CCORP.BRANCH_NUMBER_NK) BRANCH_NO,
                CONTACTS.ALIAS BRANCH_NAME,
                TO_NUMBER (CCORP.CUSTOMER_NK) CUST_NO,
                CASE
                   WHEN TO_NUMBER (CUST2.MAIN_CUSTOMER_NK) =
                           TO_NUMBER (CCORP.CUSTOMER_NK)
                   THEN NULL
                   ELSE TO_NUMBER (CUST2.MAIN_CUSTOMER_NK)
                END
                   MAIN_NO,
                CUST2.CUSTOMER_NAME,
                CASE
                   WHEN CUST2.MAIN_CUSTOMER_NK = CCORP.CUSTOMER_NK THEN NULL
                   ELSE 'JOB'
                END
                   "MAIN/JOB",
                CCORP.CONTRACT_ID,
                CCORP.OVERRIDE_ID_NK,
                CCORP.OVERRIDE_TYPE "TYPE",
                PROD.DISCOUNT_GROUP_NK DG,
                DG.DISCOUNT_GROUP_NAME,
                PROD.ALT1_CODE,
                PROD.PRODUCT_NAME,
                CCORP.EXPIRE_DATE,
                CCORP.BASIS,
                CCORP.OPERATOR_USED OP,
                CCORP.MULTIPLIER DISC,
                CCORP.INSERT_TIMESTAMP INSERT_TS,
                CCORP.UPDATE_TIMESTAMP UPDATE_TS,
                CCORP.LAST_UPDATE,
								CCORP.EFFECTIVE_PROD
           FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION CCORP,
                DW_FEI.PRODUCT_DIMENSION PROD,
                DW_FEI.DISCOUNT_GROUP_DIMENSION DG,
                AAF1046.BRANCH_CONTACTS CONTACTS,
                DW_FEI.CUSTOMER_DIMENSION CUST2
          WHERE     CCORP.MASTER_PRODUCT = PROD.PRODUCT_NK
                AND PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
                AND CONTACTS.ACCOUNT_NK = CCORP.BRANCH_NUMBER_NK
                AND CCORP.OVERRIDE_TYPE = 'P'
                --AND CCORP.EXPIRE_DATE      > SYSDATE
                AND CCORP.DELETE_DATE IS NULL
                AND CONTACTS.RPC = 'Midwest'
                AND CUST2.CUSTOMER_GK = CCORP.CUSTOMER_GK
         GROUP BY CONTACTS.RPC,
                  CONTACTS.DISTRICT,
                  CCORP.BRANCH_NUMBER_NK,
                  CONTACTS.ALIAS,
                  CCORP.CUSTOMER_NK,
                  CASE
                     WHEN TO_NUMBER (CUST2.MAIN_CUSTOMER_NK) =
                             TO_NUMBER (CCORP.CUSTOMER_NK)
                     THEN NULL
                     ELSE TO_NUMBER (CUST2.MAIN_CUSTOMER_NK)
                  END,
                  CUST2.CUSTOMER_NAME,
                  CASE
                     WHEN CUST2.MAIN_CUSTOMER_NK = CCORP.CUSTOMER_NK
                     THEN
                        NULL
                     ELSE
                        'JOB'
                  END,
                  CCORP.CONTRACT_ID,
                  CCORP.OVERRIDE_ID_NK,
                  CCORP.OVERRIDE_TYPE,
                  PROD.DISCOUNT_GROUP_NK,
                  DG.DISCOUNT_GROUP_NAME,
                  PROD.ALT1_CODE,
                  PROD.PRODUCT_NAME,
                  CCORP.EXPIRE_DATE,
                  CCORP.BASIS,
                  CCORP.OPERATOR_USED,
                  CCORP.MULTIPLIER,
                  CCORP.INSERT_TIMESTAMP,
                  CCORP.UPDATE_TIMESTAMP,
                  CCORP.LAST_UPDATE,
								  CCORP.EFFECTIVE_PROD)) XX
WHERE XX.dg IN ('0549', '0550', '0551', '0556', '0559', '0565', '9903')
ORDER BY XX.BRANCH_NAME,
         XX.CUST_NO,
         XX.DG,
         XX.ALT1_CODE
;