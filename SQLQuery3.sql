CREATE DATABASE Example5
GO
USE Example5

DROP TABLE Lophoc;
CREATE TABLE Category(
   ID int PRIMARY KEY IDENTITY,
   Name NVARCHAR(10)
)
GO

EXEC sp_rename 'Category.Name', 'Type', 'COLUMN';


SELECT * FROM Category;
INSERT INTO Category(Name) VALUES ('HE')
INSERT INTO Category(Name) VALUES ('LP')
UPDATE Category SET Name = 'CAT'
  WHERE Name= 'HE'
  UPDATE Category SET Name = 'DOG'
  WHERE Name= 'LP'
DELETE FROM Lophoc WHERE MaLopHoc = 1002
GO

DROP TABLE Sinhvien;
CREATE TABLE Product(
   ID int PRIMARY KEY,
   Name nvarchar(250),
   Price NVARCHAR(255),
   cat_id int,
   CONSTRAINT FR FOREIGN KEY (Cat_id) REFERENCES Category(ID) 
)


INSERT INTO Product(ID, Name, Price,cat_id) VALUES (1,'perter','$250',1);
INSERT INTO Product(ID, Name, Price,cat_id) VALUES (3,'helpa','$900',1);
INSERT INTO Product(ID, Name, Price,cat_id) VALUES (14,'aTTE','$1728',1),(16,'ERTWWW','$19',1);

update Product SET cat_id = 2 where ID = 16
SELECT s.Type, l.Price ,l.Name FROM Category AS s
INNER JOIN Product as l ON s.ID = l.cat_id
SELECT * FROM Category;
SELECT * FROM Product;
go


