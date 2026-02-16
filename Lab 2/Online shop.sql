CREATE TABLE [dbo].[Clients] (
  [client_id] bigint NOT NULL,
  [name] varchar(20) NULL,
  [surname] varchar(20) NULL,
  [patronymic] varchar(20) NULL,
  [passport] varchar(15) NOT NULL,
  [birth_date] date NULL,
  [phone_number] varchar(15) NULL,
  PRIMARY KEY CLUSTERED ([client_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Orders] (
  [date] date NOT NULL,
  [price] decimal NOT NULL,
  [count] int NOT NULL,
  [client_id] bigint NOT NULL,
  [product_id] bigint NOT NULL,
  PRIMARY KEY CLUSTERED ([date], [client_id], [product_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Products] (
  [product_id] bigint NOT NULL,
  [title] varchar(20) NOT NULL,
  [price] decimal NOT NULL,
  [description] varchar(255) NULL,
  PRIMARY KEY CLUSTERED ([product_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [client] FOREIGN KEY ([client_id]) REFERENCES [dbo].[Clients] ([client_id])
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [product] FOREIGN KEY ([product_id]) REFERENCES [dbo].[Products] ([product_id])
GO

