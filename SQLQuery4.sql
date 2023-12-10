USE AdventureWorks2019;
GO

SELECT COUNT(*) AS TotalProduct FROM dbo.[Current Product List];

SELECT * FROM dbo.[Current Product List]
WHERE ProductName LIKE ('%a');
GO

SELECT * FROM dbo.[Alphabetical list of products]
WHERE UnitPrice BETWEEN 50 AND 100;
GO

SELECT * FROM dbo.Invoices
WHERE CustomerName LIKE ('d%');
GO

SELECT o.OrderID,o.ProductName,o.Quantity,o.Discount, c.CustomerName
FROM dbo.[Order Details Extended] AS o
JOIN dbo.Invoices AS c ON o.OrderID = c.OrderID
WHERE c.CustomerName = 'Drachenblut Delikatessen';
GO

SELECT TOP 1 p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalSold
FROM dbo.[Current Product List] AS p
JOIN dbo.Invoices AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC
;
SELECT * FROM dbo.Invoices

