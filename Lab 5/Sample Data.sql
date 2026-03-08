SET NOCOUNT ON;

PRINT 'Populating Vehicle_types...';
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        INSERT INTO [dbo].[Vehicle_types] ([type_name], [capacity])
        VALUES (
                   CHOOSE((@i % 5) + 1, 'Truck', 'Van', 'Minibus', 'Tractor', 'Bus') + ' Type ' + CAST(@i AS VARCHAR),
                   ROUND(RAND(CHECKSUM(NEWID())) * 15000 + 500, 2)
               );
        SET @i = @i + 1;
    END
GO

PRINT 'Populating Drivers...';
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        INSERT INTO [dbo].[Drivers] ([name], [surname], [patronymic], [passport_id])
        VALUES (
                   CHOOSE((@i % 5) + 1, 'John', 'Michael', 'David', 'James', 'Robert'),
                   CHOOSE((@i % 5) + 1, 'Smith', 'Johnson', 'Williams', 'Brown', 'Jones') + '_' + CAST(@i AS VARCHAR),
                   CHOOSE((@i % 5) + 1, 'Alan', 'Edward', 'Scott', 'Paul', 'Ray'),
                   -- Generates strict mask: [A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
                   CHAR(65 + (@i % 26)) + CHAR(65 + ((@i/26) % 26)) + RIGHT('0000000' + CAST(1000000 + @i AS VARCHAR), 7)
               );
        SET @i = @i + 1;
    END
GO

PRINT 'Populating Vehicles...';
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        -- Get a random existing type_id
        DECLARE @type_id INT = (SELECT TOP 1 [type_id] FROM [dbo].[Vehicle_types] ORDER BY NEWID());

        INSERT INTO [dbo].[Vehicles] ([plate_number], [mileage], [type_id])
        VALUES (
                   -- Generates strict mask: [0-9][0-9][0-9][0-9] [A-Z][A-Z]-[0-9]
                   RIGHT('0000' + CAST(1000 + @i AS VARCHAR), 4) + ' ' + CHAR(65 + (@i % 26)) + CHAR(65 + ((@i/26) % 26)) + '-' + CAST(@i % 10 AS VARCHAR),
                   ABS(CHECKSUM(NEWID())) % 300000 + 10,
                   @type_id
               );
        SET @i = @i + 1;
    END
GO

PRINT 'Populating Routes...';
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        INSERT INTO [dbo].[Routes] ([start], [end], [distance])
        VALUES (
                   'City ' + CHAR(65 + (@i % 26)),
                   'City ' + CHAR(65 + ((@i + 5) % 26)),
                   ROUND(RAND(CHECKSUM(NEWID())) * 2000 + 5, 2)
               );
        SET @i = @i + 1;
    END
GO

PRINT 'Populating Trips...';
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        -- Get random existing IDs
        DECLARE @vehicle_id INT = (SELECT TOP 1 [vehicle_id] FROM [dbo].[Vehicles] ORDER BY NEWID());
        DECLARE @driver_id INT = (SELECT TOP 1 [driver_id] FROM [dbo].[Drivers] ORDER BY NEWID());
        DECLARE @route_id INT = (SELECT TOP 1 [route_id] FROM [dbo].[Routes] ORDER BY NEWID());

        INSERT INTO [dbo].[Trips] ([vehicle_id], [driver_id], [route_id], [departure_date])
        VALUES (
                   @vehicle_id,
                   @driver_id,
                   @route_id,
                   -- Random date within the last 1000 days
                   DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 1000), GETDATE())
               );
        SET @i = @i + 1;
    END
GO

PRINT 'Populating Maintenance...';
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        DECLARE @vehicle_id INT = (SELECT TOP 1 [vehicle_id] FROM [dbo].[Vehicles] ORDER BY NEWID());

        INSERT INTO [dbo].[Maintenance] ([vehicle_id], [maintenance_date], [description], [cost])
        VALUES (
                   @vehicle_id,
                   DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 1000), GETDATE()),
                   CHOOSE((@i % 4) + 1, 'Oil change', 'Engine repair', 'Brake pad replacement', 'Tire fitting'),
                   ROUND(RAND(CHECKSUM(NEWID())) * 50000 + 500, 2)
               );
        SET @i = @i + 1;
    END
GO

PRINT 'Data successfully generated!';