CREATE DATABASE AS5
USE AS5

SELECT * FROM userInfo;
CREATE TABLE userInfo(
   userID int primary key,
   name Nvarchar(255),
   address Nvarchar(255),
   brithday date
)
INSERT INTO userInfo(userID,name,address,brithday) VALUES 
             (20,N'Trần Văn Linh',N'Hà Nội','12-12-09'),
             (10,N'Nguyễn Văn An',N'111 Nguyễn Trãi,Thanh Xuân,Hà Nội','11-18-87')
GO

CREATE TABLE phoneAdd(
   userID int,
   phoneNumber int,
   FOREIGN KEY (userID) REFERENCES	userInfo(userID)
)
INSERT INTO phoneAdd(userID,phoneNumber) VALUES 
         (20,098723457),
         (10,987654321),
		 (10,09873452),
		 (10,09832323),
		 (10,09434343)

GO
--Liệt kê danh sách người và số đt,có tên Nguyễn Văn An.
SELECT u.name,p.phoneNumber FROM userInfo as u
JOIN phoneAdd as p ON u.userID = p.userID
WHERE u.name = N'Nguyễn Văn An'
--Liệt kê những người có ngày sinh là 12/12/09
SELECT * from userInfo
JOIN phoneAdd as p ON p.userID = userInfo.userID
WHERE brithday = '12-12-09'
--Tìm số lượng số điện thoại của mỗi ng trong danh bạ
SELECT u.name,COUNT(p.phoneNumber) AS SoluongSDT FROM userInfo as u
JOIN phoneAdd as p ON p.userID = u.userID
GROUP BY u.name
--Tìm tổng số người trong danh bạ sinh vào tháng 12
SELECT COUNT(*) AS TongSoNguoiSinhThang12
FROM userInfo
WHERE MONTH(brithday) = 12;
--Hiển thị toàn bộ thông tin về người,của từng số đt
SELECT p.phoneNumber,u.* FROM phoneAdd as p
JOIN userInfo as u ON u.userID = p.userID
--Hiển thị toàn bộ thông tin về người,của sđt 098723457
SELECT p.phoneNumber,u.* FROM phoneAdd as p
JOIN userInfo as u ON u.userID = p.userID
WHERE p.phoneNumber = 098723457
--viết các câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại
UPDATE userInfo
SET brithday = DATEADD(DAY, -1, brithday)
WHERE brithday > GETDATE();
--Viết các câu lệnh để xác định khóa chính ,khóa phụ của các bảng
EXEC sp_pkeys 'userInfo';
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

--Viết câu lệnh để thêm trường ngày liên lạc
ALTER TABLE userInfo
ADD NgayBatDauLienLac date




