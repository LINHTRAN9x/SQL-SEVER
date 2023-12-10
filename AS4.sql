CREATE DATABASE AS4 
USE AS4
SELECT * FROM productss
CREATE TABLE productss(
   productID varchar(255) primary key,
   cus_code int, 
   name Nvarchar(255),
   productCode varchar(255),
   productDate date,
   FOREIGN KEY (cus_code) REFERENCES customer(cus_code)
)
INSERT INTO productss(productID,cus_code,name,productCode,productDate) VALUES 
             ('N37 444444',987688,N'Đồ chơi robot','Z37E','09-09-08'),
             ('N37 333333',987688,N'Máy la bàn T21','Z37E','09-09-09'),
             ('N37 222222',987688,N'Máy Ủi Panasonic200','Z37E','10-10-09'),
             ('N37 111111',987688,N'Máy tính sách tay Z37','Z37E','12-12-09')
GO

CREATE TABLE customer(
    cus_code int primary key,
	name Nvarchar(255)
)
INSERT INTO customer(cus_code,name) VALUES
         (787688,N'Trần văn Linh'),
         (887688,N'Trịnh Công Sơn'),
        (987688,N'Nguyễn Văn An')
GO

--Liệt kê danh sách loại sản phẩm của công ty
SELECT name FROM productss
----Liệt kê danh sách sản phẩm của công ty
--Liệt kê danh sách người chịu trách nhiệm của công ty
SELECT name as NguoiChiuTranhNhiem FROM customer
--Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
SELECT name FROM productss
ORDER BY name ASC
--Liệt kê danh sách người chịu tn theo thứ tự tăng dần của tên
SELECT name as NguoiChiuTranhNhiem FROM customer
ORDER BY name ASC
--Liệt kê danh sách các sản phẩm của loại sản phẩm có mã số là Z37E
SELECT name FROM productss
WHERE productCode = 'Z37E'
--Liệt kê các sản phẩm Nguyễn Văn An chịu trách nhiệm theo thứ tự giảm dần
SELECT c.name, p.name as SanPhamChiuTrachNhiem FROM customer as c
JOIN productss as p ON c.cus_code = p.cus_code
WHERE c.name = N'Nguyễn Văn An'
ORDER BY p.name DESC
--Số sản phẩm của từng loại sản phẩm
SELECT productCode,COUNT(name) AS SoSanPham FROM productss 
GROUP BY productCode
--Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm
SELECT * FROM productss
----Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm,người chịu tn
SELECT * FROM customer as c
JOIN productss as p ON c.cus_code = p.cus_code
--Viết câu lệnh để thay đỏi trường ngày xản xuất là trước hoặc bằng ngày hiện tại
UPDATE Productss
SET productDate = GETDATE()
WHERE productDate <= GETDATE();
----Viết các câu lệnh để xác định khóa chính ,khóa phụ của các bảng
EXEC sp_pkeys 'productss';
EXEC sp_pkeys 'customer';
--khóa phụ
SELECT
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    col.name AS ForeignKeyColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTableName,
    col_ref.name AS ReferencedColumn
FROM
    sys.foreign_keys AS fk
INNER JOIN
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN
    sys.columns AS col ON fkc.parent_object_id = col.object_id AND fkc.parent_column_id = col.column_id
INNER JOIN
    sys.columns AS col_ref ON fkc.referenced_object_id = col_ref.object_id AND fkc.referenced_column_id = col_ref.column_id;
