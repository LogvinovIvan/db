
CREATE PROCEDURE SubOrderQtyByYear @YearsColorsList NVARCHAR(100)
AS
BEGIN
	DECLARE @Query NVARCHAR(1000)
	SET @Query = 'SELECT Name,'+@YearsColorsList+'
FROM (
SELECT Product.Name,
	   SalesOrderDetail.OrderQty,
       YEAR(OrderDate) AS y1
FROM Sales.SalesOrderDetail
JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
JOIN Production.Product ON Product.ProductID = SalesOrderDetail.ProductID) AS SALES1 PIVOT (SUM(OrderQty)
                                                                                 FOR y1 IN ('+@YearsColorsList+') ) AS pvt;'
	EXEC (@Query)
END

EXECUTE SubOrderQtyByYear '[2008],[2007],[2006]'


