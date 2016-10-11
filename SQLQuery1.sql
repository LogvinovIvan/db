


select *
into dbo.person
from Person.Person
where 1=0

ALTER TABLE dbo.person
DROP COLUMN AdditionalContactInfo, Demographics,rowguid;

ALTER TABLE dbo.person
ADD ID bigint identity(10,10) primary key;

ALTER TABLE dbo.person
ADD CONSTRAINT chk_Title CHECK (Title in ('Ms.', 'Mr.'));

ALTER TABLE dbo.person
ADD CONSTRAINT default_suffix DEFAULT 'N/A' FOR Suffix;

SET IDENTITY_INSERT dbo.person OFF;

INSERT INTO dbo.person (BusinessEntityID, PersonType,NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion, person.ModifiedDate)
SELECT Person.BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion, Person.ModifiedDate
FROM HumanResources.EmployeeDepartmentHistory
join Person.Person
ON Person.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
join HumanResources.Department
ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
WHERE Person.Title in ('Ms.', 'Mr.') AND Department.Name <> 'Executive';

SET IDENTITY_INSERT dbo.person ON;

ALTER TABLE dbo.person
ALTER COLUMN TITLE nvarchar(5);

SELECT * HumanResources.Department WHERE NAME <> 'Executive';