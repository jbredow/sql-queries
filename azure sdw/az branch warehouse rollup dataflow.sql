Sql.Database("feieimazsrv1.database.windows.net,1433", "feieimazsdw1", 
    [Query=
        "SELECT swd.DIVISION_NAME AS REGION,
       swd.REGION_NAME AS DISTRICT,
       swd.ACCOUNT_NAME,
       swd.WAREHOUSE_NUMBER_NK,
       swd.WAREHOUSE_NAME,
       swd.WAREHOUSE_NUM_NAME,
       area.AREA,
       area.RPT_NAME,
       wd.SHIP_TO_NAME NAME,
       wd.SHIP_TO_ADDRESS_1 ADDRESS1,
       wd.SHIP_TO_ADDRESS_2 ADDRESS2,
       wd.SHIP_TO_CITY CITY,
       wd.SHIP_TO_STATE STATE,
       wd.SHIP_TO_ZIP ZIP,
       wd.SHIP_TO_COUNTRY COUNTRY,
       CONCAT(wd.SHIP_TO_ADDRESS_1, ', ', SHIP_TO_CITY, ', ', SHIP_TO_STATE, ', ', wd.SHIP_TO_ZIP, ', ', wd.SHIP_TO_COUNTRY) AS ADDRESS
FROM ([DWFEI_STG].[RPT_AREA_VW] area
      RIGHT OUTER JOIN [DWFEI_STG].[WAREHOUSE_DIMENSION] wd
         ON (area.WHSE = wd.WAREHOUSE_NUMBER_NK))
     LEFT OUTER JOIN [DWFEI_STG].[SALES_WAREHOUSE_DIM] swd
        ON (swd.WAREHOUSE_NUMBER_NK = wd.WAREHOUSE_NUMBER_NK)
WHERE     (swd.REGION_NAME NOT IN ('OTHER REGION',
                                   'D97 BLENDED MISCELLANEOUS',
                                   'D96 BUSINESS TO CUSTOMER',
                                   'D80 OWN BRAND',
                                   'D98 DISTRIBUTION CENTERS',
                                   'O99 OTHER BUSINESSES',
                                   'D62 INTEGRATED SERVICES'))
      AND (wd.ACTIVE_FLAG = 1)
	  AND (wd.SHIP_TO_ZIP <> 'XXXXX')
	  AND (wd.SHIP_TO_ZIP IS NOT NULL)"
    ])