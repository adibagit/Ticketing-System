--------------------------------------------  DDL  --------------------------------------------  
CREATE DATABASE TicketsDB;

CREATE TABLE Cities(
	city_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	city VARCHAR(70) NOT NULL,
	zip_code  VARCHAR(7),
	country VARCHAR(70) 
);

CREATE TABLE Users(
	user_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50),
	email_id VARCHAR(70) NOT NULL UNIQUE,
	phone_no VARCHAR(12),
	city_id INT,
	picture VARBINARY(MAX),
	user_type VARCHAR(30) NOT NULL,
	password VARCHAR(30) NOT NULL,
	reg_date DATE DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT FK_UserCity FOREIGN KEY(city_id)
    REFERENCES Cities(city_id)
);

CREATE TABLE Properties(
	property_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(70) NOT NULL,
	description VARCHAR(200),
	city_id INT,
	picture VARBINARY(MAX),
	reg_date DATE DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT FK_PropertyCity FOREIGN KEY(city_id)
    REFERENCES Cities(city_id)
);

CREATE TABLE Departments(
	department_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(70) NOT NULL,
	location VARCHAR(70),
	description varchar(200),
	phone_no VARCHAR(12)
);

CREATE TABLE Tickets(
	ticket_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	subject VARCHAR(70) NOT NULL,
	description VARCHAR(200),
	dept_id int NOT NULL,
	property_id int NOT NULL,
	picture VARBINARY(MAX),
	priority int,
	status VARCHAR(50) NOT NULL,
	date DATE DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT FK_UserTicket FOREIGN KEY(user_id)
    REFERENCES Users(user_id),
	CONSTRAINT FK_DeptTicket FOREIGN KEY(dept_id)
    REFERENCES Departments(department_id),
	CONSTRAINT FK_PropertyTicket FOREIGN KEY(property_id)
    REFERENCES Properties(property_id)
);

--------------------------------------------  DML  -------------------------------------------- 

INSERT INTO Cities(city,zip_code,country)
          
VALUES    ('JHB','2193','South Africa'),
          ('Pune','395009','India'),
          ('London','NW10AU','UK');
            
GO


INSERT INTO Departments(name,location,description,phone_no)
          
VALUES    ('Water Supply','Bandra','Department to raise tickets regarding water supply problems','898989883'),
          ('Electricity','Lonavla','Department to raise tickets regarding electricity problems','12829883'),
          ('Garbage','Mumbra','Department to raise tickets regarding garbage problems','7013918291'),
		  ('Maintainance','Andheri','Department to raise tickets regarding maintainance problems','98127382'),
		  ('Equipments','Vasai','Department to raise tickets regarding equipments problems','11192032'),
		  ('HR','Surat','Department to raise tickets regarding human resource problems','5561828812'),
		  ('Service','Khandala','Department to raise tickets regarding services problems','271672632'),
		  ('Nighbours','Udhna','Department to raise tickets regarding neighbours problems','981928121');
            
GO



INSERT INTO Properties(name,description,city_id)
          
VALUES      ('Shalimar Fortleza','A HIGH RISE LUXURY DEVELOPMENT, PROMISING A WORLD CLASS LIFESTYLE.',2),
			('Mirchandani Enclave','Coming soon',1),
			('Triton','A building dedicated to showcasing a lifestyle focused on community building and pure opulence',5),
			('Sunshine Villas','Year of Completion: 2007,Size: 325000 sq. ft. , Configuration: Villas',3),
			('Premium Towers','Year of Completion: 2016, Size: 592000 sq. ft., Configuration: 3 & 4 BHK Homes',2),
			('Shalimar Seven Gardens','Year of Completion: 2008, Size: 270000 sq. ft., : Row Houses',5),
			('Adibas Bunglow Park','Year of Completion: 2002, Size: 240000 sq. ft., Configuration: Row Houses',1);
            
GO


INSERT INTO Users(first_name,last_name,email_id,phone_no,city_id,user_type,password)
          
VALUES     ('Adiba','Siddiqui','adiba012@gmail.com','9016941931',2,'admin','kartik@012'),
		   ('Habiba','Siddiqui','habba@gmail.com','898192891',3,'manager','habba123'),
		   ('Kartik','Verma','vermag@gmail.com','9814345198',2,'manager','adiba@012'),
		   ('John','Smith','johnas@gmail.com','66677172',5,'user','johnas1'),
		   ('Daniel','Denis','ddaniel@gmail.com','11188281',4,'user','dd1234'),
		   ('Kevin','Costner','kevincos@yahoo.com','67628121',2,'manager','kevin2'),
		   ('Mary','McDonnell','mcmarrie@gmail.com','2221213',2,'user','marry20'),
		   ('Sigourney','Weaver','siggweav198@yahoo.com','92827323',2,'user','sigg222'),
		   ('Michael','Biehn','beihn754@gmail.com','7616212',2,'user','binnn90'),
		   ('Paul','Reiser','paulr999@gmail.com','091821221',2,'manager','paul9090'),
		   ('Lance','Henriksen','lancy23@gmail.com','01883133',2,'user','mancy6'),
		   ('Bill','Paxton','billll000@outlook.com','213232321',2,'user','mybilliszero'),
		   ('Daryl','Hannah','darylh@bbd.co.za','9898989898',2,'user','hannawahito');
            
GO



INSERT INTO Tickets(user_id,subject,description,dept_id,property_id,status)
          
VALUES     (4,'Water Sink Problem ','Dust has been stucked into water pipeline',1,5,'new'),
           (11,'Smelling Problem','Too much garbage near Gate-2',3,7,'solved'),
		   (8,'Watchman','Last night watchman was not present at front gate',8,10,'in process');
            
GO



--------------------------------------------  SPs  -------------------------------------------- 

1. 
CREATE PROCEDURE P_RAISE_TICKET ( @uid int, @sub VARCHAR(70), @desc VARCHAR(200), @deptid int, @propid int)
AS
  BEGIN
      INSERT INTO Tickets(user_id,subject,description,dept_id,property_id,status) VALUES(@uid,@sub,@desc,@deptid,@propid,'new');
  END


EXEC P_RAISE_TICKET 9, 'Wires ', 'Copper wires were found on wall',2, 7;



2. 
CREATE PROCEDURE P_USERUPDATE ( @uid int, @fname VARCHAR(50), @lname VARCHAR(50), @mail VARCHAR(70))
AS
  BEGIN
      UPDATE Users SET first_name=@fname, last_name=@lname,email_id=@mail WHERE user_id=@uid;
  END

EXEC P_USERUPDATE 2, 'Kartoo', 'Verma', 'karverma@gmail.com';

3.
CREATE PROCEDURE P_DELETECITY ( @cid int)
AS
  BEGIN
      DELETE FROM Cities WHERE city_id=@cid;
  END


EXEC P_DELETECITY 4; 



-------------------------------------------- UDFs  -------------------------------------------- 

1.
CREATE FUNCTION GetUnsolvedTicketsCount()
RETURNS int
AS
BEGIN
  DECLARE @Cnt int

	 SELECT @cnt = COUNT(*) FROM Tickets
	 WHERE status <> 'solved'
	 ORDER BY COUNT(*) ;

  RETURN @cnt
END

GO


SELECT dbo.GetUnsolvedTicketsCount();
 
2.
CREATE FUNCTION GetManagers()
RETURNS TABLE AS 
RETURN
SELECT user_id AS ID, CONCAT(first_name,' ',last_name) AS Name, email_id  FROM Users 
	 WHERE user_type = 'manager'
GO

SELECT * FROM GetManagers();


--------------------------------------------  Views/Reports  -------------------------------------------- 

1.
CREATE VIEW V_SolvedTickets AS
SELECT ticket_id , CONCAT(first_name,' ',last_name) AS 'Raised by', subject, T.description, D.name AS 'Department',P.name AS 'Property Name'
FROM Tickets T
INNER JOIN Users U
ON T.user_id = U.user_id
INNER JOIN Departments D
ON T.dept_id = D.department_id
INNER JOIN Properties P
ON T.property_id = P.property_id
WHERE status = 'solved';


SELECT * FROM V_SolvedTickets ;


2.
CREATE VIEW V_PendingTickets AS
SELECT ticket_id , CONCAT(first_name,' ',last_name) AS 'Raised by', subject, T.description, D.name AS 'Department',P.name AS 'Property Name'
FROM Tickets T
INNER JOIN Users U
ON T.user_id = U.user_id
INNER JOIN Departments D
ON T.dept_id = D.department_id
INNER JOIN Properties P
ON T.property_id = P.property_id
WHERE status <> 'solved';


SELECT * FROM V_PendingTickets ;

--------------------------------------------------------------------------------------------------------- 
