SELECT
	X.ACCOUNT_NUMBER_NK BR_NO,
	NVL ( X.SELL_ALIAS_NAME, NULL ) BR_NAME, 
	X.DISCOUNT_GROUP_NK DG,
	X.DISCOUNT_GROUP_NK_NAME DG_DESC,
	CASE
		WHEN X.SELL_WAREHOUSE_NUMBER_NK IN ('276',
																																	'331',
																																	'448',
																																	'451',
																																	'467',
																																	'821',
																																	'1020',
																																	'1176',
																																	'1678',
																																	'1696',
																																	'3337'
																																	)
		THEN
			'WISCONSIN'
		ELSE
			'CHICAGO'
	END
		BU,
	X.SELL_WAREHOUSE_NUMBER_NK,
	SUM ( X.EXT_SALES_AMOUNT ) SALES,
	SUM ( X.EXT_AVG_COGS_AMOUNT ) AVG_COST,
	ROUND (
    (SUM ( X.EXT_SALES_AMOUNT ) - SUM ( X.EXT_AVG_COGS_AMOUNT ))
		/ CASE
        WHEN SUM ( X.EXT_SALES_AMOUNT ) > 0
        THEN SUM ( X.EXT_SALES_AMOUNT )
        ELSE
          1
      END
        , 3 )
     "GP %",
  -- MATRIX SALES
	SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'MATRIX'
      THEN 
        ( X.EXT_SALES_AMOUNT )
      ELSE
        0
    END )
      MTX_SALES,
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'MATRIX'
      THEN 
        ( X.EXT_AVG_COGS_AMOUNT )
      ELSE
        0
    END )
      MTX_AC,
  ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'MATRIX'
            THEN
               ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.PRICE_CATEGORY IN 'MATRIX'
              THEN
                 CASE
                    WHEN X.EXT_SALES_AMOUNT > 0
                    THEN
                       (X.EXT_SALES_AMOUNT)
                    ELSE
                       1
                 END
              ELSE
                 1
           END),
      3)
      "MTX GP%",
   ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'MATRIX'
            THEN
               (X.EXT_SALES_AMOUNT)
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.EXT_SALES_AMOUNT > 0
              THEN
                 X.EXT_SALES_AMOUNT
              ELSE
                 1
           END),
      3)
      "PM Use%$",
  -- CCOR SALES
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
      THEN 
        ( X.EXT_SALES_AMOUNT )
      ELSE
        0
    END )
      CCOR_SALES,
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
      THEN 
        ( X.EXT_AVG_COGS_AMOUNT )
      ELSE
        0
    END )
      CCOR_AC,
  ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
            THEN
               ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
              THEN
                 CASE
                    WHEN X.EXT_SALES_AMOUNT > 0
                    THEN
                       (X.EXT_SALES_AMOUNT)
                    ELSE
                       1
                 END
              ELSE
                 1
           END),
      3)
      "MAN GP%",
   ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'OVERRIDE'
            THEN
               (X.EXT_SALES_AMOUNT)
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.EXT_SALES_AMOUNT > 0
              THEN
                 X.EXT_SALES_AMOUNT
              ELSE
                 1
           END),
      3)
      "Ovr Use%$",
  -- MANUAL SALES
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'MANUAL'
      THEN 
        ( X.EXT_SALES_AMOUNT )
      ELSE
        0
    END )
      CCOR_SALES,
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'MANUAL'
      THEN 
        ( X.EXT_AVG_COGS_AMOUNT )
      ELSE
        0
    END )
      MAN_AC,
  ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'MANUAL'
            THEN
               ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.PRICE_CATEGORY IN 'MANUAL'
              THEN
                 CASE
                    WHEN X.EXT_SALES_AMOUNT > 0
                    THEN
                       (X.EXT_SALES_AMOUNT)
                    ELSE
                       1
                 END
              ELSE
                 1
           END),
      3)
      "MAN GP%",
   ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'MANUAL'
            THEN
               (X.EXT_SALES_AMOUNT)
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.EXT_SALES_AMOUNT > 0
              THEN
                 X.EXT_SALES_AMOUNT
              ELSE
                 1
           END),
      3)
      "Man Use%$",
  -- SPECIAL SALES
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'SPECIAL'
      THEN 
        ( X.EXT_SALES_AMOUNT )
      ELSE
        0
    END )
      "SP- SALES",
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'SPECIAL'
      THEN 
        ( X.EXT_AVG_COGS_AMOUNT )
      ELSE
        0
    END )
      "SP- AC",
  ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'SPECIAL'
            THEN
               ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.PRICE_CATEGORY IN 'SPECIAL'
              THEN
                 CASE
                    WHEN X.EXT_SALES_AMOUNT > 0
                    THEN
                       (X.EXT_SALES_AMOUNT)
                    ELSE
                       1
                 END
              ELSE
                 1
           END),
      3)
      "SP- GP%",
   ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'SPECIAL'
            THEN
               (X.EXT_SALES_AMOUNT)
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.EXT_SALES_AMOUNT > 0
              THEN
                 X.EXT_SALES_AMOUNT
              ELSE
                 1
           END),
      3)
      "SP- Use%$",
-- CREDIT SALES
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'CREDITS'
      THEN 
        ( X.EXT_SALES_AMOUNT )
      ELSE
        0
    END )
      CREDITS_SALES,
  SUM (
    CASE
      WHEN X.PRICE_CATEGORY IN 'CREDITS'
      THEN 
        ( X.EXT_AVG_COGS_AMOUNT )
      ELSE
        0
    END )
      CREDITS_AC,
  ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'CREDITS'
            THEN
               ( X.EXT_SALES_AMOUNT - X.EXT_AVG_COGS_AMOUNT )
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.PRICE_CATEGORY IN 'CREDITS'
              THEN
                 CASE
                    WHEN X.EXT_SALES_AMOUNT > 0
                    THEN
                       (X.EXT_SALES_AMOUNT)
                    ELSE
                       1
                 END
              ELSE
                 1
           END),
      3)
      "CR GP%",
   ROUND (
      SUM (
         CASE
            WHEN X.PRICE_CATEGORY IN 'CREDITS'
            THEN
               (X.EXT_SALES_AMOUNT)
            ELSE
               0
         END)
      / SUM (
           CASE
              WHEN X.EXT_SALES_AMOUNT > 0
              THEN
                 X.EXT_SALES_AMOUNT
              ELSE
                 1
           END),
      3)
      "CR Use%$"      
FROM SALES_MART.PRICE_MGMT_DATA_SUMM X
    
WHERE X.YEARMONTH = '201508'
  AND X.ACCOUNT_NUMBER_NK = '1550'
  AND X.IC_FLAG = 'REGULAR'
  --AND X.PRICE_CATEGORY
  --AND X.PRICE_SUB_CATEGORY
  --AND X.CHANNEL_TYPE
  AND X.SALES_TYPE LIKE 'COUNT%'
	
  
GROUP BY X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ), 
	X.DISCOUNT_GROUP_NK,
	X.DISCOUNT_GROUP_NK_NAME,
	X.SELL_WAREHOUSE_NUMBER_NK,
	CASE
		WHEN X.SELL_WAREHOUSE_NUMBER_NK IN ('276',
																																	'331',
																																	'448',
																																	'451',
																																	'467',
																																	'821',
																																	'1020',
																																	'1176',
																																	'1678',
																																	'1696',
																																	'3337'
																																	)
		THEN
			'WISCONSIN'
		ELSE
			'CHICAGO'
	END

ORDER BY X.DISCOUNT_GROUP_NK ASC 
;