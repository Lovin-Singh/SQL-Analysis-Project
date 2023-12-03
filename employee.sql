create database employee;
use employee;

CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar(50),
Gender Char,
Salary int,
City Char(20) );
 
INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');

select * from Employee;

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar(50),
EmpPosition Char(20),
DOJ date );

SET @@SQL_MODE = REPLACE(@@SQL_MODE, 'NO_ZERO_DATE', '');


INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01');

select * from EmployeeDetail;

select * from Employee
where Salary between 200000 and 300000;

SELECT E1.EmpID, E1.EmpName, E1.City
FROM Employee E1, Employee E2
WHERE E1.City = E2.City AND E1.EmpID != E2.EmpID;

SELECT * FROM Employee
WHERE EmpID IS NULL;

SELECT EmpID,EmpName,  Salary, SUM(Salary) OVER (ORDER BY EmpID) AS CumulativeSum
FROM Employee;

SELECT
(COUNT(*) FILTER (WHERE Gender = 'M') * 100.0 / COUNT(*)) AS MalePct,  /*THIS FILTER IS USED IN PostgreSQL not in mysql*/
(COUNT(*) FILTER (WHERE Gender = 'F') * 100.0 / COUNT(*)) AS FemalePct
FROM Employee;

SELECT
  (SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS MalePct,
  (SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS FemalePct
FROM Employee;


SELECT * FROM Employee 
WHERE EmpID <= (SELECT COUNT(EmpID)/2 from Employee);


SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY EmpID) AS ROWNUMBER
    FROM Employee
) AS EMP
WHERE EMP.ROWNUMBER <= (SELECT COUNT(EmpID)/2 FROM Employee);


SELECT Salary, CONCAT(LEFT(CAST(Salary AS char), LENGTH(CAST(Salary AS char))-2), 'XX') 
AS masked_number
FROM Employee;

SELECT 
    Salary,
    CONCAT(LEFT(CAST(Salary AS CHAR), LENGTH(CAST(Salary AS CHAR))-2), 'XX') AS masked_number
FROM Employee;

SELECT Salary, 
CONCAT(LEFT(Salary, LENgth(Salary)-2), 'XX') as masked_salary
FROM Employee;


SELECT * FROM Employee 
WHERE MOD(EmpID,2)=0;

SELECT * FROM Employee 
WHERE MOD(EmpID,2)=1;

SELECT * FROM 
(SELECT *, ROW_NUMBER() OVER(ORDER BY EmpId) AS 
RowNumber
FROM Employee) AS Emp
WHERE Emp.RowNumber % 2 = 0;

SELECT * FROM 
(SELECT *, ROW_NUMBER() OVER(ORDER BY EmpId) AS 
RowNumber
FROM Employee) AS Emp
WHERE Emp.RowNumber % 2 = 1;


SELECT *, ROW_NUMBER() OVER(ORDER BY EmpId) AS 
RowNumber
FROM Employee;


SELECT * FROM Employee WHERE EmpName LIKE 'A%';
SELECT * FROM Employee WHERE EmpName LIKE '_a%';
SELECT * FROM Employee WHERE EmpName LIKE '%y_';
SELECT * FROM Employee WHERE EmpName LIKE '____l';
SELECT * FROM Employee WHERE EmpName LIKE 'V%a';

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP '^[aeiou]';

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP '[aeiou]$';

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP 
'^[aeiou].*[aeiou]$';

SELECT Salary FROM Employee E1
WHERE 1 = (
SELECT COUNT( DISTINCT ( E2.Salary ) )
FROM Employee E2
WHERE E2.Salary >= E1.Salary );

SELECT Salary FROM Employee 
ORDER BY Salary DESC 
LIMIT 1 OFFSET 0;

SELECT EmpID, EmpName, gender, Salary, city, 
COUNT(*) AS duplicate_count
FROM Employee
GROUP BY EmpID, EmpName, gender, Salary, city
HAVING COUNT(*) > 1;

SELECT EmpID
FROM Employee
GROUP BY EmpID
HAVING COUNT(*) > 1;

DELETE FROM Employee
WHERE EmpID IN 
(SELECT EmpID FROM Employee
GROUP BY EmpID
HAVING COUNT(*) > 1);

SET SQL_SAFE_UPDATES = 0;

DELETE e1
FROM Employee e1
JOIN (
    SELECT EmpID
    FROM Employee
    GROUP BY EmpID
    HAVING COUNT(*) > 1
) e2 ON e1.EmpID = e2.EmpID;


WITH CTE AS  /*COMMON TABLE EXPRESSION*/
(SELECT e.EmpID, e.EmpName, ed.Project
FROM Employee AS e
INNER JOIN EmployeeDetail AS ed 
ON e.EmpID = ed.EmpID)
SELECT c1.EmpName, c2.EmpName, c1.project 
FROM CTE c1, CTE c2
WHERE c1.Project = c2.Project AND c1.EmpID != c2.EmpID AND c1.EmpID < c2.EmpID;


SELECT ed.Project, MAX(e.Salary) AS ProjectMaxSal, sum(e.Salary) AS ProjectTotalSal
FROM Employee AS e
INNER JOIN EmployeeDetail AS ed
ON e.EmpID = ed.EmpID
GROUP BY Project
ORDER BY ProjectMaxSal DESC;


SELECT EXTRACT('year' FROM doj) AS JoinYear, COUNT(*) AS EmpCount
FROM Employee AS e
INNER JOIN EmployeeDetail AS ed ON e.EmpID = ed.EmpID
GROUP BY JoinYear
ORDER BY JoinYear ASC;

SELECT EXTRACT(YEAR FROM doj) AS JoinYear, COUNT(*) AS EmpCount
FROM Employee AS e
INNER JOIN EmployeeDetail AS ed ON e.EmpID = ed.EmpID
GROUP BY JoinYear
ORDER BY JoinYear ASC;


SELECT EmpName, Salary,
CASE
WHEN Salary > 200000 THEN 'High'
WHEN Salary >= 100000 AND Salary <= 200000 THEN 'Medium'
ELSE 'Low'
END AS SalaryStatus
FROM Employee





