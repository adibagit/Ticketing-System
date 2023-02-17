USE [TicketsDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GetUnsolvedTicketsCount]    Script Date: 17-02-2023 13:56:34 ******/
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
	 WHERE status <> 'solved'
	 ORDER BY COUNT(*) ;

  RETURN @cnt
END

GO
/****** Object:  Table [dbo].[Departments]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[department_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](70) NOT NULL,
	[location] [varchar](70) NULL,
	[description] [varchar](200) NULL,
	[phone_no] [varchar](12) NULL,
PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 17-02-2023 13:56:34 ******/
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
/****** Object:  Table [dbo].[Properties]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Properties](
	[property_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](70) NOT NULL,
	[description] [varchar](200) NULL,
	[city_id] [int] NULL,
	[picture] [varbinary](max) NULL,
	[reg_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[property_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tickets](
	[ticket_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[subject] [varchar](70) NOT NULL,
	[description] [varchar](200) NULL,
	[dept_id] [int] NOT NULL,
	[property_id] [int] NOT NULL,
	[picture] [varbinary](max) NULL,
	[priority] [int] NULL,
	[status] [varchar](50) NOT NULL,
	[date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_PendingTickets]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_PendingTickets] AS
SELECT ticket_id , CONCAT(first_name,' ',last_name) AS 'Raised by', subject, T.description, D.name AS 'Department',P.name AS 'Property Name'
FROM Tickets T
INNER JOIN Users U
ON T.user_id = U.user_id
INNER JOIN Departments D
ON T.dept_id = D.department_id
INNER JOIN Properties P
ON T.property_id = P.property_id
WHERE status <> 'solved';
GO
/****** Object:  UserDefinedFunction [dbo].[GetManagers]    Script Date: 17-02-2023 13:56:34 ******/
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
/****** Object:  View [dbo].[V_SolvedTickets]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_SolvedTickets] AS
SELECT ticket_id , CONCAT(first_name,' ',last_name) AS 'Raised by', subject, T.description, D.name AS 'Department',P.name AS 'Property Name'
FROM Tickets T
INNER JOIN Users U
ON T.user_id = U.user_id
INNER JOIN Departments D
ON T.dept_id = D.department_id
INNER JOIN Properties P
ON T.property_id = P.property_id
WHERE status = 'solved';
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[city_id] [int] IDENTITY(1,1) NOT NULL,
	[city] [varchar](70) NOT NULL,
	[zip_code] [varchar](7) NULL,
	[country] [varchar](70) NULL,
PRIMARY KEY CLUSTERED 
(
	[city_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Properties] ADD  DEFAULT (getdate()) FOR [reg_date]
GO
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [reg_date]
GO
ALTER TABLE [dbo].[Properties]  WITH CHECK ADD  CONSTRAINT [FK_PropertyCity] FOREIGN KEY([city_id])
REFERENCES [dbo].[Cities] ([city_id])
GO
ALTER TABLE [dbo].[Properties] CHECK CONSTRAINT [FK_PropertyCity]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_DeptTicket] FOREIGN KEY([dept_id])
REFERENCES [dbo].[Departments] ([department_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_DeptTicket]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_PropertyTicket] FOREIGN KEY([property_id])
REFERENCES [dbo].[Properties] ([property_id])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_PropertyTicket]
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
/****** Object:  StoredProcedure [dbo].[P_DELETECITY]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_DELETECITY] ( @cid int)
AS
  BEGIN
      DELETE FROM Cities WHERE city_id=@cid;
  END
GO
/****** Object:  StoredProcedure [dbo].[P_RAISE_TICKET]    Script Date: 17-02-2023 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_RAISE_TICKET] ( @uid int, @sub VARCHAR(70), @desc VARCHAR(200), @deptid int, @propid int)
AS
  BEGIN
      INSERT INTO Tickets(user_id,subject,description,dept_id,property_id,status) VALUES(@uid,@sub,@desc,@deptid,@propid,'new');
  END
GO
/****** Object:  StoredProcedure [dbo].[P_USERUPDATE]    Script Date: 17-02-2023 13:56:34 ******/
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
