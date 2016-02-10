SELECT --WPF.PRODUCT_GK ITEM_GK,
        WHSE.ACCOUNT_NUMBER_NK "Br No",
        WHSE.ACCOUNT_NAME Branch,
        WPF.WAREHOUSE_NK Whse,
        WPF.PRODUCT_NK Prod,
        PROD.ALT1_CODE "Alt-1",
        PROD.PRODUCT_NAME "Prod Description",
        PROD.OBSOLETE_FLAG OBS,
        --PROD.OBS_DATE,
        (WPF.LIST_PR) "List",
        --BDG.DISC_TO_COST DTC,
        BDG.RAW_DISC_TO_COST "DTC",
        /* CASE WHEN WPF.LIST_PR = PROD.LIST_PRICE THEN 'Y' ELSE 'N' END
          LIST_ALIGNED, */
        WPF.BASIS_2 Bas_2,
        WPF.BASIS_3 Bas_3,
        WPF.BASIS_4 Bas_4,
        WPF.BASIS_5 Bas_5,
        WPF.BASIS_6 Bas_6,
        WPF.BASIS_7 Bas_7,
        WPF.BASIS_8 Bas_8,
        WPF.BASIS_9 Bas_9,
        WPF.REP_COST Rep,
        --WPF.CUST_ORD_QTY,
        WPF.DEMAND_12_MONTHS "Demand",
        --WPF.EXTENDED_VALUE Ext,
        WPF.ON_HAND_QTY OHB,
        WPF.UM_CODE UM_Cd,
        WPF.UNIT_OF_MEASUREMENT UM,
        WPF.WHSE_AVG_COST_AMOUNT AC,
        --WPF.YEARMONTH,
        PROD.LIST_PRICE M_LIST,
        PROD.PRIOR_LIST_PRICE PRIOR_MSTR,
        PROD.BASIS_2 MSTR_B2,
        --PROD.UPC_CODE,
        PROD.VENDOR_CODE,
        PROD.DISCOUNT_GROUP_NK DG,
        DISC_GRP.DISCOUNT_GROUP_NAME "DG Description",
        PROD.LINEBUY_NK LB,
        --LINEBUY.LINEBUY_NAME,
        PROD.MANUFACTURER MFR,
        VEND.MASTER_VENDOR_NAME MFR_NAME  --,
        --CORP_PRICE.TYPE_OF_PRICING
   FROM DW_FEI.WAREHOUSE_PRODUCT_FACT WPF,
        DW_FEI.WAREHOUSE_DIMENSION WHSE,
        DW_FEI.PRODUCT_DIMENSION PROD,
        DW_FEI.DISCOUNT_GROUP_DIMENSION DISC_GRP,
        DW_FEI.LINE_BUY_DIMENSION LINEBUY,
        DW_FEI.MASTER_VENDOR_DIMENSION VEND,
        --AAD9606.VDR_TYPE_OF_PRICING_V CORP_PRICE,
        DW_FEI.BRANCH_DISC_GROUP_DIMENSION BDG,
		AAA6863.BRANCH_CONTACTS BC
  WHERE WPF.WAREHOUSE_GK = WHSE.WAREHOUSE_GK
		AND WHSE.ACCOUNT_NAME = BDG.ACCOUNT_NAME
		AND WHSE.ACCOUNT_NAME = BC.ALIAS
		AND BC.RPC = 'Midwest'
		AND BC.DISTRICT_MGR IN ('Al Maxwell', 'David Brandt', 'Frank Reichert')
        AND PROD.DISCOUNT_GROUP_GK = BDG.DISCOUNT_GROUP_GK
		AND (WPF.YEARMONTH =
                TO_NUMBER (TO_CHAR (TRUNC (SYSDATE, 'MM') - 1, 'YYYYMM')))
        AND NVL (WPF.STATUS_TYPE, 'STOCK') IN
               ('STOCK', 'NN', 'NV', 'S', 'NQ')
        AND WPF.PRODUCT_GK = PROD.PRODUCT_GK
        --AND WPF.LIST_PR <> PROD.LIST_PRICE
        AND PROD.DISCOUNT_GROUP_GK = DISC_GRP.DISCOUNT_GROUP_GK
        AND PROD.LINEBUY_GK = LINEBUY.LINEBUY_GK
        AND PROD.MANUFACTURER = VEND.MASTER_VENDOR_NK
        --AND PROD.DISCOUNT_GROUP_GK IN ('12', '13','14','17','50','55','57','59')
		--AND PROD.OBSOLETE_FLAG = 0 
		--AND PROD.LINEBUY_NK IN( '94', '135') 
		AND WHSE.ACCOUNT_NAME IN 'APPLE'
        --AND PROD.LIST_PRICE <> 0
        --AND PROD.LIST_PRICE = 0
        --AND WHSE.ACCOUNT_NAME NOT IN 'DIST'
        --AND WHSE.ACCOUNT_NAME NOT LIKE 'INT%'
        --AND PROD.MANUFACTURER = CORP_PRICE.VENDOR_NO(+)
GROUP BY --WPF.PRODUCT_GK,
          WHSE.ACCOUNT_NUMBER_NK,
          WHSE.ACCOUNT_NAME,
          WPF.PRODUCT_NK,
          WPF.WAREHOUSE_NK,
          PROD.ALT1_CODE,
          PROD.PRODUCT_NAME,
          PROD.LIST_PRICE,
          PROD.PRIOR_LIST_PRICE,
          PROD.BASIS_2,
          WPF.LIST_PR,
          --BDG.DISC_TO_COST,
          BDG.RAW_DISC_TO_COST,
          WPF.BASIS_2,
          WPF.BASIS_3,
          WPF.BASIS_4,
          WPF.BASIS_5,
          WPF.BASIS_6,
          WPF.BASIS_7,
          WPF.BASIS_8,
          WPF.BASIS_9,
          WPF.REP_COST,
          --WPF.CUST_ORD_QTY,
          WPF.DEMAND_12_MONTHS,
          WPF.EXTENDED_VALUE,
          WPF.ON_HAND_QTY,
          WPF.UNIT_OF_MEASUREMENT,
          WPF.UM_CODE,
          WPF.WHSE_AVG_COST_AMOUNT,
          WPF.YEARMONTH,
          PROD.OBSOLETE_FLAG,
          --PROD.OBS_DATE,
          --PROD.UPC_CODE,
          PROD.VENDOR_CODE,
          PROD.DISCOUNT_GROUP_NK,
          DISC_GRP.DISCOUNT_GROUP_NAME,
          PROD.LINEBUY_NK,
          --LINEBUY.LINEBUY_NAME,
          PROD.MANUFACTURER,
          VEND.MASTER_VENDOR_NAME
  order by WHSE.ACCOUNT_NAME asc,
      PROD.DISCOUNT_GROUP_NK asc,
      PROD.ALT1_CODE
;