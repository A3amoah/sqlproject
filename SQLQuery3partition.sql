/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [EmployeeID]
      ,[FirstName]
      ,[LastName]
      ,[Age]
      ,[Gender]
  FROM [SQLTutorial].[dbo].[EmployeeDemographics]

DELETE FROM SQLTutorial.dbo.EmployeeDemographics
WHERE FirstName = 'Darryl' AND LastName = 'Philbin'  AND EmployeeID = (
  SELECT MIN(EmployeeID) FROM SQLTutorial.dbo.EmployeeDemographics
  WHERE FirstName = 'Darryl' AND LastName = 'Philbin'
);

Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male')



--SELECT FirstName, LastName, Age,
--CASE
--    WHEN Age = 38 THEN 'Stanley'
--    WHEN Age > 30 THEN 'Old'
--	ELSE 'Baby'
--END
--FROM SQLTutorial.dbo.EmployeeDemographics
--WHERE Age is NOT NULL
--ORDER BY Age



--SELECT FirstName, LastName, JobTitle, Salary,
--CASE 
--    WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
--	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
--	WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
--	ELSE Salary + (Salary * 0.3)
--END AS SalaryAfterRaise
--FROM SQLTutorial.dbo.EmployeeDemographics
--JOIN SQLTutorial.[dbo].[EmployeeSalary]
--     ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId 

--SELECT JobTitle, COUNT(JobTitle)
--FROM SQLTutorial.dbo.EmployeeDemographics
--JOIN SQLTutorial.[dbo].[EmployeeSalary]
--  ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId 
--GROUP BY JobTitle
--HAVING COUNT(JobTitle) >1


SELECT JobTitle, AVG(Salary)
FROM SQLTutorial.dbo.EmployeeDemographics
JOIN SQLTutorial.[dbo].[EmployeeSalary]
  ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeId 
GROUP BY JobTitle

HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary)



SELECT *
FROM SQLTutorial.dbo.EmployeeDemographics

UPDATE SQLTutorial.dbo.EmployeeDemographics
SET Age = 32, Gender ='Female'
WHERE FirstName ='Holly' AND LastName ='Flax'

DELETE FROM SQLTutorial.dbo.EmployeeDemographics
WHERE EmployeeID= 1011

/* 
Partition By
*/
SELECT FirstName, LastName, Gender ,Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
FROM SQLTutorial.dbo.EmployeeDemographics dem
JOIN
SQLTutorial.dbo.EmployeeSalary sal 
ON dem.EmployeeID = sal.EmployeeID

