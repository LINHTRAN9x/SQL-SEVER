USE AdventureWorks2019;

SELECT * FROM Production.Product

CREATE VIEW vwProductInfo AS
SELECT ProductID, ProductNumber, Name , SafetyStockLevel
FROM Production.Product;

SELECT * FROM vwProductInfo;

SELECT * FROM HumanResources.Employee
CREATE VIEW vwPersonDetails AS 
SELECT p.Title ,p.FirstName, p.MiddleName,p.LastName ,e.JobTitle FROM HumanResources.Employee as e
Inner JOIN Person.Person as p ON p.BusinessEntityID = e.BusinessEntityID
GO
DROP VIEW vwPersonDetails

--COALESCE() thay thế Null value.
CREATE VIEW vwPersonDetails AS 
SELECT COALESCE(p.Title,' ') AS Title ,p.FirstName,coalesce(p.MiddleName, ' ') AS MiddleName,p.LastName ,e.JobTitle FROM HumanResources.Employee as e
Inner JOIN Person.Person as p ON p.BusinessEntityID = e.BusinessEntityID
GO
SELECT * FROM vwPersonDetails;

SELECT * FROM vwStoredPersonDetails;
CREATE VIEW vwStoredPersonDetails AS 
SELECT TOP 10 COALESCE(p.Title,' ') AS Title ,p.FirstName,coalesce(p.MiddleName, ' ') AS MiddleName,p.LastName ,e.JobTitle FROM HumanResources.Employee as e
Inner JOIN Person.Person as p ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY p.FirstName
GO


