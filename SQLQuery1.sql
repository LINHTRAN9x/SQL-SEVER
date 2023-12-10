

CREATE DATABASE Studients;
GO

USE Studients
go

DROP TABLE Contacts;

CREATE TABLE Contacts(
   ID int,
   Name NTEXT,
   Age int,
   Class varchar(255),
   TEL int
)
SELECT * FROM Contacts;
GO

ALTER TABLE Contacts
ADD Email varchar(255);
GO

INSERT INTO Contacts VALUES ('Davis',18,'1A',098768213,'davis@gmail.com')
INSERT INTO Contacts VALUES ('Peter',18,'9A',098438213,'peter@gmail.com')
INSERT INTO Contacts VALUES ('Hasmane',18,'6A',0987634213,'hasmane@gmail.com')
INSERT INTO Contacts VALUES ('Miler',18,'3A',0934245213,'Miler@gmail.com')

DELETE FROM Contacts WHERE ID= 1
go

ALTER TABLE Contacts
DROP COLUMN ID
go

UPDATE Contacts SET Class = '2A' WHERE Email= 'davis@gmail.com'
 SELECT * FROM Contacts;
go

CREATE LOGIN Contacts WITH PASSWORD= '123456'
CREATE USER Contacts FROM LOGIN Contacts
go

USE AdventureWorks2019
SELECT * FROM Person.Address
GO

DECLARE @city varchar(255)
SELECT @city = 'Bothell'
SELECT AddressID, AddressLine1 FROM Person.Address WHERE City = @city
GO

SELECT @@LANGUAGE
SELECT @@VERSION
GO

SELECT @@TEXTSIZE

SELECT COUNT(StateProvinceID), PostalCode FROM Person.Address GROUP BY PostalCode ORDER BY COUNT(StateProvinceID) ASC;
GO

USE Northwind
SELECT * FROM Orders
SELECT * FROM Shippers

SELECT Shippers.CompanyName, COUNT(Orders.OrderID) AS 
NumberOfOrders FROM Orders
LEFT JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
GROUP BY CompanyName