USE AdventureWorks2019;
SELECT * from Customers

SELECT CustomerID
From dbo.Customers
WHERE City = 'London'

CREATE TYPE dbo.tesing
FROM NVARCHAR(20) NULL;
DROP TYPE dbo.tesing;

SELECT * FROM dbo.tesing;

DECLARE @Number int;
SET @Number = 2+2* (4 + (5-3));
SELECT @Number

SELECT * FROM Sales.SalesOrderHeader;
SELECT SalesOrderID, CustomerID, SalesPersonID, TerritoryID, YEAR(OrderDate)
       AS CurrentYear, YEAR(OrderDate) +1 AS NextYear
	   FROM Sales.SalesOrderHeader
GO --batch

--comment likes this--and /* like this */
SELECT SalesPersonID, YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
WHERE CustomerID = 30084
GROUP BY SalesPersonID, YEAR(OrderDate)
HAVING COUNT(*) > 1
ORDER BY SalesPersonID, YEAR(OrderDate)

SELECT a.ProductID,Name, ProductNumber,d.ModifiedDate FROM Production.Product AS a
INNER JOIN Production.ProductDocument AS d ON
a.ProductID = d.ProductID