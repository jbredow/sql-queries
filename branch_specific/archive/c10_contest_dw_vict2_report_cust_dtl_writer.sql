--maxwell oatey/hercules contest for Kristin Hogan

SELECT sp_dtl.ACCOUNT_NUMBER ACCT,
       sp_dtl.ACCOUNT_NAME,
       sp_dtl.WAREHOUSE_NUMBER WHSE,
       sp_dtl.INVOICE_NUMBER_NK INVOICE_NK,
       sp_dtl.TYPE_OF_SALE,
       sp_dtl.OML_ASSOC_INI,
       sp_dtl.OML_FL_INI,
       sp_dtl.OML_ASSOC_NAME,
       sp_dtl.WRITER,
       sp_dtl.WR_FL_INI,
       NVL (sp_dtl.ASSOC_NAME, emp.ASSOC_NAME) ASSOC_NAME,
	   sp_dtl.SALESREP_NK,
       sp_dtl.INVOICE_LINE_NUMBER INV_LINE,
       sp_dtl.MANUFACTURER MFR,
       sp_dtl.PRODUCT_NK MPID,
	   sp_dtl.DISCOUNT_GROUP_NK,
       sp_dtl.ALT1_CODE,
       sp_dtl.PRODUCT_NAME,
       sp_dtl.STATUS,
	   sp_dtl.SHIP_VIA_NAME,
       sp_dtl.SHIPPED_QTY,
       sp_dtl.EXT_SALES_AMOUNT EXT_SALES,
	   sp_dtl.EXT_AVG_COGS_AMOUNT EXT_AVG_COST,
       sp_dtl.PRICE_CODE,
       sp_dtl.PRICE_CATEGORY,
       sp_dtl.PRICE_CATEGORY_OVR,
       sp_dtl.PRICE_FORMULA,
       sp_dtl.UNIT_NET_PRICE_AMOUNT UNIT_NET_PRICE,
       sp_dtl.MATRIX_PRICE,
       sp_dtl.MATRIX,
       sp_dtl.OG_MATRIX,
       sp_dtl.PR_OVR,
       sp_dtl.PR_OVR_BASIS,
       sp_dtl.GR_OVR,
       sp_dtl.TRIM_FORM,
       sp_dtl.ORDER_CODE,
       sp_dtl.SOURCE_SYSTEM,
	   sp_dtl.YEARMONTH,
       --sp_dtl.MAIN_CUSTOMER_NK,
       sp_dtl.CUSTOMER_NK,
       sp_dtl.CUSTOMER_NAME,
       sp_dtl.PRICE_COLUMN,
       sp_dtl.CUSTOMER_TYPE,
       sp_dtl.REF_BID_NUMBER
  FROM    (SELECT SP_HIST.*,
                  CASE
                     WHEN SP_HIST.ORDER_ENTRY_DATE BETWEEN NVL (
                                                              PR_OVR.
                                                              INSERT_TIMESTAMP,
                                                              GR_OVR.
                                                              INSERT_TIMESTAMP)
                                                       AND NVL (
                                                              PR_OVR.
                                                              EXPIRE_DATE,
                                                              GR_OVR.
                                                              EXPIRE_dATE)
                     THEN
                        CASE
                           WHEN SP_HIST.PRICE_CODE IN ('R', 'N/A', 'Q')
                           THEN
                              CASE
                                 WHEN SP_HIST.UNIT_NET_PRICE_AMOUNT BETWEEN PR_OVR.
                                                                            MULTIPLIER
                                                                            - .01
                                                                        AND PR_OVR.
                                                                            MULTIPLIER
                                                                            + .01
                                 THEN
                                    'OVERRIDE'
                                 WHEN REPLACE (SP_HIST.PRICE_FORMULA,
                                               '0.',
                                               '.') =
                                         REPLACE (
                                            NVL (PR_OVR.FORMULA,
                                                 GR_OVR.FORMULA),
                                            '0.',
                                            '.')
                                 THEN
                                    'OVERRIDE'
                                 ELSE
                                    SP_HIST.PRICE_CATEGORY
                              END
                           ELSE
                              SP_HIST.PRICE_CATEGORY
                        END
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
             FROM (SELECT IHF.ACCOUNT_NUMBER,
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
						  ILF.SALESREP_NK,
                          ILF.SHIPPED_QTY,
                          ILF.EXT_AVG_COGS_AMOUNT,
                          ILF.EXT_SALES_AMOUNT,
                          --ILF.MATRIX_PRICE,
                          CASE
                             WHEN ihf.order_code = 'IC'
                             THEN
                                'CREDITS'
                             WHEN ihf.order_code = 'SP'
                             THEN
                                'SPECIALS'
                             WHEN ilf.price_code = 'Q'
                             THEN
                                CASE
                                   WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2) =
                                           ROUND (ilf.matrix_price, 2)
                                   THEN
                                      'MATRIX'
                                   WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2) =
                                           ROUND (ilf.matrix, 2)
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
                          WHEN ilf.price_code IN ('FC', 'PM')
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
                                   WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2)
                                        - ROUND (ilf.MATRIX_PRICE, 2) BETWEEN 0
                                                                          AND .01
                                   THEN
                                      'MATRIX'
                                   WHEN ROUND (ilf.UNIT_NET_PRICE_AMOUNT, 2)
                                        - ROUND (ilf.MATRIX, 2) BETWEEN 0
                                                                    AND .01
                                   THEN
                                      'MATRIX_BID'
                                   WHEN ihf.CONTRACT_NUMBER IS NOT NULL
                                   THEN
                                      'OVERRIDE'
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
						  ILF.YEARMONTH,
                          IHF.CONSIGN_TYPE,
                          IHF.ORDER_CODE,
                          IHF.CREDIT_CODE,
                          IHF.CREDIT_MEMO_TYPE,
                          IHF.PO_NUMBER,
                          IHF.REF_BID_NUMBER,
                          IHF.SOURCE_ORDER,
                          IHF.SOURCE_SYSTEM,
                          IHF.CUSTOMER_ACCOUNT_GK,
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
                    WHERE     IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK 
						  --AND ILF.PRODUCT_STATUS = 'SP'
                          --AND IHF.ACCOUNT_NUMBER = '25' 
						  --AND NVL(ILF.PRICE_CODE,'N/A') in ('Q','N/A','R')
                          --AND IHF.WRITER = 'CMC'
						  AND IHF.ACCOUNT_NUMBER IN ('448', '1674', '3093', '1020', '226', '1657', '331')
						  AND PROD.DISCOUNT_GROUP_NK IN ('1521', '1523', '1530', '1531', '1534', '1535',
														'1536', '1537', '1539', '1540', '1555', '1599',
														'1708', '1709', '1710', '1711')
                          --AND CUST.ACTIVE_ACCOUNT_NUMBER_NK = '564'
                          --AND CUST.ACTIVE_CUSTOMER_NK = '1385'
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
                          AND NVL (IHF.CONSIGN_TYPE, 'N/A') NOT IN 'R'
                          AND ILF.PRODUCT_GK = PROD.PRODUCT_GK(+)
                          AND ILF.SPECIAL_PRODUCT_GK =
                                 SP_PROD.SPECIAL_PRODUCT_GK(+)
                          AND IHF.IC_FLAG = 0
                          AND ILF.SHIPPED_QTY <> 0
                          AND IHF.ORDER_CODE NOT IN 'IC'
                          AND IHF.PO_WAREHOUSE_NUMBER IS NULL
                          AND ILF.YEARMONTH BETWEEN '201309' AND '201310'
                          AND IHF.YEARMONTH  BETWEEN '201309' AND '201310') SP_HIST
										  
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
                                     FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
                                    WHERE COD.OVERRIDE_TYPE = 'G'
                                          AND COD.DELETE_DATE IS NULL) GR_OVR
                     ON (SP_HIST.DISCOUNT_GROUP_NK =
                            (LTRIM (GR_OVR.DISC_GROUP, '0'))
                         AND SP_HIST.ACCOUNT_NUMBER = GR_OVR.BRANCH_NUMBER_NK
                         AND SP_HIST.CUSTOMER_ACCOUNT_GK = GR_OVR.CUSTOMER_GK)
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
                                             WHEN COD.OPERATOR_USED NOT IN
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
                                     FROM DW_FEI.CUSTOMER_OVERRIDE_DIMENSION COD
                                    WHERE COD.OVERRIDE_TYPE = 'P'
                                          AND COD.DELETE_DATE IS NULL) PR_OVR
                     ON (    SP_HIST.PRODUCT_NK = PR_OVR.MASTER_PRODUCT
                         AND SP_HIST.ACCOUNT_NUMBER = PR_OVR.BRANCH_NUMBER_NK
                         AND SP_HIST.CUSTOMER_ACCOUNT_GK = PR_OVR.CUSTOMER_GK)) sp_dtl
       LEFT OUTER JOIN
          DW_FEI.EMPLOYEE_DIMENSION emp
       ON sp_dtl.ACCOUNT_NAME = emp.ACCOUNT_NAME
          AND sp_dtl.WRITER = emp.INITIALS
;