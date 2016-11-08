CREATE TABLE Production.ProductCategoryHist(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Action varchar(10) NOT NULL,
	SourceID int,
	UserName varchar(50) NOT NULL
);





CREATE TRIGGER hist ON [Production].[ProductCategory]
	AFTER  INSERT,UPDATE,DELETE as
declare @EmpID int,@user varchar(20), @activity varchar(20);
if exists(SELECT * from inserted) and exists (SELECT * from deleted)
begin
    SET @activity = 'UPDATE';
    SET @user = SYSTEM_USER;
    SELECT @EmpID = ProductCategoryID from inserted i;
    INSERT into ProductCategoryHist(SourceID,Action, UserName) values (@EmpID,@activity,@user);
end

If exists (Select * from inserted) and not exists(Select * from deleted)
begin
    SET @activity = 'INSERT';
    SET @user = SYSTEM_USER;
    SELECT @EmpID = ProductCategoryID from inserted i;
    INSERT into ProductCategoryHist(SourceID,Action, UserName) values (@EmpID,@activity,@user);
end

If exists(select * from deleted) and not exists(Select * from inserted)
begin 
    SET @activity = 'DELETE';
    SET @user = SYSTEM_USER;
    SELECT @EmpID = ProductCategoryID from deleted i;
    INSERT into ProductCategoryHist(SourceID,Action, UserName) values (@EmpID,@activity,@user);
end


CREATE VIEW ProductCategoryView AS SELECT * FROM Production.ProductCategory;

DROP VIEW ProductCategoryView;

INSERT INTO ProductCategoryView ( Name,  ModifiedDate) VALUES ('v12av',GETDATE());

DELETE FROM ProductCategoryView WHERE Name = 'v12av';
SELECT * FROM Production.ProductCategoryHist;

DELETE FROM Production.ProductCategoryHist;

;