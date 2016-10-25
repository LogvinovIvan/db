ALTER TABLE dbo.person ADD FullName nvarchar(100);

GO
DECLARE @PersonInf TABLE(
[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [dbo].[NameStyle] NOT NULL,
	[Title] [nvarchar](5) NULL,
	[FirstName] [dbo].[Name] NOT NULL,
	[MiddleName] [dbo].[Name] NULL,
	[LastName] [dbo].[Name] NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ID] [bigint] IDENTITY(10,10) NOT NULL,
	[FullName][nvarchar](100)
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

INSERT INTO @PersonInf(PersonType, NameStyle, BusinessEntityID, FirstName, LastName, MiddleName, Suffix, EmailPromotion, ModifiedDate, FullName, Title)
SELECT PersonType,
       NameStyle,
       [dbo].person.BusinessEntityID,
       FirstName,
       LastName,
       MiddleName,
       Suffix,
       EmailPromotion,
       [dbo].person.ModifiedDate,
       FullName,
       CASE
           WHEN Gender = 'M' THEN 'Mr.'
           WHEN Gender = 'F' THEN 'Ms.'
       END
FROM dbo.person
JOIN HumanResources.Employee ON person.BusinessEntityID = Employee.BusinessEntityID;


UPDATE dbo.person SET FullName = CONCAT(P.Title,P.FirstName) FROM dbo.person JOIN @PersonInf P ON person.BusinessEntityID = P.BusinessEntityID;

DELETE FROM dbo.person WHERE LEN(FullName)>=20;

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'person';

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Person';


ALTER TABLE dbo.person DROP CONSTRAINT chk_Title;
ALTER TABLE dbo.person DROP CONSTRAINT PK__person__3214EC27EC1A2BC3;




