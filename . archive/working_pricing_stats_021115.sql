SELECT PM_SUMM.ACCOUNT_NUMBER_NK AS BRANCH_NO,
       BC.ALIAS AS BRANCH_NAME,
       PM_SUMM.YEARMONTH,
       PM_SUMM.PRICE_CATEGORY,
       SUM ( PM_SUMM.EXT_SALES_AMOUNT ) TOTAL_SALES,
       SUM ( PM_SUMM.EXT_AVG_COGS_AMOUNT ) TOTAL_AC
			 
FROM     (    AAF1046.BRANCH_CONTACTS BC
            INNER JOIN
                SALES_MART.PRICE_MGMT_DATA_SUMM PM_SUMM
            ON ( BC.ACCOUNT_NK = PM_SUMM.ACCOUNT_NUMBER_NK ))
       INNER JOIN
           SALES_MART.TIME_PERIOD_DIMENSION TP
       ON ( TP.YEARMONTH = PM_SUMM.YEARMONTH )
 WHERE     ( TP.ROLL12MONTHS = 'LAST TWELVE MONTHS' )
       AND ( BC.DISTRICT = 'C12' )
       AND ( PM_SUMM.ACCOUNT_NUMBER_NK = '61' )

GROUP BY TP.ROLL12MONTHS,
         BC.DISTRICT,
         PM_SUMM.ACCOUNT_NUMBER_NK,
         BC.ALIAS,
         PM_SUMM.YEARMONTH,
         PM_SUMM.PRICE_CATEGORY

ORDER BY TP.ROLL12MONTHS DESC,
         BC.ALIAS ASC;