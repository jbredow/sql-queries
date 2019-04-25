SELECT 
       MAIN.YEARMONTH,
			 MAIN.ACCOUNT_NUMBER BR_NK,
       MAIN.ACCOUNT_NAME ACCOUNT,
       MAIN.WRITER,
       MAIN.PRICE_CATEGORY,
       MAIN.TYPE_OF_SALE,
       SUM ( MAIN.EXT_SALES_AMOUNT ) EX_SALES,
       SUM ( MAIN.CORE_ADJ_AVG_COST ) EX_AC,
       COUNT ( MAIN.INV_LINE_COUNT ) INV_LINE_CT,
       COUNT ( DISTINCT MAIN.STRIPPED_INV ) - COUNT ( DISTINCT MAIN.NO_CR )
         AS INV_COUNT
       
  FROM ( SELECT IHF.ACCOUNT_NUMBER,
                CUST.ACCOUNT_NAME,
                IHF.YEARMONTH,
                IHF.WAREHOUSE_NUMBER,
                -- HF.WRITER WRITER_INIT,
                DECODE (IHF.SALE_TYPE,
                           '1', 'Our Truck',
                           '2', 'Counter',
                           '3', 'Direct',
                           '4', 'Counter',
                           '5', 'Credit Memo',
                           '6', 'Showroom',
                           '7', 'Showroom Direct',
                           '8', 'eBusiness')
                      TYPE_OF_SALE,
                IHF.INVOICE_NUMBER_NK,
                REGEXP_SUBSTR ( LTRIM ( IHF.INVOICE_NUMBER_NK,
                                       'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
                               ),
                               '[^-]*'
                )
                  STRIPPED_INV,
                CASE
                  WHEN SUBSTR ( IHF.INVOICE_NUMBER_NK,
                               0,
                               2
                       ) = 'CR'
                  THEN
                    REGEXP_SUBSTR ( IHF.INVOICE_NUMBER_NK,
                                   '[^-]*'
                    )
                  ELSE
                    NULL
                END
                  NO_CR,
                CASE
                  WHEN INSTR ( IHF.INVOICE_NUMBER_NK,
                              '-'
                       ) > 0
                  THEN
                    NULL
                  ELSE
                    IHF.INVOICE_NUMBER_NK
                END
                  INV_LINE_COUNT,
                -- SUBSTR ( IHF.INVOICE_NUMBER_NK, 0, 2),
                NVL ( IHF.WRITER, IHF.OML_ASSOC_INI ) WRITER,
                ILF.INVOICE_LINE_NUMBER,
                CASE
                  WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.ALT1_CODE
                  ELSE SP_PROD.ALT_CODE
                END
                  AS ALT1_CODE,
                CASE
                  WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.DISCOUNT_GROUP_NK
                  ELSE SP_PROD.SPECIAL_DISC_GROUP
                END
                  AS DISCOUNT_GROUP_NK,
                CASE
                  WHEN ILF.PRODUCT_GK IS NOT NULL THEN PROD.PRODUCT_NAME
                  ELSE SP_PROD.SPECIAL_PRODUCT_NAME
                END
                  AS PRODUCT_NAME,
                CASE
                  WHEN ILF.PRODUCT_GK IS NOT NULL
                  THEN
                    NVL ( ILF.PRODUCT_STATUS, 'STOCK' )
                  ELSE
                    'SP-'
                END
                  AS STATUS,
                ILF.SHIPPED_QTY,
                ILF.CORE_ADJ_AVG_COST,
                ILF.EXT_SALES_AMOUNT,
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
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX_PRICE
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             (TRUNC ( ilf.MATRIX_PRICE,
                                     2
                              )
                              + .01)
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC ( ilf.MATRIX,
                                                               2
                                                        )
                                                        + .01)
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             (ROUND ( ilf.MATRIX_PRICE,
                                     2
                              ))
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND ( ilf.MATRIX,
                                                               2
                                                        ))
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             (TRUNC ( ilf.MATRIX_PRICE,
                                     1
                              )
                              + .1)
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC ( ilf.MATRIX,
                                                               1
                                                        )
                                                        + .1)
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             FLOOR ( ilf.MATRIX_PRICE ) + 1
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             FLOOR ( ilf.MATRIX ) + 1
                      THEN
                        'MATRIX_BID'
                      ELSE
                        'MANUAL'
                    END
                  WHEN REGEXP_LIKE ( ilf.price_code,
                                    '[0-9]?[0-9]?[0-9]'
                       )
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
                           ( 'PR',
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
                            'P' )
                  THEN
                    'OVERRIDE'
                  WHEN ilf.price_code IN ('GI', 'GPC', 'HPF', 'HPN', 'NC')
                  THEN
                    'MANUAL'
                  WHEN ilf.price_code = '*E'
                  THEN
                    'MANUAL'
                  WHEN ilf.price_code = 'SKC'
                  THEN
                    'MANUAL'
                  WHEN ilf.price_code IN ('%', '$', 'N', 'F', 'B', 'PO')
                  THEN
                    'MANUAL'
                  WHEN ilf.price_code IS NULL
                  THEN
                    'MANUAL'
                  WHEN ilf.price_code IN ('R', 'N/A')
                  THEN
                    CASE
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX_PRICE
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = ilf.MATRIX
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             (TRUNC ( ilf.MATRIX_PRICE,
                                     2
                              )
                              + .01)
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC ( ilf.MATRIX,
                                                               2
                                                        )
                                                        + .01)
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             (ROUND ( ilf.MATRIX_PRICE,
                                     2
                              ))
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = (ROUND ( ilf.MATRIX,
                                                               2
                                                        ))
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             (TRUNC ( ilf.MATRIX_PRICE,
                                     1
                              )
                              + .1)
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT = (TRUNC ( ilf.MATRIX,
                                                               1
                                                        )
                                                        + .1)
                      THEN
                        'MATRIX_BID'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             FLOOR ( ilf.MATRIX_PRICE ) + 1
                      THEN
                        'MATRIX'
                      WHEN ilf.UNIT_NET_PRICE_AMOUNT =
                             FLOOR ( ilf.MATRIX ) + 1
                      THEN
                        'MATRIX_BID'
                      ELSE
                        'MANUAL'
                    END
                  ELSE
                    'MANUAL'
                END
                  AS PRICE_CATEGORY
           FROM DW_FEI.INVOICE_HEADER_FACT IHF,
                DW_FEI.INVOICE_LINE_FACT ILF,
                DW_FEI.PRODUCT_DIMENSION PROD,
                DW_FEI.CUSTOMER_DIMENSION CUST,
                DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD                  -- ,
          --DW_FEI.WAREHOUSE_DIMENSION WHSE
          WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                -- AND ILF.PRODUCT_STATUS = 'SP'
                AND IHF.ACCOUNT_NUMBER IN ('20')
                -- AND TO_CHAR ( IHF.WAREHOUSE_NUMBER ) =
                -- TO_CHAR ( WHSE.WAREHOUSE_NUMBER_NK )
                AND IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK
								--AND ihf.SALE_TYPE IN ('2', '4' )   -- counter
                AND DECODE ( NVL ( cust.ar_gl_number, '9999' ),
                     '1320', 0,
                     '1360', 0,
                     '1380', 0,
                     '1400', 0,
                     '1401', 0,
                     '1500', 0,
                     '4000', 0,
                     '7100', 0,
                     '9999', 0,
                     1 ) <> 0
                AND NVL ( IHF.CONSIGN_TYPE, 'N/A' ) <> 'R'
                AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
                AND ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK(+)
                AND IHF.IC_FLAG = 0
                AND ILF.SHIPPED_QTY <> 0
                AND IHF.ORDER_CODE NOT IN 'IC'
                AND IHF.PO_WAREHOUSE_NUMBER IS NULL
								AND IHF.YEARMONTH BETWEEN '201808' AND '201901'
								AND ILF.YEARMONTH BETWEEN '201808' AND '201901'
               /*AND ILF.YEARMONTH = TO_CHAR ( TRUNC ( SYSDATE,
                                                     'MM'
                                             )
                                             - 1,
                                             'YYYYMM'
                                    )
                AND IHF.YEARMONTH = TO_CHAR ( TRUNC ( SYSDATE,
                                                     'MM'
                                             )
                                             - 1,
                                             'YYYYMM'
                                    )*/
											) MAIN
GROUP BY  
       MAIN.YEARMONTH,
			 MAIN.ACCOUNT_NUMBER,
       MAIN.ACCOUNT_NAME,
       MAIN.WRITER,
       MAIN.PRICE_CATEGORY,
       MAIN.TYPE_OF_SALE
				 
ORDER BY  
       MAIN.YEARMONTH,
			 MAIN.ACCOUNT_NUMBER,
			 MAIN.ACCOUNT_NAME,      
       MAIN.WRITER
	;