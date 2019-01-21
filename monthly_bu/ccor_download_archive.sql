/*
	monthly backup of contracts for cent*/

CREATE TABLE AAM1365.A_CCOR_CENT_201901 NOLOGGING
	AS 

SELECT * 
  FROM ( (SELECT SWD.DIVISION_NAME REGION,
                 SUBSTR ( SWD.REGION_NAME, 1, 3 ) DIST,
                 SWD.ACCOUNT_NUMBER_NK BRANCH_NO,
                 SWD.ALIAS_NAME BRANCH_NAME,
                 TO_NUMBER (CCORG.CUSTOMER_NK) CUST_NO,
                 CASE
                    WHEN TO_NUMBER (CUST.MAIN_CUSTOMER_NK) =
                            TO_NUMBER (CCORG.CUSTOMER_NK)
                    THEN
                       NULL
                    ELSE
                       TO_NUMBER (CUST.MAIN_CUSTOMER_NK)
                 END
                    MAIN_NO,
                 CUST.CUSTOMER_NAME,
                 CASE
                    WHEN CUST.MAIN_CUSTOMER_NK = CCORG.CUSTOMER_NK THEN NULL
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
                 DW_FEI.CUSTOMER_DIMENSION CUST,
                 EBUSINESS.SALES_DIVISIONS SWD
           WHERE   CCORG.DISC_GROUP = DG.DISCOUNT_GROUP_NK
                 AND CCORG.OVERRIDE_TYPE = 'G'
                 --AND CCORG.EXPIRE_DATE      > SYSDATE
                 AND (CCORG.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK)
                 AND CCORG.DELETE_DATE IS NULL
                 AND CUST.CUSTOMER_GK = CCORG.CUSTOMER_GK
                 AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                            ('D10',
                             'D11',
                             'D12',
                             'D13',
                             'D14',
                             'D30',
                             'D31',
                             'D32',
                             'D50',
                             'D51',
                             'D53'))
                 --AND TO_CHAR (CCORG.EXPIRE_DATE, 'YYYYMM') BETWEEN TO_CHAR('201508')
                 --                                              AND  TO_CHAR('201511')
          --AND SWD.ACCOUNT_NUMBER_NK IN ( '480', '190', '61', '1869', '116', '454' )
          GROUP BY SWD.DIVISION_NAME,
                   SUBSTR ( SWD.REGION_NAME, 1, 3 ),
                   SWD.ACCOUNT_NUMBER_NK,
                   SWD.ALIAS_NAME,
                   TO_NUMBER (CCORG.CUSTOMER_NK),
                   CASE
                      WHEN TO_NUMBER (CUST.MAIN_CUSTOMER_NK) =
                              TO_NUMBER (CCORG.CUSTOMER_NK)
                      THEN
                         NULL
                      ELSE
                         TO_NUMBER (CUST.MAIN_CUSTOMER_NK)
                   END,
                   CUST.CUSTOMER_NAME,
                   CASE
                      WHEN CUST.MAIN_CUSTOMER_NK = CCORG.CUSTOMER_NK THEN NULL
                      ELSE 'JOB'
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
        (SELECT SWD.DIVISION_NAME REGION,
                SUBSTR ( SWD.REGION_NAME, 1, 3 ) DIST,
                SWD.ACCOUNT_NUMBER_NK BRANCH_NO,
                SWD.ALIAS_NAME BRANCH_NAME,
                TO_NUMBER (CCORP.CUSTOMER_NK) CUST_NO,
                CASE
                   WHEN TO_NUMBER (CUST2.MAIN_CUSTOMER_NK) =
                           TO_NUMBER (CCORP.CUSTOMER_NK)
                   THEN
                      NULL
                   ELSE
                      TO_NUMBER (CUST2.MAIN_CUSTOMER_NK)
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
                DW_FEI.CUSTOMER_DIMENSION CUST2,
                EBUSINESS.SALES_DIVISIONS SWD
          WHERE     CCORP.MASTER_PRODUCT = PROD.PRODUCT_NK
                AND PROD.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
                AND (CCORP.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK)
                AND CCORP.OVERRIDE_TYPE = 'P'
                --AND CCORP.EXPIRE_DATE      > SYSDATE
                AND CCORP.DELETE_DATE IS NULL
                AND CUST2.CUSTOMER_GK = CCORP.CUSTOMER_GK
                AND (SUBSTR (SWD.REGION_NAME, 1, 3) IN
                           ('D10',
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
														'D59'))
                --AND TO_CHAR (CCORP.EXPIRE_DATE, 'YYYYMM') BETWEEN TO_CHAR('201508')
                --                                              AND  TO_CHAR('201511')
         				--AND SWD.ACCOUNT_NUMBER_NK IN ( '480', '190', '61', '1869', '116', '454' )
         GROUP BY SWD.DIVISION_NAME,
                  SUBSTR ( SWD.REGION_NAME, 1, 3 ),
                  SWD.ACCOUNT_NUMBER_NK,
                  SWD.ALIAS_NAME,
                  TO_NUMBER (CCORP.CUSTOMER_NK),
                  CASE
                     WHEN TO_NUMBER (CUST2.MAIN_CUSTOMER_NK) =
                             TO_NUMBER (CCORP.CUSTOMER_NK)
                     THEN
                        NULL
                     ELSE
                        TO_NUMBER (CUST2.MAIN_CUSTOMER_NK)
                  END,
                  CUST2.CUSTOMER_NAME,
                  CASE
                     WHEN CUST2.MAIN_CUSTOMER_NK = CCORP.CUSTOMER_NK THEN NULL
                     ELSE 'JOB'
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
--WHERE   XX.DG IN ( '0504', '0505', '0508', '0511', '0513', '0517', '0525', '0528', '0529', '0533', '0534'	)
-- WHERE   XX.DG = '0504'
	/*WHERE TO_CHAR (XX.EXPIRE_DATE, 'YYYYMM') BETWEEN TO_CHAR('201510')
                                                 AND  TO_CHAR('201601')*/

ORDER BY XX.REGION, XX.DIST, XX.BRANCH_NO, XX.MAIN_NO, XX.CUST_NO
;


GRANT SELECT ON AAM1365.A_CCOR_CENT_201901 TO PUBLIC;

SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D10';

SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D11';
 
SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D12';
 
SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D14';

SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D30';
 
 SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D31';
 
 SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D32';
 
 SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) IN ('D50', 'D51', 'D53');
 
/*
 SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D50';
 
 SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D51';
 
 SELECT *
  FROM AAM1365.A_CCOR_CENT_201901 CCOR
 WHERE SUBSTR (CCOR.DIST, 1, 3) = 'D53';*/