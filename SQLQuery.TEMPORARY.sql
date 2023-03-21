/* TODAY's Topic : Temporary Tables*/
CREATE TABLE #temp_Employee(
EmployeeID int,
JobTitle varchar(100),
Salary int
)

SELECT *
FROM #temp_Employee

INSERT INTO #temp_Employee VALUES(
'1001', 'HR', '45000'
)
 INSERT INTO #temp_Employee
SELECT *
FROM SQLTutorial.[dbo].[EmployeeSalary]


DROP TABLE IF EXISTS #TEMP_Employee2
CREATE TABLE #TEMP_Employee2 (
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int
)

INSERT INTO #TEMP_Employee2
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

SELECT *
FROM #TEMP_Employee2 



