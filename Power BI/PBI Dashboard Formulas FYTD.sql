Total Sales TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")

Total Sales LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")

Total Lines TY = CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
    tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")

Total Lines LY = CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
    tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")

Outbound Sales LY = CALCULATE([Total Sales LY]-[Credits Sales LY])

Outbound Sales TY = CALCULATE([Total Sales TY]-[Credits Sales TY])

Outbound Lines TY = CALCULATE([Total Lines TY]-[Credits Lines TY])

Outbound Lines LY = CALCULATE([Total Lines LY]-[Credits Lines LY])
---------------------------------------------------------------------------------
-- CORE Adjusted Cost

Total CORE COGS TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")

Total CORE COGS LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")


Total CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE") 
        - CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")

Total CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE") 
        - CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")


TOTAL CORE GP% TY = DIVIDE([Total CORE GP$ TY],[Total Sales TY],0)

TOTAL CORE GP% LY = DIVIDE([Total CORE GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
-- Invoice Cost

Total INV COGS TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE") 

Total INV COGS LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE") 

Total Inv GP$ TY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE") 

Total Inv GP$ LY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")         

Total Inv GP% TY = DIVIDE([Total INV GP$ TY],[Total Sales TY],0)

Total Inv GP% LY = DIVIDE([Total INV GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
-- Average Cost

Total Avg COGS TY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE") 

Total Avg COGS LY = CALCULATE(
    SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE") 

Total Avg GP$ TY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE") 

Total Avg GP$ LY = CALCULATE( SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")
    - CALCULATE( SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
        tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE")         

Total Avg GP% TY = DIVIDE([Total Avg GP$ TY],[Total Sales TY],0)

Total Avg GP% LY = DIVIDE([Total Avg GP$ LY],[Total Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Matrix Sales Cat

Matrix Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Lines TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Lines LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Sales Util. LY = DIVIDE([Matrix Sales LY],[Outbound Sales LY],0)

Matrix Sales Util. TY = DIVIDE([Matrix Sales TY],[Outbound Sales TY],0)

Matrix Lines Util. LY = DIVIDE([Matrix Lines LY],[Outbound Lines LY],0)

Matrix Lines Util. TY = DIVIDE([Matrix Lines TY],[Outbound Lines TY],0)

---------------------------------------------------------------------------------
-- Matrix Average Cost

Matrix Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
            
Matrix Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Avg GP% TY = DIVIDE([Matrix Avg GP$ TY],[Matrix Sales TY],0)

Matrix Avg GP% LY = DIVIDE([Matrix Avg GP$ LY],[Matrix Sales LY],0)

---------------------------------------------------------------------------------
-- Matrix CORE Adjusted Average Cost

Matrix CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
            
Matrix CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix CORE GP% TY = DIVIDE([Matrix CORE GP$ TY],[Matrix Sales TY],0)

Matrix CORE GP% LY = DIVIDE([Matrix CORE GP$ LY],[Matrix Sales LY],0)

---------------------------------------------------------------------------------
-- Matrix Invoice Cost

Matrix Inv. COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
            
Matrix Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MATRIX")

Matrix Inv. GP% TY = DIVIDE([Matrix Inv. GP$ TY],[Matrix Sales TY],0)

Matrix Inv. GP% LY = DIVIDE([Matrix Inv. GP$ LY],[Matrix Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- CCOR Sales Cat

CCOR Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Lines TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Lines LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Sales Util. LY = DIVIDE([CCOR Sales LY],[Outbound Sales LY],0)

CCOR Sales Util. TY = DIVIDE([CCOR Sales TY],[Outbound Sales TY],0)

CCOR Lines Util. LY = DIVIDE([CCOR Lines LY],[Outbound Lines LY],0)

CCOR Lines Util. TY = DIVIDE([CCOR Lines TY],[Outbound Lines TY],0)

---------------------------------------------------------------------------------
-- CCOR Average Cost

CCOR Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
            
CCOR Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Avg GP% TY = DIVIDE([CCOR Avg GP$ TY],[CCOR Sales TY],0)

CCOR Avg GP% LY = DIVIDE([CCOR Avg GP$ LY],[CCOR Sales LY],0)

---------------------------------------------------------------------------------
-- CCOR CORE Adjusted Average Cost

CCOR CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
            
CCOR CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR CORE GP% TY = DIVIDE([CCOR CORE GP$ TY],[CCOR Sales TY],0)

CCOR CORE GP% LY = DIVIDE([CCOR CORE GP$ LY],[CCOR Sales LY],0)

---------------------------------------------------------------------------------
-- CCOR Invoice Cost

CCOR Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
            
CCOR Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CCOR")

CCOR Inv. GP% TY = DIVIDE([CCOR Inv. GP$ TY],[CCOR Sales TY],0)

CCOR Inv. GP% LY = DIVIDE([CCOR Inv. GP$ LY],[CCOR Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- MANUAL Sales Cat

Manual Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Lines LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Lines TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Sales Util. LY = DIVIDE([MANUAL Sales LY],[Outbound Sales LY],0)

Manual Sales Util. TY = DIVIDE([MANUAL Sales TY],[Outbound Sales TY],0)

Manual Lines Util. LY = DIVIDE([Manual Lines LY],[Outbound Lines LY],0)

Manual Lines Util. TY = DIVIDE([Manual Lines TY],[Outbound Lines TY],0)

---------------------------------------------------------------------------------
-- MANUAL Average Cost

Manual Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
            
Manual Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Avg GP% TY = DIVIDE([MANUAL Avg GP$ TY],[MANUAL Sales TY],0)

Manual Avg GP% LY = DIVIDE([MANUAL Avg GP$ LY],[MANUAL Sales LY],0)

---------------------------------------------------------------------------------
-- MANUAL CORE Adjusted Average Cost

Manual CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
            
Manual CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual CORE GP% TY = DIVIDE([MANUAL CORE GP$ TY],[MANUAL Sales TY],0)

Manual CORE GP% LY = DIVIDE([MANUAL CORE GP$ LY],[MANUAL Sales LY],0)

---------------------------------------------------------------------------------
-- MANUAL Invoice Cost

Manual Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
            
Manual Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "MANUAL" ||
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "OTH/ERROR")

Manual Inv. GP% TY = DIVIDE([MANUAL Inv. GP$ TY],[MANUAL Sales TY],0)

Manual Inv. GP% LY = DIVIDE([MANUAL Inv. GP$ LY],[MANUAL Sales LY],0)


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- SP- Sales Cat

SP- Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Lines TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Lines LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Sales Util. LY = DIVIDE([SP- Lines LY],[Outbound Sales LY],0)

SP- Sales Util. TY = DIVIDE([SP- Lines TY],[Outbound Sales TY],0)

SP- Lines Util. LY = DIVIDE([SP- Lines LY],[Outbound Lines LY],0)

SP- Lines Util. TY = DIVIDE([SP- Lines TY],[Outbound Lines TY],0)

---------------------------------------------------------------------------------
-- SP- Average Cost

SP- Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
            
SP- Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Avg GP% TY = DIVIDE([SP- Avg GP$ TY],[SP- Sales TY],0)

SP- Avg GP% LY = DIVIDE([SP- Avg GP$ LY],[SP- Sales LY],0)

---------------------------------------------------------------------------------
-- SP- CORE Adjusted Average Cost

SP- CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
            
SP- CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- CORE GP% TY = DIVIDE([SP- CORE GP$ TY],[SP- Sales TY],0)

SP- CORE GP% LY = DIVIDE([SP- CORE GP$ LY],[SP- Sales LY],0)

---------------------------------------------------------------------------------
-- SP- Invoice Cost

SP- Inv. COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
            
SP- Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "SP-")

SP- Inv. GP% TY = DIVIDE([SP- Inv. GP$ TY],[SP- Sales TY],0)

SP- Inv. GP% LY = DIVIDE([SP- Inv. GP$ LY],[SP- Sales LY],0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- CREDITS Sales Cat

Credits Sales TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Sales LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Lines TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Lines LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_LINES]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Sales Util. LY = DIVIDE([CREDITS Sales LY],[Outbound Sales LY],0)

Credits Sales Util. TY = DIVIDE([CREDITS Sales TY],[Outbound Sales TY],0)

Credits Lines Util. LY = DIVIDE([Credits Lines LY],[Outbound Lines LY],0)

Credits Lines Util. TY = DIVIDE([Credits Lines TY],[Outbound Lines TY],0)

---------------------------------------------------------------------------------
-- CREDITS Average Cost

Credits Avg COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Avg COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
            
Credits Avg GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Avg GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[AVG_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Avg GP% TY = DIVIDE([CREDITS Avg GP$ TY],[CREDITS Sales TY],0)

Credits Avg GP% LY = DIVIDE([CREDITS Avg GP$ LY],[CREDITS Sales LY],0)

---------------------------------------------------------------------------------
-- CREDITS CORE Adjusted Average Cost

Credits CORE COGS TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits CORE COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
            
Credits CORE GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits CORE GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[CORE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits CORE GP% TY = DIVIDE([CREDITS CORE GP$ TY],[CREDITS Sales TY],0)

Credits CORE GP% LY = DIVIDE([CREDITS CORE GP$ LY],[CREDITS Sales LY],0)

---------------------------------------------------------------------------------
-- CREDITS Invoice Cost

Credits Inv. TY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Inv. COGS LY = CALCULATE(
        SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
            
Credits Inv. GP$ TY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
        -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
                tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "YEAR TO DATE",
                tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Inv. GP$ LY = CALCULATE(SUM(tbl_pbi_price_category_sums[EXT_SALES_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")
    -   CALCULATE(SUM(tbl_pbi_price_category_sums[INVOICE_COGS_AMT]),
            tbl_pbi_time_dim[FISCAL_YEAR_TO_DATE] = "LAST YEAR TO DATE",
            tbl_pbi_price_category_sums[PRICE_CATEGORY] = "CREDITS")

Credits Inv. GP% TY = DIVIDE([CREDITS Inv. GP$ TY],[CREDITS Sales TY],0)

Credits Inv. GP% LY = DIVIDE([CREDITS Inv. GP$ LY],[CREDITS Sales LY],0)
