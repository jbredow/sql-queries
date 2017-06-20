Here is the logic I used to break out the “Customer Category” in case you would like to utilize for other stuff.

  CASE
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'B_'      THEN 'BUILDER'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'H_'      THEN 'HVAC'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'P_'      THEN 'PLUMBING'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'M_'      THEN 'MECHANICAL'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'U_'      THEN 'UTILITIES'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'C_'      THEN 'COMMERCIAL'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'R_'      THEN 'RETAIL'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'I_'      THEN 'INDUSTRIAL'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'S_'      THEN 'DESIGN'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'G_'      THEN 'GOVT'
    WHEN CUST.CUSTOMER_TYPE                  = 'T_HOTEL' THEN 'HOSPITALITY'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'T_'      THEN 'FACILITIES'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'E_'      THEN 'END_USER'
    WHEN SUBSTR ( CUST.CUSTOMER_TYPE, 0, 2 ) = 'O_'      THEN 'OTHER'
  END

SELECT last_name,
       C.name,
       MAX (SH.salary) best_salary_ever
  FROM employee E,
       company C,
       salary_history SH
 WHERE E.company_id = C.company_id
   AND E.employee_id = SH.employee_id
   AND E.hire_date > ADD_MONTHS (SYSDATE, -60);

UPDATE employee
   SET hire_date = SYSDATE,
       termination_date = NULL
 WHERE department_id = 105;

 SELECT ... select list ...
  FROM employee EMP, company CO, history HIST, bonus, 
       profile PROF, sales
 WHERE EMP.company_id = CO.company_id
   AND EMP.employee_id = HIST.employee_id
   AND CO.company_id = SALES.company_id
   AND EMP.employee_id = BONUS.employee_id
   AND CO.company_id = PROF.company_id;


