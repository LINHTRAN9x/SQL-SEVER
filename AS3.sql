CREATE DATABASE AS3
USE AS3
DROP DATABASE AS3
SELECT * FROM userInfo
CREATE TABLE userInfo(
   userID int primary key,
   name Nvarchar(255),
   scmt int unique,
   address Nvarchar(255)
)
INSERT INTO userInfo(userID,name,scmt,address) VALUES 
               (30,N'Lương Thế Vinh',0982127456,N'Hà Nội'),
               (20,N'Trần Văn Linh',023456789,N'Hà Nội'),
               (10,N'Nguyễn Nguyệt Nga',123456789,N'Hà Nội')
GO
DELETE refPhone
SELECT * FROM refPhone
CREATE TABLE refPhone(
   phoneNum varchar(90) primary key,
   userID int,
   typeNum Nvarchar(255),
   refDay date
   FOREIGN KEY (userID) REFERENCES userInfo(userID)
)
ALTER TABLE refPhone
ALTER COLUMN phoneNum varchar(25)

exec sp_helpconstraint 'phoneNum'
ALTER TABLE refPhone
DROP CONSTRAINT refPhone

INSERT INTO refPhone(phoneNum,userID,typeNum,refDay) VALUES
          (923131313,30,N'Trả Trước','2023-11-09'),
          (0982127456,30,N'Trả Trước','2023-11-09'),
         (023456789,20,N'Trả Trước','2023-11-09'),
         (123456789,10,N'Trả Trước','2023-11-09')
GO

--Hiển thị toàn bộ thông tin của thê bao số : 023456789.
SELECT r.phoneNum,u.* FROM refPhone as r
JOIN userInfo as u ON r.userID = u.userID
WHERE r.phoneNum = 023456789
--Hiển thị toàn bộ thông tin của khách hàng có số CMTND: 123456789.
SELECT * FROM userInfo 
WHERE scmt = 123456789
--Hiển thị toàn bộ các số thuê bao của khách hàng có số  CMTND : 123456789.
SELECT u.scmt,r.phoneNum FROM userInfo as u
JOIN refPhone as r On u.userID = r.userID
WHERE u.scmt  = 123456789
--Liệt kê các thuê bao đăng kí vào ngày 11/09/23.
SELECT refDay,phoneNum  FROM refPhone
WHERE refDay = '11-09-23'
--Liệt kê các thuê bao có địa chỉ tạo Hà Nội 
SELECT u.address, r.phoneNum  FROM userInfo as u
JOIN refPhone as r ON u.userID = r.userID
WHERE u.address = N'Hà Nội'
--Tổng số khách hàng của công ty
SELECT COUNT(name) AS TongSoKhachHang FROM userInfo
--Tổng số thuê bao của công ty
SELECT COUNT(phoneNum) AS TongSoThueBao FROM refPhone
--Tổng số thuê bao đăng kí ngày 11/09/23
SELECT COUNT(phoneNum) AS TongSoThueBao FROM refPhone
WHERE refDay = '11-09-23'
--Hiển thi thông tin về khách hàng và thuê bao của tất cả các số thuê bao.
SELECT * FROM userInfo
JOIN refPhone ON userInfo.userID = refPhone.userID
--Viết câu lệnh thay đổi trường ngày đăng kí là not null.
ALTER TABLE refPhone
ALTER COLUMN refDay DATE NOT NULL;
----Viết câu lệnh thay đổi trường ngày đăng kí là trước hoặc bằng ngày hiện tại
UPDATE refPhone
SET refDay = GETDATE()
WHERE refDay >= GETDATE();
--Viết câu lệnh thay đổi SĐT phải bắt đầu 09
UPDATE refPhone
SET phoneNum = '09' + SUBSTRING(phoneNum, 3, LEN(phoneNum))
--thêm cột điểm thưởng cho mỗi số thuê bao
ALTER TABLE refPhone
ADD DiemThuong int

UPDATE refPhone
SET DiemThuong = 10
WHERE phoneNum LIke ('09%')