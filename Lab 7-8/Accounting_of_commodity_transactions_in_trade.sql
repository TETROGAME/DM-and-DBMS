CREATE TABLE [dbo].[Product_groups] (
  [group_id] int  IDENTITY NOT NULL,
  [group_name] varchar(255)  NOT NULL,
  PRIMARY KEY CLUSTERED ([group_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Products] (
  [product_id] int  IDENTITY NOT NULL,
  [product_name] varchar(255)  NOT NULL,
  [group_id] int  NOT NULL,
  [unit] varchar(255)  NOT NULL,
  [price] money  NOT NULL,
  PRIMARY KEY CLUSTERED ([product_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [product_price_chk] CHECK (price >= 0)
)
GO

CREATE TABLE [dbo].[Receipt_lines] (
  [line_id] int  IDENTITY NOT NULL,
  [receipt_id] int  NOT NULL,
  [product_id] int  NOT NULL,
  [quantity] float  NOT NULL,
  PRIMARY KEY CLUSTERED ([line_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [receipts_quantity_chk] CHECK (quantity > 0)
)
GO

CREATE TABLE [dbo].[Receipts] (
  [receipt_id] int  IDENTITY NOT NULL,
  [receipt_date] datetime2 DEFAULT GETDATE() NOT NULL,
  [store_id] int  NOT NULL,
  PRIMARY KEY CLUSTERED ([receipt_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Sales] (
  [sale_id] int  IDENTITY NOT NULL,
  [sale_date] datetime2 DEFAULT GETDATE() NOT NULL,
  [store_id] int  NOT NULL,
  PRIMARY KEY CLUSTERED ([sale_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Sales_lines] (
  [line_id] int  IDENTITY NOT NULL,
  [sale_id] int  NOT NULL,
  [product_id] int  NOT NULL,
  [quantity] float  NOT NULL,
  PRIMARY KEY CLUSTERED ([line_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [salse_quantity_chk] CHECK (quantity > 0)
)
GO

CREATE TABLE [dbo].[Stores] (
  [store_id] int  IDENTITY NOT NULL,
  [store_name] varchar(255)  NOT NULL,
  PRIMARY KEY CLUSTERED ([store_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[Products] ADD CONSTRAINT [product_group_id_fk] FOREIGN KEY ([group_id]) REFERENCES [dbo].[Product_groups] ([group_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Receipt_lines] ADD CONSTRAINT [rlines_receipt_id_fk] FOREIGN KEY ([receipt_id]) REFERENCES [dbo].[Receipts] ([receipt_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Receipt_lines] ADD CONSTRAINT [rlines_product_id_fk] FOREIGN KEY ([product_id]) REFERENCES [dbo].[Products] ([product_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Receipts] ADD CONSTRAINT [receipt_store_id_fk] FOREIGN KEY ([store_id]) REFERENCES [dbo].[Stores] ([store_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Sales] ADD CONSTRAINT [sales_store_id_fk] FOREIGN KEY ([store_id]) REFERENCES [dbo].[Stores] ([store_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Sales_lines] ADD CONSTRAINT [sl_sale_id_fk] FOREIGN KEY ([sale_id]) REFERENCES [dbo].[Sales] ([sale_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Sales_lines] ADD CONSTRAINT [sl_product_id_fk] FOREIGN KEY ([product_id]) REFERENCES [dbo].[Products] ([product_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO

