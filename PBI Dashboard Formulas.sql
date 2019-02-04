Total Sales TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")

Total Sales LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")

---------------------------------------------------------------------------------

Total CORE COGS TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")

Total CORE COGS LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")


Total CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 
        - CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")

Total CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR") 
        - CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")


TOTAL GP% TY = DIVIDE([Total GP$ TY],[Total Sales TY],0)

TOTAL GP% LY = DIVIDE([Total GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------

Total INV GP$ TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 

Total INV GP$ LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR") 

Total Inv GP$ TY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 

Total Inv GP$ LY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")         

Total Inv GP% TY = DIVIDE([Total INV GP$ TY],[Total Sales TY],0)

Total Inv GP% LY = DIVIDE([Total INV GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
