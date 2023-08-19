CREATE DATABASE BookLibrary
USE BookLibrary;
GO
CREATE TABLE Book(
    BookCode int PRIMARY KEY IDENTITY,
	BookTitle varchar(100) NOT NULL,
	Author varchar(50) NOT NULL,
	Edition int,
	BookPrice money ,
	Copies int
)
INSERT INTO Book(BookTitle,Author,Edition,BookPrice,Copies) VALUES ('The mountan','Perter','2',20.99,2001);
INSERT INTO Book(BookTitle,Author,Edition,BookPrice,Copies) VALUES ('The Bunker','Jack','20',10.99,10004);
INSERT INTO Book(BookTitle,Author,Edition,BookPrice,Copies) VALUES ('Fall in Love','Hesalina','87',78.43,100992);
INSERT INTO Book(BookTitle,Author,Edition,BookPrice,Copies) VALUES ('RAIN','Hminton','87',100.43,100992);
INSERT INTO Book(BookTitle,Author,Edition,BookPrice,Copies) VALUES ('Myseft','Blinton','87',1200.43,102);
SELECT * FROM Book;
DROP TABLE Book;
--Bổ sung thêm Ràng buộc giá bán sách > 0 và < 200
ALTER TABLE Book
ADD CHECK (BookPrice < 200 AND BookPrice > 0);
--Xóa bỏ khóa chính hiện có.
ALTER TABLE Book 
DROP PRIMARY KEY;
GO

CREATE TABLE Member(
    MemberCode int PRIMARY KEY,
	Name varchar(50) NOT NULL,
	Address varchar(100) NOT NULL,
	PhoneNumber int
)
INSERT INTO Member(MemberCode,Name,Address,PhoneNumber) VALUES(10,'Nolan','122-TR.stress-London',0982543782);
INSERT INTO Member(MemberCode,Name,Address,PhoneNumber) VALUES(20,'Nohman','19-LKY.stress-London',0297716542);
INSERT INTO Member(MemberCode,Name,Address,PhoneNumber) VALUES(30,'Jackson','998-VNB.stress-London',0296578943);
INSERT INTO Member(MemberCode,Name,Address,PhoneNumber) VALUES(40,'Hame','23-TYY.stress-London',0128966544);
SELECT * FROM Member;
--Xóa khóa chính hiện có và thêm mới khóa chính vào cột PhoneNumber.
ALTER TABLE Member
DROP PRIMARY KEY;
ALTER TABLE Member
ADD PRIMARY KEY (PhoneNumber);
GO

CREATE TABLE IssueDetails (
    BookCode int,
    MemberCode int,
    IssueDate datetime,
    ReturnDate datetime,
    CONSTRAINT fk1 FOREIGN KEY (BookCode) REFERENCES Book(BookCode),
    CONSTRAINT fk2 FOREIGN KEY (MemberCode) REFERENCES Member(MemberCode)
);
INSERT INTO IssueDetails(BookCode,MemberCode,IssueDate,ReturnDate) VALUES (1,10,'2023/09/11','2023/09/12');
INSERT INTO IssueDetails(BookCode,MemberCode,IssueDate,ReturnDate) VALUES (2,20,'2023/08/11','2023/09/12');
INSERT INTO IssueDetails(BookCode,MemberCode,IssueDate,ReturnDate) VALUES (4,30,'2023/01/21','2023/04/12');
INSERT INTO IssueDetails(BookCode,MemberCode,IssueDate,ReturnDate) VALUES (3,40,'2023/02/01','2023/02/17');
INSERT INTO IssueDetails(BookCode,MemberCode,IssueDate,ReturnDate) VALUES (1,20,'2023/03/11','2023/08/22');
--Bổ sung thêm ràng buộc NOT NULL cho BookCode, MemberCode 
ALTER TABLE IssueDetails
ALTER COLUMN BookCode int NOT NULL;
ALTER TABLE IssueDetails
ALTER COLUMN MemberCode int NOT NULL;

--Tạo khóa chính gồm 2 cột BookCode, MemberCode cho bảng IssueDetails
ALTER TABLE IssueDetails
ADD CONSTRAINT primarykey PRIMARY KEY(BookCode, MemberCode);

--Xóa bỏ và thêm mới các Ràng buộc Khóa ngoại của bảng IssueDetails
ALTER TABLE IssueDetails
DROP CONSTRAINT fk1;
ALTER TABLE IssueDetails
DROP CONSTRAINT fk2;
ALTER TABLE IssueDetails
ADD CONSTRAINT fk1 FOREIGN KEY (BookCode) REFERENCES Book(BookCode);
ALTER TABLE IssueDetails
ADD CONSTRAINT fk2 FOREIGN KEY (MemberCode) REFERENCES Member(MemberCode);


SELECT * FROM IssueDetails;
DROP TABLE IssueDetails;
GO

--Hiển thị ra lần lượt tên sách,tác giả,giá sách,tên và mã thành viên mượn sách,thời gian mượn và trả lại sách.
SELECT b.BookTitle,b.Author, b.BookPrice,m.MemberCode, m.Name, i.IssueDate, i.ReturnDate 
FROM Book AS b 
JOIN IssueDetails AS i ON i.BookCode = b.BookCode
JOIN Member AS m ON m.MemberCode = i.MemberCode;



