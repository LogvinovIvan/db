USE AdventureWorks2012
GO

DECLARE @employees XML;

SET @employees =
(SELECT BusinessEntityID AS '@ID', NationalIDNumber, JobTitle
FROM HumanResources.Employee
FOR XML PATH('Employee'), ROOT('Employees'))

SELECT @employees AS 'Employees'

CREATE TABLE #Employees(ID INT PRIMARY KEY NOT NULL,
NationalIDNumber INT NOT NULL, JobTitle NVARCHAR(50) NOT NULL)

INSERT INTO #Employees(ID, NationalIDNumber, JobTitle)
SELECT ID = x.value('@ID[1]', 'INT'),
	   NationalIDNumber = x.value('NationalIDNumber[1]', 'INT'),
	   JobTitle = x.value('JobTitle[1]', 'NVARCHAR(50)')
FROM @employees.nodes('/Employees/Employee') AS XmlData(x)

SELECT *
FROM #Employees

DROP TABLE #Employees