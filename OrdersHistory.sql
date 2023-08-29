CREATE database ordersHistory
USE OrdersHistory
GO

SELECT * FROM Orderss
delete Orderss
CREATE TABLE Orderss (
     orderID int primary key,
	 customerID int ,
	 order_date date,
	 status Nvarchar(255)
	 FOREIGN KEY (customerID) REFERENCES Customer(customerID)
)
--ADD thêm cột mới
ALTER TABLE Orderss
ADD Order_date1 datetime;
--cập nhật dữ liệu từ cột cũ order_date sang cột mới Order_date1. Sử dụng hàm CAST để chuyển đổi từ kiểu date sang datetime:
UPDATE Orderss
SET Order_date1 = CAST(order_date AS datetime);
--Xóa cột order_date.
ALTER TABLE Orderss
DROP COLUMN order_date;
--ĐỔi tên Order_date1 thành order_date.
EXEC sp_rename 'Orderss.Order_date1', 'order_date', 'COLUMN';


INSERT INTO Orderss(orderID,customerID,order_date,status) VALUES
          (123,10,'09/18/11','ON')
GO


SELECT * FROM Customer
CREATE TABLE Customer (
     customerID int primary key,
	 name Nvarchar(255),
	 address Nvarchar(255),
	 tel bigint,
     status Nvarchar(255)
)
INSERT INTO Customer(customerID,name,address,tel,status) VALUES 
              (10,N'Nguyễn Văn An',N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội',987654321,N'Level 1')
GO


SELECT * FROM OrdersDetails
delete OrdersDetails
CREATE TABLE OrdersDetails (
     orderID int,
	 productID int,
	 price money,
	 qty int,
	 FOREIGN KEY (orderID) REFERENCES Orderss(orderID),
	 FOREIGN KEY (productID) REFERENCES Productss(productID)
)
INSERT INTO OrdersDetails(orderID,productID,price,qty) VALUES
          (123,1,1000,1),
		  (123,2,200,2),
		  (123,3,100,1)
GO

SELECT * FROM Productss
CREATE TABLE Productss (
   productID int primary key,
   name Nvarchar(255),
   description Nvarchar(25),
   unit Nvarchar(25),
   price money,
   qty int,
   status Nvarchar(255)
)

INSERT INTO Productss(productID,name,description,unit,price,qty,status) VALUES
          (1,N'Máy tính T450',N'Máy nhập mới',N'Chiếc',1000,1,N'Còn Hàng'),
		  (2,N'Điện thoại Nokia5670',N'Điện thoại đang hot',N'Chiếc',200,2,N'Còn Hàng'),
		  (3,N'Máy In Samsung 450',N'Máy in đang ế',N'Chiếc',100,1,N'Còn Hàng')
--Cập nhật lại số lượng sản phẩm.
UPDATE Productss
SET qty = 10
WHERE productID = 1;
UPDATE Productss
SET qty = 100
WHERE productID = 3;
GO
--Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua.
--& Tổng tiền của từng đơn hàng
SELECT o.orderID,c.name,p.name,d.price,d.qty ,sum(d.price * d.qty) AS Total FROM Orderss as o
JOIN Customer as c ON o.customerID = c.customerID
JOIN OrdersDetails as d ON o.orderID = d.orderID
JOIN Productss as p ON d.productID = p.productID 
GROUP BY o.orderID,c.name,p.name,d.price,d.qty
GO

SELECT p.name,p.price,p.qty ,SUM(p.price * p.qty) AS Total FROM Productss as p
GROUP BY p.name,p.price,p.qty
--Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần.
SELECT name FROM Productss
ORDER BY price DESC
--Số khách hàng đã mua ở cửa hàng.

--Số mặt hàng mà cửa hàng bán.
--Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0)
ALTER TABLE Productss
ADD CONSTRAINT CHK_PricePositive CHECK (price > 0);
--Viết câu lệnh để thay đổi ngày đặt hàng của khách hàng phải nhỏ hơn ngày hiện tại.
ALTER TABLE Orderss
ADD CONSTRAINT CHK_Datetime CHECK (order_date < GETDATE())
--Viết câu lệnh để thêm trường (ngày xuất hiện) trên thị trường của sản phẩm
ALTER TABLE Productss
ADD release_date date
UPDATE Productss
SET release_date = '2023-08-12'
WHERE productID = 1;
UPDATE Productss
SET release_date = '2023-07-12'
WHERE productID IN (2, 3)
GO

--Đặt chỉ mục (index) cho cột Tên hàng và Người đặt hàng để tăng tốc độ truy vấn dữ liệu trên các cột này.
CREATE INDEX IX_ProductName ON Productss(name)
DROP INDEX IX_Product ON Productss
CREATE INDEX IX_CustomerName ON Customer(name)
EXEC sp_helpindex 'Productss'

GO
/*Xây dựng các view sau đây:
◦ View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại*/
CREATE VIEW View_KhachHang AS 
SELECT name , address , tel FROM Customer;
--◦ View_SanPham với các cột: Tên sản phẩm, Giá bán
CREATE VIEW View_SanPham AS
SELECT name , price FROM Productss;
--◦ View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản phẩm, Số lượng, Ngày mua
CREATE VIEW View_KhachHang_SanPham AS 
SELECT c.name , c.tel, p.name AS productName , od.qty , o.order_date FROM Customer AS c
JOIN Orderss AS o ON o.customerID = c.customerID
JOIN OrdersDetails AS od ON od.orderID = o.orderID
JOIN Productss AS p ON p.productID = od.productID
SELECT * FROM View_KhachHang_SanPham
GO
/* Viết các Store Procedure (Thủ tục lưu trữ) sau:
◦ SP_TimKH_MaKH: Tìm khách hàng theo mã khách hàng*/
CREATE PROCEDURE SP_TimKH_MaKH @makh int AS
SELECT * FROM Customer
WHERE customerID = @makh
EXECUTE SP_TimKH_MaKH 123
--◦ SP_TimKH_MaHD: Tìm thông tin khách hàng theo mã hóa đơn
CREATE PROCEDURE SP_TimKH_MaHD @mahd int AS
SELECT * FROM Customer
JOIN Orderss ON Customer.customerID = Orderss.customerID
WHERE orderID = @mahd
EXECUTE SP_TimKH_MaHD 123
--◦ SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được truyền vào Store.
CREATE PROCEDURE SP_SanPham_MaKH
    @MaKH int
AS
BEGIN
    SELECT p.productID, p.name AS TenSanPham, od.price, od.qty
    FROM OrdersDetails AS od
    JOIN Productss AS p ON od.productID = p.productID
    JOIN Orderss AS o ON od.orderID = o.orderID
    WHERE o.customerID = @MaKH;
END;
EXECUTE SP_SanPham_MaKH 10
