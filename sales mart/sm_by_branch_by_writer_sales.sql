SELECT --X.YEARMONTH,
       X.ACCOUNT_NUMBER_NK BR_NO,
       NVL ( X.SELL_ALIAS_NAME, NULL ) BR_NAME,
       X.WRITER,
       -- X.CUSTOMER_TYPE,
			 X.SALES_TYPE,
       -- X.SELL_WAREHOUSE_NUMBER_NK WHSE,
       -- X.SELL_WAREHOUSE_NAME WH_NAME,
       -- X.CHANNEL_TYPE CHANNEL,
       SUM ( X.EXT_SALES_AMOUNT ) SALES,
       SUM ( X.EXT_AVG_COGS_AMOUNT ) AVG_COST,
       -- MATRIX SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MATRIX' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         MTX_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MATRIX' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         MTX_AC,
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'MATRIX'
                     THEN
                       ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.PRICE_CATEGORY IN 'MATRIX'
                      THEN
                        CASE
                          WHEN X.EXT_SALES_AMOUNT > 0
                          THEN
                            ( X.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         "MTX GP%",
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'MATRIX'
                     THEN
                       ( X.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.EXT_SALES_AMOUNT > 0 THEN X.EXT_SALES_AMOUNT
                      ELSE 1
                    END),
              3
       )
         "PM Use%$",
       -- CCOR SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'OVERRIDE' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         CCOR_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
             THEN
               ( X.EXT_AVG_COGS_AMOUNT )
             ELSE
               0
           END)
         CCOR_AC,
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                       ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
                      THEN
                        CASE
                          WHEN X.EXT_SALES_AMOUNT > 0
                          THEN
                            ( X.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         "MAN GP%",
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
                     THEN
                       ( X.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.EXT_SALES_AMOUNT > 0 THEN X.EXT_SALES_AMOUNT
                      ELSE 1
                    END),
              3
       )
         "Ovr Use%$",
       -- MANUAL SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MANUAL' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         CCOR_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'MANUAL' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         MAN_AC,
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'MANUAL'
                     THEN
                       ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.PRICE_CATEGORY IN 'MANUAL'
                      THEN
                        CASE
                          WHEN X.EXT_SALES_AMOUNT > 0
                          THEN
                            ( X.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         "MAN GP%",
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'MANUAL'
                     THEN
                       ( X.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.EXT_SALES_AMOUNT > 0 THEN X.EXT_SALES_AMOUNT
                      ELSE 1
                    END),
              3
       )
         "Man Use%$",
       -- SPECIAL SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'SPECIAL' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         "SP- SALES",
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'SPECIAL' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         "SP- AC",
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'SPECIAL'
                     THEN
                       ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.PRICE_CATEGORY IN 'SPECIAL'
                      THEN
                        CASE
                          WHEN X.EXT_SALES_AMOUNT > 0
                          THEN
                            ( X.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         "SP- GP%",
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'SPECIAL'
                     THEN
                       ( X.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.EXT_SALES_AMOUNT > 0 THEN X.EXT_SALES_AMOUNT
                      ELSE 1
                    END),
              3
       )
         "SP- Use%$",
       -- CREDIT SALES
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'CREDITS' THEN ( X.EXT_SALES_AMOUNT )
             ELSE 0
           END)
         CREDITS_SALES,
       SUM(CASE
             WHEN X.PRICE_CATEGORY IN 'CREDITS' THEN ( X.EXT_AVG_COGS_AMOUNT )
             ELSE 0
           END)
         CREDITS_AC,
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'CREDITS'
                     THEN
                       ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.PRICE_CATEGORY IN 'CREDITS'
                      THEN
                        CASE
                          WHEN X.EXT_SALES_AMOUNT > 0
                          THEN
                            ( X.EXT_SALES_AMOUNT )
                          ELSE
                            1
                        END
                      ELSE
                        1
                    END),
              3
       )
         "CR GP%",
       ROUND ( SUM(CASE
                     WHEN X.PRICE_CATEGORY IN 'CREDITS'
                     THEN
                       ( X.EXT_SALES_AMOUNT )
                     ELSE
                       0
                   END)
              / SUM(CASE
                      WHEN X.EXT_SALES_AMOUNT > 0 THEN X.EXT_SALES_AMOUNT
                      ELSE 1
                    END),
              3
       )
         "CR Use%$"
  FROM SALES_MART.PRICE_MGMT_DATA_DET X
			INNER JOIN
		SALES_MART.TIME_PERIOD_DIMENSION TPD
			ON ( X.YEARMONTH = TPD.YEARMONTH )
			
 WHERE   TPD.YEARMONTH BETWEEN 201610 AND 201703 --TPD.ROLLING_QTR = 'THIS QUARTER'
       -- AND X.ACCOUNT_NUMBER_NK = '1480' --IN ( '1550', '448', '276', '331', '1020', '2778' )
       AND X.IC_FLAG = 'REGULAR'
			 -- AND X.DISCOUNT_GROUP_NK IN ('4808', '4809', '4813', '4814', '5753' )
			 -- AND X.PRICE_CATEGORY
			 -- AND X.PRICE_SUB_CATEGORY
			 -- AND X.CHANNEL_TYPE
			 -- AND X.SALES_TYPE

GROUP BY --X.YEARMONTH,
         X.ACCOUNT_NUMBER_NK,
         NVL ( X.SELL_ALIAS_NAME, NULL ),
				 X.SALES_TYPE,
         X.WRITER
ORDER BY --X.YEARMONTH,
         X.ACCOUNT_NUMBER_NK,
         NVL ( X.SELL_ALIAS_NAME, NULL ),
				 X.SALES_TYPE,
         X.WRITER
		;