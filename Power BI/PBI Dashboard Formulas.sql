Total Sales TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")

Total Sales LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")

---------------------------------------------------------------------------------
-- CORE Adjusted Cost

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


TOTAL CORE GP% TY = DIVIDE([Total CORE GP$ TY],[Total Sales TY],0)

TOTAL CORE GP% LY = DIVIDE([Total CORE GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
-- Invoice Cost

Total INV COGS TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 

Total INV COGS LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR") 

Total Inv GP$ TY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 

Total Inv GP$ LY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")         

Total Inv GP% TY = DIVIDE([Total INV GP$ TY],[Total Sales TY],0)

Total Inv GP% LY = DIVIDE([Total INV GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
-- Average Cost

Total Avg GP$ TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 

Total Avg GP$ LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR") 

Total Avg GP$ TY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS") 

Total Avg GP$ LY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR")         

Total Avg GP% TY = DIVIDE([Total Avg GP$ TY],[Total Sales TY],0)

Total Avg GP% LY = DIVIDE([Total Avg GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Matrix Sales Cat

Matrix Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

---------------------------------------------------------------------------------
-- Matrix Average Cost

Matrix Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
            
Matrix Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Avg GP% TY = DIVIDE([Matrix Avg GP$ TY],[Matrix Sales TY],0)

Matrix Avg GP% LY = DIVIDE([Matrix Avg GP$ LY],[Matrix Sales LY],0)

---------------------------------------------------------------------------------
-- Matrix CORE Adjusted Average Cost

Matrix CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
            
Matrix CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix CORE GP% TY = DIVIDE([Matrix CORE GP$ TY],[Matrix Sales TY],0)

Matrix CORE GP% LY = DIVIDE([Matrix CORE GP$ LY],[Matrix Sales LY],0)

---------------------------------------------------------------------------------
-- Matrix Invoice Cost

Matrix Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
            
Matrix Inv. COGS GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Inv. GP% TY = DIVIDE([Matrix Inv. GP$ TY],[Matrix Sales TY],0)

Matrix Inv. GP% LY = DIVIDE([Matrix Inv. GP$ LY],[Matrix Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- CCOR Sales Cat

CCOR Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

---------------------------------------------------------------------------------
-- CCOR Average Cost

CCOR Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
            
CCOR Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Avg GP% TY = DIVIDE([CCOR Avg GP$ TY],[CCOR Sales TY],0)

CCOR Avg GP% LY = DIVIDE([CCOR Avg GP$ LY],[CCOR Sales LY],0)

---------------------------------------------------------------------------------
-- CCOR CORE Adjusted Average Cost

CCOR CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
            
CCOR CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR CORE GP% TY = DIVIDE([CCOR CORE GP$ TY],[CCOR Sales TY],0)

CCOR CORE GP% LY = DIVIDE([CCOR CORE GP$ LY],[CCOR Sales LY],0)

---------------------------------------------------------------------------------
-- CCOR Invoice Cost

CCOR Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
            
CCOR Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Inv. GP% TY = DIVIDE([CCOR Inv. GP$ TY],[CCOR Sales TY],0)

CCOR Inv. GP% LY = DIVIDE([CCOR Inv. GP$ LY],[CCOR Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- MANUAL Sales Cat

MANUAL Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

---------------------------------------------------------------------------------
-- MANUAL Average Cost

MANUAL Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
            
MANUAL Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Avg GP% TY = DIVIDE([MANUAL Avg GP$ TY],[MANUAL Sales TY],0)

MANUAL Avg GP% LY = DIVIDE([MANUAL Avg GP$ LY],[MANUAL Sales LY],0)

---------------------------------------------------------------------------------
-- MANUAL CORE Adjusted Average Cost

MANUAL CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
            
MANUAL CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL CORE GP% TY = DIVIDE([MANUAL CORE GP$ TY],[MANUAL Sales TY],0)

MANUAL CORE GP% LY = DIVIDE([MANUAL CORE GP$ LY],[MANUAL Sales LY],0)

---------------------------------------------------------------------------------
-- MANUAL Invoice Cost

MANUAL Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
            
MANUAL Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

MANUAL Inv. GP% TY = DIVIDE([MANUAL Inv. GP$ TY],[MANUAL Sales TY],0)

MANUAL Inv. GP% LY = DIVIDE([MANUAL Inv. GP$ LY],[MANUAL Sales LY],0)

---------------------------------------------------------------------------------
-- SP- Average Cost

SP- Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
            
SP- Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Avg GP% TY = DIVIDE([SP- Avg GP$ TY],[SP- Sales TY],0)

SP- Avg GP% LY = DIVIDE([SP- Avg GP$ LY],[SP- Sales LY],0)

---------------------------------------------------------------------------------
-- SP- CORE Adjusted Average Cost

SP- CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
            
SP- CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- CORE GP% TY = DIVIDE([SP- CORE GP$ TY],[SP- Sales TY],0)

SP- CORE GP% LY = DIVIDE([SP- CORE GP$ LY],[SP- Sales LY],0)

---------------------------------------------------------------------------------
-- SP- Invoice Cost

SP- Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
            
SP- Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[ROLL12MONTHS] = "LAST TWELVE MONTHS LAST YEAR",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Inv. GP% TY = DIVIDE([SP- Inv. GP$ TY],[SP- Sales TY],0)

SP- Inv. GP% LY = DIVIDE([SP- Inv. GP$ LY],[SP- Sales LY],0)

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
