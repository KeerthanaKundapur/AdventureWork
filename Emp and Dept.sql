USE P2;

CREATE TABLE Employee(
empno INT NOT NULL UNIQUE, 
ename VARCHAR(20), 
job VARCHAR(20), 
mgr INT, 
hiredate DATE, 
sal DECIMAL(6,2), 
comm DECIMAL(6,2), 
deptno INT);

CREATE TABLE Dept(
deptno INT,
dname VARCHAR(20), 
loc VARCHAR(20));

-- Adding check for salary

ALTER TABLE Employee
ADD CHECK (sal>0);

-- Adding Primary key for deptno

ALTER TABLE Dept
ADD PRIMARY KEY (deptno);

-- Adding Foreign key to deptno in Employee table

ALTER TABLE Employee
ADD FOREIGN KEY (deptno) REFERENCES Dept(deptno);

-- Setting Clerk as default job

ALTER TABLE Employee
ALTER job SET DEFAULT 'Clerk';

INSERT INTO Dept
VALUES
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEW YORK');

INSERT INTO Employee
VALUES
(7369, 'SMITH', 'CLERK', 7902, '1890-12-17', 800.00,NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.50, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

SELECT * FROM Employee;

SELECT * FROM dept;

CREATE TABLE Job_grades(
grade VARCHAR(1),
lowest_sal INT,
highest_sal INT);

INSERT INTO Job_grades
VALUES
('A', 0, 999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);

SELECT * FROM Job_Grades;

-- Q3 List the Names and salary of the employee whose salary is greater than 1000

SELECT 
ename , 
sal 
FROM Employee 
WHERE sal > 1000;

-- Q4	List the details of the employees who have joined before end of September 81.

SELECT 
ename,
hiredate
FROM Employee
WHERE hiredate < '1981-09-30';

-- Q5.	List Employee Names having I as second character.

SELECT 
ename 
FROM Employee 
WHERE ename LIKE '_I%';

-- Q6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE Employee 
ADD COLUMN (
Allowances DECIMAL(6,2),
PF DECIMAL(6,2),
Net_Salary DECIMAL(6,2));

UPDATE Employee
SET 
Allowances = 0.4*sal,
PF = 0.1*sal,
Net_Salary = IFNULL(sal,0) + Allowances + PF + IFNULL(comm,0);
SELECT * FROM Employee;

-- Q7 List Employee Names with designations who does not report to anybody

SELECT 
ename 
FROM Employee 
WHERE MGR IS NULL;

-- Q8.	List Empno, Ename and Salary in the ascending order of salary.

SELECT 
empno,
ename,
sal 
FROM Employee 
ORDER BY sal;

-- Q9.	How many jobs are available in the Organization ?

SELECT 
COUNT(DISTINCT job) as Job_Count
FROM Employee;

-- Q10.	Determine total payable salary of salesman category

SELECT 
SUM(Net_Salary) 
FROM Employee  
WHERE job = 'SALESMAN';

-- Q11.	List average monthly salary for each job within each department

SELECT 
dname, 
job, 
AVG(sal) AS Average_Salary 
FROM Employee    
JOIN Dept 
	ON Employee.deptno = Dept.deptno
GROUP BY Dept.dname, job
ORDER BY Dept.dname;

-- Q12.	Use the Same EMP and Dept table used in the Case study to Display EMPNAME, SAlARY and DeptNAME in which the employee is working

SELECT 
ename, 
sal, 
Dept.dname FROM Employee 
JOIN Dept 
	ON Employee.deptno = Dept.deptno
ORDER BY Dept.dname;

-- Q13. Create the Job Grades Table as below

SELECT * FROM Job_Grades;

-- Q14.	Display the last name, salary and  Corresponding Grade.

ALTER TABLE Employee
ADD COLUMN grade CHAR(1);
UPDATE Employee SET grade = 'A' WHERE sal BETWEEN 0 AND 999;
UPDATE Employee SET grade = 'B' WHERE sal BETWEEN 1000 AND 1999;
UPDATE Employee SET grade = 'C' WHERE sal BETWEEN 2000 AND 2999;
UPDATE Employee SET grade = 'D' WHERE sal BETWEEN 3000 AND 3999;
UPDATE Employee SET grade = 'E' WHERE sal BETWEEN 4000 AND 5000;

SELECT 
ename, 
sal, 
grade 
FROM Employee
ORDER BY GRADE;

-- Q15.	Display the Emp name and the Manager name under whom the Employee works in the below format 

SELECT 
A.ename AS EMPLOYEE , 
B.ename AS MANAGER
FROM 
Employee A
JOIN Employee B 
	ON A.mgr = B.empno;

-- Q16.	Display Empname and Total sal where Total Sal (sal + Comm)

SELECT 
    ename AS Employee, sal + IFNULL(comm, 0) AS Total_Salary
FROM
    Employee
ORDER BY Total_Salary DESC;

-- Q17.	Display Empname and Sal whose empno is a odd number

SELECT empno, 
ename, 
sal FROM Employee 
WHERE MOD(empno,2) = 1;

-- Q18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department

SELECT 
ename,
sal, 
DENSE_RANK() OVER (ORDER BY sal DESC) AS sal_rank, 
DENSE_RANK() OVER(PARTITION BY dname ORDER BY sal DESC) AS dept_rank, 
dname  
FROM Employee
JOIN Dept 
	ON Employee.deptno = Dept.deptno
ORDER BY sal DESC;

-- Q19.	Display Top 3 Empnames based on their Salary

SELECT 
ename, 
sal FROM Employee 
ORDER BY sal DESC
LIMIT 3;

-- Q20 Display Empname who has highest Salary in Each Department.

SELECT * 
FROM
	(SELECT 
    ename,
    sal,
    deptno,
	DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) 
    AS "Rank" 
    FROM Employee) AS A
WHERE A.RANK=1;
