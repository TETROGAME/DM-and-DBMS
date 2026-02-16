CREATE TABLE [dbo].[Drivers] (
  [driver_id] bigint  NOT NULL,
  [name] varchar(20)  NOT NULL,
  [surname] varchar(20)  NOT NULL,
  [patronymic] varchar(20)  NULL,
  [licence_category] varchar(2)  NOT NULL,
  [passport_id] varchar(9)  NOT NULL,
  PRIMARY KEY CLUSTERED ([driver_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
EXEC sp_addextendedproperty
'MS_Description', N'Format: "^[A-Z]{2}\d{7}$
"',
'SCHEMA', N'dbo',
'TABLE', N'Drivers',
'COLUMN', N'passport_id'
GO

CREATE TABLE [dbo].[Trips] (
  [trip_id] bigint  NOT NULL,
  [vehicle_id] bigint  NULL,
  [driver_id] bigint  NULL,
  [destination] varchar(30)  NULL,
  [departure_date] date NULL,
  PRIMARY KEY CLUSTERED ([trip_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Vehicles] (
  [vehicle_id] bigint  NOT NULL,
  [plate_number] varchar(10)  NOT NULL,
  [capacity] decimal  NOT NULL,
  PRIMARY KEY CLUSTERED ([vehicle_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
EXEC sp_addextendedproperty
'MS_Description', N'Format: "^[A-Z]{2}\d{4}-?\d$
"',
'SCHEMA', N'dbo',
'TABLE', N'Vehicles',
'COLUMN', N'plate_number'
GO

ALTER TABLE [dbo].[Trips] ADD CONSTRAINT [driver] FOREIGN KEY ([driver_id]) REFERENCES [dbo].[Drivers] ([driver_id]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Trips] ADD CONSTRAINT [vehicle] FOREIGN KEY ([vehicle_id]) REFERENCES [dbo].[Vehicles] ([vehicle_id]) ON UPDATE CASCADE
GO

