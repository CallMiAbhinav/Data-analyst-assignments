-- ASSIGNMENT--
USE CLASSIMODELS;

-- DAY 3--
/*  1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.
			State should not contain null values
			credit limit should be between 50000 and 100000 */
SELECT*FROM customers;
SELECT 
    CUSTOMERNUMBER, CUSTOMERNAME, STATE, CREDITLIMIT
FROM
    CUSTOMERS
WHERE
    STATE IS NOT NULL
        AND CREDITLIMIT BETWEEN 50000 AND 100000
ORDER BY CREDITLIMIT DESC;


 /* 2.Show the unique productline values containing the word cars at the end from products table.*/
SELECT*FROM productlines;
SELECT 
    PRODUCTLINE
FROM
    productlines
WHERE
    productLine LIKE '%CARS';
    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
-- DAY 4--
/* 1)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“ */
SELECT * FROM ORDERS;
SELECT 
    ORDERNUMBER, STATUS, IFNULL(COMMENTS, '-')
FROM
    ORDERS
WHERE
    STATUS = 'SHIPPED';
    
/* 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP” */

SELECT *FROM employees;
SELECT distinct JOBTITLE FROM EMPLOYEES;
SELECT EMPLOYEENUMBER,FIRSTNAME,JOBTITLE, 
	CASE 
		WHEN JOBTITLE="PRESIDENT" THEN "P"
		WHEN JOBTITLE="SALES MANAGER (APAC)" THEN "SM"
		WHEN JOBTITLE="Sale Manager (EMEA)" THEN "SM"
		WHEN JOBTITLE="SALES MANAGER (NA)" THEN "SM"
		WHEN JOBTITLE="SALES REP" THEN "SR"
		WHEN  JOBTITLE="VP SALES" THEN "VP"
        WHEN  JOBTITLE="VP MARKETING" THEN "VP"
    END AS JOBTITLE_ABBR 
FROM EMPLOYEES ORDER  BY JOBTITLE ASC ;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY 5--
/* 1.	For every year, find the minimum amount value from payments table. */
select*FROM payments;
SELECT DISTINCT
    YEAR(PAYMENTDATE) AS YEAR, MIN(AMOUNT) AS MIN_AMOUNT
FROM
    PAYMENTS
GROUP BY YEAR(PAYMENTDATE)
ORDER BY PAYMENTDATE ASC;


/*2)	For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.*/
select*from orders;
SELECT 
    YEAR(orderdate) as "YEAR",
    CONCAT('Q',QUARTER(orderdate)) AS "QUARTER",
    COUNT(DISTINCT customerNumber) AS "UNIQUE CUSTOMERS",
    COUNT(orderNumber) AS "TOTAL ORDERS"
FROM
    orders
GROUP BY YEAR(orderdate) , CONCAT('Q',QUARTER(orderdate));


/*3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode.
 [ Refer. Payments Table]*/

USE CLASSICMODELS;
SELECT*FROM PAYMENTS;
SELECT 
   LEFT (MONTHNAME(PAYMENTDATE),3),
    CONCAT(ROUND(((SUM(AMOUNT)) / 1000), 0), 'k') AS total_amount
FROM
    PAYMENTS
GROUP BY left(MONTHNAME(PAYMENTDATE),3)
ORDER BY total_amount DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY6--
/*1)	Create a journey table with following fields and constraints.*/
CREATE DATABASE ASSIGNMENT;
USE ASSIGNMENT;
CREATE TABLE JOURNEY (
    BUS_ID INT PRIMARY KEY,
    BUS_NAME VARCHAR(25) NOT NULL,
    SOURCE_STATION VARCHAR(25) NOT NULL,
    DESTINATION VARCHAR(25) NOT NULL,
    EMAIL VARCHAR(25) UNIQUE
);

CREATE TABLE VENDOR (
    VENDOR_ID INT PRIMARY KEY,
    NAME_ VARCHAR(25) NOT NULL,
    EMAIL VARCHAR(25) UNIQUE,
    COUNTRY VARCHAR(25) DEFAULT 'N/A'
);
USE ASSIGNMENT;
CREATE TABLE MOVIES(
MOVIE_ID INT PRIMARY KEY,
NAME_ VARCHAR(25) NOT NULL,
RELEASE_YEAR  Date,
CAST VARCHAR(25) NOT NULL,
GENDER VARCHAR(25) CHECK(GENDER IN("MALE","FEMALE"))
 );
 
 USE ASSIGNMENT;
 -- SUPPLIER TABLE--
 CREATE TABLE SUPPLIERS (
    SUPPLIER_ID INT PRIMARY KEY,
    SUPPLIER_NAME VARCHAR(25) NOT NULL,
    LOCATION VARCHAR(25) NOT NULL
);
 
 -- PRODUCT TABLE --
CREATE TABLE PRODUCT (
    PRODUCT_ID INT PRIMARY KEY,
    PRODUCT_NAME VARCHAR(25) UNIQUE NOT NULL,
    SUPPLIER_ID INT,
    FOREIGN KEY (SUPPLIER_ID)
        REFERENCES SUPPLIERS (SUPPLIER_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- STOCK TABLE --
CREATE TABLE STOCK(
ID INT PRIMARY KEY,
BALANCE_STOCK INT NOT NULL,
PRODUCT_ID INT,
   FOREIGN KEY (PRODUCT_ID)
        REFERENCES PRODUCT (PRODUCT_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DAY7--
/*1)	Show employee number, Sales Person (combination of first and last names of employees),
 unique customers for each employee number and sort the data by highest to lowest unique
 customers.
 Tables: Employees, Customers*/
 USE CLASSICMODELS;
 SELECT  * FROM EMPLOYEES;
 SELECT * FROM CUSTOMERS;
 SELECT 
E1.EMPLOYEENUMBER AS EMPLOYEENUMBER,
CONCAT(E1.FIRSTNAME,E1.LASTNAME) AS "SALES PERSON", 
COUNT( distinct C1.CUSTOMERNUMBER) AS "UNIQUE CUSTOMER"
FROM
    EMPLOYEES E1
        LEFT JOIN
    CUSTOMERS C1 ON E1.EMPLOYEENUMBER = C1.SALESREPEMPLOYEENUMBER
   GROUP BY E1.EMPLOYEENUMBER 
    ORDER BY COUNT(C1.CUSTOMERNUMBER) DESC;
 
 
 /*2)	Show total quantities, total quantities in stock, left over quantities for each 
 product and each customer. Sort the data by customer number.
Tables: Customers, Orders, Orderdetails, Products*/
SELECT*FROM CUSTOMERS;
SELECT*FROM ORDERS;
SELECT*FROM ORDERDETAILS;
SELECT*FROM PRODUCTS; 
SELECT C1.CUSTOMERNUMBER,C1.CUSTOMERNAME,P1.PRODUCTCODE,P1.PRODUCTNAME,OD1.QUANTITYORDERED AS "ORDERED QUANTITY",P1.QUANTITYINSTOCK AS "TOTAL INVENTORY",(P1.QUANTITYINSTOCK-OD1.QUANTITYORDERED) AS "LEFT QUANTITY"
FROM CUSTOMERS C1
INNER JOIN ORDERS O1 ON C1.CUSTOMERNUMBER = O1.CUSTOMERNUMBER
INNER JOIN ORDERDETAILS OD1 ON O1.ORDERNUMBER = OD1.ORDERNUMBER
INNER JOIN PRODUCTS P1 ON OD1.PRODUCTCODE=P1.PRODUCTCODE
ORDER BY C1.CUSTOMERNUMBER,P1.PRODUCTCODE ASC;



/*3)	Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.*/
USE ASSIGNMENT;

CREATE TABLE LAPTOP(
LAPTOP_NAME VARCHAR(25) NOT NULL);

CREATE TABLE COLOR(
COLOR_NAME VARCHAR(25) NOT NULL);


INSERT INTO LAPTOP VALUES ("DELL");
INSERT INTO LAPTOP VALUES ("HP");
INSERT INTO COLOR VALUES ("WHITE");
INSERT INTO COLOR VALUES ("SILVER");
INSERT INTO COLOR VALUES ("BLACK");

SELECT *
FROM LAPTOP L1
CROSS JOIN COLOR C1
ORDER BY L1.LAPTOP_NAME ASC;

/*4)	Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers.*/
CREATE TABLE PROJECT(
EMPLOYEEID INT PRIMARY KEY,
FULLNAME VARCHAR(25) NOT NULL,
GENDER VARCHAR(25) NOT NULL,
MANAGERID INT );

INSERT INTO  PROJECT VALUES (1,"PRANAYA","MALE",3);
INSERT INTO  PROJECT VALUES (2,"PRIYANKA","FEMALE",1);
INSERT INTO  PROJECT VALUES (3,"PREETY","FEMALE",NULL);
INSERT INTO  PROJECT VALUES (4,"ANURAG","MALE",1);
INSERT INTO  PROJECT VALUES (5,"SAMBIT","MALE",1);
INSERT INTO  PROJECT VALUES (6,"RAJESH","MALE",3);
INSERT INTO  PROJECT VALUES (7,"HINA","FEMALE",3);

SELECT*FROM PROJECT;

SELECT 
P1.FULLNAME AS "MANAGER NAME",
P2.FULLNAME AS "EMPLOYEE NAME" 
FROM PROJECT P1 
JOIN PROJECT P2 ON P1.EMPLOYEEID=P2.MANAGERID 
ORDER BY P1.FULLNAME ASC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY 8 --
/*Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country
i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.*/

CREATE TABLE FACILITY(
FACILITY_ID INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(100),
CITY VARCHAR(100) NOT NULL,
STATE VARCHAR(100),
COUNTRY VARCHAR(100) 
);

DESC FACILITY;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DAY 9 --
/*Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.*/

CREATE TABLE UNIVERSITY(
ID INT PRIMARY KEY,
NAME_ VARCHAR(100) NOT NULL) ;

INSERT INTO University
VALUES (1, "       Pune          University     "),
		(2, "  Mumbai          University     "),
		(3, "     Delhi   University     "),
		(4, "Madras University"),
		(5, "Nagpur University");
        
SELECT * FROM university;

SELECT ID,TRIM(REPLACE(REPLACE(REPLACE(NAME_," ","<>"),"><",""),"<>"," ")) AS "NAME" FROM  UNIVERSITY;



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY 10 
/*Create the view products status.Show year wise total products sold. Also find the percentage of total value for each year. 
The output should look as shown in below figure.*/
USE CLASSICMODELS;
CREATE VIEW PRODUCT_STATUS
AS
SELECT COUNT(ORDERNUMBER) FROM ORDERDETAILS;
SELECT * FROM ORDERDETAILS; -- count for order, 
SELECT * FROM ORDERS; -- date
CREATE VIEW PRODUCT_STATUS
AS
SELECT YEAR(O.ORDERDATE) AS YEAR,
CONCAT(COUNT(OD.ORDERNUMBER)," ",CONCAT("(",ROUND((COUNT(OD.ORDERNUMBER)/(SELECT COUNT(ORDERNUMBER) FROM ORDERDETAILS))*100),"%",")")) AS VALUE
FROM ORDERDETAILS OD
INNER JOIN ORDERS O ON OD.ORDERNUMBER=O.ORDERNUMBER 
GROUP BY YEAR(O.ORDERDATE)
ORDER BY CONCAT(ROUND((COUNT(OD.ORDERNUMBER)/(SELECT COUNT(ORDERNUMBER) FROM ORDERDETAILS))*100),"%",")") DESC;

SELECT * FROM PRODUCT_STATUS;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Day 11
/* 1)	Create a stored procedure GetCustomerLevel which takes input as 
customer number and gives the output as either Platinum, Gold or Silver 
as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000
*/
USE ASSIGNMENT;
USE CLASSICMODELS;
SELECT CUSTOMERNUMBER,CREDITLIMIT FROM CUSTOMERS;

DELIMITER // 
CREATE PROCEDURE GETCUSTOMERLEVEL (IN Cust_num INT,OUT CUST_LEVEL VARCHAR(25))
BEGIN
	SELECT 
			CASE
			WHEN CREDITLIMIT > 100000 THEN "PLATINUM"
            WHEN CREDITLIMIT BETWEEN 25000 AND 100000 THEN "GOLD"
            ELSE "SILVER"
            END INTO CUST_LEVEL
	FROM CUSTOMERS
    WHERE  CUSTOMERNUMBER=CUST_NUM;
 END 
 // DELIMITER ;
 
 CALL GETCUSTOMERLEVEL(112, @CL);
 select @CL;
 
/* 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise,
 country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments */

USE CLASSICMODELS;
SELECT * FROM CUSTOMERS;
SELECT * FROM PAYMENTS;

DELIMITER //
CREATE PROCEDURE GET_COUNTRY_PAYMENT (IN Y INT,IN C VARCHAR(25),OUT A VARCHAR(25))
BEGIN
DECLARE TOTAL_AMOUNT DECIMAL(10,2);
SELECT SUM(AMOUNT) INTO TOTAL_AMOUNT
FROM PAYMENTS
WHERE YEAR(PAYMENTDATE) = Y AND CUSTOMERNUMBER IN (SELECT
													CUSTOMERNUMBER FROM CUSTOMERS WHERE COUNTRY = C);
SET A =CONCAT(FORMAT(TOTAL_AMOUNT/1000,0),"K");
END
 // DELIMITER ;
 
 CALL GET_COUNTRY_PAYMENT(2004,"FRANCE",@A);
SELECT @A;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY12
/* 
1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
Table: Orders
*/
USE CLASSICMODELS;
SELECT * FROM ORDERS;

SELECT
    YEAR(ORDERDATE) AS YEAR_,
    MONTHNAME(ORDERDATE) AS MONTH_,
    COUNT(ORDERNUMBER) AS "ORDERCOUNT" ,
	CONCAT(ROUND(
    ( COUNT(ORDERNUMBER) -
    (LAG (COUNT(ORDERNUMBER)) OVER (PARTITION BY YEAR(ORDERDATE))))/(LAG (COUNT(ORDERNUMBER)) OVER (PARTITION BY YEAR(ORDERDATE)))*100),"%") AS "YOY"
    FROM ORDERS
    GROUP BY YEAR_,MONTH_;



/*
2)	Create the table emp_udf with below fields.
●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.
*/
USE ASSIGNMENT;
CREATE TABLE EMP_UDF (
EMP_ID INT PRIMARY KEY AUTO_INCREMENT,
NAME_ VARCHAR(30),
DOB DATE
);

INSERT INTO EMP_UDF(NAME_,DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
SELECT * FROM EMP_UDF;

SELECT EMP_ID,
		NAME_,
        DOB,
        CONCAT(TIMESTAMPDIFF(YEAR,DOB,NOW())," "  , "YEARS" ," ",  TIMESTAMPDIFF(MONTH,DOB,NOW())%12," ",  "MONTHS" )  AS AGE 
FROM EMP_UDF;

SELECT  TIMESTAMPDIFF(MONTH,DOB,NOW()) FROM EMP_UDF;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY13
/* 1)	Display the customer numbers and customer names from customers
 table who have not placed any orders using subquery
Table: Customers, Orders */

USE CLASSICMODELS;

SELECT CUSTOMERNUMBER,CUSTOMERNAME
FROM CUSTOMERS
WHERE CUSTOMERNUMBER NOT IN (SELECT DISTINCT CUSTOMERNUMBER FROM ORDERS);


/* 
2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
Table: Customers, Orders
*/
SELECT C.CUSTOMERNUMBER,C.CUSTOMERNAME,COUNT(O.ORDERNUMBER) AS "TOTAL ORDERS"
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON O.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY CUSTOMERNUMBER
UNION
SELECT C.CUSTOMERNUMBER,C.CUSTOMERNAME,COUNT(O.ORDERNUMBER) AS "TOTAL ORDERS"
FROM CUSTOMERS c 
RIGHT JOIN ORDERS O ON O.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY CUSTOMERNUMBER;
 
 
/* 
3)	Show the second highest quantity ordered value for each order number.
Table: Orderdetails
*/ 
SELECT ORDERNUMBER,QUANTITYORDERED
FROM (SELECT ORDERNUMBER,QUANTITYORDERED,
	DENSE_RANK () OVER (PARTITION BY ORDERNUMBER ORDER BY QUANTITYORDERED DESC) AS _DRANK
FROM ORDERDETAILS) OD
WHERE _DRANK = 2;

/* 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
Table: Orderdetails
*/
SELECT * FROM ORDERDETAILS;
SELECT MAX(OD.COUNT_) AS "MAX(TOTAL)",MIN(OD.COUNT_) "MIN(TOTAL) "
FROM( SELECT ORDERNUMBER,COUNT(PRODUCTCODE) AS COUNT_ FROM ORDERDETAILS GROUP BY ORDERNUMBER ) OD;

/* 5)	Find out how many product lines are there for which the buy price value is greater
 than the average of buy price value. Show the output as product line and its count.
*/
SELECT * FROM PRODUCTS;
SELECT COUNT(PRODUCTLINE),AVG(BUYPRICE) FROM PRODUCTS;

USE CLASSICMODELS;
SELECT PRODUCTLINE,COUNT(BUYPRICE)
FROM PRODUCTS P 
WHERE BUYPRICE>(SELECT AVG(BUYPRICE) FROM PRODUCTS)
GROUP BY PRODUCTLINE
ORDER BY COUNT(BUYPRICE) DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY 14 

/* 
Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
Show the message as “Error occurred” in case of anything wrong.
*/
USE ASSIGNMENT;

CREATE TABLE EMP_EH (
    EMPID INT PRIMARY KEY,
    EMPNAME VARCHAR(30),
    EMAILADDRESS VARCHAR(30));
SELECT * FROM EMP_EH;

DELIMITER //
CREATE PROCEDURE `INSERT_EMP_EH`(
	IN EMP_ID INT,
    IN EMP_NAME VARCHAR(30),
    IN EMAIL_ADDRESS VARCHAR(30))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    SELECT "ERROR OCCURED" AS MESSAGE;
    INSERT INTO EMP_EH (EMPID,EMPNAME, EMAILADDRESS) VALUES (EMP_ID,EMP_NAME, EMAIL_ADDRESS);
    
    SELECT "RECORD INSERTED SUCCESSFULLY" AS MESSAGE;
END
// DELIMITER ;

CALL `INSERT_EMP_EH`(1,"UMED","UMEDCHOUDHARY@GMAIL.COM");
SELECT * FROM EMP_EH;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- DAY 15
/*
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours,
if it is negative, then it should be inserted as positive.

*/

USE ASSIGNMENT;
CREATE TABLE EMP_BIT(
	`NAME` VARCHAR(30),
    OCCUPATION VARCHAR(30),
    WORKING_DATE DATE,
    WORKING_HOURS INT
);

SELECT * FROM EMP_BIT;

INSERT INTO EMP_BIT (NAME, OCCUPATION ,WORKING_DATE, WORKING_HOURS)
VALUES 
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER //
CREATE TRIGGER CHECKWORKINGHOURS
BEFORE INSERT ON EMP_BIT
FOR EACH ROW
BEGIN 
	IF NEW.WORKING_HOURS < 0 THEN
		SET NEW.WORKING_HOURS= ABS(NEW.WORKING_HOURS);
	END IF;
END;
// DELIMITER ;

INSERT INTO EMP_BIT VALUES ("UMED","ENGINEER","2020-10-01",-15);
