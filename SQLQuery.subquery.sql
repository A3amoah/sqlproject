/*
Today's Topic: Subqueries (in the Select, From, and Where Statement)
*/

SELECT *
FROM EmployeeSalary

--Subquery in select
SELECT EmployeeID, Salary,(select AVG(salary) from EmployeeSalary) AS AllAvgSalary
FROM EmployeeSalary

--partiton
SELECT EmployeeID, Salary, AVG(salary) over () AS AllAvgSalary
FROM EmployeeSalary

--why group by doesnt work
SELECT EmployeeID, Salary, AVG(salary) AS AllAvgSalary
FROM EmployeeSalary
Group by EmployeeID, Salary
Order by 1,2
  
--subquery in from
select a.EmployeeId, AllAvgSalary
from ( SELECT EmployeeID, Salary, AVG(salary) over () AS AllAvgSalary
FROM EmployeeSalary)  a

--subquery in where
SELECT EmployeeID,JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID in (
         select EmployeeID
		 from EmployeeDemographics
		 where Age > 30)
