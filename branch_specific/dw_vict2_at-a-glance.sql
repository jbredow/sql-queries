--VICT2 sql with updated rounding logic aligned with pricing cube
--10/7/2013, Leigh North
-- set for branch level industrial, waterworks and hvac

/*
DROP TABLE AAA6863.PR_VICT2_SKU_DETAIL;

CREATE TABLE AAA6863.PR_VICT2_SKU_DETAIL
AS */
SELECT DISTINCT
			SP_DTL.YEARMONTH,
			SUBSTR ( SWD.REGION_NAME, 1 ,3 ) DIST,
			SP_DTL.ACCOUNT_NUMBER BRANCH,
			SP_DTL.ACCOUNT_NAME,
			/*SP_DTL.WAREHOUSE_NUMBER,
			SP_DTL.INVOICE_NUMBER_NK,
			SP_DTL.TYPE_OF_SALE,
			SP_DTL.SHIP_VIA_NAME,
			SP_DTL.OML_ASSOC_INI,
			SP_DTL.OML_FL_INI,
			SP_DTL.OML_ASSOC_NAME,
			SP_DTL.WRITER,
			SP_DTL.WR_FL_INI,
			SP_DTL.ASSOC_NAME,
			SP_DTL.DISCOUNT_GROUP_NK,
			SP_DTL.DISCOUNT_GROUP_NAME,
			SP_DTL.CHANNEL_TYPE,
			SP_DTL.INVOICE_LINE_NUMBER,
			SP_DTL.MANUFACTURER,
			SP_DTL.PRODUCT_NK,
			SP_DTL.ALT1_CODE,
			SP_DTL.PRODUCT_NAME,
			SP_DTL.STATUS,
			SP_DTL.SHIPPED_QTY,*/
			SUM ( SP_DTL.EXT_SALES_AMOUNT ) EX_SALES,
			SUM ( SP_DTL.EXT_AVG_COGS_AMOUNT ) EX_AC,
			/*SP_DTL.REPLACEMENT_COST,
			SP_DTL.UNIT_INV_COST,
			SP_DTL.PRICE_CODE,*/
			CASE
					WHEN SP_DTL.PRICE_CATEGORY_OVR = 'OVERRIDE' THEN  
							'OVERRIDE'
					WHEN SP_DTL.PRICE_CATEGORY like 'MATR%' THEN 
							'MATRIX'
					WHEN SP_DTL.PRICE_CATEGORY in ( 'TOOLS', 'QUOTE', 'OTH/ERROR' ) THEN
							'MANUAL'
					ELSE SP_DTL.PRICE_CATEGORY
    	END
    			PRICE_CAT
			/*SP_DTL.PRICE_FORMULA,
			SP_DTL.UNIT_NET_PRICE_AMOUNT,
			SP_DTL.UM,
			SP_DTL.SELL_MULT,
			SP_DTL.PACK_QTY,
			SP_DTL.LIST_PRICE,
			SP_DTL.MATRIX_PRICE,
			SP_DTL.MATRIX,
			SP_DTL.OG_MATRIX,
			CASE WHEN SP_DTL.PRICE_CATEGORY_OVR IS NOT NULL THEN 
			SP_DTL.PR_OVR ELSE NULL END PR_OVR,
			CASE WHEN SP_DTL.PRICE_CATEGORY_OVR IS NOT NULL THEN 
			SP_DTL.PR_OVR_BASIS ELSE NULL END PR_OVR_BASIS,
			CASE WHEN SP_DTL.PRICE_CATEGORY_OVR IS NOT NULL THEN 
			SP_DTL.GR_OVR ELSE NULL END GR_OVR,
			SP_DTL.TRIM_FORM,
			SP_DTL.ORDER_CODE,
			SP_DTL.SOURCE_SYSTEM,
			SP_DTL.CONSIGN_TYPE,
			SP_DTL.MAIN_CUSTOMER_NK,
			SP_DTL.CUSTOMER_NK,
			SP_DTL.CUSTOMER_NAME,
			SP_DTL.PRICE_COLUMN,
			SP_DTL.CUSTOMER_TYPE,
			SP_DTL.REF_BID_NUMBER,
			SP_DTL.SOURCE_ORDER,
			SP_DTL.ORDER_ENTRY_DATE,
			SP_DTL.COPY_SOURCE_HIST,
			SP_DTL.CONTRACT_DESCRIPTION,
			SP_DTL.CONTRACT_NUMBER*/
  FROM    ( SELECT SP_HIST.*,
                  CASE
                     WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                     THEN
                         CASE  
												 		WHEN SP_HIST.ORDER_ENTRY_DATE BETWEEN
                                                              PR_OVR.
                                                              INSERT_TIMESTAMP
                                                       AND
                                                              NVL(PR_OVR.
                                                              EXPIRE_DATE,
    															SP_HIST.ORDER_ENTRY_DATE)
                     				THEN
                            		CASE
																		WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
																						PR_OVR.MULTIPLIER
																		THEN
																				'OVERRIDE'
																		WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
																						(TRUNC (PR_OVR.MULTIPLIER, 2) + .01)
																		THEN
																				'OVERRIDE'
																		WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
																						(ROUND (PR_OVR.MULTIPLIER, 2))
																		THEN
																				'OVERRIDE'
																		WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
																						(TRUNC (PR_OVR.MULTIPLIER, 1) + .1)
																		THEN
																				'OVERRIDE'
																		WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT =
																						FLOOR (PR_OVR.MULTIPLIER) + 1
																		THEN
																				'OVERRIDE'
																		WHEN SP_HIST.ORDER_ENTRY_DATE BETWEEN
																																	GR_OVR.
																																	INSERT_TIMESTAMP
																													AND
																																	NVL(GR_OVR.
																																	EXPIRE_DATE,
																				SP_HIST.ORDER_ENTRY_DATE)
																		THEN
                                				CASE 
																						WHEN 
																								REPLACE (SP_HIST.PRICE_FORMULA,
																										'0.',
																										'.') =
																								REPLACE (
																										NVL (PR_OVR.FORMULA,
																														GR_OVR.FORMULA),
																										'0.',
																										'.')
																						THEN
                                    						'OVERRIDE'
                                 --ELSE
                                    --SP_HIST.PRICE_CATEGORY
                              END
                           --ELSE
                             -- SP_HIST.PRICE_CATEGORY
                        END
                         --ELSE
                              --SP_HIST.PRICE_CATEGORY
                  END
                   --ELSE
                              --SP_HIST.PRICE_CATEGORY
                  END
                     PRICE_CATEGORY_OVR,
                  PR_OVR.FORMULA PR_OVR,
                  REPLACE (PR_OVR.FORMULA, '0.', '.') TRIM_FORM,
                  PR_OVR.BASIS PR_OVR_BASIS,
                  GR_OVR.FORMULA GR_OVR,
                  NVL (PR_OVR.INSERT_TIMESTAMP, GR_OVR.INSERT_TIMESTAMP)
                     CCOR_CREATE,
                  NVL (PR_OVR.EXPIRE_DATE, GR_OVR.EXPIRE_DATE) CCOR_EXPIRE,
                  LB.LINEBUY_NAME,
                  DG.DISCOUNT_GROUP_NAME,
                  MV.MASTER_VENDOR_NAME
									
             FROM ( SELECT 
						 							IHF.ACCOUNT_NUMBER,
             							IHF.YEARMONTH,
                          CUST.ACCOUNT_NAME,
                          IHF.WAREHOUSE_NUMBER,
                          IHF.INVOICE_NUMBER_NK,
                          IHF.JOB_NAME,
                          IHF.CONTRACT_DESCRIPTION,
                          IHF.CONTRACT_NUMBER,
                          IHF.OML_ASSOC_NAME,
                          DECODE (ihf.SALE_TYPE,
                                  '1', 'Our Truck',
                                  '2', 'Counter',
                                  '3', 'Direct',
                                  '4', 'Counter',
                                  '5', 'Credit Memo',
                                  '6', 'Showroom',
                                  '7', 'Showroom Direct',
                                  '8', 'eBusiness')
                             TYPE_OF_SALE,
                          IHF.CHANNEL_TYPE,
                          IHF.SHIP_VIA_NAME,
                          NVL (IHF.WRITER, IHF.OML_ASSOC_INI) WRITER,
                          SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), 0, 1)
                          || SUBSTR (NVL (IHF.WRITER, IHF.OML_ASSOC_INI), -1)
                          WR_FL_INI,
                          IHF.OML_ASSOC_INI,
                          SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
                          || SUBSTR (IHF.OML_ASSOC_INI, -1)
                             OML_FL_INI,
                          CASE
                             WHEN NVL (IHF.WRITER, IHF.OML_ASSOC_INI) =
                                     IHF.OML_ASSOC_INI
                             THEN
                                IHF.OML_ASSOC_NAME
                             WHEN SUBSTR (
                                     NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
                                     0,
                                     1)
                                  || SUBSTR (
                                        NVL (IHF.WRITER, IHF.OML_ASSOC_INI),
                                        -1) =
                                     SUBSTR (IHF.OML_ASSOC_INI, 0, 1)
                                     || SUBSTR (IHF.OML_ASSOC_INI, -1)
                             THEN
                                IHF.OML_ASSOC_NAME
                             ELSE
                                NULL
                          END
                             ASSOC_NAME,
                          ILF.INVOICE_LINE_NUMBER,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.MANUFACTURER
                             ELSE
                                SP_PROD.PRIMARY_VNDR
                          END
                             AS MANUFACTURER,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.PRODUCT_NK
                             ELSE
                                SP_PROD.SPECIAL_PRODUCT_NK
                          END
                             AS PRODUCT_NK,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.ALT1_CODE
                             ELSE
                                SP_PROD.ALT_CODE
                          END
                             AS ALT1_CODE,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.DISCOUNT_GROUP_NK
                             ELSE
                                SP_PROD.SPECIAL_DISC_GROUP
                          END
                             AS DISCOUNT_GROUP_NK,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.LINEBUY_NK
                             ELSE
                                SP_PROD.SPECIAL_LINE
                          END
                             AS LINEBUY_NK,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                PROD.PRODUCT_NAME
                             ELSE
                                SP_PROD.SPECIAL_PRODUCT_NAME
                          END
                             AS PRODUCT_NAME,
                          CASE
                             WHEN ILF.PRODUCT_GK IS NOT NULL
                             THEN
                                NVL (ILF.PRODUCT_STATUS, 'STOCK')
                             ELSE
                                'SP-'
                          END
                             AS STATUS,
                          CASE
                             WHEN ILF.EXT_SALES_AMOUNT <= 1500 THEN 'Y'
                             ELSE 'N'
                          END
                             "<1500",
                          PROD.UNIT_OF_MEASURE UM,
                          PROD.SELL_MULT,
                          PROD.SELL_PACKAGE_QTY PACK_QTY,
                          /*PROD.DISCOUNT_GROUP_NK,
                          PROD.LINEBUY_NK,
                          PROD.PRODUCT_NK,
                          PROD.ALT1_CODE,
                          PROD.PRODUCT_NAME,
                          SP_PROD.ALT_CODE,
                          SP_PROD.PRIMARY_VNDR,
                          SP_PROD.SPECIAL_PRODUCT_NAME,
                          SP_PROD.SPECIAL_PRODUCT_NK,
                          SP_PROD.SPECIAL_DISC_GROUP,
                          SP_PROD.SPECIAL_LINE,*/
                          ILF.SHIPPED_QTY,
                          ILF.EXT_AVG_COGS_AMOUNT,
                          ILF.EXT_SALES_AMOUNT,
                          --ILF.MATRIX_PRICE,
                          CASE
                             WHEN ihf.order_code = 'IC'
                             THEN
                                'CREDITS'
                             WHEN ilf.special_product_gk IS NOT NULL
                             THEN
                                'SPECIALS'
                             WHEN ilf.price_code = 'Q'
                             THEN
                                CASE
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX_PRICE
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX
                                   THEN
                                      'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX, 2) + .01)
                                   THEN
                                      'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                         (ROUND (ilf.MATRIX_PRICE, 2))
																	 THEN
																				'MATRIX'
																	 WHEN ilf.UNIT_NET_PRICE_AMOUNT =
																						(ROUND (ilf.MATRIX, 2))
																	 THEN
																				'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX, 1) + .1)
                                   THEN
                                      'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (ilf.MATRIX_PRICE) + 1
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (ilf.MATRIX) + 1
                                   THEN
                                      'MATRIX_BID'
                                   ELSE
                                      'QUOTE'
                                END
                             WHEN REGEXP_LIKE (ilf.price_code,
                                               '[0-9]?[0-9]?[0-9]')
                             THEN
                                'MATRIX'
																--WHEN NVL (ihf.split_ticket_flag, '0') = '1'
																--THEN
																--   'MATRIX'
														 WHEN ilf.price_code IN ('FC', 'PM', 'spec')
                             THEN
                                'MATRIX'
                             WHEN ilf.price_code LIKE 'M%'
                             THEN
                                'MATRIX'
                             WHEN ilf.price_formula IN ('CPA', 'CPO')
                             THEN
                                'OVERRIDE'
                             WHEN ilf.price_code IN
                                     ('PR',
                                      'GR',
                                      'CB',
                                      'GJ',
                                      'PJ',
                                      '*G',
                                      '*P',
                                      'G*',
                                      'P*',
                                      'G',
                                      'GJ',
                                      'P')
                             THEN
                                'OVERRIDE'
                             WHEN ilf.price_code IN
                                     ('GI', 'GPC', 'HPF', 'HPN', 'NC')
                             THEN
                                'MANUAL'
                             WHEN ilf.price_code = '*E'
                             THEN
                                'OTH/ERROR'
                             WHEN ilf.price_code = 'SKC'
                             THEN
                                'OTH/ERROR'
                             WHEN ilf.price_code IN
                                     ('%', '$', 'N', 'F', 'B', 'PO')
                             THEN
                                'TOOLS'
                             WHEN ilf.price_code IS NULL
                             THEN
                                'MANUAL'
                             WHEN ilf.price_code IN ('R', 'N/A')
                             THEN
                                CASE
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX_PRICE
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           ilf.MATRIX
                                   THEN
                                      'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX_PRICE, 2) + .01)
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX, 2) + .01)
                                   THEN
                                      'MATRIX_BID'
                                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                         (ROUND (ilf.MATRIX_PRICE, 2))
                                 THEN
                                    'MATRIX'
                                    WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                         (ROUND (ilf.MATRIX, 2))
                                 THEN
                                    'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX_PRICE, 1) + .1)
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           (TRUNC (ilf.MATRIX, 1) + .1)
                                   THEN
                                      'MATRIX_BID'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (ilf.MATRIX_PRICE) + 1
                                   THEN
                                      'MATRIX'
                                   WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                                           FLOOR (ilf.MATRIX) + 1
                                   THEN
                                      'MATRIX_BID'
                                   ELSE
                                      'MANUAL'
                                END
                             ELSE
                                'MANUAL'
                          END
                             AS PRICE_CATEGORY,
                          ILF.PRICE_CODE,
                          ILF.PRICE_FORMULA,
                          ILF.UNIT_NET_PRICE_AMOUNT,
                          ILF.UNIT_INV_COST,
                          ILF.REPLACEMENT_COST,
                          ILF.LIST_PRICE,
                          ILF.ORDER_ENTRY_DATE,
                          ILF.PO_COST,
                          ILF.PO_DATE,
                          ILF.PO_NUMBER_NK,
                          ILF.PROCESS_DATE,
                          ILF.PRODUCT_STATUS,
                          ILF.MATRIX,
                          ILF.MATRIX_PRICE OG_MATRIX,
                          NVL (ILF.MATRIX_PRICE, ILF.MATRIX) MATRIX_PRICE,
                          IHF.CONSIGN_TYPE,
                          IHF.ORDER_CODE,
                          IHF.CREDIT_CODE,
                          IHF.CREDIT_MEMO_TYPE,
                          IHF.PO_NUMBER,
                          IHF.REF_BID_NUMBER,
                          IHF.SOURCE_ORDER,
                          IHF.COPY_SOURCE_HIST,
                          IHF.SOURCE_SYSTEM,
                          IHF.CUSTOMER_ACCOUNT_GK,
                          ILF.BUILDER_REBATE,
                          ILF.COST_REBATE,
                          CUST.MAIN_CUSTOMER_NK,
                          CUST.JOB_YN,
                          CUST.CUSTOMER_NK,
                          CUST.CUSTOMER_NAME,
                          CUST.PRICE_COLUMN,
                          CUST.CUSTOMER_TYPE
                     FROM DW_FEI.INVOICE_HEADER_FACT IHF,
                          DW_FEI.INVOICE_LINE_FACT ILF,
                          DW_FEI.PRODUCT_DIMENSION PROD,
                          DW_FEI.CUSTOMER_DIMENSION CUST,
                          DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
                    WHERE IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                          --AND ILF.PRODUCT_STATUS = 'SP'
                          --AND IHF.ACCOUNT_NUMBER = '13'
                          --AND NVL (ILF.PRICE_CODE, 'N/A') IN
                          --      ('Q', 'N/A', 'R')
                          --AND IHF.WRITER = 'CMC'
                          --AND CUST.ACCOUNT_NAME IN ('MIDATLWW','MYERSUG')
                          --AND IHF.INVOICE_NUMBER_NK in ('2658674','2683795')
                          --AND ILF.PRICE_CODE in ('R','N/A','Q')
                          --AND IHF.REF_BID_NUMBER='B225888'
                          --AND CUST.CUSTOMER_NK = '127896'
                          --AND PROD.LINEBUY_NK='200'
                          AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
                          AND DECODE (NVL (cust.ar_gl_number, '9999'),
                                   '1320', 0,
                                   '1360', 0,
                                   '1380', 0,
                                   '1400', 0,
                                   '1401', 0,
                                   '1500', 0,
                                   '4000', 0,
                                   '7100', 0,
                                   '9999', 0,
                                   1) <> 0
                          AND NVL (IHF.CONSIGN_TYPE, 'N/A') <> 'R'
                          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
                          AND ILF.SPECIAL_PRODUCT_GK =
                                 SP_PROD.SPECIAL_PRODUCT_GK(+)
                          AND IHF.IC_FLAG = 0
                          AND ILF.SHIPPED_QTY <> 0
                          --AND IHF.ORDER_CODE NOT IN 'IC'
                          --Excludes shipments to other FEI locations.
                          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
                          AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                                       TRUNC (
                                                          SYSDATE
                                                          - NUMTOYMINTERVAL (
                                                               1,
                                                               'MONTH'),
                                                          'MONTH'),
                                                       'YYYYMM')
                                                AND
                                 TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                          'YYYYMM')
                          AND IHF.YEARMONTH BETWEEN TO_CHAR (
                                                       TRUNC (
                                                          SYSDATE
                                                          - NUMTOYMINTERVAL (
                                                               1,
                                                               'MONTH'),
                                                          'MONTH'),
                                                       'YYYYMM')
                                                AND
                                 TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                          'YYYYMM')
            ) SP_HIST
                  LEFT OUTER JOIN DW_FEI.DISCOUNT_GROUP_DIMENSION DG
                     ON SP_HIST.DISCOUNT_GROUP_NK = DG.DISCOUNT_GROUP_NK
                  LEFT OUTER JOIN DW_FEI.LINE_BUY_DIMENSION LB
                     ON SP_HIST.LINEBUY_NK = LB.LINEBUY_NK
                  LEFT OUTER JOIN DW_FEI.MASTER_VENDOR_DIMENSION MV
                     ON SP_HIST.MANUFACTURER = MV.MASTER_VENDOR_NK
                  LEFT OUTER JOIN (SELECT COD.BASIS,
                                          COD.BRANCH_NUMBER_NK,
                                          COD.CONTRACT_ID,
                                          COD.CUSTOMER_GK,
                                          COD.CUSTOMER_NK,
                                          COD.DISC_GROUP,
                                          COD.INSERT_TIMESTAMP,
                                          COD.EXPIRE_DATE,
                                          COD.MASTER_PRODUCT,
                                          COD.MULTIPLIER,
                                          COD.OPERATOR_USED,
                                          COD.OVERRIDE_ID_NK,
                                          COD.OVERRIDE_TYPE,
                                             COD.BASIS
                                          || COD.OPERATOR_USED
                                          || '0'
                                          || COD.MULTIPLIER
                                             FORMULA
                                     FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION
    COD
                                    WHERE COD.OVERRIDE_TYPE = 'G'
                                          AND COD.DELETE_DATE IS NULL
                                          AND NVL(COD.EXPIRE_DATE,SYSDATE) >=
    (SYSDATE-395)) GR_OVR
                     ON (SP_HIST.DISCOUNT_GROUP_NK =
                            (LTRIM (GR_OVR.DISC_GROUP, '0'))
                         AND SP_HIST.ACCOUNT_NUMBER = GR_OVR.BRANCH_NUMBER_NK
                         AND SP_HIST.CUSTOMER_ACCOUNT_GK = GR_OVR.CUSTOMER_GK
                         AND NVL(SP_HIST.CONTRACT_NUMBER,'DEFAULT_MATCH')=NVL(
    GR_OVR.CONTRACT_ID,'DEFAULT_MATCH'))
                  LEFT OUTER JOIN (SELECT COD.BASIS,
                                          COD.BRANCH_NUMBER_NK,
                                          COD.CONTRACT_ID,
                                          COD.CUSTOMER_GK,
                                          COD.CUSTOMER_NK,
                                          COD.DISC_GROUP,
                                          COD.INSERT_TIMESTAMP,
                                          COD.EXPIRE_DATE,
                                          COD.MASTER_PRODUCT,
                                          TO_NUMBER (COD.MULTIPLIER)
                                             MULTIPLIER,
                                          COD.OPERATOR_USED,
                                          COD.OVERRIDE_ID_NK,
                                          COD.OVERRIDE_TYPE,
                                          CASE
                                             WHEN COD.OPERATOR_USED <>
                                                     '$'
                                             THEN
                                                   COD.BASIS
                                                || COD.OPERATOR_USED
                                                || '0'
                                                || COD.MULTIPLIER
                                             ELSE
                                                TO_CHAR (COD.MULTIPLIER)
                                          END
                                             FORMULA
                                     FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION
    COD
                                    WHERE COD.OVERRIDE_TYPE = 'P'
                                          AND COD.DELETE_DATE IS NULL
                                          AND NVL(COD.EXPIRE_DATE,SYSDATE) >=
    (SYSDATE-395)) PR_OVR
                     ON (    SP_HIST.PRODUCT_NK = PR_OVR.MASTER_PRODUCT
                         AND SP_HIST.ACCOUNT_NUMBER = PR_OVR.BRANCH_NUMBER_NK
                         AND SP_HIST.CUSTOMER_ACCOUNT_GK = PR_OVR.CUSTOMER_GK
                         AND NVL(SP_HIST.CONTRACT_NUMBER,'DEFAULT_MATCH')=NVL(
    PR_OVR.CONTRACT_ID,'DEFAULT_MATCH'))
              ) SP_DTL
LEFT OUTER JOIN
  SALES_MART.SALES_WAREHOUSE_DIM SWD
   ON SP_DTL.ACCOUNT_NUMBER = SWD.ACCOUNT_NUMBER_NK

   WHERE ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN (
                     	'D40',
											'D41',
											'D42',
											'D50',
											'D51',
											'D52',
											'D53',
											'D54',
											'D59',
											'D60',
											'D61',
											'D62',
											'D63',
											'D69'
                     ))
    	/*AND SP_DTL.DISCOUNT_GROUP_NK IN ( '1072',
																					'1076',
																					'0540',
																					'0545'
																					)
       LEFT OUTER JOIN DW_FEI.EMPLOYEE_DIMENSION emp
			ON SP_DTL.ACCOUNT_NAME = emp.ACCOUNT_NAME
			AND SP_DTL.WRITER = emp.INITIALS */
GROUP BY
    SP_DTL.YEARMONTH,
       SP_DTL.ACCOUNT_NUMBER,
       SP_DTL.ACCOUNT_NAME,
			 SUBSTR ( SWD.REGION_NAME, 1 ,3 ),
     case
     when SP_DTL.PRICE_CATEGORY_OVR = 'OVERRIDE' then  'OVERRIDE'
    when SP_DTL.PRICE_CATEGORY like 'MATR%' then 'MATRIX'
    when SP_DTL.PRICE_CATEGORY in ( 'TOOLS', 'QUOTE', 'OTH/ERROR' ) then
    'MANUAL'
    else SP_DTL.PRICE_CATEGORY
    end;
GRANT SELECT ON AAA6863.PR_VICT2_SKU_DETAIL TO PUBLIC;