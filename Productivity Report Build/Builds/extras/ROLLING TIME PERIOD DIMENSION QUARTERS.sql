SELECT YEARMONTH,
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