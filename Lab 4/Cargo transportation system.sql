CREATE TABLE [dbo].[Drivers] (
  [driver_id] int  IDENTITY NOT NULL,
  [name] varchar(20)  NOT NULL,
  [surname] varchar(20)  NOT NULL,
  [patronymic] varchar(20)  NULL,
  [passport_id] varchar(9)  NOT NULL,
  PRIMARY KEY CLUSTERED ([driver_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [passport_id_check] CHECK (passport_id LIKE '[A-Z][A-Z]%')
)
GO
CREATE NONCLUSTERED INDEX [idx_surname]
ON [dbo].[Drivers] (
  [surname] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_passport_id]
ON [dbo].[Drivers] (
  [passport_id] ASC
)
GO

CREATE TABLE [dbo].[Maintenance] (
  [maintenance_id] int  IDENTITY NOT NULL,
  [vehicle_id] int  NOT NULL,
  [maintenance_date] datetime2  NOT NULL,
  [description] varchar(255)  NULL,
  [cost] decimal(10,2)  NOT NULL,
  PRIMARY KEY CLUSTERED ([maintenance_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [cost_check] CHECK (cost >= 0)
)
GO
CREATE NONCLUSTERED INDEX [idx_maintenance_date]
ON [dbo].[Maintenance] (
  [maintenance_date] ASC
)
GO
CREATE NONCLUSTERED INDEX [idx_vehicle_id]
ON [dbo].[Maintenance] (
  [vehicle_id] ASC
)
GO

CREATE TABLE [dbo].[Routes] (
  [route_id] int  IDENTITY NOT NULL,
  [start] varchar(255)  NOT NULL,
  [end] varchar(255)  NOT NULL,
  [distance] decimal(10,2)  NOT NULL,
  PRIMARY KEY CLUSTERED ([route_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [distance_check] CHECK (distance > 0)
)
GO
CREATE NONCLUSTERED INDEX [idx_start]
ON [dbo].[Routes] (
  [start] ASC
)
GO

CREATE TABLE [dbo].[Trips] (
  [trip_id] int  IDENTITY NOT NULL,
  [vehicle_id] int  NOT NULL,
  [driver_id] int  NOT NULL,
  [route_id] int  NOT NULL,
  [depatrute_date] datetime2 DEFAULT GETDATE() NOT NULL,
  PRIMARY KEY CLUSTERED ([trip_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
CREATE NONCLUSTERED INDEX [idx_vehicle_with_date]
ON [dbo].[Trips] (
  [vehicle_id] ASC,
  [depatrute_date] ASC
)
GO
CREATE NONCLUSTERED INDEX [idx_driver_id]
ON [dbo].[Trips] (
  [driver_id] ASC
)
GO

CREATE TABLE [dbo].[Vehicle_types] (
  [type_id] int  IDENTITY NOT NULL,
  [type_name] varchar(50)  NOT NULL,
  [capacity] decimal(10,2)  NOT NULL,
  PRIMARY KEY CLUSTERED ([type_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [capacity_check] CHECK (capacity >= 0)
)
GO
CREATE NONCLUSTERED INDEX [idx_capacity]
ON [dbo].[Vehicle_types] (
  [capacity] ASC
)
GO

CREATE TABLE [dbo].[Vehicles] (
  [vehicle_id] int  IDENTITY NOT NULL,
  [plate_number] varchar(10)  NOT NULL,
  [mileage] int  NOT NULL,
  [type_id] int  NOT NULL,
  PRIMARY KEY CLUSTERED ([vehicle_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
  CONSTRAINT [mileage_check] CHECK (mileage > 0),
  CONSTRAINT [plate_number_check] CHECK (plate_number LIKE '[A-Z][A-Z]-%')
)
GO
CREATE NONCLUSTERED INDEX [idx_type_id]
ON [dbo].[Vehicles] (
  [type_id] ASC
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_plate_number]
ON [dbo].[Vehicles] (
  [plate_number] ASC
)
GO

ALTER TABLE [dbo].[Maintenance] ADD CONSTRAINT [maint_vehicle_id] FOREIGN KEY ([vehicle_id]) REFERENCES [dbo].[Vehicles] ([vehicle_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Trips] ADD CONSTRAINT [trips_vehicle_id] FOREIGN KEY ([vehicle_id]) REFERENCES [dbo].[Vehicles] ([vehicle_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Trips] ADD CONSTRAINT [driver_id] FOREIGN KEY ([driver_id]) REFERENCES [dbo].[Drivers] ([driver_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Trips] ADD CONSTRAINT [route_id] FOREIGN KEY ([route_id]) REFERENCES [dbo].[Routes] ([route_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Vehicles] ADD CONSTRAINT [type_id] FOREIGN KEY ([type_id]) REFERENCES [dbo].[Vehicle_types] ([type_id]) ON DELETE NO ACTION ON UPDATE CASCADE
GO

