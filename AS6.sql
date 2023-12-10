CREATE database AS6
USE AS6

select * from books 
delete books 
CREATE TABLE books(
    bookID varchar(255) PRIMARY KEY,
    bookName NVARCHAR(255),
    tacgiaID int,
    tomtat NVARCHAR(max),
    NamXuatBan int,
    LanXuatBan int,
    MaNXB int,
    GiaBan money,
    SoLuong int,
    MaLoaiSach int,
    FOREIGN KEY (MaNXB) REFERENCES NhaXuatBan(MaNXB),
    FOREIGN KEY (MaLoaiSach) REFERENCES LoaiSach(MaLoaiSach),
    FOREIGN KEY (tacgiaID) REFERENCES tacgia(MaTacGia)
)
INSERT INTO books(bookID,bookName,tacgiaID,tomtat,NamXuatBan,LanXuatBan,MaNXB,GiaBan,SoLuong,MaLoaiSach) VALUES
    ('B001',N'Trí tuệ do Thái',5,N'Bạn có muốn biết...',2010,1,10,79000,100,100),
    ('B002',N'Thiên Đàng',5,N'Bạn có muốn biết...',2011,1,10,99000,100,200),
	('B003',N'Hell',6,N'the hell coming for you..',2008,2,10,666666,66,300)

CREATE TABLE tacgia(
    MaTacGia int primary key,
    TenTacGia nvarchar(255) not null
)
INSERT INTO tacgia(MaTacGia,TenTacGia) VALUES (5,'Eran Katz'),(6,'Perte Park')

CREATE TABLE LoaiSach (
    MaLoaiSach int primary key,
    TenLoaiSach nvarchar(255) not null
);
INSERT into LoaiSach(MaLoaiSach,TenLoaiSach) VALUES
    (100,N'Khoa học xã hội'),
    (200,N'Tiểu thuyết'),
	(300,N'Viễn Tửơng')

CREATE TABLE NhaXuatBan (
    MaNXB int primary key,
    TenNXB nvarchar(255) not null,
    DiaChi nvarchar(255)
);
INSERT INTO NhaXuatBan(MaNXB,TenNXB,DiaChi) VALUES 
     (10,N'Tri Thức',N'53 Nguyễn Du,Hai bà trưng,Hà Nội')
GO

--liệt kê các các cuốn sách có năm xuất bản từ 2008 đến nay
SELECT bookName FROM books 
WHERE NamXuatBan >= 2008 
--Liệt kê 10 cuốn có giá bán cao nhất
SELECT bookName,GiaBan FROM books
ORDER BY GiaBan DESC
--Tìm những cuốn sách có tiêu đề chứa từ 'tin học'
SELECT bookName FROM books
WHERE bookName like (N'%Trí%')
--Liệt kê các cuốn sách có tên bắt đầu vs chữ 'T' theo thứ tự giá giảm dần
SELECT bookName,GiaBan FROM books 
WHERE bookName like ('T%')
ORDER BY GiaBan DESC
--liệt kê các cuốn sách của NXB Tri Thức
SELECT n.TenNXB ,b.bookName FROM NhaXuatBan as n
Left JOIN books as b ON n.MaNXB = b.MaNXB
--Lấy thông tin chi tiết về NXB cuốn sách 'Trí tuệ DO Thái'
SELECT b.bookName ,n.TenNXB,n.DiaChi FROM books as b
JOIN NhaXuatBan as n ON b.MaNXB = n.MaNXB
WHERE b.bookName = N'Trí tuệ Do Thái'
--Hiển thị các thông tin sau về  các cuốn sách:Mã,tên sách,nawmXB,NXB,Loại sách.
SELECT b.bookID,b.bookName,b.NamXuatBan,n.TenNXB,l.TenLoaiSach FROM books as b
JOIN NhaXuatBan as n ON b.MaNXB = n.MaNXB
JOIN LoaiSach as l on b.MaLoaiSach = l.MaLoaiSach
--Tìm cuốn sách có giá bán đắt nhất
SELECT TOP 1 bookName,GiaBan as GiaBanDatNhat from books 
ORDER BY GiaBan DESC
--Tìm cuốn sách có số lượng lớn nhất trong kho
SELECT TOP 1 bookName,SoLuong as SoLuongLonNhat FROM books  
ORDER BY SoLuong DESC
--Tìm các cuốn sách của tác giả 'Eran Katz'
SELECT t.TenTacGia,b.bookName FROM books as b
JOIN tacgia as t ON b.tacgiaID = t.MaTacGia
WHERE t.TenTacGia = 'Eran Katz'
--Giản giá bán 10% các cuốn sách xuất bản từ năm 2008 về trước
UPDATE books
SET GiaBan = GiaBan * 0.9
WHERE NamXuatBan <= 2009;
--Thống kê đầu sách của mỗi NXB
SELECT n.TenNXB,COUNT(b.bookName) as TongSoDauSach FROM NhaXuatBan as n 
JOIN books as b ON n.MaNXB = b.MaNXB
GROUP BY n.TenNXB
--THống kê số đầu sách của mỗi loại sách
SELECT l.TenLoaiSach,COUNT(b.bookName) AS TongSoDauSach FROM LoaiSach as l
JOIN books as b ON l.MaLoaiSach = b.MaLoaiSach
GROUP BY l.TenLoaiSach
--