USE AdventureWorks2019;

SELECT * FROM Production.Product

CREATE VIEW vwProductInfo AS
SELECT ProductID, ProductNumber, Name , SafetyStockLevel
FROM Production.Product;

SELECT * FROM vwProductInfo;

