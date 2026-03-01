-- Insert Vehicle Types
INSERT INTO [dbo].[Vehicle_types] ([type_name], [capacity]) VALUES
('Refrigerated Truck', 22.50), ('Curtainside Trailer', 18.00),
('Flatbed Platform', 25.00), ('Container Carrier', 30.00);
GO

-- Insert Drivers (10 records)
INSERT INTO [dbo].[Drivers] ([name], [surname], [patronymic], [passport_id]) VALUES
('John', 'Smith', 'Edward', 'JS9922334'), ('Robert', 'Brown', NULL, 'RB1122334'),
('Michael', 'Davis', 'William', 'MD5566778'), ('William', 'Wilson', 'James', 'WW8877665'),
('David', 'Taylor', NULL, 'DT3344556'), ('Richard', 'Moore', 'Joseph', 'RM2211009'),
('Joseph', 'Anderson', 'Charles', 'JA4455667'), ('Thomas', 'Thomas', NULL, 'TT7788990'),
('Charles', 'Jackson', 'Robert', 'CJ5566112'), ('Christopher', 'White', 'Paul', 'CW6677881');
GO

-- Insert Routes
INSERT INTO [dbo].[Routes] ([start], [end], [distance]) VALUES
('Berlin', 'Paris', 1050.00), ('Warsaw', 'Prague', 670.50), ('Minsk', 'Vilnius', 180.00);
GO

-- Insert Vehicles (10 records)
INSERT INTO [dbo].[Vehicles] ([plate_number], [mileage], [type_id]) VALUES
('AA-1001', 45000, 1), ('BC-2002', 125000, 2), ('DE-3003', 15000, 3),
('FG-4004', 89000, 4), ('HI-5005', 210000, 1), ('JK-6006', 32000, 2),
('LM-7007', 56000, 3), ('NO-8008', 95000, 4), ('PQ-9009', 11000, 1),
('RS-1010', 64000, 2);
GO

-- Insert Initial Trips
INSERT INTO [dbo].[Trips] ([vehicle_id], [driver_id], [route_id]) VALUES
 (1, 1, 1), (2, 2, 2), (3, 3, 3);
GO