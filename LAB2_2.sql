CREATE TYPE dbo.NameStyle
FROM bit NOT NUll;

CREATE TYPE dbo.NAME 
FROm nvarchar(50) NOT NULL;



CREATE TABLE dbo.Person
(
	BusinessEntityID nchar(2) primary key NOT NULL,
	NameStyle NameStyle NOT NULL,
	Title nvarchar(8),
	FirstName Name NOT NULL,
	MiddleName Name,
	LastName Name NOT NULL,
	Suffix nvarchar(10),
	EmailPromotion int NOT NULL,
	ModifiedDate datetime NOT NULL
);

ALTER TABLE dbo.person
ADD ID bigint identity(10,10);


ALTER TABLE dbo.Person
DROP CONSTRAINT BusinessEntityID;

ALTER TABLE dbo.person
ADD PRIMARY KEY (ID);


ALTER TABLE dbo.person
ADD CHECK(Suffix in ('Ms', 'Mrs'));

