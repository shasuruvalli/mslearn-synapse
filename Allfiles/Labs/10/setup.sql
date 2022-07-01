SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar(50)] NOT NULL,
	[Category] [nvarchar(50)] NOT NULL,
	[ListPrice] [money] NULL
)
GO


