USE [skills]
GO
/****** Object:  User [dhaval]    Script Date: 5/7/2024 4:12:08 PM ******/
CREATE USER [dhaval] FOR LOGIN [dhaval] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT AUTHORITY\LOCAL SERVICE]    Script Date: 5/7/2024 4:12:08 PM ******/
CREATE USER [NT AUTHORITY\LOCAL SERVICE] FOR LOGIN [NT AUTHORITY\LOCAL SERVICE] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT AUTHORITY\SYSTEM]    Script Date: 5/7/2024 4:12:08 PM ******/
CREATE USER [NT AUTHORITY\SYSTEM] FOR LOGIN [NT AUTHORITY\SYSTEM] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NT AUTHORITY\LOCAL SERVICE]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NT AUTHORITY\LOCAL SERVICE]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NT AUTHORITY\SYSTEM]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [NT AUTHORITY\SYSTEM]
GO
/****** Object:  Table [dbo].[EmployeesSkill]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeesSkill](
	[EmployeeSkillId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[SkillName] [nvarchar](50) NOT NULL,
	[ProficiencyLevel] [nvarchar](max) NOT NULL,
	[IsDelete] [nvarchar](20) NULL,
 CONSTRAINT [PK_EmployeesSkill] PRIMARY KEY CLUSTERED 
(
	[EmployeeSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Department] [nvarchar](max) NULL,
	[Role] [varchar](20) NULL,
	[Password] [varchar](20) NULL,
	[Status] [varchar](20) NULL,
	[IsDelete] [nvarchar](20) NULL,
	[Email] [varchar](255) NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[EmployeeViewData]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EmployeeViewData]
AS
SELECT        dbo.Employees.EmployeeId AS Expr1, dbo.Employees.FirstName AS Expr4, dbo.Employees.Department AS Expr5, dbo.Employees.LastName AS Expr6, dbo.Employees.Role AS Expr7, dbo.Employees.Password AS Expr8, 
                         dbo.Employees.Status AS Expr9, dbo.Employees.IsDelete AS Expr2, dbo.Employees.Email AS Expr10, dbo.EmployeesSkill.EmployeeSkillId AS Expr3, dbo.EmployeesSkill.EmployeeId AS Expr11, 
                         dbo.EmployeesSkill.SkillName AS Expr12, dbo.EmployeesSkill.ProficiencyLevel AS Expr13, dbo.EmployeesSkill.IsDelete AS Expr14
FROM            dbo.Employees INNER JOIN
                         dbo.EmployeesSkill ON dbo.Employees.EmployeeId = dbo.EmployeesSkill.EmployeeId
GO
/****** Object:  UserDefinedFunction [dbo].[f_split]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[f_split] (@String NVARCHAR(4000), @Delimiter NCHAR(1)) RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)
GO
/****** Object:  Table [dbo].[Department]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](20) NULL,
	[Manager] [nvarchar](20) NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([DepartmentId], [DepartmentName], [Manager]) VALUES (1, N'PowerBI', N'Santush Barot')
INSERT [dbo].[Department] ([DepartmentId], [DepartmentName], [Manager]) VALUES (2, N'Salesforce', N'Dhaval Thanki')
INSERT [dbo].[Department] ([DepartmentId], [DepartmentName], [Manager]) VALUES (3, N'QA', N'Sanket Vaidya')
INSERT [dbo].[Department] ([DepartmentId], [DepartmentName], [Manager]) VALUES (4, N'Software Development', N'Dhaval Thanki')
INSERT [dbo].[Department] ([DepartmentId], [DepartmentName], [Manager]) VALUES (5, N'Marketing ', N'Thereza Nadar')
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2040, N'Krish', N'Amin', N'PowerBI', N'Admin', N'MTExMQ==', NULL, N'N', N'krisha@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2041, N'Mallika', N'Trivedi', N'PowerBI', N'Admin', N'MQ==', NULL, N'N', N'mallikat@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2042, N'Yash', N'Desai', N'PowerBI', N'Admin', N'dg==', NULL, N'N', N'yashd@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2043, N'Disha', N'Shah', N'PowerBI', N'Admin', N'ZA==', NULL, N'N', N'dishas@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2044, N'Mitul', N'Patel', N'PowerBI', N'Admin', N'MTExMQ==', NULL, N'N', N'mitulp@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2045, N'Ishaan', N'Joshi', N'PowerBI', N'Admin', N'MQ==', NULL, N'N', N'ishaanj@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2046, N'Shivani', N'Thakkar', N'PowerBI', N'Admin', N'dg==', NULL, N'N', N'shivanit@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2047, N'Mihir', N'Sejpal', N'PowerBI', N'Admin', N'ZA==', NULL, N'N', N'mihirs@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2048, N'Devanshi', N'Patel', N'PowerBI', N'Admin', N'MTExMQ==', NULL, N'N', N'devansh ip@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2049, N'Smit', N'Shah', N'PowerBI', N'Admin', N'MQ==', NULL, N'N', N'smits@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2705, N'Vishal', N'Vaghela', N'DotNet', N'Employee', N'MTExMQ==', NULL, N'N', N'vishalvaghela@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2706, N'1', N'1', N'DotNet', N'Employee', N'MQ==', NULL, N'N', N'1@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2707, N'Varsha', N'Jha', N'DotNet', N'Admin', N'dg==', NULL, N'N', N'v@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2708, N'Dhaval', N'Thanki', N'Salesforce', N'Manager', N'MTExMQ==', NULL, N'N', N'dhaval@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2709, N'Harsh', N'Gohel', N'Director', N'Employee', N'MTExMQ==', NULL, N'N', N'H@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2710, N'Priya', N'Patel', N'QA', N'Employee', N'MTExMQ==', NULL, N'N', N'priyap@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2711, N'Meet', N'Shah', N'QA', N'Employee', N'MQ==', NULL, N'N', N'meets@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2712, N'Jay', N'Mehta', N'QA', N'Employee', N'dg==', NULL, N'N', N'jaym@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2713, N'Kinjal', N'Dave', N'QA', N'Employee', N'ZA==', NULL, N'N', N'kinjald@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2714, N'Disha', N'Parekh', N'QA', N'Employee', N'MTExMQ==', NULL, N'N', N'dishap@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2715, N'Arpit', N'Desai', N'Salesforce', N'Employee', N'MQ==', NULL, N'N', N'arpitd@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2716, N'Jignesh', N'Trivedi', N'Salesforce', N'Employee', N'dg==', NULL, N'N', N'jignesht@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2717, N'Bhavika', N'Raval', N'Salesforce', N'Employee', N'ZA==', NULL, N'N', N'bhavikar@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2718, N'Urvi', N'Patel', N'Salesforce', N'Employee', N'MTExMQ==', NULL, N'N', N'urvip@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2719, N'Mitul', N'Shah', N'Salesforce', N'Employee', N'MQ==', NULL, N'N', N'mituls@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2720, N'Ishaan', N'Pandya', N'DotNet', N'Employee', N'dg==', NULL, N'N', N'ishaanp@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2725, N'Mihir', N'Thakkar', N'Management', N'Admin', N'MTExMQ==', NULL, N'N', N'mihirt@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2726, N'Devanshi', N'Sejpal', N'HR', N'Admin', N'MQ==', NULL, N'N', N'devanshis@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2727, N'Smit', N'Patel', N'QA', N'Admin', N'dg==', NULL, N'N', N'smitp@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2728, N'Avani', N'Shah', N'Salesforce', N'Admin', N'ZA==', NULL, N'N', N'avanis@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2729, N'Jatin', N'Mehta', N'DotNet', N'Admin', N'MTExMQ==', NULL, N'N', N'jatim@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2730, N'Khushi', N'Gajjar', N'Marketing', N'Admin', N'MQ==', NULL, N'N', N'khushig@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2732, N'Malvika', N'Trivedi', N'QA', N'Admin', N'ZA==', NULL, N'N', N'malvikat@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2733, N'Chirag', N'Patel', N'DotNet', N'Admin', N'MTExMQ==', NULL, N'N', N'chirap@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2734, N'Disha', N'Shah', N'Finance', N'Admin', N'MQ==', NULL, N'N', N'dishas@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2735, N'Meet', N'Joshi', N'HR', N'Admin', N'dg==', NULL, N'N', N'meetj@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2738, N'Urvi', N'Gajjar', N'DotNet', N'Admin', N'MQ==', NULL, N'N', N'urvig@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2739, N'Viral', N'Shah', N'DotNet', N'Employee', N'MTExMQ==', NULL, N'N', N'viral@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2740, N'Rohan', N'Vaghela', N'Salesforce', N'Employee', N'MTExMQ==', NULL, N'N', N'rohan@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2742, N'Santush', N'Barot', N'PowerBI', N'Manager', N'MTExMQ==', NULL, N'N', N'santush@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2743, N'Satish', N'Prajapati', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'satish@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2744, N'Kartik', N'Purohit', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'kartik@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2745, N'Kartik', N'Purohit', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'kartiki@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2746, N'Kartik', N'Purohit', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'kartik1i@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2747, N'Kartik', N'Purohit', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'kartik12i@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2748, N'Kartik', N'Purohit', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'kartik132i@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2749, N'Kartik', N'Purohit', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'kartik1322i@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2750, N'Satish', N'Prajapati', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'satish2@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2751, N'Ekta', N'Moliya', N'PowerBI', N'Employee', N'MTExMQ==', NULL, N'N', N'ekta@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2752, N'Sanket', N'Vaidya', N'QA', N'Manager', N'MTExMQ==', NULL, N'N', N'sanket@desototechnologies.com')
INSERT [dbo].[Employees] ([EmployeeId], [FirstName], [LastName], [Department], [Role], [Password], [Status], [IsDelete], [Email]) VALUES (2753, N'Thereza', N'Nadar', N'Marketing ', N'Manager', N'MTExMQ==', NULL, N'N', N'thereza@desototechnologies.com')
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
SET IDENTITY_INSERT [dbo].[EmployeesSkill] ON 

INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (20, 2705, N'C#', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (21, 2705, N'HTML', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (22, 2705, N'JavaScript', N'Intermediate', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (23, 2705, N'Python', N'Expert', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (24, 2706, N'C#', N'Expert', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (25, 2706, N'HTML', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (26, 2706, N'HTML', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (27, 2706, N'HTML', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (28, 2706, N'C', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (29, 2706, N'Angular', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (30, 2706, N'HTML', N'Intermediate', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (31, 2707, N'HTML', N'Intermediate', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (32, 2707, N'HTML', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (33, 2707, N'HTML', N'Beginner', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (34, 2707, N'CSS', N'Beginner', N'Y')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (35, 2708, N'JavaScript', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (36, 2708, N'HTML', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (37, 2707, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (38, 2707, N'CSS', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (39, 2707, N'JavaScript', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (40, 2707, N'Python', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (41, 2707, N'CSS', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (42, 2707, N'Python', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (43, 2707, N'C#', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (44, 2707, N'Python', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (45, 2707, N'C#', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (46, 2707, N'C#', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (47, 2740, N'CSS', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (48, 2740, N'Python', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (49, 2707, N'CSS', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (50, 2742, N'Python', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (51, 2742, N'SQL', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (52, 2743, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (53, 2743, N'Python', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (54, 2742, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (55, 2751, N'C#', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (56, 2751, N'CSS', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (57, 2751, N'Python', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (58, 2707, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (59, 2707, N'Java', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (60, 2707, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (61, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (62, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (63, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (64, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (65, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (66, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (67, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (68, 2707, N'CSS', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (69, 2707, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (70, 2707, N'CSS', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (71, 2707, N'C#', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (72, 2707, N'C', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (73, 2742, N'Angular', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (74, 2742, N'Java', N'Intermediate', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (75, 2742, N'C', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (76, 2708, N'Java', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (77, 2708, N'C', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (78, 2708, N'SQL', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (79, 2708, N'Angular', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (80, 2708, N'JavaScript', N'Expert', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (81, 2707, N'React', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (82, 2707, N'AJAX', N'Beginner', N'N')
INSERT [dbo].[EmployeesSkill] ([EmployeeSkillId], [EmployeeId], [SkillName], [ProficiencyLevel], [IsDelete]) VALUES (83, 2753, N'SEO', N'Expert', N'N')
SET IDENTITY_INSERT [dbo].[EmployeesSkill] OFF
GO
/****** Object:  StoredProcedure [dbo].[AddSkill]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSkill]
(
	@EmployeeId int,
    @SkillName NVARCHAR(MAX),
    @ProficiencyLevel NVARCHAR(MAX)
)
AS
BEGIN
    INSERT INTO EmployeesSkill(EmployeeId, SkillName, ProficiencyLevel, IsDelete)
    VALUES (@EmployeeId, @SkillName,@ProficiencyLevel, 'N');
END;
GO
/****** Object:  StoredProcedure [dbo].[Chart]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Chart]
as
begin
WITH SkillCount AS (
  SELECT SkillName, ProficiencyLevel, COUNT(EmployeesSkill.EmployeeId) AS EmployeeCount
  FROM Employees inner join EmployeesSkill on Employees.EmployeeId = EmployeesSkill.EmployeeId
  WHERE EmployeesSkill.IsDelete = 'N'
  GROUP BY SkillName, ProficiencyLevel
)
SELECT SkillName,
  SUM(CASE WHEN ProficiencyLevel = 'Beginner' THEN EmployeeCount ELSE 0 END) AS Beginner,
  SUM(CASE WHEN ProficiencyLevel = 'Intermediate' THEN EmployeeCount ELSE 0 END) AS Intermediate,
  SUM(CASE WHEN ProficiencyLevel = 'Expert' THEN EmployeeCount ELSE 0 END) AS Expert,
  SUM(EmployeeCount) AS TotalEmployees  -- Add this line to calculate total employees per skill
FROM SkillCount
GROUP BY SkillName
ORDER BY TotalEmployees DESC;
end
GO
/****** Object:  StoredProcedure [dbo].[ChartPie]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ChartPie]
  @filterDepartment BIT,
  @departmentList NVARCHAR(MAX)
AS
BEGIN
  DECLARE @tempDepartmentList TABLE (Department NVARCHAR(50));

  -- Insert departments from @departmentList into temporary table
  IF @filterDepartment = 1 AND @departmentList IS NOT NULL
  BEGIN
    INSERT INTO @tempDepartmentList (Department)
    SELECT value
    FROM STRING_SPLIT(@departmentList, ',');
  END;

  WITH SkillCount AS (
    SELECT SkillName, ProficiencyLevel, COUNT(EmployeesSkill.EmployeeId) AS EmployeeCount
    FROM Employees
      INNER JOIN EmployeesSkill ON Employees.EmployeeId = EmployeesSkill.EmployeeId
    WHERE EmployeesSkill.IsDelete = 'N'
      AND (
        @filterDepartment = 0  -- Don't filter if @filterDepartment is false
        OR (
          EXISTS (  -- Use EXISTS to check for matching department
            SELECT 1
            FROM @tempDepartmentList d
            WHERE Employees.Department = d.Department
          )
        )
      )
    GROUP BY SkillName, ProficiencyLevel
  )
  SELECT SkillName,
         SUM(CASE WHEN ProficiencyLevel = 'Beginner' THEN EmployeeCount ELSE 0 END) AS Beginner,
         SUM(CASE WHEN ProficiencyLevel = 'Intermediate' THEN EmployeeCount ELSE 0 END) AS Intermediate,
         SUM(CASE WHEN ProficiencyLevel = 'Expert' THEN EmployeeCount ELSE 0 END) AS Expert,
         SUM(EmployeeCount) AS TotalEmployees
  FROM SkillCount
  GROUP BY SkillName
  ORDER BY TotalEmployees DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteEmp]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteEmp] (
  @EmployeeSkillId int
)
AS
BEGIN
  -- Update EmployeesSkill table with IsDelete flag
  UPDATE EmployeesSkill
  SET IsDelete = 'Y'
  WHERE EmployeeSkillId = @EmployeeSkillId;

  -- Get EmployeeId from the deleted skill record 
  DECLARE @EmployeeId int;
  SELECT @EmployeeId = EmployeeId
  FROM EmployeesSkill
  WHERE EmployeeSkillId = @EmployeeSkillId;

  -- Check if any skills remain for the employee (IsDelete != 'Y')
  IF NOT EXISTS (
    SELECT 1
    FROM EmployeesSkill
    WHERE EmployeeId = @EmployeeId
      AND IsDelete = 'N'
  )
  BEGIN
    -- Update Employees table with IsDelete flag
    UPDATE Employees
    SET IsDelete = 'Y'
    WHERE EmployeeId = @EmployeeId;
  END
END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteEmpSkill]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteEmpSkill] (
  @EmployeeSkillId int
)
AS
BEGIN
  -- Update EmployeesSkill table with IsDelete flag
  UPDATE EmployeesSkill
  SET IsDelete = 'Y'
  WHERE EmployeeSkillId = @EmployeeSkillId;

  -- Get EmployeeId from the deleted skill record 
  DECLARE @EmployeeId int;
  SELECT @EmployeeId = EmployeeId
  FROM EmployeesSkill
  WHERE EmployeeSkillId = @EmployeeSkillId;
END;
GO
/****** Object:  StoredProcedure [dbo].[DepartmentEmp]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DepartmentEmp]
as
begin
SELECT SkillName, COUNT(*) AS Employees
FROM dbo.EmployeesSkill where EmployeesSkill.IsDelete='N'
GROUP BY SkillName
ORDER BY Employees DESC;
end
GO
/****** Object:  StoredProcedure [dbo].[EmpInfo]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[EmpInfo]
As
SELECT dbo.Employees.EmployeeId,dbo.Employees.FirstName, dbo.Employees.LastName, dbo.Employees.Email, dbo.Employees.Department, dbo.Skill.SkillName,dbo.Employees.Role,dbo.Employees.Password, dbo.EmployeesSkill.ProficiencyLevel,dbo.EmployeesSkill.EmployeeSkillId
FROM dbo.Employees INNER JOIN
dbo.EmployeesSkill ON dbo.Employees.EmployeeId = dbo.EmployeesSkill.EmployeeId INNER JOIN
dbo.Skill ON dbo.EmployeesSkill.SkillName = dbo.Skill.SkillId
where dbo.EmployeesSkill.IsDelete='N';
GO
/****** Object:  StoredProcedure [dbo].[FInsertData]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[FInsertData]
@FirstName NVARCHAR(MAX),
@LastName NVARCHAR(MAX),
@Email NVARCHAR(MAX),
@Department NVARCHAR(MAX),
@Role NVARCHAR(20),
@Password NVARCHAR(20),
@AllSkillId NVARCHAR(100),
@ProficiencyLevel NVARCHAR(MAX)
as
begin
insert into Employees(FirstName,LastName,Email,Department,Role,[Password],IsDelete)values(@FirstName,@LastName,@Email,@Department,@Role,@Password,'N')
declare @EmployeeId int = @@Identity
    BEGIN
	DECLARE @SkillId int;
    DECLARE @TotalSkill int = 0;

    -- Create a table variable to store the individual skill IDs
    DECLARE @SkillIds TABLE (SkillId int);

	WHILE CHARINDEX(',', @AllSkillId) > 0
    BEGIN
        SET @SkillId = SUBSTRING(@AllSkillId, 1, CHARINDEX(',', @AllSkillId) - 1);
        SET @AllSkillId = SUBSTRING(@AllSkillId, CHARINDEX(',', @AllSkillId) + 1, LEN(@AllSkillId));
        
        INSERT INTO EmployeesSkill(EmployeeId, SkillName, ProficiencyLevel, IsDelete) VALUES (@EmployeeId, @SkillId, @ProficiencyLevel, 'N')

      --  SET @AllSkillId = SUBSTRING(@AllSkillId, @Position + 1, LEN(@AllSkillId))
    END
	INSERT INTO EmployeesSkill(EmployeeId, SkillName, ProficiencyLevel, IsDelete) VALUES (@EmployeeId, @AllSkillId, @ProficiencyLevel, 'N')
END
END
GO
/****** Object:  StoredProcedure [dbo].[getByIdEd]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[getByIdEd]
(
	@EmployeeSkillId int
)
AS
SELECT 
	dbo.EmployeesSkill.EmployeeId,
	dbo.EmployeesSkill.ProficiencyLevel,
	dbo.EmployeesSkill.SkillName,
	dbo.EmployeesSkill.EmployeeSkillId
FROM 
dbo.EmployeesSkill 
where EmployeesSkill.EmployeeSkillId=@EmployeeSkillId;
GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetDepartment]
As
select DISTINCT DepartmentName from Department;
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeDetails]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeDetails] (@EmployeeId INT)
AS
BEGIN
  SELECT 
  E.EmployeeId,
    E.FirstName,
    E.LastName,
    E.Department,
    E.Role,
    E.Password -- Consider hashing passwords before storing them
    , E.Status,
    E.Email,
    ES.ProficiencyLevel,
    ES.SkillName,
    ES.IsDelete,
    (SELECT COUNT(*) FROM Employees AS E2
     INNER JOIN EmployeesSkill AS ES2 ON E2.EmployeeId = ES2.EmployeeId
     WHERE E2.EmployeeId = @EmployeeId AND ES2.IsDelete = 'N') AS TotalCount
  FROM Employees AS E
  INNER JOIN EmployeesSkill AS ES ON E.EmployeeId = ES.EmployeeId
  WHERE E.EmployeeId = @EmployeeId AND ES.IsDelete = 'N';
END;
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeSkillCount]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeSkillCount] (@EmployeeId INT)
AS
BEGIN
  SELECT e.EmployeeId, COUNT(*) AS TotalSkills
  FROM EmployeesSkill es
  INNER JOIN Employees e ON es.EmployeeId = e.EmployeeId
  WHERE es.EmployeeId = @EmployeeId
  GROUP BY e.EmployeeId;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetSkill]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetSkill]
As
select DISTINCT SKillId,SkillName from Skill;
GO
/****** Object:  StoredProcedure [dbo].[GetSkillIds]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSkillIds]
    @AllSkillId varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SkillId int;
    DECLARE @TotalSkill int = 0;

    -- Split the comma-separated string into a table
    DECLARE @SkillIdsTable TABLE (SkillId int);
    INSERT INTO @SkillIdsTable
        SELECT Value
        FROM STRING_SPLIT(@AllSkillId, ',');

    -- Iterate through the table and output each skill ID
    WHILE (SELECT COUNT(*) FROM @SkillIdsTable) > 0
    BEGIN
        SELECT TOP 1 @SkillId = SkillId FROM @SkillIdsTable;
        DELETE FROM @SkillIdsTable WHERE SkillId = @SkillId;

        SELECT @SkillId AS SkillId;  -- Output the current skill ID

        SET @TotalSkill = @TotalSkill + 1;
    END

    -- Output the total number of skills
    SELECT @TotalSkill AS TotalSkill;
END
GO
/****** Object:  StoredProcedure [dbo].[GetTotalEmployees]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTotalEmployees]
as
BEGIN
  SELECT COUNT(*) AS TotalEmployees
  FROM Employees;
END;
GO
/****** Object:  StoredProcedure [dbo].[LoginSP]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[LoginSP]
(
  @Email nvarchar(50) null,
  @Password nvarchar(50) OUT,  -- Added 'OUT' keyword
  @Role nvarchar(50) Out,
  @EmployeeId int OUT,        -- Added output parameter for EmployeeId
  @Isvalid bit Out,
  @EmployeeName nvarchar(max) Out
  )
as
begin
  -- Set @Isvalid to check if a valid employee exists
  Set @Isvalid =(Select Count(*) FROM Employees 
                where Email = @Email 
                  and [Password]= @Password 
                  and [IsDelete] = 'N');

  -- If valid user found, set the role (@Role) and EmployeeId (@EmployeeId)
  if @Isvalid = 1
  Begin
    Set @Role = (Select Role FROM Employees 
                 where Email = @Email 
                   and [Password]= @Password 
                   and [IsDelete] = 'N');
    
    Set @EmployeeId = (Select EmployeeId FROM Employees 
                       where Email = @Email 
                         and [Password]= @Password 
                         and [IsDelete] = 'N');
	Set @EmployeeName = (SELECT CONCAT(FirstName, ' ', LastName) AS FullName
						  FROM Employees
						  WHERE Email = @Email
						  AND [Password] = @Password
						  AND [IsDelete] = 'N');

  END
end
GO
/****** Object:  StoredProcedure [dbo].[ProcessSkillIds]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcessSkillIds] (@AllSkillId varchar(100))
AS
BEGIN
    DECLARE @SkillId int;
    DECLARE @TotalSkill int = 0;

    -- Create a table variable to store the individual skill IDs
    DECLARE @SkillIds TABLE (SkillId int);

    -- Split the comma-separated string into individual values
    WHILE CHARINDEX(',', @AllSkillId) > 0
    BEGIN
        SET @SkillId = SUBSTRING(@AllSkillId, 1, CHARINDEX(',', @AllSkillId) - 1);
        SET @AllSkillId = SUBSTRING(@AllSkillId, CHARINDEX(',', @AllSkillId) + 1, LEN(@AllSkillId));

        -- Insert each skill ID into the table variable
        INSERT INTO @SkillIds (SkillId)
        VALUES (@SkillId);
    END

    -- Insert the last remaining skill ID
    --INSERT INTO @SkillIds (SkillId) VALUES (@AllSkillId);

    -- Select the individual skill IDs from the table variable
    --SELECT SkillId FROM @SkillIds;

    -- Set the total skill count
    --SET @TotalSkill = @@ROWCOUNT;

    -- Output the total skill count
    --SELECT @TotalSkill AS TotalSkill;
END;
GO
/****** Object:  StoredProcedure [dbo].[Registration]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Registration]
(
    @FirstName NVARCHAR(MAX),
    @LastName NVARCHAR(MAX),
    @Email NVARCHAR(MAX),
    @Department NVARCHAR(MAX),
    @Role NVARCHAR(20),
    @Password NVARCHAR(20)
)
AS
BEGIN
    DECLARE @ExistingEmailCount INT;

    -- Check for existing email with a single, efficient SELECT statement
    SELECT @ExistingEmailCount = COUNT(*)
    FROM Employees
    WHERE Email = @Email;

    IF @ExistingEmailCount > 0
    BEGIN
        RAISERROR ('Email "%1" already exists.', 16, 1, @Email);  -- Informative error message
        RETURN;  -- Terminate procedure execution
    END;

    -- Insert new employee using parameterized query for security
    INSERT INTO Employees (Employees.FirstName, Employees.LastName, Employees.Email, Employees.Department, Employees.Role, Employees.Password, Employees.IsDelete)
    VALUES (@FirstName, @LastName, @Email, @Department, @Role, @Password, 'N');

	--INSERT INTO Department (Department.DepartmentName, Department.Manager)
	--VALUES (@Department, @FirstName+' '+@LastName)
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateData]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateData](
	@EmployeeSkillId int,
	@EmployeeId int,
    @SkillName nvarchar(Max),
	@ProficiencyLevel nvarchar(Max)
)
As
Begin
	update
		EmployeesSkill
	set
		EmployeeId=@EmployeeId,
		SkillName=@SkillName,
		ProficiencyLevel=@ProficiencyLevel
	where
		EmployeeSkillId=@EmployeeSkillId
End
GO
/****** Object:  StoredProcedure [dbo].[UpdateEmployeeStatusOnSkillDelete]    Script Date: 5/7/2024 4:12:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateEmployeeStatusOnSkillDelete] (
  @EmployeeSkillId int
)
AS
BEGIN
  -- Update EmployeesSkill table with IsDelete flag
  UPDATE EmployeesSkill
  SET IsDelete = 'Y'
  WHERE EmployeeSkillId = @EmployeeSkillId;

  -- Get EmployeeId from the deleted skill record 
  DECLARE @EmployeeId int;
  SELECT @EmployeeId = EmployeeId
  FROM EmployeesSkill
  WHERE EmployeeSkillId = @EmployeeSkillId;

  -- Check if any skills remain for the employee (IsDelete != 'Y')
  IF NOT EXISTS (
    SELECT 1
    FROM EmployeesSkill
    WHERE EmployeeId = @EmployeeId
      AND IsDelete = 'N'
  )
  BEGIN
    -- Update Employees table with IsDelete flag
    UPDATE Employees
    SET IsDelete = 'Y'
    WHERE EmployeeId = @EmployeeId;
  END
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Employees"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 292
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmployeesSkill"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 248
               Right = 461
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'EmployeeViewData'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'EmployeeViewData'
GO
