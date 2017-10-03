CREATE OR REPLACE FORCE VIEW AAA6863.BRANCH_STOCK_SKUS_LISTPR
AS
   SELECT WPF.ACCOUNT_NUMBER_NK,
          WPF.PRODUCT_GK ITEM_GK,
          WPF.PRODUCT_NK,
          PROD.ALT1_CODE,
          PROD.PRODUCT_NAME PROD_DESC,
          PROD.OBSOLETE_FLAG OBS,
          PROD.OBS_DATE,
          CASE WHEN PROD.LIST_PRICE > 0 THEN 'Y' ELSE 'N' END HAS_MASTER_LIST,
          ROUND (AVG (WPF.LIST_PR), 2) AVG_BRANCH_LIST,
          --ROUND( SUM(WPF.LIST_PR*WPF.ON_HAND_QTY)/SUM(WPF.ON_HAND_QTY),2) AVG_BRANCH_LIST2,
          SUM (CASE WHEN WPF.LIST_PR = PROD.LIST_PRICE THEN 1 ELSE 0 END)
             LIST_ALIGNED,
          COUNT (WPF.WAREHOUSE_NK) STOCKING_WHSES,
          SUM (CASE WHEN WPF.LIST_PR > 0 THEN 1 ELSE 0 END) WHSE_HAS_LIST,
          SUM (WPF.DEMAND_12_MONTHS) ANNUAL_DMD,
          SUM (WPF.EXTENDED_VALUE) EXT_VALUE,
          SUM (WPF.ON_HAND_QTY) EXT_ON_HAND,
          ROUND (AVG (WPF.WHSE_AVG_COST_AMOUNT), 2) AVG_WHSE_COST,
          WPF.UM_CODE,
          WPF.YEARMONTH,
          PROD.LIST_PRICE MSTR_LIST,
          PROD.PRIOR_LIST_PRICE PRIOR_MSTR_LIST,
          PROD.BASIS_6 BASIS_6,
          PROD.UPC_CODE,
          PROD.VENDOR_CODE,
          PROD.DISCOUNT_GROUP_NK DISC_GRP,
          DISC_GRP.DISCOUNT_GROUP_NAME,
          PROD.LINEBUY_NK,
          LINEBUY.LINEBUY_NAME,
          PROD.MANUFACTURER MFR,
          VEND.MASTER_VENDOR_NAME MFR_NAME
   FROM DW_FEI.WAREHOUSE_PRODUCT_FACT WPF,
        --DW_FEI.WAREHOUSE_DIMENSION WHSE,
        DW_FEI.PRODUCT_DIMENSION PROD,
        DW_FEI.DISCOUNT_GROUP_DIMENSION DISC_GRP,
        DW_FEI.LINE_BUY_DIMENSION LINEBUY,
        DW_FEI.MASTER_VENDOR_DIMENSION VEND
   WHERE  WPF.YEARMONTH = TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')
         AND WPF.ACCOUNT_NUMBER_NK IN ('3007',
                                       '34',
                                       '1196',
                                       '215',
                                       '20',
                                       '2504',
                                       '1598',
                                       '3067',
                                       '1300',
                                       '1001',
                                       '1480',
                                       '3017',
                                       '1550',
                                       '1888',
                                       '3370',
                                       '61',
                                       '2000',
                                       '686',
                                       '1657',
                                       '109',
                                       '501',
                                       '1205',
                                       '107',
                                       '1245',
                                       '52',
                                       '5',
                                       '3014',
                                       '1350',
                                       '1225',
                                       '3371',
                                       '2783')
         /*AND (WPF.YEARMONTH BETWEEN TO_CHAR (
                                       TRUNC (
                                          SYSDATE
                                          - NUMTOYMINTERVAL (2, 'MONTH'),
                                          'MONTH'),
                                       'YYYYMM')
                                AND TO_CHAR (TRUNC (SYSDATE, 'MM') - 1,
                                             'YYYYMM'))*/
         -- AND NVL (WPF.STATUS_TYPE, 'STOCK') IN
         --    ('STOCK', 'NN', 'NV', 'S', 'NQ')
         AND WPF.PRODUCT_GK = PROD.PRODUCT_GK
         AND WPF.LIST_PR <> 0
         --AND WPF.LIST_PR <> PROD.LIST_PRICE
         AND PROD.DISCOUNT_GROUP_GK = DISC_GRP.DISCOUNT_GROUP_GK
         AND PROD.LINEBUY_GK = LINEBUY.LINEBUY_GK
         AND PROD.MANUFACTURER = VEND.MASTER_VENDOR_NK
   --AND WPF.ON_HAND_QTY>0
   --AND WHSE.ACCOUNT_NAME IN 'ATLANTA'
   --AND PROD.LIST_PRICE <> 0
   --AND PROD.LIST_PRICE = 0
   --AND WHSE.ACCOUNT_NAME <> 'DIST'
   --AND WHSE.ACCOUNT_NAME NOT LIKE 'INT%'
   --AND PROD.MANUFACTURER = CORP_PRICE.VENDOR_NO(+)
   GROUP BY WPF.ACCOUNT_NUMBER_NK,
            WPF.PRODUCT_GK,
            WPF.PRODUCT_NK,
            PROD.ALT1_CODE,
            PROD.PRODUCT_NAME,
            PROD.LIST_PRICE,
            PROD.PRIOR_LIST_PRICE,
            PROD.BASIS_6,
            WPF.UM_CODE,
            WPF.YEARMONTH,
            PROD.OBSOLETE_FLAG,
            PROD.OBS_DATE,
            PROD.UPC_CODE,
            PROD.VENDOR_CODE,
            PROD.DISCOUNT_GROUP_NK,
            DISC_GRP.DISCOUNT_GROUP_NAME,
            PROD.LINEBUY_NK,
            LINEBUY.LINEBUY_NAME,
            PROD.MANUFACTURER,
            VEND.MASTER_VENDOR_NAME