USE AdventureWorks2019;

CREATE PROCEDURE sp_DisplayEmployeesHireYear
      @HireYear INT
AS
SELECT * FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
GO

EXECUTE sp_DisplayEmployeesHireYear 2009

Create PROCEDURE sp_EmployeesHireYearCount
 @HireYear int,
 @Count int OUTPUT
 AS
 SELECT @Count=COUNT(*) FROM HumanResources.Employee
 WHERE DATEPART(YY , HireDate) = @HireYear
 GO
 DECLARE @Number INT
EXECUTE sp_EmployeesHireYearCount 2009,@Number Output
PRINT @Number

CREATE TABLE #Students(
    RollNo VARCHAR(6) CONSTRAINT fk_Students PRIMARY KEY,
    FullName NVARCHAR(100),
    Birthday DATETIME CONSTRAINT DF_StudentsBirthday DEFAULT DATEADD(YY, -18, getdate())
)
GO

CREATE PROCEDURE #spInsertStudents
 @rollNo VARCHAR(6),
 @fullName NVARCHAR(100),
 @birthday DATETIME
AS BEGIN
      IF(@birthday is null)
           SET @birthday = DATEADD(YY, -18, GETDATE())
      INSERT into #Students(RollNo,FullName,Birthday) VALUES 
             (@rollNo,@fullName,@birthday)
    END    
GO 

EXEC #spInsertStudents 'A12345','abc',null
EXEC #spInsertStudents 'A54321','abc','2011-12-24'
select * from #Students

create PROCEDURE #spDeleteStudents
  @rollNo VARCHAR(6)
AS BEGIN
   DELETE FROM #Students Where RollNo = @rollNo
   END
GO
EXEC #spDeleteStudents 'A12345'   

CREATE PROCEDURE Cal_Square 
 @num int=0 
AS BEGIN
      RETURN (@num * @num);
   END
GO
DECLARE @square int;
EXEC @square = Cal_Square 10;
PRINT @square; --=100;

--Xem định nghĩa thủ tục lưu trữ bằng hàm OBJECT_DEFINITION
SELECT
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalI
nfo')) AS DEFINITION

SELECT definition FROM sys.sql_modules
WHERE
object_id=OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO

--Thủ tục lưu trữ hệ thống xem các thành phần mà thủ tục lưu trữ phụ thuộc
sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO

--Tạo thủ tục lưu trữ sp_DisplayEmployees
CREATE PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
GO
--Thay đổi thủ tục lưu trữ sp_DisplayEmployees
ALTER PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
EXEC sp_DisplayEmployees

--Xóa một thủ tục lưu trữ
DROP PROCEDURE sp_DisplayEmployees
GO

--tong hop
CREATE PROCEDURE sp_EmployeesHire
AS BEGIN
    EXECUTE sp_DisplayEmployeesHireYear 2009
    DECLARE @Number INT
    EXECUTE sp_EmployeesHireYearCount 2009,@Number output
    PRINT N'Số nhân viên vào làm năm 2009 là: '+ CONVERT(VARCHAR(3),@Number)
   END
GO
EXEC sp_EmployeesHire

--Thay đổi thủ tục lưu trữ sp_EmployeeHire có khối TRY ... CATCH
ALTER PROCEDURE sp_EmployeesHire
 @HireYear int
AS BEGIN
       BEGIN TRY
              EXECUTE sp_DisplayEmployeesHireYear @HireYear
              DECLARE @Number int
              EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT
              PRINT N'Số nhân viên vào làm năm là: ' +CONVERT(varchar(3),@Number)
        END TRY
        BEGIN CATCH
              PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
        END CATCH
        PRINT N'Kết thúc thủ tục lưu trữ'
    END 
GO   
EXEC sp_EmployeesHire 2009     

--Thay đổi thủ tục lưu trữ sp_EmployeeHire sử dụng hàm @@ERROR
ALTER PROCEDURE sp_EmployeeHire
 @HireYear int
AS BEGIN
       EXECUTE sp_DisplayEmployeesHireYear @HireYear
       DECLARE @Number int
       --Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ
       --truyền 2 tham số mà ta truyền 3
       EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT,'123'
       IF @@ERROR <> 0
               PRINT  N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
        PRINT N'Số nhân viên vào làm năm là: ' + CONVERT(varchar(3),@Number)
    END
GO
EXEC sp_EmployeesHire 2009