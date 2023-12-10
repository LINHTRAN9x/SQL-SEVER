CREATE DATABASE AS2
USE AS2
select * from company
CREATE TABLE company (
     companyID int primary key,
	 name varchar(255),
	 address varchar(255),
	 tel int,
	 FOREIGN KEY (productID) REFERENCES Productss(productID)
)

INSERT INTO company(companyID,name,address,tel) VALUES
          (123,'Asus','USA',983232)
		  
GO

CREATE TABLE CompanyDetails (
     companyID int,
	 productID int,
	 price money,
	 qty int,
	 FOREIGN KEY (companyID) REFERENCES company(companyID),
	 FOREIGN KEY (productID) REFERENCES Productss(productID)
)
INSERT INTO CompanyDetails(companyID,productID,price,qty) VALUES
          (123,1,1000,10),
		  (123,2,200,200),
		  (123,3,100,100)
GO

CREATE TABLE Productss (
   productID int primary key,
   name Nvarchar(255),
   description Nvarchar(25),
   unit Nvarchar(25),
   price money,
   qty int,
)
INSERT INTO Productss(productID,name,description,unit,price,qty) VALUES
          (1,N'Máy tính T450',N'Máy nhập cũ',N'Chiếc',1000,10),
		  (2,N'Điện thoại Nokia5670',N'Điện thoại đang hot',N'Chiếc',200,200),
		  (3,N'Máy In Samsung 450',N'Máy in đang loại bình',N'Chiếc',100,100)