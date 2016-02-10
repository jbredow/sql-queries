/*
	Joe Hall customer report
	drops the DG's and groupings
	run monthly
*/

SELECT XX.BRANCH_NO,
       XX.MAIN_NO,
			 --XX.CUSTOMER_NK,
       XX.CUST_NAME,
       NVL ( XX.PRODUCT_GROUP, 'OTHER' ) PRODUCT_GROUP,
       --XX.DG_NK,
       SUM ( XX.LAST_MO_TY_EX_SALES ) AS LMTY_EX_SALES,
       SUM ( XX.LAST_MO_TY_EX_AC ) AS LMTY_EX_AC,
       SUM ( XX.LAST_MO_LY_EX_SALES ) AS LMLY_EX_SALES,
       SUM ( XX.LAST_MO_LY_EX_AC ) AS LMLY_EX_AC,
       SUM ( XX.FYTD_TY_EX_SALES ) AS FYTY_EX_SALES,
       SUM ( XX.FYTD_TY_EX_AC ) AS FYTY_EX_AC,
       SUM ( XX.FYTD_LY_EX_SALES ) AS FYLY_EX_SALES,
       SUM ( XX.FYTD_LY_EX_AC ) AS FYLY_EX_AC
			 
			 
  FROM ( SELECT IHF.ACCOUNT_NUMBER AS BRANCH_NO,
                CUST_DIM.MAIN_CUSTOMER_NK AS MAIN_NO,
								--CUST_DIM.CUSTOMER_NK,
                CUST_DIM.CUSTOMER_NAME AS CUST_NAME,
                NVL ( DG_LIST.PRODUCT_GROUP, NULL ) AS PRODUCT_GROUP,
                --PROD.DISCOUNT_GROUP_NK AS DG_NK,
                SUM ( ILF.EXT_SALES_AMOUNT ) AS LAST_MO_TY_EX_SALES,
                SUM ( ILF.EXT_AVG_COGS_AMOUNT ) AS LAST_MO_TY_EX_AC,
                NULL AS LAST_MO_LY_EX_SALES,
                NULL AS LAST_MO_LY_EX_AC,
                NULL AS FYTD_TY_EX_SALES,
                NULL AS FYTD_TY_EX_AC,
                NULL AS FYTD_LY_EX_SALES,
                NULL AS FYTD_LY_EX_AC
           FROM   (  (  (  (  DW_FEI.PRODUCT_DIMENSION PROD
                            LEFT OUTER JOIN
                              AAA6863.DALLAS_DG_LIST DG_LIST
                            ON ( PROD.DISCOUNT_GROUP_NK =
                                  DG_LIST.DISCOUNT_GROUP_NK ))
                         INNER JOIN
                           DW_FEI.INVOICE_LINE_FACT ILF
                         ON ( PROD.PRODUCT_GK = ILF.PRODUCT_GK ))
                      INNER JOIN
                        DW_FEI.INVOICE_HEADER_FACT IHF
                      ON ( IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK ))
                   INNER JOIN
                     DW_FEI.CUSTOMER_DIMENSION CUST_DIM
                   ON ( IHF.CUSTOMER_NUMBER_NK = CUST_DIM.CUSTOMER_NK )
                      AND ( IHF.CUSTOMER_ACCOUNT_GK = CUST_DIM.CUSTOMER_GK ))
                INNER JOIN
                  SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON ( IHF.YEARMONTH = TPD.YEARMONTH )
          WHERE ( IHF.ACCOUNT_NUMBER = '61' )
                AND ( CUST_DIM.MAIN_CUSTOMER_NK IN
                         ('2219', '3258', '27743', '108990',
												  '147880', '142512', '144334', '142737',
													'138281', '144574', '144801', '143109') )
								--AND ( CUST_DIM.MAIN_CUSTOMER_NK IN ('2219', '62054', '62059', '26347') )
                -- AND ( TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE' )
                AND TPD.YEARMONTH = TO_CHAR ( TRUNC ( SYSDATE,
                                                     'MM'
                                             )
                                             - 1,
                                             'YYYYMM'
                                    )
         GROUP BY IHF.ACCOUNT_NUMBER,
                  CUST_DIM.MAIN_CUSTOMER_NK,
									CUST_DIM.CUSTOMER_NK,
                  CUST_DIM.CUSTOMER_NAME,
                  NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                  PROD.DISCOUNT_GROUP_NK
         UNION
         SELECT IHF.ACCOUNT_NUMBER AS BRANCH_NO,
                CUST_DIM.MAIN_CUSTOMER_NK AS MAIN_NO,
								--CUST_DIM.CUSTOMER_NK,
                CUST_DIM.CUSTOMER_NAME AS CUST_NAME,
                NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                --PROD.DISCOUNT_GROUP_NK,
                NULL AS LAST_MO_TY_EX_SALES,
                NULL AS LAST_MO_TY_EX_AC,
                SUM ( ILF.EXT_SALES_AMOUNT ) AS LAST_MO_LY_EX_SALES,
                SUM ( ILF.EXT_AVG_COGS_AMOUNT ) LAST_MO_LY_EX_AC,
                NULL AS FYTD_TY_EX_SALES,
                NULL AS FYTD_TY_EX_AC,
                NULL AS FYTD_LY_EX_SALES,
                NULL AS FYTD_LY_EX_AC
           FROM   (  (  (  (  DW_FEI.PRODUCT_DIMENSION PROD
                            LEFT OUTER JOIN
                              AAA6863.DALLAS_DG_LIST DG_LIST
                            ON ( PROD.DISCOUNT_GROUP_NK =
                                  DG_LIST.DISCOUNT_GROUP_NK ))
                         INNER JOIN
                           DW_FEI.INVOICE_LINE_FACT ILF
                         ON ( PROD.PRODUCT_GK = ILF.PRODUCT_GK ))
                      INNER JOIN
                        DW_FEI.INVOICE_HEADER_FACT IHF
                      ON ( IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK ))
                   INNER JOIN
                     DW_FEI.CUSTOMER_DIMENSION CUST_DIM
                   ON ( IHF.CUSTOMER_NUMBER_NK = CUST_DIM.CUSTOMER_NK )
                      AND ( IHF.CUSTOMER_ACCOUNT_GK = CUST_DIM.CUSTOMER_GK ))
                INNER JOIN
                  SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON ( IHF.YEARMONTH = TPD.YEARMONTH )
          WHERE ( IHF.ACCOUNT_NUMBER = '61' )
                AND ( CUST_DIM.MAIN_CUSTOMER_NK IN
                         ('2219', '3258', '27743', '108990',
												  '147880', '142512', '144334', '142737',
													'138281', '144574', '144801', '143109') )
								--AND ( CUST_DIM.MAIN_CUSTOMER_NK IN ('2219', '62054', '62059', '26347') )
                -- AND ( TPD.FISCAL_YEAR_TO_DATE = 'LAST YEAR TO DATE' )
                AND TPD.YEARMONTH = TO_CHAR ( TRUNC ( SYSDATE,
                                                     'MM'
                                             )
                                             - 101,
                                             'YYYYMM'
                                    )
         GROUP BY IHF.ACCOUNT_NUMBER,
                  CUST_DIM.MAIN_CUSTOMER_NK,
									CUST_DIM.CUSTOMER_NK,
                  CUST_DIM.CUSTOMER_NAME,
                  NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                  PROD.DISCOUNT_GROUP_NK
         UNION
         SELECT IHF.ACCOUNT_NUMBER AS BRANCH_NO,
                CUST_DIM.MAIN_CUSTOMER_NK AS MAIN_NO,
								--CUST_DIM.CUSTOMER_NK,
                CUST_DIM.CUSTOMER_NAME AS CUST_NAME,
                NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                --PROD.DISCOUNT_GROUP_NK,
                NULL AS LAST_MO_TY_EX_SALES,
                NULL AS LAST_MO_TY_EX_AC,
                NULL AS LAST_MO_LY_EX_SALES,
                NULL AS LAST_MO_LY_EX_AC,
                SUM ( ILF.EXT_SALES_AMOUNT ) AS FYTD_TY_EX_SALES,
                SUM ( ILF.EXT_AVG_COGS_AMOUNT ) FYTD_TY_EX_AC,
                NULL AS FYTD_LY_EX_SALES,
                NULL AS FYTD_LY_EX_AC
           FROM   (  (  (  (  DW_FEI.PRODUCT_DIMENSION PROD
                            LEFT OUTER JOIN
                              AAA6863.DALLAS_DG_LIST DG_LIST
                            ON ( PROD.DISCOUNT_GROUP_NK =
                                  DG_LIST.DISCOUNT_GROUP_NK ))
                         INNER JOIN
                           DW_FEI.INVOICE_LINE_FACT ILF
                         ON ( PROD.PRODUCT_GK = ILF.PRODUCT_GK ))
                      INNER JOIN
                        DW_FEI.INVOICE_HEADER_FACT IHF
                      ON ( IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK ))
                   INNER JOIN
                     DW_FEI.CUSTOMER_DIMENSION CUST_DIM
                   ON ( IHF.CUSTOMER_NUMBER_NK = CUST_DIM.CUSTOMER_NK )
                      AND ( IHF.CUSTOMER_ACCOUNT_GK = CUST_DIM.CUSTOMER_GK ))
                INNER JOIN
                  SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON ( IHF.YEARMONTH = TPD.YEARMONTH )
          WHERE ( IHF.ACCOUNT_NUMBER = '61' )
                AND ( CUST_DIM.MAIN_CUSTOMER_NK IN
                         ('2219', '3258', '27743', '108990',
												  '147880', '142512', '144334', '142737',
													'138281', '144574', '144801', '143109') )
								--AND ( CUST_DIM.MAIN_CUSTOMER_NK IN ('2219', '62054', '62059', '26347') )
                AND ( TPD.FISCAL_YEAR_TO_DATE = 'YEAR TO DATE' )
         GROUP BY IHF.ACCOUNT_NUMBER,
                  CUST_DIM.MAIN_CUSTOMER_NK,
									CUST_DIM.CUSTOMER_NK,
                  CUST_DIM.CUSTOMER_NAME,
                  NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                  PROD.DISCOUNT_GROUP_NK
         UNION
         SELECT IHF.ACCOUNT_NUMBER AS BRANCH_NO,
                CUST_DIM.MAIN_CUSTOMER_NK AS MAIN_NO,
								--CUST_DIM.CUSTOMER_NK,
                CUST_DIM.CUSTOMER_NAME AS CUST_NAME,
                NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                --PROD.DISCOUNT_GROUP_NK,
                NULL AS LAST_MO_TY_EX_SALES,
                NULL AS LAST_MO_TY_EX_AC,
                NULL AS LAST_MO_LY_EX_SALES,
                NULL AS LAST_MO_LY_EX_AC,
                NULL AS FYTD_TY_EX_SALES,
                NULL AS FYTD_TY_EX_AC,
                SUM ( ILF.EXT_SALES_AMOUNT ) AS FYTD_LY_EX_SALES,
                SUM ( ILF.EXT_AVG_COGS_AMOUNT ) AS FYTD_LY_EX_AC
           FROM   (  (  (  (  DW_FEI.PRODUCT_DIMENSION PROD
                            LEFT OUTER JOIN
                              AAA6863.DALLAS_DG_LIST DG_LIST
                            ON ( PROD.DISCOUNT_GROUP_NK =
                                  DG_LIST.DISCOUNT_GROUP_NK ))
                         INNER JOIN
                           DW_FEI.INVOICE_LINE_FACT ILF
                         ON ( PROD.PRODUCT_GK = ILF.PRODUCT_GK ))
                      INNER JOIN
                        DW_FEI.INVOICE_HEADER_FACT IHF
                      ON ( IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK ))
                   INNER JOIN
                     DW_FEI.CUSTOMER_DIMENSION CUST_DIM
                   ON ( IHF.CUSTOMER_NUMBER_NK = CUST_DIM.CUSTOMER_NK )
                      AND ( IHF.CUSTOMER_ACCOUNT_GK = CUST_DIM.CUSTOMER_GK ))
                INNER JOIN
                  SALES_MART.TIME_PERIOD_DIMENSION TPD
                ON ( IHF.YEARMONTH = TPD.YEARMONTH )
          WHERE ( IHF.ACCOUNT_NUMBER = '61' )
                AND ( CUST_DIM.MAIN_CUSTOMER_NK IN
                         ('2219', '3258', '27743', '108990',
												  '147880', '142512', '144334', '142737',
													'138281', '144574', '144801', '143109') )
								--AND ( CUST_DIM.MAIN_CUSTOMER_NK IN ('2219', '62054', '62059', '26347') )
                AND ( TPD.FISCAL_YEAR_TO_DATE = 'LAST YEAR TO DATE' )
         GROUP BY IHF.ACCOUNT_NUMBER,
                  CUST_DIM.MAIN_CUSTOMER_NK,
									--CUST_DIM.CUSTOMER_NK,
                  CUST_DIM.CUSTOMER_NAME,
                  NVL ( DG_LIST.PRODUCT_GROUP, NULL ),
                  PROD.DISCOUNT_GROUP_NK ) xx
GROUP BY XX.BRANCH_NO, XX.MAIN_NO, XX.CUST_NAME, NVL ( XX.PRODUCT_GROUP, 'OTHER' ) --, XX.DG_NK
ORDER BY XX.BRANCH_NO, XX.MAIN_NO, NVL ( XX.PRODUCT_GROUP, 'OTHER' ); --, XX.DG_NK;