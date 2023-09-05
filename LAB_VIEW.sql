USE AdventureWorks2019;

--tạo view
CREATE VIEW vw_Contact_Info AS 
SELECT FirstName,MiddleName,LastName FROM Person.Person
GO

--tạo view lấy Info Employee
CREATE view vw_Employee_Contact AS
SELECT p.FirstName,p.LastName,e.BusinessEntityID,e.HireDate FROM HumanResources.Employee as e
JOIN Person.Person as p ON e.BusinessEntityID = p.BusinessEntityID; 
GO
SELECT * FROM vw_Employee_Contact;

--Thêm cột Birthdate 
ALTER VIEW vw_Employee_Contact AS
SELECT p.FirstName,p.LastName,e.BusinessEntityID,e.HireDate,e.BirthDate FROM HumanResources.Employee as e
JOIN Person.Person as p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName like ('%B%')
GO

--Xóa view
DROP VIEW vw_Contact_Info;
GO

--Xem định nghĩa view 
EXEC sp_helptext 'vw_Employee_Contact'
--Xem các thành phần mà view phụ thuộc.
EXEC sp_depends 'vw_Employee_Contact'
GO

--Tạo view ẩn mà định nghĩa bị ẩn đi.(k xem đc định nghĩa view).
CREATE VIEW vw_OrderRejects
WITH ENCRYPTION AS 
SELECT PurchaseOrderID,ReceivedQty,RejectedQty,
       RejectedQty / ReceivedQty AS RejectRatio,DueDate
FROM Purchasing.PurchaseOrderDetail
WHERE RejectedQty / ReceivedQty > 0 AND DueDate > CONVERT(datetime,'20010630',101);

SELECT * FROM vw_OrderRejects
--Không xem đc định nghĩa vì đã dùng ENCRYPTION ở trên.
EXEC sp_helptext 'vw_OrderRejects'
GO
--Thay đổi view thêm tùy chọn check option.
ALTER view vw_Employee_Contact AS
SELECT p.FirstName,p.LastName,e.BusinessEntityID,e.HireDate FROM HumanResources.Employee as e
JOIN Person.Person as p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName like ('A%')
WITH CHECK OPTION
GO
SELECT * FROM vw_Employee_Contact
--update đc view khi fn start bằng 'A' 
UPDATE vw_Employee_Contact SET FirstName = 'Atest' WHERE LastName = 'Alberts'
--Không update đc view khi fn start bằng khác 'A' 
UPDATE vw_Employee_Contact SET FirstName = 'BCD' WHERE LastName = 'Atest'
GO

--tạo view có giản đồ.
CREATE VIEW vw_Contact_Info 
WITH SCHEMABINDING AS
SELECT FirstName,MiddleName,LastName,rowguid FROM Person.Person
GO
SELECT * FROM Person.Person
ALTER VIEW vw_Contact_Info 
WITH SCHEMABINDING AS
SELECT FirstName,MiddleName,LastName,rowguid FROM Person.Person


--Tạo chỉ mục duy nhất trên view
CREATE UNIQUE CLUSTERED INDEX IX_Contact_rơguid
ON vw_Contact_Info(rowguid) 

--Đổi tên view
EXEC sp_rename vw_Contact_Info , vw_Contact_Infomation 
SELECT * FROM vw_Contact_Infomation

--Không thể thêm bản ghi vào view vì có cột không cho phép NULL trong bảng person
INSERT INTO vw_Contact_Infomation VALUES ('abc','bnm','asd','323')

--Không thể xóa bản ghi của view vì bảng person.person còn có các rằng buộc khóa ngoại.
DELETE FROM vw_Contact_Infomation 
WHERE LastName = 'Gilbert' AND FirstName = 'Guy'

--Phần 2: BT Tự làm.
--tạo 1 CSDL:
CREATE DATABASE BookManagerSystem;
USE BookManagerSystem
CREATE TABLE Books (
    BookCode int primary key,
	Category varchar(50),
	Author varchar(50),
	Publisher varchar(50),
	Title varchar(100),
	Price int,
	InStore int
)
INSERT INTO Books(BookCode,Category,Author,Publisher,Title,Price,InStore) VALUES
          (1,'literature','JoinSmith','TK Group','contemporary literature..',50,1000),
		  (2,'horror','SperteKing','TK Group','In the dark..',60,2000),
		  (3,'Love','DatlingMJ','ForEve','Edless LOVE story..',90,5000),
		  (4,'detective','JoinSmith','TK Group','one of serlockHomles story..',30,4000),
		  (5,'horror','DatNguyen','TK Group','Holiday nightmare..',50,1000)
		  
GO


CREATE TABLE BookSold (
    BookSoldID int primary key,
	CustomerID int references Customerss(CustomerID) ,
	BookCode int references Books(BookCode),
	Date datetime,
	Price int,
	Amount int,
)
INSERT INTO BookSold(BookSoldID,CustomerID,BookCode,Date,Price,Amount) VALUES 
       (1010,50,1,'2023-08-05',50,9),
       (1000,10,1,'2023-09-05',50,5),
	   (1001,10,3,'2023-09-04',90,2),
	   (1002,20,2,'2023-09-05',60,3),
	   (1003,20,4,'2023-09-05',30,2),
	   (1004,30,1,'2023-09-03',50,1),
	   (1005,30,5,'2023-09-03',50,4),
	   (1006,40,5,'2023-09-02',50,4),
	   (1007,40,2,'2023-09-03',60,2),
	   (1008,50,4,'2023-09-01',30,6),
	   (1009,50,3,'2023-09-02',90,9)
GO

CREATE TABLE Customerss (
    CustomerID int primary key,
	CustomerName varchar(50),
	Address varchar(100),
	Phone varchar(12)
)
INSERT INTO Customerss(CustomerID,CustomerName,Address,Phone) VALUES 
       (10,'Peter Parker','101-102St-NewYork','0123456789'),
	   (20,'Joker','10-1St-NewYork','0145782129'),
	   (30,'Batman','45-102St-NewYork','011092837'),
	   (40,'OptimusPrime','09-78St-NewYork','012343459'),
	   (50,'Deceptiocon','100St-NewYork','012329987')
GO

--Tạo một khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã
--bán được của mỗi cuốn sách.
CREATE VIEW vw_Book_Info_Amount AS
SELECT b.BookCode,b.Title,b.Price,bs.Amount FROM Books as b
JOIN BookSold as bs ON b.BookCode = bs.BookCode
GO

--Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm
--theo số lượng các cuốn sách mà khách hàng đó đã mua.
CREATE VIEW vw_Customers_Info AS
SELECT c.CustomerID,c.CustomerName,c.Address,SUM(bs.Amount) AS TotalAmountBooks FROM Customerss as c
JOIN BookSold as bs ON c.CustomerID = bs.CustomerID
GROUP BY c.CustomerID,c.CustomerName,c.Address
GO

--Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) đã
--mua sách vào tháng trước, kèm theo tên các cuốn sách mà khách hàng đã mua.
CREATE VIEW vw_Customers_Info_BuyBookLastMonth AS
SELECT c.CustomerID,c.CustomerName,c.Address,b.Category,SUM(bs.Amount) AS TotalAmountBooks FROM Customerss as c
JOIN BookSold as bs ON c.CustomerID = bs.CustomerID
JOIn Books as b ON b.BookCode = bs.BookCode
GROUP BY c.CustomerID,c.CustomerName,c.Address,b.Category
GO

--Tạo một khung nhìn chứa danh sách các khách hàng kèm theo tổng tiền mà mỗi khách hàng đã chi cho việc mua sách.
CREATE VIEW vw_TotalPrice_Customers AS
SELECT c.CustomerName,SUM(bs.Price * bs.Amount) AS TotalPrice FROM Customerss as c
JOIN BookSold as bs ON c.CustomerID = bs.CustomerID
JOIn Books as b ON b.BookCode = bs.BookCode
GROUP BY c.CustomerName
GO