SELECT *
  FROM (SELECT --DISTINCT
               CUST.ACCOUNT_NAME AS "Branch",
               IHF.CUSTOMER_NUMBER_NK AS "Cust No",
               CUST.CUSTOMER_NAME AS "Customer Name",
               IHF.INVOICE_NUMBER_NK AS "Inv #",
               IHF.INVOICE_DATE AS "Inv Date",
               IHF.PO_NUMBER AS PO#,
               CUST.JOB_YN AS "Job?",
               IHF.JOB_NAME AS "Job Name/Notes",
               NVL (PD.DISCOUNT_GROUP_NK, SP_PROD.SPECIAL_DISC_GROUP) AS DG,
               NVL (PD.ALT1_CODE, SP_PROD.ALT_CODE) "Alt 1",
               PD.VENDOR_CODE AS "Vend Cd",
               PD.PRODUCT_NAME AS "Product Description",
               --ILF.ORDERED_QTY AS "Ord Quan",
               ILF.SHIPPED_QTY AS "Ship Quan",
               ILF.EXT_SALES_AMOUNT AS "Ext Sales",
			   			 ILF.EXT_AVG_COGS_AMOUNT AS AVG_COST,
               --ILF.UNIT_NET_PRICE_AMOUNT AS "Discounted Price Each",
               NVL (ILF.LIST_PRICE, NULL) AS "List Price",
               CASE
                  WHEN ILF.LIST_PRICE > 0
                  THEN
                     ROUND (ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE, 3)
                  ELSE
                     0
               END
                  AS "Calc Mult",
               ILF.PRICE_FORMULA AS "Formula",
               CASE
                  WHEN ILF.LIST_PRICE > 0
                  THEN
                     1
                     - ROUND (ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE, 3)
                  ELSE
                     NULL
               END
                  AS "Calc Disc",
               MVD.MASTER_VENDOR_NAME AS "Manufacturer"
               --CASE WHEN IPF.PAID_METHOD = 'VI' THEN 'P-Card' ELSE NULL END
                  --AS P_CARD
          FROM DW_FEI.INVOICE_HEADER_FACT IHF
               INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
                  ON IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
               INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
                  ON IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK 
               LEFT JOIN DW_FEI.PRODUCT_DIMENSION PD
                  ON ILF.PRODUCT_GK = PD.PRODUCT_GK
               LEFT JOIN DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
                  ON ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK
               LEFT JOIN DW_FEI.MASTER_VENDOR_DIMENSION MVD
                  ON NVL(PD.MANUFACTURER,SP_PROD.PRIMARY_VNDR) = MVD.MASTER_VENDOR_NK
               LEFT JOIN DW_FEI.INVOICE_PAYMETHOD_FACT IPF
                  ON IHF.INVOICE_NUMBER_GK = IPF.INVOICE_NUMBER_GK
         WHERE ILF.SHIPPED_QTY <> 0
               -- AND IHF.YEARMONTH BETWEEN '201607' AND '201609'
               -- AND ILF.YEARMONTH BETWEEN '201607' AND '201609'
							 AND ILF.YEARMONTH BETWEEN TO_CHAR (
                                                       TRUNC (
                                                          SYSDATE
                                                          - NUMTOYMINTERVAL (
                                                               3,
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
                                                               3,
                                                               'MONTH'),
                                                          'MONTH'),
                                                       'YYYYMM')
                                                AND
                                 TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                          'YYYYMM')
        ORDER BY CUST.ACCOUNT_NAME,
                 CUST.CUSTOMER_NAME,
                 NVL (PD.DISCOUNT_GROUP_NK, SP_PROD.SPECIAL_DISC_GROUP),
                 NVL (PD.ALT1_CODE, SP_PROD.ALT_CODE)) INV
 WHERE INV.DG IN ( '176',
									'4125',
									'4133',
									'4134',
									'5853',
									'5854',
									'8926',
									'0552',
									'0553',
									'0554',
									'0555',
									'0558',
									'0564',
									'0567',
									'0876',
									'0877',
									'0881'
									)
       AND INV."Branch" IN ('NASH', 'OHVAL', 'SEATTLE', 'PETRO')
			 ;