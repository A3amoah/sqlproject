/*

Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/

--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM(Left Trim), RTRIM(Right Trim)
SELECT EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

--Using Replace

SELECT LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors



--Using SubString
SELECT SUBSTRING(FirstName,3,3)
FROM EmployeeErrors
 
 SELECT SUBSTRING(err.FirstName,1,3),SUBSTRING(dem.FirstName,1,3)
 FROM EmployeeErrors err
 JOIN EmployeeDemographics dem
      ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)
--GENDER
--lastname
--age
--dob


--USING UPPER AND lower

SELECT FirstName, LOWER(FirstName)
FROM EmployeeErrors

SELECT FirstName,UPPER(FirstName)
FROM EmployeeErrors

