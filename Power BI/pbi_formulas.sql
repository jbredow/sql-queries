Total Sales FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")

Total ACCA FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")

Total GP$ FYTD TY = [Total Sales FYTD TY] - [Total ACCA FYTD TY]

Total ACCA FYTD GP% TY = DIVIDE([Total GP$ TY],[Total Sales FYTD TY],0)


Total Sales FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")

Total ACCA FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")

Total GP$ LY = [Total Sales FYTD LY] - [Total ACCA FYTD LY]

Total ACCA GP% LY = DIVIDE([Total GP$ LY],[Total Sales FYTD LY],0)


--############ MATRIX
Matrix Sales FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MATRIX")

Matrix ACCA $ FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MATRIX")

Matrix GP$ FYTD LY = [Matrix Sales FYTD TY] - [Matrix ACCA FYTD TY]

Matrix ACCA FYTD GP% TY = DIVIDE([Matrix GP$ TY],[Matrix Sales FYTD TY],0)

Matrix $ Util TY = DIVIDE([Matrix Sales FYTD TY],[o/b sales fytd ty],0)

Matrix Sales FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MATRIX")

Matrix ACCA $ FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MATRIX")

Matrix GP$ FYTD LY = [Matrix Sales FYTD LY] - [Matrix ACCA FYTD LY]

Matrix ACCA FYTD GP% LY = DIVIDE([Matrix GP$ TY],[Matrix Sales FYTD LY],0)

Matrix $ Util LY = DIVIDE([Matrix Sales FYTD LY],[o/b sales fytd ly],0)

--############ CONTRACT
Contract Sales FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CCOR")

Contract ACCA $ FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CCOR")

Contract GP$ FYTD TY = [Contract Sales FYTD TY] - [Contract ACCA $ FYTD TY]

Contract ACCA FYTD GP% TY = DIVIDE([Contract GP$ FYTD TY],[Contract Sales FYTD TY],0)

Contract $ Util TY = DIVIDE([Contract Sales FYTD TY],[o/b sales fytd ty],0)

Contract Sales FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CCOR")

Contract ACCA $ FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CCOR")

Contract GP$ FYTD LY = [Contract Sales FYTD LY] - [Contract ACCA $ FYTD LY]

Contract ACCA FYTD GP% LY = DIVIDE([Contract GP$ FYTD TY],[Contract Sales FYTD LY],0)

Contract $ Util LY = DIVIDE([Contract Sales FYTD LY],[o/b sales fytd ly],0)

--############ MANUAL
Manual Sales FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MANUAL")
+   CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "OTH/ERROR")

Manual ACCA $ FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MANUAL")
+   CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "OTH/ERROR")        

Manual GP$ FYTD TY = [Manual Sales FYTD TY] - [Manual ACCA $ FYTD TY]

Manual ACCA FYTD GP% TY = DIVIDE([Manual GP$ FYTD TY],[Manual Sales FYTD TY],0)

Manual $ Util TY = DIVIDE([Manual Sales FYTD TY],[o/b sales fytd ty],0)

Manual Sales FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MANUAL")
+   CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "OTH/ERROR")

Manual ACCA $ FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "MANUAL")
+   CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "OTH/ERROR")

Manual GP$ FYTD LY = [Manual Sales FYTD LY] - [Manual ACCA $ FYTD LY]

Manual ACCA FYTD GP% LY = DIVIDE([Manual GP$ FYTD TY],[Manual Sales FYTD LY],0)

Manual $ Util LY = DIVIDE([Manual Sales FYTD LY],[o/b sales fytd ly],0)

--############ Specials
Specials Sales FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "SP-")

Specials ACCA $ FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "SP-")

Specials GP$ FYTD TY = [Specials Sales FYTD TY] - [Specials ACCA $ FYTD TY]

Specials ACCA FYTD GP% TY = DIVIDE([Specials GP$ FYTD TY],[Specials Sales FYTD TY],0)

Specials $ Util TY = DIVIDE([Specials Sales FYTD TY],[o/b sales fytd ty],0)

Specials Sales FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "SP-")

Specials ACCA $ FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "SP-")

Specials GP$ FYTD LY = [Specials Sales FYTD LY] - [Specials ACCA $ FYTD LY]

Specials ACCA FYTD GP% LY = DIVIDE([Specials GP$ FYTD TY],[Specials Sales FYTD LY],0)

Specials $ Util LY = DIVIDE([Specials Sales FYTD LY],[o/b sales fytd ly],0)

--############ Credit
Credit Sales FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CREDITS")

Credit ACCA $ FYTD TY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CREDITS")

Credit GP$ FYTD TY = [Credit Sales FYTD TY] - [Credit ACCA $ FYTD TY]

Credit ACCA FYTD GP% TY = DIVIDE([Credit GP$ FYTD TY],[Credit Sales FYTD TY],0)

Credit Sales FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[EXT_SALES_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CREDITS")

Credit ACCA $ FYTD LY = 
    CALCULATE(SUM('DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[CORE_COGS_AMT]),
        'DWFEI_STG TIME_PERIOD_DIMENSION'[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
        'DWFEI_STG PR_PBI_PRICE_CAT_SUMS'[PRICE_CATEGORY] = "CREDITS")

Credit GP$ FYTD LY = [Credit Sales FYTD LY] - [Credit ACCA $ FYTD LY]

Credit ACCA FYTD GP% LY = DIVIDE([Credit GP$ FYTD TY],[Credit Sales FYTD LY],0)
