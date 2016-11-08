ALTER TABLE dbo.person ADD SalesYTD MONEY, 
						   SalesLastYear MONEY, 
						   OrdersNum INT, 
						   SalesDiff  AS SalesYTD - SalesLastYear;


CREATE TABLE #Person(
	[BusinessEntityID] [int] NOT NULL ,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](5) NULL,
	[FirstName] nvarchar(50) NOT NULL,
	[MiddleName] nvarchar(50) NULL,
	[LastName] nvarchar(50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ID] [bigint] IDENTITY(10,10) NOT NULL,
	[SalesYTD] [money] NULL,
	[SalesLastYear] [money] NULL,
	[OrdersNum] [int] NULL,
	[SalesDiff]  AS ([SalesYTD]-[SalesLastYear]),
	PRIMARY KEY(BusinessEntityID)
)


USE [AdventureWorks2012]
GO

WITH COUNT_ORDER AS 
(SELECT COUNT(SalesOrderID) as count_orders, BusinessEntityID FROM Sales.SalesOrderHeader 
											JOIN dbo.person ON SalesPersonID = BusinessEntityID 
											GROUP BY (BusinessEntityID))
INSERT INTO #Person
           ([BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[ModifiedDate]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[OrdersNum])
     
		   SELECT
		    [dbo].[person].[BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[dbo].[person].[ModifiedDate]
           ,Sales.SalesPerson.[SalesYTD]
           ,Sales.SalesPerson.[SalesLastYear]
           ,count_orders FROM [dbo].[person] JOIN Sales.SalesPerson ON dbo.person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
							 JOIN COUNT_ORDER ON COUNT_ORDER.BusinessEntityID = Sales.SalesPerson.BusinessEntityID 
GO

MERGE dbo.person trg
USING #Person s
ON trg.BusinessEntityID = s.BusinessEntityID
WHEN NOT MATCHED BY TARGET
	THEN INSERT (BusinessEntityID
           ,PersonType
           ,NameStyle
           ,Title
           ,FirstName
           ,MiddleName
           ,LastName
           ,Suffix
           ,EmailPromotion
           ,ModifiedDate
           ,SalesYTD
           ,SalesLastYear
           ,OrdersNum) VALUES (s.[BusinessEntityID]
           ,s.[PersonType]
           ,s.[NameStyle]
           ,s.[Title]
           ,s.[FirstName]
           ,s.[MiddleName]
           ,s.[LastName]
           ,s.[Suffix]
           ,s.[EmailPromotion]
           ,s.[ModifiedDate]
           ,s.[SalesYTD]
           ,s.[SalesLastYear]
           ,s.[OrdersNum])
WHEN MATCHED THEN UPDATE SET trg.SalesYTD = s.SalesYTD, trg.SaleslastYear = s.SaleslastYear, trg.OrdersNum = s.OrdersNum
WHEN NOT MATCHED BY SOURCE THEN DELETE;


SELECT * FROM dbo.person;

















WITH COUNT_ORDER AS 
(SELECT COUNT(SalesOrderID) as count_orders,BusinessEntityID FROM Sales.SalesOrderHeader 
											JOIN dbo.person ON SalesPersonID = BusinessEntityID 
											GROUP BY (BusinessEntityID))
SELECT count_orders,BusinessEntityID FROM COUNT_ORDER;






