C
/*Shows list of tables in database*/
select * from dba_tables;
-------------------------------------------------
--SELECT
SELECT
FROM Namibia
WHERE col1 = 'value1'
AND col2 = 'value2'
-------------------------------------------------
--SELECT INTO
SELECT name,address,phone_number
INTO v_employee_name,v_employee_address,v_employee_phone_number
FROM employee
WHERE employee_id = 6;
-------------------------------------------------
INSERT
--insert using the VALUES keyword
INSERT INTO table_name VALUES (' Value1', 'Value2', ... );
INSERT INTO table_name( Column1, Column2, ... ) VALUES ( 'Value1', 'Value2', ... );

--insert using a SELECT statement
INSERT INTO table_name( SELECT Value1, Value2, ... from table_name );
INSERT INTO table_name( Column1, Column2, ... ) ( SELECT Value1, Value2, ... from table_name );
-------------------------------------------------
DELETE
--The DELETE statement is used to delete rows in a table. deletes the rows which match the criteria
DELETE FROM table_name WHERE some_column=some_value
DELETE FROM customer WHERE sold = 0;
-------------------------------------------------
UPDATE
--updates the entire column of that table
UPDATE customer SET state='CA';

--updates the specific record of the table eg:
UPDATE customer SET name='Joe' WHERE customer_id=10;

--updates the column invoice as paid when paid column has more than zero.
UPDATE movies SET invoice='paid' WHERE paid > 0;
-------------------------------------------------

--Setting Constraints on a Table

--The syntax for creating a check constraint using a CREATE TABLE statement is:
CREATE TABLE table_name
(
    column1 datatype null/not null,
    column2 datatype null/not null,
    ...
    CONSTRAINT constraint_name CHECK (column_name condition) [DISABLE]
);
--For example:
CREATE TABLE suppliers
(
    supplier_id  numeric(4),  
    supplier_name  varchar2(50),  
    CONSTRAINT check_supplier_id
    CHECK (supplier_id BETWEEN 100 and 9999)
);
-------------------------------------------------
--Unique Index on a Table

--The syntax for creating a unique constraint using a CREATE TABLE statement is:

CREATE TABLE table_name
(
    column1 datatype null/not null,
    column2 datatype null/not null,
    ...
    CONSTRAINT constraint_name UNIQUE (column1, column2, column_n)
);
--For example:
CREATE TABLE customer
(
    id   integer not null,
    name varchar2(20),
    CONSTRAINT customer_id_constraint UNIQUE (id)
);
-------------------------------------------------
--SEQUENCES

--CREATE SEQUENCE

--The syntax for a sequence is:

CREATE SEQUENCE sequence_name
    MINVALUE value
    MAXVALUE value
    START WITH value
    INCREMENT BY value
    CACHE value;
--For example:
CREATE SEQUENCE supplier_seq
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

--ALTER SEQUENCE

--Increment a sequence by a certain amount:
ALTER SEQUENCE <sequence_name> INCREMENT BY <integer>;
ALTER SEQUENCE seq_inc_by_ten  INCREMENT BY 10;

--Change the maximum value of a sequence:
ALTER SEQUENCE <sequence_name> MAXVALUE <integer>;
ALTER SEQUENCE seq_maxval  MAXVALUE  10;

--Set the sequence to cycle or not cycle:
ALTER SEQUENCE <sequence_name> <CYCLE | NOCYCLE>;
ALTER SEQUENCE seq_cycle NOCYCLE;

--Configure the sequence to cache a value:
ALTER SEQUENCE <sequence_name> CACHE <integer> | NOCACHE;
ALTER SEQUENCE seq_cache NOCACHE;

--Set whether or not the values are to be returned in order
ALTER SEQUENCE <sequence_name> <ORDER | NOORDER>;
ALTER SEQUENCE seq_order NOORDER;
-------------------------------------------------
--Generate Query From A String

/*It is sometimes necessary to create a query from a string. That is, if the programmer 
wants to create a query at run time (generate an Oracle query on the fly), based on a 
particular set of circumstances, etc.  Care should be taken not to insert user-supplied 
data directly into a dynamic query string, without first vetting the data very strictly 
for SQL escape characters; otherwise you run a significant risk of enabling data-injection 
hacks on your code.  Here is a very simple example of how a dynamic query is done. 
There are, of course, many different ways to do this; this is just an example of the 
functionality.*/

PROCEDURE oracle_runtime_query_pcd IS
    TYPE ref_cursor IS REF CURSOR;
    l_cursor        ref_cursor;

    v_query         varchar2(5000);
    v_name          varchar2(64);
BEGIN
    v_query := 'SELECT name FROM employee WHERE employee_id=5';
    OPEN l_cursor FOR v_query;
    LOOP
       FETCH l_cursor INTO v_name;         
       EXIT WHEN l_cursor%NOTFOUND; 
    END LOOP;
    CLOSE l_cursor;
END;
-------------------------------------------------
--TRIM
trim ( [ leading | trailing | both ] [ trim-char ] from string-to-be-trimmed );
trim ('   removing spaces at both sides     ');
this returns "removing spaces at both sides"

ltrim ( string-to-be-trimmed [, trimming-char-set ] );
ltrim ('   removing spaces at the left side     ');
this returns "removing spaces at the left side     "

rtrim ( string-to-be-trimmed [, trimming-char-set ] );
rtrim ('   removing spaces at the right side     ');
this returns "   removing spaces at the right side"

-------------------------------------------------
-------------------------------------------------
--DDL SQL

--Create Table / Syntax

CREATE TABLE [table name]
      ( [column name] [datatype], ... );

--For example:
CREATE TABLE employee
      (id int, name varchar(20));
-------------------------------------------------

--Add Column

--The syntax to add a column is:

ALTER TABLE [table name]
      ADD ( [column name] [datatype], ... );

--For example:
ALTER TABLE employee
      ADD (id int)
-------------------------------------------------

--Modify Column

--The syntax to modify a column is:

ALTER TABLE [table name]
      MODIFY ( [column name] [new datatype] );

ALTER Table Syntax and Examples:

--For example:
ALTER TABLE employee
      MODIFY( sickHours s float );
-------------------------------------------------

--Drop Column

--The syntax to drop a column is:

ALTER TABLE [table name]
      DROP COLUMN [column name];

--For example:
ALTER TABLE employee
      DROP COLUMN vacationPay;
-------------------------------------------------


/*Constraints
Constraint Types and Codes
Type Code                   Type Description                    Acts On Level
---------                --------------------------             -------------
   C                     Check on a table                         Column
   O                     Read Only on a view                      Object
   P                     Primary Key                              Object
   R                     Referential AKA Foreign Key              Column
   U                     Unique Key                               Column
   V                     Check Option on a view                   Object

   */

   --Displaying Constraints
SELECT
    table_name,
    constraint_name,
    constraint_type
FROM user_constraints;

select * table_name;

-------------------------------------------------

--Selecting Referential Constraints

/*The following statement will show all referential constraints (foreign keys) 
with both source and destination table/column couples:*/

SELECT
    c_list.CONSTRAINT_NAME as NAME,
    c_src.TABLE_NAME as SRC_TABLE,
    c_src.COLUMN_NAME as SRC_COLUMN,
    c_dest.TABLE_NAME as DEST_TABLE,
    c_dest.COLUMN_NAME as DEST_COLUMN
FROM ALL_CONSTRAINTS c_list, 
     ALL_CONS_COLUMNS c_src, 
     ALL_CONS_COLUMNS c_dest
WHERE c_list.CONSTRAINT_NAME = c_src.CONSTRAINT_NAME
  AND c_list.R_CONSTRAINT_NAME = c_dest.CONSTRAINT_NAME
  AND c_list.CONSTRAINT_TYPE = 'R'
GROUP BY c_list.CONSTRAINT_NAME,
        c_src.TABLE_NAME,
        c_src.COLUMN_NAME,
        c_dest.TABLE_NAME,
        c_dest.COLUMN_NAME;

--Creating Unique Constraints

--The syntax for a unique constraint is:

ALTER TABLE [table name]
      ADD CONSTRAINT [constraint name] UNIQUE( [column name] ) USING INDEX [index name];

--For example:
ALTER TABLE employee
      ADD CONSTRAINT uniqueEmployeeId UNIQUE(employeeId) USING INDEX ourcompanyIndx_tbs;

--Deleting Constraints

--The syntax for dropping (removing) a constraint is:

ALTER TABLE [table name]
      DROP CONSTRAINT [constraint name];

--For example:
ALTER TABLE employee
      DROP CONSTRAINT uniqueEmployeeId;

-------------------------------------------------
--INDEXES

/*An index is a method by which records are retreived with greater efficiency. 
An index creates an entry for each value that appears in the indexed columns. Oracle 
will, by default, create B-tree indexes.*/

--Create an Index

--The syntax for creating an index is:

CREATE [UNIQUE] INDEX index_name
    ON table_name (column1, column2, . column_n)
    [ COMPUTE STATISTICS ];

--UNIQUE indicates that the combination of values in the indexed columns must be unique.

/*COMPUTE STATISTICS tells Oracle to collect statistics during the creation of the index. 
The statistics are then used by the optimizer to choose an optimal execution plan when the 
statements are executed.*/

--For example:
CREATE INDEX customer_idx
    ON customer (customer_name);

/*In this example, an index has been created on the customer table called customer_idx. 
It consists of only of the customer_name field.*/

--The following creates an index with more than one field:

CREATE INDEX customer_idx
    ON supplier (customer_name, country);

--The following collects statistics upon creation of the index:

CREATE INDEX customer_idx
    ON supplier (customer_name, country)
    COMPUTE STATISTICS;
-------------------------------------------------
--Create a Function-Based Index

In Oracle, you are not restricted to creating indexes on only columns. You can create function-based indexes.

--The syntax for creating a function-based index is:

CREATE [UNIQUE] INDEX index_name
    ON table_name (function1, function2, . function_n)
    [ COMPUTE STATISTICS ];

--For example:
CREATE INDEX customer_idx
    ON customer (UPPER(customer_name));

--An index, based on the uppercase evaluation of the customer_name field, has been created.

/*To assure that the Oracle optimizer uses this index when executing your SQL statements, 
be sure that UPPER(customer_name) does not evaluate to a NULL value. To ensure this, add 
UPPER(customer_name) IS NOT NULL to your WHERE clause as follows:*/

SELECT customer_id, customer_name, UPPER(customer_name)
FROM customer
WHERE UPPER(customer_name) IS NOT NULL
ORDER BY UPPER(customer_name);
-------------------------------------------------
--Rename an Index
--The syntax for renaming an index is:

ALTER INDEX index_name
    RENAME TO new_index_name;

--For example:
ALTER INDEX customer_id
    RENAME TO new_customer_id;

/*In this example, customer_id is renamed to new_customer_id.
Collect Statistics on an Index

If you need to collect statistics on the index after it is first created or you want to 
update the statistics, you can always use the ALTER INDEX command to collect statistics. 
You collect statistics so that oracle can use the indexes in an effective manner. This 
recalcultes the table size, number of rows, blocks, segments and update the dictionary 
tables so that oracle can use the data effectively while choosing the execution plan.*/

--The syntax for collecting statistics on an index is:

ALTER INDEX index_name
    REBUILD COMPUTE STATISTICS;

--For example:
ALTER INDEX customer_idx
    REBUILD COMPUTE STATISTICS;

--In this example, statistics are collected for the index called customer_idx.
--Drop an Index

--The syntax for dropping an index is:
   DROP INDEX index_name;

--For example:
   DROP INDEX customer_idx;
--In this example, the customer_idx is dropped.

-------------------------------------------------
-------------------------------------------------
--PL/SQL

/*Arithmetic Operators

    Addition: +
    Subtraction: -
    Multiplication: *
    Division: /
    Power (PL/SQL only): 

Examples*/

--gives all employees a 5% raise

UPDATE employee SET salary = salary * 1.05
                  WHERE customer_id = 5;

--determines the after tax wage for all employee's

SELECT wage - tax FROM employee;

/*Comparison Operators

    Greater Than: >
    Greater Than or Equal To: >=
    Less Than: <
    Less Than or Equal to: <=
    Equivalence: =
    Inequality: != ^= <> ¬= (depends on platform)

Examples*/

SELECT name, salary, email FROM employees WHERE salary > 40000;

SELECT name FROM customers WHERE customer_id < 6;

/*String Operators

    Concatenate: ||

Date Operators

    Addition: +
    Subtraction: -

Types*/

--Basic PL/SQL Types

/*Scalar type (defined in package STANDARD):*/ 
NUMBER, CHAR, VARCHAR2, BOOLEAN, BINARY_INTEGER, 
LONG\LONG RAW, DATE, TIMESTAMP
/*(and its family including intervals)*/

/*Composite types (user-defined types):*/ 
TABLE, RECORD, NESTED TABLE and VARRAY

/*LOB datatypes : used to store an unstructured large amount of data
 %TYPE - anchored type variable declaration

The syntax for anchored type declarations is*/

<var_name> <obj>%type [not null][:= <init-val>];

--For example

name Books.title%type;   /*  name is defined as the same type as column 'title' of table  Books */

commission number(5,2) := 12.5;

x commission%type;   /*  x is defined as the same type as variable 'commission' */

/*Note:

    Anchored variables allow for the automatic synchronization of the type of anchored variable 
    with the type of <obj> when there is a change to the <obj> type.
    Anchored types are evaluated at compile time, so recompile the program to reflect the change 
    of <obj> type in the anchored variable.

Collections

A collection is an ordered group of elements, all of the same type. It is a general concept that 
encompasses lists, arrays, and other familiar datatypes. Each element has a unique subscript that 
determines its position in the collection.

Define a PL/SQL record type representing a book:*/
TYPE book_rec IS RECORD 
   (title                   book.title%TYPE,
    author                  book.author_last_name%TYPE,
    year_published          book.published_date%TYPE);

--define a PL/SQL table containing entries of type book_rec:
Type book_rec_tab IS TABLE OF book_rec%TYPE
     INDEX BY BINARY_INTEGER;

my_book_rec  book_rec%TYPE;
my_book_rec_tab book_rec_tab%TYPE;
...
my_book_rec := my_book_rec_tab(5);
find_authors_books(my_book_rec.author);
...


