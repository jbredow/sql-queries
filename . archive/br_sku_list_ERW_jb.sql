
SELECT 
			 WHSE.ACCOUNT_NAME,
       WHSE.WAREHOUSE_NUMBER_NK,
    	 PROD.DISCOUNT_GROUP_NK,
       PRICE.MASTER_PRODUCT_NK,
       PROD.ALT1_CODE,
       PRICE.LAST_UPDATE,
       PROD.LIST_PRICE AS MASTER_LIST,
       WPF.LIST_PR,
       WPF.NEW_LIST,
       WPF.BASIS_2,
       WPF.BASIS_3,
       WPF.STATUS_TYPE
  FROM   (  (  DW_FEI.WAREHOUSE_PRODUCT_FACT WPF
             INNER JOIN
               DW_FEI.PRODUCT_DIMENSION PROD
             ON ( WPF.PRODUCT_GK = PROD.PRODUCT_GK ))
          INNER JOIN
            DW_FEI.WAREHOUSE_DIMENSION WHSE
          ON ( WHSE.WAREHOUSE_GK = WPF.WAREHOUSE_GK ))
       INNER JOIN
         DW_FEI.PRICE_DIMENSION PRICE
       ON ( PRICE.BRANCH_NUMBER_NK = WHSE.ACCOUNT_NUMBER_NK )
          AND ( PROD.PRODUCT_NK = PRICE.MASTER_PRODUCT_NK )
 WHERE (    PROD.DELETE_DATE IS NULL
  /*AND WHSE.WAREHOUSE_NUMBER_NK IN ('3017',
                                                             '3083',
                                                             '1895',
                                                             '107',
                                                             '1888',
                                                             '1315',
                                                             '1245',
                                                             '1205',
                                                             '2504',
                                                             '2783',
                                                             '520',
                                                             '34',
                                                             '1550',
                                                             '1408',
                                                             '109',
                                                             '590',
                                                             '61',
                                                             '1316',
                                                             '788',
                                                             '920',
                                                             '2000',
                                                             '1116',
                                                             '1674',
                                                             '256',
                                                             '710',
                                                             '1751',
                                                             '2019',
                                                             '716',
                                                             '2501',
                                                             '704',
                                                             '1743',
                                                             '2523',
                                                             '554',
                                                             '2637',
                                                             '3014',
                                                             '1105',
                                                             '1701',
                                                             '1934',
                                                             '215',
                                                             '1282',
                                                             '1491',
                                                             '1240',
                                                             '501',
                                                             '794',
                                                             '1300',
                                                             '1221',
                                                             '1196',
                                                             '305',
                                                             '435',
                                                             '461',
                                                             '309',
                                                             '3650',
                                                             '1393',
                                                             '1430',
                                                             '1800',
                                                             '527',
                                                             '127',
                                                             '20',
                                                             '1271',
                                                             '576',
                                                             '1693',
                                                             '2516',
                                                             '3097',
                                                             '1496',
                                                             '1480',
                                                             '226',
                                                             '52',
                                                             '126',
                                                             '1598',
                                                             '2735',
                                                             '1001',
                                                             '1401',
                                                             '1657',
                                                             '3325',
                                                             '125',
                                                             '3011',
                                                             '3019',
                                                             '1856',
                                                             '5',
                                                             '1423',
                                                             '686',
                                                             '1204',
                                                             '3007',
                                                             '3007',
                                                             '1539',
                                                             '1539',
                                                             '9005',
                                                             '1616',
                                                             '1350',
                                                             '1183',
                                                             '1083',
                                                             '1201',
                                                             '950',
                                                             '44',
                                                             '1575',
                                                             '1225',
                                                             '1600',
                                                             '2638',
                                                             '1476',
                                                             '3067')*/
    AND PROD.DISCOUNT_GROUP_NK IN ( '0012',
																													'0013',
																													'0014',
																													'0017',
																													'0050',
																													'0055',
																													'0057',
																													'0059'))
		AND WHSE.ACCOUNT_NAME NOT IN ( 'DIST', 'PIPE' )
 GROUP BY WHSE.ACCOUNT_NAME,
									WHSE.WAREHOUSE_NUMBER_NK,
									PROD.DISCOUNT_GROUP_NK,
									PRICE.MASTER_PRODUCT_NK,
									PROD.ALT1_CODE,
									PRICE.LAST_UPDATE,
									PROD.LIST_PRICE,
									WPF.LIST_PR,
									WPF.NEW_LIST,
									WPF.BASIS_2,
									WPF.BASIS_3,
									WPF.STATUS_TYPE;