Sql.Database("feieimazsrv1.database.windows.net,1433", "feieimazsdw1", 
    [Query=
        "SELECT DISTINCT whse.REGION_NAME,
                whse.DISTRICT,
                whse.ACCOUNT_NUMBER_NK,
                whse.ACCOUNT_NAME,
                sums.EOM_YEARMONTH,
                sums.DISC_GRP,
                hier.DESCRIPTION,
                sums.ORDER_CHANNEL,
                CASE
                   WHEN sums.DISC_GRP IN ('5799',
                                          '5835',
                                          '5838',
                                          '5943',
                                          '5890',
                                          '5863',
                                          '5871',
                                          '5797',
                                          '5895',
                                          '5944')
                   THEN
                      'PIPE'
                   WHEN sums.DISC_GRP IN ('5955', '6055', '6062')
                   THEN
                      'DI Fittings'
                   WHEN sums.DISC_GRP IN ('6480',
                                          '6481',
                                          '6474',
                                          '6476',
                                          '6466',
                                          '6467')
                   THEN
                      'Restraints'
                   WHEN sums.DISC_GRP IN ('6480',
                                          '6481',
                                          '6474',
                                          '6476',
                                          '6466',
                                          '6467')
                   THEN
                      'Restraints'
                   WHEN sums.DISC_GRP IN ('6037',
                                          '6140',
                                          '6105',
                                          '6069')
                   THEN
                      'Valves'
                   WHEN sums.DISC_GRP IN ('6044',
                                          '6146',
                                          '6115',
                                          '6073',
                                          '6198')
                   THEN
                      'Hydrants'
                   WHEN sums.DISC_GRP IN ('6264', '6279', '6251')
                   THEN
                      'Service Brass'
                   WHEN sums.DISC_GRP IN ('5929', '5935')
                   THEN
                      'Sewer Fittings'
                   ELSE
                      'Other'
                END
                   CORE_CATEGORY,
                sums.DELIVERY_CHANNEL,
                SUM (sums.EXT_SALES_AMT)
                   AS SUM_EXT_SALES_AMT,
                SUM (sums.CORE_COGS_AMT)
                   AS SUM_CORE_COGS_AMT,
                tpd.ROLL12MONTHS,
                tpd.FISCAL_YEAR_TO_DATE,
                tpd.ROLLING_MONTH
FROM (((DWFEI_STG.WHSE_RPT_AREA_VW whse
        INNER JOIN DWFEI_STG.PR_PBI_PRICE_CAT_SUMS sums
           
		   ON (whse.WAREHOUSE_NUMBER_NK = CONVERT( VARCHAR(8),sums.WHSE))

        INNER JOIN DWFEI_STG.BUSGRP_PROD_HIERARCHY hier
           ON (hier.DISCOUNT_GROUP_NK = sums.DISC_GRP))
       INNER JOIN DWFEI_STG.TIME_PERIOD_DIMENSION tpd
          ON (sums.EOM_YEARMONTH = tpd.YEARMONTH)))
WHERE     (whse.REGION_NAME = 'WATERWORKS REGION')
      AND (tpd.ROLL12MONTHS = 'LAST TWELVE MONTHS')
      AND (sums.DISC_GRP IN ( '5799',
                              '5835',
                              '5838',
                              '5943',
                              '5890',
                              '5863',
                              '5871',
                              '5895',
                              '5944',
                              '5955',
                              '6055',
                              '6062',
                              '6480',
                              '6481',
                              '6474',
                              '6476',
                              '6466',
                              '6467',
                              '6037',
                              '6140',
                              '6105',
                              '6069',
                              '6044',
                              '6146',
                              '6115',
                              '6073',
                              '6198',
                              '6264',
                              '6279',
                              '6251',
                              '5929',
                              '5935',
                              '5797'
                              ))
GROUP BY whse.REGION_NAME,
         whse.DISTRICT,
         whse.ACCOUNT_NUMBER_NK,
         whse.ACCOUNT_NAME,
         sums.EOM_YEARMONTH,
         sums.DISC_GRP,
         hier.DESCRIPTION,
         sums.ORDER_CHANNEL,
         CASE
                   WHEN sums.DISC_GRP IN ('5799',
                                          '5835',
                                          '5838',
                                          '5943',
                                          '5890',
                                          '5863',
                                          '5871',
                                          '5797',
                                          '5895',
                                          '5944')
                   THEN
                      'PIPE'
                   WHEN sums.DISC_GRP IN ('5955', '6055', '6062')
                   THEN
                      'DI Fittings'
                   WHEN sums.DISC_GRP IN ('6480',
                                          '6481',
                                          '6474',
                                          '6476',
                                          '6466',
                                          '6467')
                   THEN
                      'Restraints'
                   WHEN sums.DISC_GRP IN ('6480',
                                          '6481',
                                          '6474',
                                          '6476',
                                          '6466',
                                          '6467')
                   THEN
                      'Restraints'
                   WHEN sums.DISC_GRP IN ('6037',
                                          '6140',
                                          '6105',
                                          '6069')
                   THEN
                      'Valves'
                   WHEN sums.DISC_GRP IN ('6044',
                                          '6146',
                                          '6115',
                                          '6073',
                                          '6198')
                   THEN
                      'Hydrants'
                   WHEN sums.DISC_GRP IN ('6264', '6279', '6251')
                   THEN
                      'Service Brass'
                   WHEN sums.DISC_GRP IN ('5929', '5935')
                   THEN
                      'Sewer Fittings'
                   ELSE
                      'Other'
                END,
         sums.DELIVERY_CHANNEL,
         tpd.ROLL12MONTHS,
         tpd.FISCAL_YEAR_TO_DATE,
         tpd.ROLLING_MONTH"
    ])