USE [master]
GO
/****** Object:  Database [TicketsDB]    Script Date: 23-02-2023 14:39:41 ******/
CREATE DATABASE [TicketsDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TicketsDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS02\MSSQL\DATA\TicketsDB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TicketsDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS02\MSSQL\DATA\TicketsDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [TicketsDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TicketsDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TicketsDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TicketsDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TicketsDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TicketsDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TicketsDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TicketsDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TicketsDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TicketsDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TicketsDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TicketsDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TicketsDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TicketsDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TicketsDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TicketsDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TicketsDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TicketsDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TicketsDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TicketsDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TicketsDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TicketsDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TicketsDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TicketsDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TicketsDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TicketsDB] SET  MULTI_USER 
GO
ALTER DATABASE [TicketsDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TicketsDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TicketsDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TicketsDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TicketsDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TicketsDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [TicketsDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [TicketsDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TicketsDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GetUnsolvedTicketsCount]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUnsolvedTicketsCount]()
RETURNS int
AS
BEGIN
  DECLARE @Cnt int

	 SELECT @cnt = COUNT(*) FROM Tickets
	 WHERE status_id <> 4
	 ORDER BY COUNT(*) ;

  RETURN @cnt
END

GO
/****** Object:  Table [dbo].[Users]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NULL,
	[email_id] [varchar](70) NOT NULL,
	[phone_no] [varchar](12) NULL,
	[city_id] [int] NULL,
	[picture] [varbinary](max) NULL,
	[user_type] [varchar](30) NOT NULL,
	[password] [varchar](30) NOT NULL,
	[reg_date] [date] NULL,
	[last_modified] [date] NULL,
	[address] [varchar](300) NULL,
	[zip_code] [varchar](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetManagers]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetManagers]()
RETURNS TABLE AS 
RETURN
SELECT user_id AS ID, CONCAT(first_name,' ',last_name) AS Name, email_id  FROM Users 
	 WHERE user_type = 'manager'
GO
/****** Object:  Table [dbo].[Properties]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Properties](
	[property_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](70) NOT NULL,
	[description] [varchar](800) NULL,
	[reg_date] [date] NULL,
	[last_modified] [date] NULL,
	[address] [varchar](300) NULL,
	[zip_code] [varchar](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[property_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tickets](
	[ticket_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[subject] [varchar](70) NOT NULL,
	[description] [varchar](800) NULL,
	[property_id] [int] NOT NULL,
	[priority] [int] NULL,
	[status_id] [int] NOT NULL,
	[date] [date] NULL,
	[assigned_to] [int] NULL,
	[last_modified] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_SolvedTickets]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_SolvedTickets] AS
SELECT ticket_id , CONCAT(first_name,' ',last_name) AS 'Raised by', subject, 
       T.description,P.name AS 'Property Name'
FROM Tickets T
INNER JOIN Users U
ON T.user_id = U.user_id
INNER JOIN Properties P
ON T.property_id = P.property_id
WHERE status_id = 4;
GO
/****** Object:  View [dbo].[V_PendingTickets]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_PendingTickets] AS
SELECT ticket_id , CONCAT(first_name,' ',last_name) AS 'Raised by', subject, 
       T.description,P.name AS 'Property Name'
FROM Tickets T
INNER JOIN Users U
ON T.user_id = U.user_id
INNER JOIN Properties P
ON T.property_id = P.property_id
WHERE status_id <> 4;
GO
/****** Object:  Table [dbo].[Areas]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Areas](
	[zip_code] [varchar](7) NOT NULL,
	[area_name] [varchar](70) NOT NULL,
	[city_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[zip_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[city_id] [int] IDENTITY(1,1) NOT NULL,
	[city] [varchar](70) NOT NULL,
	[country_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[city_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[country_id] [int] IDENTITY(1,1) NOT NULL,
	[country] [varchar](70) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[department_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](70) NOT NULL,
	[description] [varchar](800) NULL,
	[last_modified] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[user_id] [int] NOT NULL,
	[dept_id] [int] NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[dept_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedbacks]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedbacks](
	[feedback_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[ticket_id] [int] NULL,
	[feedback] [varchar](800) NULL,
	[feedback_date] [date] NULL,
	[last_modified] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[feedback_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Images]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Images](
	[image_id] [int] IDENTITY(1,1) NOT NULL,
	[image_name] [varchar](100) NULL,
	[path] [varbinary](max) NULL,
	[ticket_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[image_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Status]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[status_id] [int] IDENTITY(1,1) NOT NULL,
	[status] [varchar](70) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Feedbacks] ADD  DEFAULT (getdate()) FOR [feedback_date]
GO
ALTER TABLE [dbo].[Properties] ADD  DEFAULT (getdate()) FOR [reg_date]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [reg_date]
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_AreaCity] FOREIGN KEY([city_id])
REFERENCES [dbo].[Cities] ([city_id])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_AreaCity]
GO
ALTER TABLE [dbo].[Cities]  WITH CHECK ADD  CONSTRAINT [FK_CityCountry] FOREIGN KEY([country_id])
REFERENCES [dbo].[Countries] ([country_id])
GO
ALTER TABLE [dbo].[Cities] CHECK CONSTRAINT [FK_CityCountry]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDept] FOREIGN KEY([dept_id])
REFERENCES [dbo].[Departments] ([department_id])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_EmployeeDept]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeUser] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_EmployeeUser]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackTicket] FOREIGN KEY([ticket_id])
REFERENCES [dbo].[Tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_FeedbackTicket]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackUser] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_FeedbackUser]
GO
ALTER TABLE [dbo].[Images]  WITH CHECK ADD  CONSTRAINT [FK_ImageTicket] FOREIGN KEY([ticket_id])
REFERENCES [dbo].[Tickets] ([ticket_id])
GO
ALTER TABLE [dbo].[Images] CHECK CONSTRAINT [FK_ImageTicket]
GO
ALTER TABLE [dbo].[Properties]  WITH CHECK ADD  CONSTRAINT [FK_PropertiesArea] FOREIGN KEY([zip_code])
REFERENCES [dbo].[Areas] ([zip_code])
GO
ALTER TABLE [dbo].[Properties] CHECK CONSTRAINT [FK_PropertiesArea]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_PropertyTicket] FOREIGN KEY([property_id])
REFERENCES [dbo].[Properties] ([property_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_PropertyTicket]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_TicketEmployee] FOREIGN KEY([assigned_to])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_TicketEmployee]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_TicketStatus] FOREIGN KEY([status_id])
REFERENCES [dbo].[Status] ([status_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_TicketStatus]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_UserTicket] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_UserTicket]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_UserCity] FOREIGN KEY([city_id])
REFERENCES [dbo].[Cities] ([city_id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_UserCity]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_UsersArea] FOREIGN KEY([zip_code])
REFERENCES [dbo].[Areas] ([zip_code])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_UsersArea]
GO
/****** Object:  StoredProcedure [dbo].[P_RAISE_TICKET]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_RAISE_TICKET] ( @uid int, @sub VARCHAR(70), @desc VARCHAR(200), @deptid int, @propid int)
AS
  BEGIN
      INSERT INTO Tickets(user_id,subject,description,dept_id,property_id,status_id) 
                  VALUES(@uid,@sub,@desc,@deptid,@propid,1);
  END

GO
/****** Object:  StoredProcedure [dbo].[P_USERUPDATE]    Script Date: 23-02-2023 14:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_USERUPDATE] ( @uid int, @fname VARCHAR(50), @lname VARCHAR(50), @mail VARCHAR(70))
AS
  BEGIN
      UPDATE Users SET first_name=@fname, last_name=@lname,email_id=@mail WHERE user_id=@uid;
  END
GO
USE [master]
GO
ALTER DATABASE [TicketsDB] SET  READ_WRITE 
GO
