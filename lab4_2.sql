CREATE VIEW CategoryView WITH SCHEMABINDING, ENCRYPTION
AS
SELECT [category].[ProductCategoryID] as categoryId,
	   [category].[Name] as categoryName,
	   [category].[ModifiedDate] as categoryModifiedDate,
	   [category].rowguid as categoryRowguid,
	   [subcategory].Name as subCategoryName,
	   [subcategory].ModifiedDate as subCategoryModifiedDate,
	   [subcategory].ProductSubcategoryID as subCategoryId,
	   [subcategory].rowguid as subCategoryRowguid
FROM [Production].[ProductCategory] as category
JOIN [Production].[ProductSubcategory] as subcategory 
ON category.ProductCategoryID = subcategory.ProductCategoryID;

CREATE UNIQUE CLUSTERED INDEX CategoryViewIndex
	ON CategoryView(categoryId,subCategoryId);


CREATE TRIGGER viewInsertTrigger
ON [CategoryView]
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO [Production].[ProductCategory] (Name,rowguid,ModifiedDate)
	SELECT DISTINCT categoryName,categoryRowguid,categoryModifiedDate
		FROM inserted
		WHERE NOT EXISTS (SELECT * FROM [Production].[ProductCategory] WHERE Name IN (SELECT categoryName FROM inserted));

	INSERT INTO [Production].[ProductSubcategory] (ProductCategoryID,Name,rowguid,ModifiedDate)
	SELECT [Production].[ProductCategory].[ProductCategoryID],
		   subCategoryName,
		   subCategoryRowguid,
		   subCategoryModifiedDate
	FROM [inserted]
		JOIN [Production].[ProductCategory] ON inserted.categoryName = ProductCategory.Name;
END;


CREATE TRIGGER viewUpdateTrigger
ON [CategoryView]
INSTEAD OF UPDATE
AS
BEGIN
	UPDATE Production.ProductCategory 
	SET
		Name = inserted.[categoryName],
		ModifiedDate = inserted.categoryModifiedDate,
		rowguid = inserted.categoryRowguid
	FROM inserted
	WHERE ProductCategory.ProductCategoryID = (SELECT categoryId FROM inserted);

	UPDATE Production.ProductSubcategory
	SET
		Name = inserted.subCategoryName,
		ModifiedDate = inserted.subCategoryModifiedDate,
		rowguid = inserted.subCategoryRowguid
	FROM inserted
	WHERE Production.ProductSubcategory.ProductSubcategoryID = (SELECT subCategoryId FROM inserted) 
	AND Production.ProductSubcategory.ProductCategoryID = (SELECT categoryId FROM inserted);	
END;


CREATE TRIGGER viewDeleteTRigger
ON [CategoryView]
INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM Production.ProductSubcategory 
	WHERE ProductSubcategoryID = (SELECT subCategoryId FROM deleted) AND ProductCategoryID = (SELECT categoryId FROM deleted);

	DELETE FROM Production.ProductCategory
	WHERE NOT EXISTS (SELECT * FROM Production.ProductSubcategory WHERE ProductSubcategory.ProductCategoryID = (SELECT categoryId FROM deleted))
	AND ProductCategory.ProductCategoryID = (SELECT categoryId FROM deleted);
END;



INSERT INTO CategoryView
( categoryName,
	categoryModifiedDate,
	categoryRowguid,
	subCategoryName,
	subCategoryModifiedDate,
	subCategoryRowguid)

	VALUES('Sport_1', 
			GETDATE(),
			CONVERT(uniqueidentifier,'75BC8338-126E-45CF-8737-A7B7A2C3C072'),
			'Sport_2',GETDATE(),
			CONVERT(uniqueidentifier,'73BB8336-126E-45CF-8737-A7B7A2C3C072'));


SELECT COUNT(*) FROM [Production].[ProductCategory];
SELECT * FROM Production.ProductSubcategory WHERE Name = 'Sport_2';
SELECT * FROM Production.ProductCategory WHERE ProductCategoryID = 14;



UPDATE CategoryView
SET categoryName = '2345'
WHERE categoryId = 14 AND subCategoryId = 39;


DELETE FROM CategoryView WHERE categoryId = 14 AND subCategoryId = 39;


			