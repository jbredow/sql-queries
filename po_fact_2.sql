SELECT DISTINCT WHSE.ACCOUNT_NUMBER_NK,
       WHSE.ACCOUNT_NAME,
       PO_HDR.WAREHOUSE_NUMBER_NK,
       PO_HDR.BRANCH_VENDOR_NK,
       PO_HDR.PO_NUMBER_NK,
       PO_HDR.PO_DATE,
       PO_HDR.PO_DATE_YEARMONTH,
       PO_LINE.RECEIPT_NUMBER,
       PO_LINE.RECEIPT_DATE,
       PO_LINE.RECEIPT_YEARMONTH,
       PO_LINE.PRODUCT_NK,
       PO_LINE.ORDERED_QTY,
       PO_LINE.RECEIVED_QTY,
       PO_LINE.UNIT_COST,
       PO_LINE.EXT_LINE_COST,
       -- ORIGINAL INVOICE
       ILF.PROCESS_DATE,
      ILF.PRODUCT_NUMBER_NK,
       ILF.ORDERED_QTY,
       ILF.SHIPPED_QTY,
       ILF.EXT_SALES_AMOUNT,
       ILF.EXT_AVG_COGS_AMOUNT,
       ILF.UNIT_NET_PRICE_AMOUNT,
       ILF.ORDER_ENTRY_DATE,
       IHF.CUSTOMER_NUMBER_NK,
       IHF.INVOICE_NUMBER_NK,
       ILF.INVOICE_LINE_NUMBER,
       -- CREDIT MEMO
       ILF2.CREDIT_MEMO_TYPE,
       ILF2.PROCESS_DATE,
       ILF2.PRODUCT_NUMBER_NK,
       ILF2.ORDERED_QTY,
       ILF2.SHIPPED_QTY,
       ILF2.EXT_SALES_AMOUNT,
       ILF2.EXT_AVG_COGS_AMOUNT,
       ILF2.UNIT_NET_PRICE_AMOUNT,
       ILF2.ORDER_ENTRY_DATE,
       ILF2.INVOICE_LINE_NUMBER,
       -- YOU CAN ATTEMPT TO JOIN ANY OF THESE PO TO THE HDR FACT,
       -- IF THEY ARE FEI POS YOU WILL GET SOME MATCHES:
       IHF.TAG_PO,
       IHF.PO_NUMBER,
       IHF.DIRECT_PO_NUMBER,
       CUST.CUSTOMER_NAME,
       IHF.SALE_TYPE,
       BR_VDR.VENDOR_NK,
       BR_VDR.VENDOR_NAME,
       BR_VDR.IC_EDI_WHSE
  FROM DW_FEI.PO_LINE_FACT PO_LINE
       INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
          ON (PO_LINE.PRODUCT_GK = ILF.PRODUCT_GK)
       INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
          ON (IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK)
       --JOIN FROM THE ORIGINAL INVOICE TO THE PO

       INNER JOIN
       DW_FEI.PO_HEADER_FACT PO_HDR
          -- USE ANY OF THE INVOICE PO FIELDS HERE TO JOIN DEPENDING ON SCENARIO
          -- IHF.TAG_PO,
          -- IHF.PO_NUMBER,
          -- IHF.DIRECT_PO_NUMBER,

          ON (    PO_HDR.PO_NUMBER_NK = IHF.DIRECT_PO_NUMBER
              AND PO_HDR.PO_GK = PO_LINE.PO_GK)
       INNER JOIN
       DW_FEI.WAREHOUSE_DIMENSION WHSE
          ON (    WHSE.WAREHOUSE_GK = IHF.SHIP_FROM_WAREHOUSE_GK
              AND PO_HDR.WAREHOUSE_NUMBER_GK = WHSE.WAREHOUSE_GK)
       INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
          ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK)
       INNER JOIN DW_FEI.BRANCH_VENDOR_DIMENSION BR_VDR
          ON (PO_HDR.BRANCH_VENDOR_GK = BR_VDR.VENDOR_GK)
       --JOIN FROM THE CREDIT INVOICE TO THE ORIGINAL INVOICE

       INNER JOIN
       (SELECT *
          FROM DW_FEI.INVOICE_LINE_FACT INV, DW_FEI.WAREHOUSE_DIMENSION WHSE
         WHERE     INV.SELL_WAREHOUSE_NUMBER_NK = WHSE.WAREHOUSE_NUMBER_NK
               AND WHSE.ACCOUNT_NAME = 'DALLAS'
               AND INV.CM_ORIG_INV IS NOT NULL
               AND INV.YEARMONTH BETWEEN 201502 AND 201601) ILF2
          ON (    IHF.INVOICE_NUMBER_NK = ILF2.CM_ORIG_INV
              --AND IHF.ORDER_ENTRY_DATE = ILF2.CM_ORIG_INV_DATE
              AND IHF.WAREHOUSE_NUMBER = ILF2.SELL_WAREHOUSE_NUMBER_NK
              AND ILF.PRODUCT_GK = ILF2.PRODUCT_GK)
WHERE     WHSE.ACCOUNT_NUMBER_NK = '61'
       AND PO_HDR.PO_DATE_YEARMONTH BETWEEN 201502 AND 201601
       AND IHF.CUSTOMER_NUMBER_NK IN
              ('24351',
               '28646',
               '32607',
               '81713',
               '90799',
               '146156',
               '197407',
               '2219',
               '26347',
               '28623',
               '30186',
               '32606',
               '62054',
               '62059')

Leigh North
Manager of Pricing Development
Ferguson Enterprises, Inc. 
T: 757.223.6924

From: Bredow, Joe [Ferguson] - 9852 Reg Pricing Ctr Central 
Sent: Friday, February 12, 2016 7:29 AM
To: North, Leigh [Ferguson] - 9774 Pricing Management
Subject: RE: po fact

Leigh,
It looks like I broke it.  I added another join to the query because the original referenced IHF2 but it wasn’t there, added some customer numbers and changed the date range.  The last bit of the macro looks like this:

--JOIN FROM THE CREDIT INVOICE TO THE ORIGINAL INVOICE
       
INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF2
          ON (IHF.INVOICE_NUMBER_NK = ILF2.CM_ORIG_INV
          --AND IHF.ORDER_ENTRY_DATE = ILF2.CM_ORIG_INV_DATE
          AND IHF.WAREHOUSE_NUMBER = ILF2.SELL_WAREHOUSE_NUMBER_NK)
INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF2
                                                            ON ILF.INVOICE_NUMBER_GK = IHF2.INVOICE_NUMBER_GK
                                                            AND ILF.SELL_WAREHOUSE_NUMBER_NK = ILF2.SELL_WAREHOUSE_NUMBER_NK
          
 WHERE WHSE.ACCOUNT_NUMBER_NK = '61' 
            AND PO_HDR.PO_DATE_YEARMONTH BETWEEN 201502 AND 201601
            AND IHF.CUSTOMER_NUMBER_NK IN (
                                                                        '24351',
                                                                        '28646',
                                                                        '32607',
                                                                        '81713',
                                                                        '90799',
                                                                        '146156',
                                                                        '197407',
                                                                        '2219',
                                                                        '26347',
                                                                        '28623',
                                                                        '30186',
                                                                        '32606',
                                                                        '62054',
                                                                        '62059'
                                                                        )
;
Any idea what I did wrong?

Thanks,

Joe Bredow
Central Regional Pricing Center
Tele 616.447.2956 - Email joe.bredow@ferguson.com

From: North, Leigh [Ferguson] - 9774 Pricing Management 
Sent: Thursday, February 11, 2016 5:54 PM
To: Bredow, Joe [Ferguson] - 9852 Reg Pricing Ctr Central
Subject: po fact

Joe,

I have cobbled together something that you can work from. You can find FEI PO Numbers in the PO number field if it was a direct shipment from the DC you can find those in the direct po field or you can link to the tag_po field. If you know the credit memo issued you can isolate that by joining back out to the invoice hdr for the credit via the cm_orig_invoice field. It’s rather convoluted but you may get something after a couple of tries. You will also need to adjust your where clause with your know data to direct your query.

SELECT WHSE.ACCOUNT_NUMBER_NK,
       WHSE.ACCOUNT_NAME,
       PO_HDR.WAREHOUSE_NUMBER_NK,
       PO_HDR.BRANCH_VENDOR_NK,
       PO_HDR.PO_NUMBER_NK,
       PO_HDR.PO_DATE,
       PO_HDR.PO_DATE_YEARMONTH,
       PO_LINE.RECEIPT_NUMBER,
       PO_LINE.RECEIPT_DATE,
       PO_LINE.RECEIPT_YEARMONTH,
       PO_LINE.PRODUCT_NK,
       PO_LINE.ORDERED_QTY,
       PO_LINE.RECEIVED_QTY,
       PO_LINE.UNIT_COST,
       PO_LINE.EXT_LINE_COST,
-- ORIGINAL INVOICE
       ILF.PROCESS_DATE,
       ILF.PRODUCT_NUMBER_NK,
       ILF.ORDERED_QTY,
       ILF.SHIPPED_QTY,
       ILF.EXT_SALES_AMOUNT,
       ILF.EXT_AVG_COGS_AMOUNT,
       ILF.UNIT_NET_PRICE_AMOUNT,
       ILF.ORDER_ENTRY_DATE,
       IHF.CUSTOMER_NUMBER_NK,
       IHF.INVOICE_NUMBER_NK,
       ILF.INVOICE_LINE_NUMBER, 
-- CREDIT MEMO
       ILF2.CREDIT_MEMO_TYPE,
       ILF2.PROCESS_DATE,
       ILF2.PRODUCT_NUMBER_NK,
       ILF2.ORDERED_QTY,
       ILF2.SHIPPED_QTY,
       ILF2.EXT_SALES_AMOUNT,
       ILF2.EXT_AVG_COGS_AMOUNT,
       ILF2.UNIT_NET_PRICE_AMOUNT,
       ILF2.ORDER_ENTRY_DATE,
       IHF2.CUSTOMER_NUMBER_NK,
       IHF2.INVOICE_NUMBER_NK,
       ILF2.INVOICE_LINE_NUMBER,      
     
-- YOU CAN ATTEMPT TO JOIN ANY OF THESE PO TO THE HDR FACT, 
-- IF THEY ARE FEI POS YOU WILL GET SOME MATCHES:
       IHF.TAG_PO,
       IHF.PO_NUMBER,
       IHF.DIRECT_PO_NUMBER,
       CUST.CUSTOMER_NAME,
       IHF.SALE_TYPE,
       BR_VDR.VENDOR_NK,
       BR_VDR.VENDOR_NAME,
       BR_VDR.IC_EDI_WHSE
  FROM DW_FEI.PO_LINE_FACT PO_LINE
       
INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF
          ON (PO_LINE.PRODUCT_GK = ILF.PRODUCT_GK)
       
INNER JOIN DW_FEI.INVOICE_HEADER_FACT IHF
          ON (IHF.INVOICE_NUMBER_GK = ILF.INVOICE_NUMBER_GK)
       --JOIN FROM THE ORIGINAL INVOICE TO THE PO
       
INNER JOIN
       DW_FEI.PO_HEADER_FACT PO_HDR

-- USE ANY OF THE INVOICE PO FIELDS HERE TO JOIN DEPENDING ON SCENARIO
-- IHF.TAG_PO,
      -- IHF.PO_NUMBER,
      -- IHF.DIRECT_PO_NUMBER,

          ON (    PO_HDR.PO_NUMBER_NK = IHF.PO_NUMBER 
              AND PO_HDR.PO_GK = PO_LINE.PO_GK)
       
INNER JOIN
       DW_FEI.WAREHOUSE_DIMENSION WHSE
          ON (    WHSE.WAREHOUSE_GK = IHF.SHIP_FROM_WAREHOUSE_GK
              AND PO_HDR.WAREHOUSE_NUMBER_GK = WHSE.WAREHOUSE_GK)
       
INNER JOIN DW_FEI.CUSTOMER_DIMENSION CUST
          ON (IHF.CUSTOMER_ACCOUNT_GK = CUST.CUSTOMER_GK)
       
INNER JOIN DW_FEI.BRANCH_VENDOR_DIMENSION BR_VDR
          ON (PO_HDR.BRANCH_VENDOR_GK = BR_VDR.VENDOR_GK)
      
--JOIN FROM THE CREDIT INVOICE TO THE ORIGINAL INVOICE
       
INNER JOIN DW_FEI.INVOICE_LINE_FACT ILF2
          ON (IHF.INVOICE_NUMBER_NK = ILF2.CM_ORIG_INV
          --AND IHF.ORDER_ENTRY_DATE = ILF2.CM_ORIG_INV_DATE
          AND IHF.WAREHOUSE_NUMBER = ILF2.SELL_WAREHOUSE_NUMBER_NK)
          
 WHERE WHSE.ACCOUNT_NUMBER_NK = '61' AND PO_HDR.PO_DATE_YEARMONTH = 201601
