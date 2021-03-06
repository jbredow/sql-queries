IF ([YEARMONTH] between ?beg_date? and ?end_date?)
THEN (COALESCE([Database Layer].[INVOICE_LINE_FACT].[EXT_SALES_AMOUNT],0))
ELSE (0)

IF ([YEARMONTH] between ?beg_date? and ?end_date?)
THEN (COALESCE([Database Layer].[INVOICE_LINE_FACT].[EXT_AVG_COGS_AMOUNT],0))
ELSE (0)


[Database Layer].[INVOICE_HEADER_FACT].[WRITER]

IF ([Database Layer].[INVOICE_HEADER_FACT].[WRITER] starts with h) 
THEN
  IF ([YEARMONTH] between ?beg_date? and ?end_date?)
  THEN (COALESCE([Database Layer].[INVOICE_LINE_FACT].[EXT_SALES_AMOUNT],0))
  ELSE (0)
ELSE (0)



IF ([WRITER] in ) 
THEN (COALESCE([Database Layer].[INVOICE_LINE_FACT].[EXT_SALES_AMOUNT],0))
ELSE (0)

case 
  when ([Database Layer].[INVOICE_HEADER_FACT].[WRITER] begins with 'h') 
  then (COALESCE([Database Layer].[INVOICE_LINE_FACT].[EXT_SALES_AMOUNT],0))
  else (0) 
end

case 
    when ([Presentation View].[Price Management Data].[Order Code]<>'IC') 
    then (COALESCE([Ext Avg Cogs AmountLY],0))
    else 
        (0)
end