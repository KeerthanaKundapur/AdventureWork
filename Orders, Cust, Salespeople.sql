CREATE DATABASE P2;

USE P2;

CREATE TABLE 
Salespeople
	(snum INT PRIMARY KEY, 
	sname VARCHAR(20), 
    city VARCHAR(20), 
    comm DECIMAL(3,2));

CREATE TABLE
Cust_Table
	(cnum INT PRIMARY KEY, 
    cname VARCHAR(20), 
    city VARCHAR(20), 
    rating INT, 
    snum INT,
    FOREIGN KEY(snum)
	REFERENCES Salespeople(snum));
    
CREATE TABLE
Orders
	(onum INT PRIMARY KEY,
    amt DECIMAL(6,2),
    odate DATE,
    cnum INT,
    snum INT,
    FOREIGN KEY(cnum)
    REFERENCES Cust_Table(cnum),
    FOREIGN KEY(snum)
    REFERENCES Salespeople(snum));
    
    
    
INSERT INTO Salespeople
VALUES 
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New York', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);

SELECT * FROM Salespeople;

INSERT INTO Cust_Table
VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007); 

SELECT * FROM Cust_Table;

INSERT INTO Orders
VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);

SELECT * FROM Orders;

-- Q4.	Write a query to match the salespeople to the customers according to the city they are living.

SELECT  
sname, 
cname, 
Cust_Table.city AS City 
FROM Salespeople
JOIN Cust_Table 
	ON Salespeople.snum = Cust_Table.snum
ORDER BY City;

-- Q5.	Write a query to select the names of customers and the salespersons who are providing service to them.

SELECT  
sname, 
cname, 
Salespeople.snum 
FROM Salespeople
JOIN Cust_Table 
	ON Salespeople.snum = Cust_Table.snum
ORDER BY Salespeople.snum;

-- Q6. Write a query to find out all orders by customers not located in the same cities as that of their salespeople

SELECT 
onum, 
cname, 
Cust_Table.city 
AS Cust_City, 
Salespeople.city AS Sales_City
FROM Orders
JOIN Cust_Table 
	ON Orders.cnum = Cust_Table.cnum
JOIN Salespeople 
	ON Orders.snum = Salespeople.snum
WHERE Cust_Table.City <> Salespeople.City;

-- Q7.	Write a query that lists each order number followed by name of customer who made that order

SELECT 
onum, 
cname 
FROM Orders
JOIN Cust_Table 
	ON Orders.cnum = Cust_Table.cnum;

-- Q8.	Write a query that finds all pairs of customers having the same rating

SELECT 
rating, 
GROUP_CONCAT(cname SEPARATOR ", ") 
AS CUSTOMERS 
FROM Cust_Table 
GROUP BY rating;

-- Q9.	Write a query to find out all pairs of customers served by a single salesperson

SELECT 
sname,  
GROUP_CONCAT(cname SEPARATOR ", ") 
AS CUSTOMERS 
FROM Cust_Table
JOIN Salespeople 
	ON Cust_Table.snum = Salespeople.snum
GROUP BY Salespeople.snum;

-- Q10.	Write a query that produces all pairs of salespeople who are living in same city

SELECT 
City, 
GROUP_CONCAT(sname SEPARATOR ", ") 
AS Salesperson 
FROM Salespeople 
GROUP BY City;

-- Q11.	Write a Query to find all orders credited to the same salesperson who services Customer 2008

SELECT 
onum, 
snum, 
cnum FROM Orders  
WHERE snum = (
	SELECT DISTINCT snum FROM Orders
				WHERE cnum = 2008);

-- Q12.	Write a Query to find out all orders that are greater than the average for Oct 4th

SELECT 
onum, 
amt, 
odate FROM Orders
WHERE amt > (
	SELECT AVG(amt) FROM Orders
	WHERE MONTH(odate) = 10 
    AND DAY(odate) = 4);

-- Q13.	Write a Query to find all orders attributed to salespeople in London.

SELECT 
onum, 
Orders.snum, 
Salespeople.sname, 
Salespeople.City 
FROM Orders  
JOIN Salespeople 
	ON Salespeople.snum = Orders.snum
WHERE City = 'LONDON';

-- Q14.	Write a query to find all the customers whose cnum is 1000 above the snum of Serres.

SELECT 
cnum, 
cname 
FROM Cust_Table
JOIN Salespeople 
	ON Cust_Table.snum = Salespeople.snum
WHERE cnum > 1000 + (
	SELECT Salespeople.snum 
    FROM Salespeople 
    WHERE sname = 'Serres');

-- Q15.	Write a query to count customers with ratings above San Jose’s average rating.

SELECT 
COUNT(cnum) AS Cust, 
rating 
FROM Cust_Table 
JOIN Salespeople 
	ON Cust_Table.snum = Salespeople.snum
WHERE rating > (
	SELECT AVG(rating) 
    FROM Cust_Table
	WHERE City = 'San Jose');
                
-- Q16. Write a query to show each salesperson with multiple customers.

SELECT 
sname,
Salespeople.snum, 
GROUP_CONCAT(Cust_Table.cname) 
AS Cust 
FROM Salespeople 
JOIN Cust_Table 
	ON Salespeople.snum = Cust_Table.snum 
GROUP BY sname
HAVING COUNT(sname)>1;

