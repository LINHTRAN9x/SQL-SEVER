CREATE DATABASE AZBank;
USE AZBank;

SELECT * from Customer
CREATE TABLE Customer (
    CustomerId int PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) ,
    City NVARCHAR(50) ,
    Country NVARCHAR(50) ,
    Phone NVARCHAR(15),
    Email NVARCHAR(50)
)
INSERT INTO Customer(CustomerId,Name,City,Country,Phone,Email) VALUES
         (10,N'Trần Văn Linh',N'Hà Nội',N'Việt Nam',N'0903387976',N'tranvanlinh@gmail.com'),
         (20,N'Nguyễn Thị Mi',N'Hà Nội',N'Việt Nam',N'0905477889',N'misociu@gmail.com'),
         (30,N'Hồ Đình Long',N'Hà Nội',N'Việt Nam',N'0909876231',N'longhoguom@gmail.com')
GO

CREATE TABLE CustomerAccount (
    AccountNumber char(9) PRIMARY KEY NOT NULL,
    CustomerId int REFERENCES Customer(CustomerId) NOT NULL,
    Balance money NOT NULL,
    MinAccount money
)
INSERT INTO CustomerAccount(AccountNumber,CustomerId,Balance) VALUES
       ('123456789',10,1000000),
       ('112233445',20,2000000),
       ('987654321',30,3000000)
GO

CREATE TABLE CustomerTransaction (
    TransactionId int PRIMARY KEY NOT NULL,
    AccountNumber char(9) REFERENCES CustomerAccount(AccountNumber),
    TransactionDate smalldatetime,
    Amount money,
    DepositorWithdraw bit
)

INSERT INTO CustomerTransaction(TransactionId,AccountNumber,TransactionDate,Amount) VALUES 
   (1,'123456789','2023-09-11',550000),
   (2,'112233445','2023-08-21',100000),
   (3,'987654321','2023-04-14',300000)
GO

SELECT * FROM Customer
WHERE City = N'Hà Nội';
GO

SELECT c.Name,c.Phone,c.Email,ca.AccountNumber,ca.Balance
FROM Customer as c
JOIN CustomerAccount as ca ON c.CustomerId = ca.CustomerId
WHERE c.CustomerId = 10;
GO

ALTER TABLE CustomerTransaction
ADD CHECK (Amount>0 AND Amount <= 1000000)
GO

CREATE VIEW vCustomerTransactioms as
SELECT c.Name,ca.AccountNumber,ct.TransactionDate,ct.Amount,ct.DepositorWithdraw FROM Customer as c
JOIN CustomerAccount as ca ON ca.CustomerId = c.CustomerId
JOIN CustomerTransaction as ct ON ct.AccountNumber = ca.AccountNumber

SELECT * FROM vCustomerTransactioms
GO;
