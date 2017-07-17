SELECT
	X.ACCOUNT_NUMBER_NK BR_NO,
	NVL ( X.SELL_ALIAS_NAME, NULL ) BR_NAME, 
	--X.DISCOUNT_GROUP_NK DG,
	--X.DISCOUNT_GROUP_NK_NAME DG_DESC,
	--X.PRICE_CATEGORY,
  --X.PRICE_SUB_CATEGORY,
	X.SALES_TYPE,
	SUM ( X.EXT_SALES_AMOUNT ) SALES,
	SUM ( X.EXT_AVG_COGS_AMOUNT ) AVG_COST,
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
    
WHERE X.YEARMONTH BETWEEN '201404' AND '201503'
  AND X.ACCOUNT_NUMBER_NK IN ( 
			'226',	'448',	'520',	'1020',	'1550',	'1657',	'1674',	'3093',
			'13',	'20',	'56',	'100',	'150',	'215',	'216',	'564',	'1480',
			'61',	'88',	'116',	'190',	'230',	'454',	'480',	'1869', '1599', 
			'2000', '142', '1599', '0026'
			)
  AND X.IC_FLAG = 'REGULAR'
  --AND X.PRICE_CATEGORY
  --AND X.PRICE_SUB_CATEGORY
  --AND X.CHANNEL_TYPE
  --AND X.SALES_TYPE
  
GROUP BY X.ACCOUNT_NUMBER_NK,
	NVL ( X.SELL_ALIAS_NAME, NULL ),
	X.SALES_TYPE
	--X.DISCOUNT_GROUP_NK DG,
	--X.DISCOUNT_GROUP_NK_NAME DG_DESC,
	--X.PRICE_CATEGORY,
  --X.PRICE_SUB_CATEGORY

--ORDER BY X.DISCOUNT_GROUP_NK ASC 
;