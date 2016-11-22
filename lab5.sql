CREATE FUNCTION getCountDapartment(@NameGroup nvarchar(50))
RETURNS int 
AS 
-- Returns the stock level for the product.
BEGIN
    DECLARE @ret int;
    SELECT @ret = COUNT(DepartmentID) 
    FROM HumanResources.Department 
    WHERE Department.GroupName = @NameGroup;
     IF (@ret IS NULL) 
        SET @ret = 0;
    RETURN @ret;
END;


CREATE FUNCTION getThreeOlderEmploee (@DepId int)
RETURNS TABLE
AS
RETURN 
(
    SELECT TOP 3 Employee.LoginID as id, Employee.BirthDate as birthDate
    FROM HumanResources.EmployeeDepartmentHistory  
    JOIN HumanResources.Department ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
    JOIN HumanResources.Employee  ON Employee.BusinessEntityID = Department.DepartmentID
    WHERE Department.DepartmentID = @DepId AND YEAR(EmployeeDepartmentHistory.StartDate) = '2005'
    ORDER BY Employee.BirthDate
);




SELECT LoginId, BirthDate, Department.Name FROM HumanResources.Department CROSS APPLY getThreeOlderEmploee(Department.DepartmentID);
SELECT LoginId, BirthDate, Department.Name FROM HumanResources.Department OUTER APPLY getThreeOlderEmploee(Department.DepartmentID);
SELECT * FROM getThreeOlderEmploee(1);




ALTER FUNCTION getThreeOlderEmploee1 (@DepId int)
RETURNS @report TABLE(loginId nvarchar(256)
    PRIMARY KEY, 
    birthDate DATE)
AS
BEGIN
    DECLARE @t TABLE(loginId nvarchar(256)
    PRIMARY KEY, 
    birthDate DATE)
	INSERT @t  
	SELECT  TOP 3 Employee.LoginID as id, Employee.BirthDate as birthDate
    FROM HumanResources.EmployeeDepartmentHistory  
    JOIN HumanResources.Department ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
    JOIN HumanResources.Employee  ON Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
    WHERE Department.DepartmentID = @DepId AND YEAR(EmployeeDepartmentHistory.StartDate) = '2005' AND EndDate is NULL
    ORDER BY Employee.BirthDate;
	INSERT @report SELECT loginId, birthDate
    FROM @t
RETURN 
END;


SELECT * FROM getThreeOlderEmploee1 (1);