/*
	monthly matrix back-up not including hfm/g
*/
--DROP TABLE AAM1365.A_MATRIX_CENT_201803;

CREATE TABLE AAM1365.A_MATRIX_CENT_201803
	AS 
	(
	SELECT * FROM (
		SELECT SWD.DIVISION_NAME AS REG,
      SUBSTR ( SWD.REGION_NAME, 1 ,3 ) AS DIST,
	  SWD.ACCOUNT_NUMBER_NK AS BR_NO,								
	  SWD.ALIAS_NAME AS BRANCH_NAME,
      PRICE.PRICE_ID,
	  PRICE.PRICE_COLUMN PC,
	  PRICE.PRICE_TYPE,
      DG.DISCOUNT_GROUP_NK DG_NO,
      DG.DISCOUNT_GROUP_NAME DG_NAME,
	  NULL AS ALT1_CODE,
	  NULL AS PRODUCT_NAME,
      PRICE.BASIS BAS,
      PRICE.OPERATOR_USED OP,
      PRICE.MULTIPLIER MULT,
      PRICE.UPDATE_TIMESTAMP UPDATE_TS
       
  FROM     (    DW_FEI.PRICE_DIMENSION PRICE
            INNER JOIN
                EBUSINESS.SALES_DIVISIONS SWD
            ON ( PRICE.BRANCH_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK ))
       INNER JOIN
           DW_FEI.DISCOUNT_GROUP_DIMENSION DG
       ON ( PRICE.DISC_GROUP = DG.DISCOUNT_GROUP_NK )
 WHERE ( PRICE.PRICE_TYPE = 'G' )
 	--AND ( SWD.ACCOUNT_NUMBER_NK = '2778' )
	--AND DG.DISCOUNT_GROUP_NK = '0540'
	AND (PRICE.PRICE_COLUMN   NOT IN (
								 	23, 170, 171, 172, 173,
											180, 181, 182, 183,
											190, 191, 192, 193))
	AND ( PRICE.DELETE_DATE IS NULL )
	AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
					'D10', 'D11', 'D12', 'D14', 
					'D30', 'D31', 'D32', 
					'D50', 'D51', 'D53'
					))
	)
UNION (
	SELECT SWD.DIVISION_NAME AS REG,
			SUBSTR ( SWD.REGION_NAME, 1 ,3 ) AS DIST,
			SWD.ACCOUNT_NUMBER_NK AS BR_NO,								
			SWD.ALIAS_NAME AS BRANCH_NAME,
			PRICE.PRICE_ID,
			PRICE.PRICE_COLUMN AS PC,
			PRICE.PRICE_TYPE,
			DG.DISCOUNT_GROUP_NK AS DG_NO,
			DG.DISCOUNT_GROUP_NAME AS DG_NAME,
			PROD.ALT1_CODE,
			PROD.PRODUCT_NAME,
			PRICE.BASIS AS BAS,
			PRICE.OPERATOR_USED AS OP,
			PRICE.MULTIPLIER AS MULT,
			PRICE.UPDATE_TIMESTAMP AS UPDATE_TS
								
  FROM     (    (    EBUSINESS.SALES_DIVISIONS SWD
                INNER JOIN
                    DW_FEI.PRICE_DIMENSION PRICE
                ON ( SWD.ACCOUNT_NUMBER_NK = PRICE.BRANCH_NUMBER_NK ))
           INNER JOIN
               DW_FEI.PRODUCT_DIMENSION PROD
           ON ( PROD.PRODUCT_NK = PRICE.MASTER_PRODUCT_NK ))
      INNER JOIN
          DW_FEI.DISCOUNT_GROUP_DIMENSION DG
      ON ( PROD.DISCOUNT_GROUP_GK = DG.DISCOUNT_GROUP_GK )
 WHERE     ( PRICE.PRICE_TYPE = 'P' )
 			--AND ( SWD.ACCOUNT_NUMBER_NK = '2778' )
      --AND ( DG.DISCOUNT_GROUP_NK = '0540' )
			AND (PRICE.PRICE_COLUMN   NOT IN (
								 	23, 170, 171, 172, 173,
											180, 181, 182, 183,
											190, 191, 192, 193))
      AND ( PRICE.DELETE_DATE IS NULL )
			AND ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
							'D10', 'D11', 'D12', 'D14', 
							'D30', 'D31', 'D32', 
							'D50', 'D51', 'D53'
							)) 
			  ) 
		) 
;

GRANT SELECT ON  AAM1365.A_MATRIX_CENT_201506 TO PUBLIC;

SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D10';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D11';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D12';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D14';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D30';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D31';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D32';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST IN ( 'D50', 'D51', 'D53' );


/*SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D50';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D51';
SELECT * FROM AAM1365.A_MATRIX_CENT_201803 WHERE DIST = 'D53';*/



