-- select previous work week
SELECT TO_CHAR (SYSDATE, 'DAY')
          TODAY,
         SYSDATE
       - (CASE WHEN TO_CHAR (SYSDATE, 'DAY') LIKE '%MONDAY%' THEN 3 ELSE 1 END)
          DATE_PARAM,
       (CASE WHEN TO_CHAR (SYSDATE, 'DAY') LIKE '%MONDAY%' THEN 3 ELSE 1 END)
          SUBTRACTOR
FROM DUAL


--strip page# and alpha characters from invoice number
REGEXP_SUBSTR ( 
            LTRIM ( sp_dtl.INVOICE_NUMBER_NK,
                      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
                  ),
                      '[^-]*'
              )

grant select on AAA6863.branch_contacts to public;

/* ############################################################# */

-- select previous month first day to last 
AND IHF.INVOICE_DATE 
  BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') 
  AND TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))

-- ###
SELECT SWD.DIVISION_NAME,
       SWD.REGION_NAME,
       SWD.ACCOUNT_NUMBER_NK,
       SWD.ACCOUNT_NAME
       
  FROM     SALES_MART.PRICE_MGMT_DATA_SUMM PM_DATA
       INNER JOIN
           EBUSINESS.SALES_DIVISIONS SWD
       ON ( PM_DATA.ACCOUNT_NUMBER_NK = SWD.ACCOUNT_NUMBER_NK )

WHERE ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
			 	 'D10', 'D11', 'D12', 'D13', 
				    'D14', 'D30', 'D31', 'D32', 
				    'D50', 'D51', 'D53'
				 )


--  join to select cent business units.

SUBSTR ( string, start_position [ , length ] ) [ optional ]


-- roll up months into quarters
SELECT YEARMONTH,

  -- DECODE THE YYYYMM INTO ROLLING QUARTERS BASED ON INTERVAL FROM SYSDATE
       DECODE (
          TPD.YEARMONTH,
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (12, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q1',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (11, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q1',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (10, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q1',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (9, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q2',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (8, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q2',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (7, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q2',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (6, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q3',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (5, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q3',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (4, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q3',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (3, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q4',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (2, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q4',
          TO_CHAR (TRUNC (SYSDATE - NUMTOYMINTERVAL (1, 'MONTH'), 'MONTH'),
                   'YYYYMM'), 'ROLL_Q4')
          ROLLING_QTR
  
  FROM SALES_MART.TIME_PERIOD_DIMENSION TPD
WHERE TPD.ROLL12MONTHS = 'LAST TWELVE MONTHS'



-- BRANCH SELECT
SELECT t.chargeId,
       t.chargeType,
       t.serviceMonth
  FROM     ( SELECT chargeId,
                    MAX ( serviceMonth ) AS serviceMonth
               FROM invoice
             GROUP BY chargeId ) x
       JOIN
           invoice t
       ON x.chargeId = t.chargeId
          AND x.serviceMonth = t.serviceMonth
          
          

--salesrep_sales_fact
SELECT DISTINCT 
  SLS.SALESREP_GK,
	SLS.SALESREP_NK,
	SLS.ACCOUNT_NUMBER_NK,
	SLS.YEARMONTH,
	SLS.MONTH_SALES,
	SLS.MONTH_GP,
	SLS.MONTH_PAID_SALES,
	SLS.MONTH_PAID_GP
  
FROM DW_FEI.SALESREP_SALES_FACT SLS;


--simple join
SELECT DISTINCT
	DG.ACCOUNT_NAME,
	DG.ACCOUNT_NUMBER_NK,
	DG.BRANCH_DISC_GROUP_NK,
	DG_DIM.DISCOUNT_GROUP_NAME,
	DG_DIM.DISCOUNT_GROUP_NK,
	DG_DIM.PRODUCT_CAT,
	DG_DIM.PRODUCT_GROUP

FROM DW_FEI.BRANCH_DISC_GROUP_DIMENSION DG, 
	DW_FEI.DISCOUNT_GROUP_DIMENSION DG_DIM 

WHERE DG.ACCOUNT_NAME = 'OHVAL'

ORDER BY DG.BRANCH_DISC_GROUP_NK;

--show fields


DISCOUNT_GROUP_DIMENSION
	DISCOUNT_GROUP_NAME
	DISCOUNT_GROUP_NK
	PRODUCT_CAT
	PRODUCT_GROUP

SELECT DISTINCT
  cd.customer_alpha,
  cd.customer_name,
  cd.customer_type,
  cd.price_column,
  cd.salesman_code,
  ccd.branch_number_nk,
  ccd.disc_group,
  ccd.effective_prod,
  ccd.override_type,
  ccd.basis,
  ccd.operator_used,
  ccd.multiplier
FROM customer_dimension AS cd OUTER JOIN customer_override_dimension AS ccd
WHERE cd.branch_number_nk = ccd.branch_number_nk;

-- DESC(ribe) function
DESC DW_FEI.MARKETING_CHANNEL_TYPES;




