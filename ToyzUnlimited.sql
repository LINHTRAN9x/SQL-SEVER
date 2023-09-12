--Phan 2 : TOYUNLIMITED
CREATE DATABASE ToyzUnlimited;
USE ToyzUnlimited;

delete toyHandle;
SELECT * FROM toyHandle;
CREATE TABLE toyHandle(
    ProductCode varchar(5) PRIMARY KEY,
    Name VARCHAR(30),
    Category VARCHAR(30),
    Manufacturer VARCHAR(40),
    AgeRange VARCHAR(15),
    UnitPrice money,
    Netweight int,
    QtyOnHand int
)
INSERT INTO toyHandle(ProductCode,Name,Category,Manufacturer,AgeRange,UnitPrice,Netweight,QtyOnHand) VALUES
   ('T01','GUNDAMZ66','Mo Hinh','GundamNippon','3-12',300000,600,50),
   ('T02', 'Robot-X', 'Mo Hinh', 'TechToys', '4-10', 450000, 750, 25),
   ('T03', 'SuperCar 3000', 'Xe Dien', 'SpeedyToys', '5-12', 750000, 1200, 15),
   ('T04', 'Barbie Dream House', 'Bup Be', 'Mattel', '3-10', 1200000, 1800, 30),
   ('T05', 'Football Pro', 'The Thao', 'SportsWorld', '8-16', 350000, 450, 40),
   ('T06', 'Science Lab Kit', 'Do Choi Thong Minh', 'EduToys', '10+', 550000, 800, 20),
   ('T07', 'Dollhouse', 'Bup Be', 'TinyTowns', '3-8', 950000, 1600, 12),
   ('T08', 'Remote Control Helicopter', 'May Bay Dieu Khien', 'SkyHigh', '8-14', 850000, 900, 18),
   ('T09', 'Chess Set', 'Tro Choi Co Vua', 'StrategicGames', '6+', 650000, 1200, 22),
   ('T10', 'Art Supplies Kit', 'Do Choi Ve Tran', 'CreativeCrafts', '5+', 550000, 950, 28),
   ('T11', 'Wooden Train Set', 'Do Choi Go', 'WoodenWonders', '3-7', 750000, 1800, 15),
   ('T12', 'Puzzle Adventure Game', 'Tro Choi Giai Đố', 'BrainyGames', '8-12', 550000, 850, 20),
   ('T13', 'Musical Keyboard', 'Duong Cam', 'MelodyMakers', '4-10', 950000, 1600, 10),
   ('T14', 'Remote Control Car', 'O To Dieu Khien', 'Speedsters', '6-12', 850000, 900, 15),
   ('T15', 'Plush Stuffed Animal', 'Do Choi Bup Be', 'CuddleCritters', '3-8', 650000, 1200, 28);
GO

--Viết câu lệnh tạo Thủ tục lưu trữ có tên là HeavyToys cho phép liệt kê tất cả các loại đồ chơi có
--trọng lượng lớn hơn 500g.
CREATE PROCEDURE HeavyToys
 @weight INT
AS 
SELECT * FROM toyHandle
WHERE Netweight = @weight AND @weight > 500;
GO
ALTER PROCEDURE HeavyToys
AS 
SELECT * FROM toyHandle
WHERE Netweight > 500;
GO
EXEC HeavyToys

--Viết câu lệnh tạo Thủ tục lưu trữ có tên là PriceIncrease cho phép tăng giá của tất cả các loại đồ
--chơi lên thêm 10 đơn vị giá.
CREATE PROCEDURE sp_PriceIncrease 
AS BEGIN
    UPDATE toyHandle
    SET UnitPrice = UnitPrice + 10;
   END;
GO
EXEC sp_PriceIncrease

--Viết câu lệnh tạo Thủ tục lưu trữ có tên là QtyOnHand làm giảm số lượng đồ chơi còn trong của
--hàng mỗi thứ 5 đơn vị.
CREATE PROCEDURE sp_QtyOnHand
AS BEGIN
     UPDATE toyHandle
     SET QtyOnHand = QtyOnHand - 5;
   END
GO
exec sp_QtyOnHand
--Thực thi 3 thủ tục lưu trữ trên
CREATE PROCEDURE sp_toyAllInOne
AS BEGIN
      EXEC HeavyToys
      EXEC sp_PriceIncrease
      EXEC sp_QtyOnHand
    END
GO
EXEC sp_toyAllInOne

--PHẦN 3: BÀI TẬP VỀ NHÀ ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--1. Ta đã có 3 thủ tục lưu trữ tên là HeavyToys,PriceIncrease, QtyOnHand. Viết các câu lệnh xem
--Định Nghĩa của các thủ tục trên dùng 3 cách sau:
exec sp_helptext 'HeavyToys'
SELECT definition FROM sys.sql_modules
SELECT OBJECT_DEFINITION(OBJECT_ID('HeavyToys')) AS DEFINITION

--Viết câu lệnh hiển thị các đối tượng phụ thuộc của mỗi thủ tục lưu trữ trên.
sp_depends 'HeavyToys'
sp_depends 'sp_PriceIncrease'
sp_depends 'sp_QtyOnHand'
GO

--Chỉnh sửa thủ tục PriceIncrease và QtyOnHand thêm câu lệnh cho phép hiển thị giá trị mới đã
--được cập nhật của các trường (UnitPrice,QtyOnHand).
CREATE PROCEDURE sp_PriceIncrease 
AS BEGIN
    UPDATE toyHandle
    SET UnitPrice = UnitPrice + 10;
    
    SELECT Name,
          CAST(UnitPrice AS NVARCHAR(255)) AS NewUnitPrice
    FROM toyHandle;
END;
GO
---------------------------------------------------
ALTER PROCEDURE sp_QtyOnHand 
AS BEGIN
    UPDATE toyHandle
    SET QtyOnHand = QtyOnHand - 5;
    SELECT Name,
          + CAST(QtyOnHand AS NVARCHAR(255)) AS NewQtyOnHand
    FROM toyHandle;
END;
GO
EXEC sp_QtyOnHand
EXEC sp_PriceIncrease

--Viết câu lệnh tạo thủ tục lưu trữ có tên là SpecificPriceIncrease thực hiện cộng thêm tổng số sản
--phẩm (giá trị trường QtyOnHand)vào giá của sản phẩm đồ chơi tương ứng.
ALTER PROCEDURE SpecificPriceIncrease
AS
BEGIN
    -- Khai báo biến để lưu giá trị tổng số sản phẩm (QtyOnHand).
    DECLARE @TotalQtyOnHand INT;

    -- Lấy tổng số sản phẩm từ bảng toyHandle.
    SELECT @TotalQtyOnHand = QtyOnHand
    FROM toyHandle;

    -- Kiểm tra xem có dữ liệu không trước khi thực hiện cập nhật.
    IF @TotalQtyOnHand IS NOT NULL
       BEGIN
        -- Cập nhật giá của sản phẩm đồ chơi.
        UPDATE toyHandle
        SET UnitPrice = UnitPrice + @TotalQtyOnHand;

        -- Hiển thị thông tin cập nhật cho từng sản phẩm.
        SELECT Name AS 'Product Name', UnitPrice AS 'New Unit Price'
        FROM toyHandle;

       END
    ELSE
      BEGIN
        -- Nếu không có dữ liệu, in thông báo.
        PRINT 'No data available for price update.';
      END
END;
EXEC SpecificPriceIncrease
drop PROCEDURE SpecificPriceIncrease

--Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho thêm tính năng trả lại tổng số các bản ghi được cập nhật
ALTER PROCEDURE SpecificPriceIncrease
AS
BEGIN
    -- Khai báo biến để lưu giá trị tổng số sản phẩm (QtyOnHand).
    DECLARE @TotalQtyOnHand INT;
    DECLARE @TotalUpdate int;
    -- Lấy tổng số sản phẩm từ bảng toyHandle.
    SELECT @TotalQtyOnHand = QtyOnHand
    FROM toyHandle;

    -- Kiểm tra xem có dữ liệu không trước khi thực hiện cập nhật.
    IF @TotalQtyOnHand IS NOT NULL
       BEGIN
        -- Cập nhật giá của sản phẩm đồ chơi.
        UPDATE toyHandle
        SET UnitPrice = UnitPrice + @TotalQtyOnHand;
        --
        SELECT @TotalUpdate = COUNT(UnitPrice)
        FROM toyHandle
        PRINT N'tổng số các bản ghi được cập nhật: ' + CAST(@TotalUpdate AS NVARCHAR(30))
        -- Hiển thị thông tin cập nhật cho từng sản phẩm.
        SELECT Name AS 'Product Name', UnitPrice AS 'New Unit Price'
        FROM toyHandle;

       END
    ELSE
      BEGIN
        -- Nếu không có dữ liệu, in thông báo.
        PRINT 'No data available for price update.';
      END
END;

--Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho phép gọi thủ tục HeavyToysbên trong nó
ALTER PROCEDURE SpecificPriceIncrease
AS
BEGIN
    -- Khai báo biến để lưu giá trị tổng số sản phẩm (QtyOnHand).
    DECLARE @TotalQtyOnHand INT;
    DECLARE @TotalUpdate int;
    -- Lấy tổng số sản phẩm từ bảng toyHandle.
    SELECT @TotalQtyOnHand = QtyOnHand
    FROM toyHandle;

    -- Kiểm tra xem có dữ liệu không trước khi thực hiện cập nhật.
    IF @TotalQtyOnHand IS NOT NULL
       BEGIN
        -- Cập nhật giá của sản phẩm đồ chơi.
        UPDATE toyHandle
        SET UnitPrice = UnitPrice + @TotalQtyOnHand;
        --
        SELECT @TotalUpdate = COUNT(UnitPrice)
        FROM toyHandle
        PRINT N'tổng số các bản ghi được cập nhật: ' + CAST(@TotalUpdate AS NVARCHAR(30))
        -- Hiển thị thông tin cập nhật cho từng sản phẩm.
        SELECT Name AS 'Product Name', UnitPrice AS 'New Unit Price'
        FROM toyHandle;

        --gọi thủ tục HeavyToysbên trong nó
        EXEC HeavyToys

       END
    ELSE
      BEGIN
        -- Nếu không có dữ liệu, in thông báo.
        PRINT 'No data available for price update.';
      END
END;
EXEC SpecificPriceIncrease

--Thực hiện điều khiển xử lý lỗi cho tất cả các thủ tục lưu trữ được tạo ra.
ALTER PROCEDURE HeavyToys
AS BEGIN
    begin TRY
        SELECT * FROM toyHandle
        WHERE Netweight > 500;
    END TRY
    BEGIN CATCH
     PRINT N'Co loi xay ra!!!' 
    END CATCH  
  END;
GO

ALTER PROCEDURE sp_PriceIncrease 
AS BEGIN
    BEGIN TRY
     UPDATE toyHandle
     SET UnitPrice = UnitPrice + 10;
    END TRY
    BEGIN CATCH
      PRINT N'Co loi xay ra' 
    END CATCH
   END;
GO

ALTER PROCEDURE sp_QtyOnHand
AS BEGIN
    BEGIN TRY
     UPDATE toyHandle
     SET QtyOnHand = QtyOnHand - 5;
    END TRY
    BEGIN CATCH
      PRINT N'Co loi xay ra' 
    END CATCH  
   END;
GO

ALTER PROCEDURE SpecificPriceIncrease
AS BEGIN
    BEGIN TRY
    -- Khai báo biến để lưu giá trị tổng số sản phẩm (QtyOnHand).
    DECLARE @TotalQtyOnHand INT;
    DECLARE @TotalUpdate int;
    -- Lấy tổng số sản phẩm từ bảng toyHandle.
    SELECT @TotalQtyOnHand = QtyOnHand
    FROM toyHandle;

    -- Kiểm tra xem có dữ liệu không trước khi thực hiện cập nhật.
    IF @TotalQtyOnHand IS NOT NULL
       BEGIN
        -- Cập nhật giá của sản phẩm đồ chơi.
        UPDATE toyHandle
        SET UnitPrice = UnitPrice + @TotalQtyOnHand;
        --
        SELECT @TotalUpdate = COUNT(UnitPrice)
        FROM toyHandle
        PRINT N'tổng số các bản ghi được cập nhật: ' + CAST(@TotalUpdate AS NVARCHAR(30))
        -- Hiển thị thông tin cập nhật cho từng sản phẩm.
        SELECT Name AS 'Product Name', UnitPrice AS 'New Unit Price'
        FROM toyHandle;

        --gọi thủ tục HeavyToysbên trong nó
        EXEC HeavyToys

       END
    ELSE
      BEGIN
        -- Nếu không có dữ liệu, in thông báo.
        PRINT 'No data available for price update.';
      END
    END TRY
    BEGIN CATCH
     PRINT N'Co loi xay ra!!!'  
    END CATCH
END;
GO

ALTER PROCEDURE sp_toyAllInOne
AS BEGIN
    BEGIN TRY
      EXEC HeavyToys
      EXEC sp_PriceIncrease
      EXEC sp_QtyOnHand
    END TRY
    BEGIN CATCH
      PRINT N'Co loi xay ra!!'
    END CATCH  
  END;
GO

--Xóa bỏ tất cả các thủ tục lưu trữ đã được tạo ra
DROP PROCEDURE HeavyToys;
DROP PROCEDURE sp_PriceIncrease;
DROP PROCEDURE sp_QtyOnHand;
DROP PROCEDURE sp_toyAllInOne;
DROP PROCEDURE SpecificPriceIncrease;

SELECT * FROM sys.procedures;
