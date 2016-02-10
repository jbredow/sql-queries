INNER JOIN
           EBUSINESS.SALES_DIVISIONS SWD
       ON ( cust.account_number_nk = SWD.ACCOUNT_NUMBER_NK )
	   
WHERE ( SUBSTR ( SWD.REGION_NAME, 1 ,3 ) IN ( 
			 	 'D10', 'D11', 'D12', 'D13', 
				 'D14', 'D30', 'D31', 'D32', 
				 'D50', 'D51', 'D53'
				 ))

-- getting the top results of query
SELECT *
FROM (select * from suppliers ORDER BY supplier_name DESC) suppliers2
WHERE ROWNUM <= 50
ORDER BY ROWNUM;
-- or
SELECT * FROM
   (SELECT * FROM employees ORDER BY employee_id)
   WHERE ROWNUM < 11;


SQL INNER JOIN
--  SQL INNER JOINS return all rows from multiple tables where the join condition is met.

Syntax - all where join condition is met

SELECT columns
	FROM table1 
	INNER JOIN table2
	ON table1.column = table2.column;
	
SQL LEFT OUTER JOIN
--  LEFT OUTER JOIN returns all rows from the LEFT-hand table specified in the ON condition 
--	and only those rows from the other table where the joined fields are equal (join condition is met).

Syntax - all from the ON table

The syntax for the SQL LEFT OUTER JOIN is:

SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;

SQL RIGHT OUTER JOIN
--  RIGHT OUTER JOIN returns all rows from the RIGHT-hand table specified in the ON condition 
--  and only those rows from the other table where the joined fields are equal (join condition is met).

The syntax for the SQL RIGHT OUTER JOIN is:

SELECT columns
FROM table1
RIGHT JOIN table2
ON table1.column = table2.column;

SQL FULL OUTER JOIN
--  FULL OUTER JOIN returns all rows from the LEFT-hand table and RIGHT-hand table with nulls in place 
--  where the join condition is not met.

The syntax for the SQL FULL OUTER JOIN is:

SELECT columns
FROM table1
FULL JOIN table2
ON table1.column = table2.column;

FULL JOIN