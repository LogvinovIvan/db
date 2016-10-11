SELECT EmployeePayHistory.BusinessEntityID,
       JobTitle,
       MAX(Rate) AS MaxRate
FROM HumanResources.EmployeePayHistory
JOIN HumanResources.Employee ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
GROUP BY JobTitle,
         EmployeePayHistory.BusinessEntityID;






SELECT EmployeePayHistory.BusinessEntityID,
       JobTitle,
       Rate, DENSE_RANK() OVER ( ORDER BY Rate) AS RankRate
FROM HumanResources.EmployeePayHistory
JOIN HumanResources.Employee ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
GROUP BY JobTitle,
         EmployeePayHistory.BusinessEntityID,
		 Rate;




SELECT Department.Name AS DepName,
       Shift.ShiftID,
       Employee.BusinessEntityID,
       Employee.JobTitle
FROM HumanResources.EmployeeDepartmentHistory
JOIN HumanResources.Shift ON EmployeeDepartmentHistory.ShiftID = Shift.ShiftID
JOIN HumanResources.Employee ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
JOIN HumanResources.Department ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
WHERE EmployeeDepartmentHistory.EndDate IS NULL
ORDER BY DepName,
         CASE
             WHEN Department.Name = 'Document Control' THEN Shift.ShiftID
             ELSE Employee.BusinessEntityID
         END;
