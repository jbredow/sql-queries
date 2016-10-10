/*
		NOTE!
		must be run after the SALES_MART.TIME_DIM has been updated
		two reports, one with and one without the GP%
*/

SELECT DISTINCT
       CUST.ACCOUNT_NAME AS "Branch",
       IHF.CUSTOMER_NUMBER_NK AS "Cust No",
       CUST.CUSTOMER_NAME AS "Customer Name",
       IHF.INVOICE_NUMBER_NK AS "Inv #",
       IHF.INVOICE_DATE AS "Inv Date",
       IHF.PO_NUMBER AS PO#,
       CUST.JOB_YN AS "Job?",
       IHF.JOB_NAME AS "Job Name/Notes",
       NVL ( PD.DISCOUNT_GROUP_NK, SP_PROD.SPECIAL_DISC_GROUP ) AS DG,
       NVL ( ILF.PRODUCT_NUMBER_NK, SP_PROD.SPECIAL_PRODUCT_NK ) "Product #",
       NVL ( PD.ALT1_CODE, SP_PROD.ALT_CODE ) "Alt 1",
       PD.VENDOR_CODE AS "Vend Cd",
       NVL ( PD.PRODUCT_NAME, SPECIAL_PRODUCT_NAME ) AS "Product Description",
       ILF.ORDERED_QTY AS "Ord Quan",
       ILF.SHIPPED_QTY AS "Ship Quan",
       ILF.EXT_SALES_AMOUNT AS "Ext Sales",
			 -- ILF.EXT_AVG_COGS_AMOUNT AS "Ext AC",
			 ROUND (
     			( ILF.EXT_SALES_AMOUNT  -  ILF.EXT_AVG_COGS_AMOUNT )
							/ CASE
									WHEN ILF.EXT_SALES_AMOUNT  > 0
									THEN  ILF.EXT_SALES_AMOUNT
									ELSE
										1
								END
									, 3 )
							"GP %",
			 
			 
       ILF.UNIT_NET_PRICE_AMOUNT AS "Discounted Price Each",
       NVL ( ILF.LIST_PRICE, NULL ) AS "List Price",
       CASE
         WHEN ILF.LIST_PRICE > 0
         THEN
           ROUND ( ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE,
                  3
           )
         ELSE
           0
       END
         AS "Calc Mult",
       ILF.PRICE_FORMULA AS "Formula",
       CASE
         WHEN ILF.LIST_PRICE > 0
         THEN
           1
           - ROUND ( ILF.UNIT_NET_PRICE_AMOUNT / ILF.LIST_PRICE,
                    3
             )
         ELSE
           NULL
       END
         AS "Calc Disc",
       MVD.MASTER_VENDOR_NAME AS "Manufacturer",
       CASE WHEN IPF.PAID_METHOD = 'VI' THEN 'P-Card' ELSE NULL END AS P_CARD,
       IHF.SOURCE_SYSTEM,
       IHF.WRITER
  FROM               DW_FEI.INVOICE_HEADER_FACT IHF
                   INNER JOIN
                     DW_FEI.INVOICE_LINE_FACT ILF
                   ON IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK
                      AND ILF.CUSTOMER_ACCOUNT_GK = IHF.CUSTOMER_ACCOUNT_GK
                 LEFT JOIN
                   DW_FEI.CUSTOMER_DIMENSION CUST
                 ON CUST.CUSTOMER_NK = IHF.CUSTOMER_NUMBER_NK
                    AND CUST.ACCOUNT_NUMBER_NK = IHF.ACCOUNT_NUMBER
               INNER JOIN
                 AAA6863.UW_CUSTOMER_LIST C_LIST
               ON C_LIST.BR_NK = IHF.ACCOUNT_NUMBER
                  AND C_LIST.CUST_NK = IHF.CUSTOMER_NUMBER_NK
             LEFT JOIN
               DW_FEI.PRODUCT_DIMENSION PD
             ON PD.PRODUCT_GK = ILF.PRODUCT_GK
           LEFT JOIN
             DW_FEI.SPECIAL_PRODUCT_DIMENSION SP_PROD
           ON ILF.SPECIAL_PRODUCT_GK = SP_PROD.SPECIAL_PRODUCT_GK
         LEFT JOIN
           DW_FEI.MASTER_VENDOR_DIMENSION MVD
         ON PD.MANUFACTURER = MVD.MASTER_VENDOR_NK
       LEFT JOIN
         DW_FEI.INVOICE_PAYMETHOD_FACT IPF
       ON IPF.INVOICE_NUMBER_GK = IHF.INVOICE_NUMBER_GK
			 
 WHERE     ILF.SHIPPED_QTY <> 0
       AND IHF.YEARMONTH = (SELECT PRIOR_YEARMONTH
                              FROM SALES_MART.TIME_DIM)
       AND ILF.YEARMONTH = (SELECT PRIOR_YEARMONTH
                              FROM SALES_MART.TIME_DIM)

ORDER BY CUST.ACCOUNT_NAME,
         CUST.CUSTOMER_NAME,
         NVL ( PD.DISCOUNT_GROUP_NK, SP_PROD.SPECIAL_DISC_GROUP ),
         NVL ( PD.ALT1_CODE, SP_PROD.ALT_CODE );