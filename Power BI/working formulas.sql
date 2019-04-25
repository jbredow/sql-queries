---------------------------------------------------------------------------------
-- CREDITS Average Cost

CREDITS Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
            
CREDITS Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS Avg GP% TY = DIVIDE([CREDITS Avg GP$ TY],[CREDITS Sales TY],0)

CREDITS Avg GP% LY = DIVIDE([CREDITS Avg GP$ LY],[CREDITS Sales LY],0)

---------------------------------------------------------------------------------
-- CREDITS CORE Adjusted Average Cost

CREDITS CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
            
CREDITS CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS CORE GP% TY = DIVIDE([CREDITS CORE GP$ TY],[CREDITS Sales TY],0)

CREDITS CORE GP% LY = DIVIDE([CREDITS CORE GP$ LY],[CREDITS Sales LY],0)

---------------------------------------------------------------------------------
-- CREDITS Invoice Cost

CREDITS Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
            
CREDITS Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

CREDITS Inv. GP% TY = DIVIDE([CREDITS Inv. GP$ TY],[CREDITS Sales TY],0)

CREDITS Inv. GP% LY = DIVIDE([CREDITS Inv. GP$ LY],[CREDITS Sales LY],0)
