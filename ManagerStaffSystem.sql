CREATE DATABASE ManagerStaffSystem;
USE ManagerStaffSystem;

SELECT * FROM PhongBan;
CREATE TABLE PhongBan(
   MaPB varchar(7) PRIMARY KEY,
   TenPB nvarchar(50)
);
INSERT INTO PhongBan(MaPB,TenPB) VALUES (1,'MAKETING'),(2,'SALES TEAM'),(3,'DESIGN'),(4,'MANAGER'),(5,'PRODUCTS')
GO

delete NhanVien;
SELECT * FROM NhanVien;
CREATE TABLE NhanVien(
   MaNV varchar(7) PRIMARY KEY,
   TenNV nvarchar(50),
   NgaySinh datetime CHECK (NgaySinh < GETDATE()),
   SoCMND char(9) CHECK (SoCMND NOT LIKE '%[^0-9]%'),
   GioiTinh char(1) DEFAULT 'M' CHECK (GioiTinh IN ('M', 'F')),
   DiaChi nvarchar(100),
   NgayVaoLam datetime,
   MaPB varchar(7),
   FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB)
)
CREATE TRIGGER CheckNgayVaoLam
ON NhanVien
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.NgayVaoLam <= DATEADD(YEAR, 20, i.NgaySinh)
    )
    BEGIN
        THROW 50000, 'NgayVaoLam must be greater than NgaySinh + 20 years.', 1;
    END
END;
INSERT INTO NhanVien(MaNV,TenNV,NgaySinh,SoCMND,GioiTinh,DiaChi,NgayVaoLam,MaPB) VALUES 
           (10,N'TRẦN THỊ THU','1992/09/25','264789274','F',N'56-ST HÀ NỘI','2020/05/11',1),
		   (11,N'TRẦN VĂN THUẬN','1993/01/15','265831274','M',N'562-STR HÀ NỘI','2022/01/21',1),
		   (20,N'NGUYỄN THƯƠNG KÍCH','1995/01/25','128864772','M',N'51-TR HÀ NỘI','2019/05/11',2),
		   (21,N'TRỊNH THU HƯƠNG','1994/06/25','264789785','F',N'56-ST HÀ NỘI','2022/12/11',2),
		   (30,N'NGHUYỄN HOÀNG LONG','1990/09/21','117289274','M',N'12-HT HÀ NỘI','2018/11/01',3),
		   (31,N'LƯƠNG VĂN QUYẾT','1994/04/29','264269274','M',N'56-HT HÀ NỘI','2019/04/01',3),
		   (40,N'LƯƠNG THỊ TUYẾT','1996/09/25','124789074','F',N'4673-THY HÀ NỘI','2020/01/10',3),
		   (1,N'NGUYỄN THU TRANG','1996/03/11','264336674','F',N'562-ST3 HÀ NỘI','2023/01/21',4),
		   (50,N'TRẦN HÒA LẠC','1997/12/12','223142274','M',N'56E-SDSD HÀ NỘI','2022/08/18',5),
		   (51,N'HỒ HƯƠNG HIẾU','1997/12/01','187275597','M',N'23-T HÀ NỘI','2023/07/12',5)
GO

SELECT * FROM LuongDA;
CREATE TABLE LuongDA(
   MaDA varchar(8) ,
   MaNV varchar(7) ,
   NgayNhan datetime NOT NULL DEFAULT GETDATE(),
   SoTien money CHECK (SoTien > 0),
   PRIMARY KEY(MaDA,MaNV),
   FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
INSERT INTO LuongDA(MaDA,MaNV,NgayNhan,SoTien) values 
                 ('XDX01',10,'2023/01/11',12000000),
				 ('XDX01',20,'2023/01/11',12000000),
				 ('XDX02',11,'2023/06/01',15000000),
				 ('XDX02',21,'2023/06/01',15000000),
				 ('DXD02',30,'2023/05/12',17000000),
				 ('DXD02',50,'2023/05/12',17000000),
				 ('XDX03',31,'2023/03/21',20000000),
				 ('XDX03',51,'2023/03/21',20000000)

GO

SELECT * FROM NhanVien WHERE GioiTinh = 'F';
go
--Hiển thị tổng lương của từng nhân viên (dùng mệnh đề GROUP BY).
SELECT n.TenNV,SUM(l.SoTien) FROM LuongDA AS l
JOIN NhanVien AS n ON n.MaNV = l.MaNV
GROUP BY n.TenNV ;
GO

--Hiển thị tất cả các nhân viên trên một phòng ban sales.
SELECT p.TenPB , n.TenNV FROM PhongBan AS p
JOIN NhanVien AS n ON n.MaPB = p.MaPB
WHERE p.MaPB = 2;
GO
--Hiển thị mức lương của những nhân viên phòng sales.
SELECT p.TenPB, n.TenNV,SUM(l.SoTien) AS LUONG FROM PhongBan as p
JOIN NhanVien AS n ON n.MaPB = p.MaPB
JOIN LuongDA AS l ON n.MaNV = l.MaNV
WHERE p.MaPB = 2
GROUP by p.TenPB,n.TenNV
GO
--Hiển thị số lượng nhân viên của từng phòng.
SELECT p.TenPB, COUNT(n.MaNV) AS SoLuongNhanVien
FROM PhongBan AS p
LEFT JOIN NhanVien AS n ON p.MaPB = n.MaPB
GROUP BY p.TenPB;
GO
--Viết một query để hiển thị những nhân viên mà tham gia ít nhất vào một dự án.
SELECT n.TenNV, COUNT(l.MaDA) AS SoDuAnThamGia
FROM NhanVien AS n
LEFT JOIN LuongDA AS l ON n.MaNV = l.MaNV
GROUP BY n.TenNV
HAVING COUNT(l.MaDA) > 0;
GO
--Viết một query hiển thị phòng ban có số lượng nhân viên nhiều nhất.
SELECT TOP 1 p.TenPB,COUNT(l.MaNV) AS SoLuongNhanVen FROM PhongBan AS p
JOIN NhanVien AS l ON l.MaPB = p.MaPB
GROUP BY p.TenPB
ORDER BY COUNT(l.MaNV) DESC
GO
--Tính tổng số lượng của các nhân viên trong phòng Sales.
SELECT p.TenPB,COUNT(n.MaNV) AS TOngSoLuongNV FROM PhongBan AS p
JOIN NhanVien AS n ON n.MaPB = p.MaPB
WHERE p.MaPB = 2 
GROUP BY p.TenPB
GO
--Hiển thị tống lương của các nhân viên có số CMND tận cùng bằng 7;
SELECT n.SoCMND , SUM(l.SoTien) AS TongLuong FROM NhanVien AS n
JOIN LuongDA AS l ON l.MaNV = n.MaNV
WHERE n.SoCMND LIKE ('%7')
GROUP BY n.SoCMND
GO
--Tìm nhân viên có số lương cao nhất.
SELECT TOP 2 n.TenNV, SUM(l.SoTien) AS LuongCaoNHat FROM NhanVien AS n
JOIN LuongDA AS l ON l.MaNV = n.MaNV
GROUP BY N.TenNV 
ORDER BY SUM(l.SoTien) DESC
GO
--Tìm nhân viên ở phòng sales có giới tính bằng ‘F’ và có mức lương > 1200000.
SELECT p.TenPB, n.TenNV,n.GioiTinh,l.SoTien FROM PhongBan AS p
JOIN NhanVien AS n ON n.MaPB = p.MaPB
JOIN LuongDA AS l ON l.MaNV = n.MaNV
WHERE n.GioiTinh = 'F' AND l.SoTien > 1200000 AND p.MaPB = 2
GO
--Tìm tổng lương trên từng phòng.
SELECT p.TenPB, SUM(l.SoTien) AS TongLuong FROM PhongBan AS p
JOIN NhanVien AS n ON n.MaPB = p.MaPB
JOIN LuongDA AS l ON l.MaNV = n.MaNV
GROUP BY p.TenPB
GO
--Liệt kê các dự án có ít nhất 2 người tham gia.
SELECT l.MaDA, COUNT(n.MaNV) AS SoNguoiThamGia FROM LuongDA AS l
JOIN NhanVien AS n ON n.MaNV = l.MaNV
GROUP BY l.MaDA
HAVING COUNT(n.MaNV) >=2
GO
-- Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’.
SELECT * FROM NhanVien
WHERE TenNV LIKE ('N%')
GO
--Hiển thị thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2023.
SELECT n.TenNV, n.NgaySinh, n.SoCMND, l.NgayNhan, l.SoTien
FROM NhanVien AS n
JOIN LuongDA AS l ON n.MaNV = l.MaNV
WHERE YEAR(l.NgayNhan) = 2023;
GO
--Hiển thị thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào.
SELECT n.TenNV, n.NgaySinh, n.SoCMND,n.MaNV,n.GioiTinh,n.DiaChi,n.SoCMND,n.NgayVaoLam
FROM NhanVien AS n
LEFT JOIN LuongDA AS l ON n.MaNV = l.MaNV
WHERE l.MaDA IS NULL ;
GO
--Xoá dự án có mã dự án là DXD02.\
DELETE FROM LuongDA
WHERE MaDA = 'DXD02';
GO
--Xoá đi từ bảng LuongDA những nhân viên có mức lương 2000000.
DELETE FROM LuongDA
WHERE SoTien = 20000000
GO
--Cập nhật lại lương cho những người tham gia dự án XDX01 thêm 10% lương cũ.
UPDATE LuongDA
SET SoTien = SoTien * 1.1
WHERE MaDA = 'XDX01';
GO
--Xoá các bản ghi tương ứng từ bảng NhanVien đối với những nhân viên không có mã nhân viên tồn tại trong bảng LuongDA\
DELETE FROM NhanVien
WHERE NOT EXISTS (
    SELECT 1
    FROM LuongDA
    WHERE NhanVien.MaNV = LuongDA.MaNV
);
GO
--Viết một truy vấn đặt lại ngày vào làm của tất cả các nhân viên thuộc phòng sales là ngày 12/02/1999
UPDATE NhanVien
SET NgayVaoLam = '1999-02-12'
WHERE MaPB = 2;
--err: NgayVaoLam must be greater than NgaySinh + 20 years.