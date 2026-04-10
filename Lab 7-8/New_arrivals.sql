SET NOCOUNT ON;

DECLARE @Counter INT = 1;
DECLARE @NewReceiptId INT;
DECLARE @NewSaleId INT;
DECLARE @RandomDate DATETIME2;

PRINT N'Генерация поступлений (Ноябрь 2024 - Январь 2025)...';
-- =========================================================================
-- 1. Добавляем 300 новых поступлений (Receipts) и их строки
-- =========================================================================
WHILE @Counter <= 300
    BEGIN
        -- Генерируем даты от 1 ноября 2024 до конца января 2025
        SET @RandomDate = DATEADD(hour, (@Counter * 23) % 2200, '2024-11-01T08:00:00');

        INSERT INTO [dbo].[Receipts] ([receipt_date], [store_id])
        VALUES (@RandomDate, (@Counter % 50) + 1);

        -- Получаем ID только что созданного документа
        SET @NewReceiptId = SCOPE_IDENTITY();

        -- Добавляем 3 разные позиции в этот документ (продукты от 1 до 100)
        INSERT INTO [dbo].[Receipt_lines] ([receipt_id], [product_id], [quantity])
        VALUES
            (@NewReceiptId, (@Counter * 3) % 100 + 1, (@Counter * 7) % 50 + 10),
            (@NewReceiptId, (@Counter * 5) % 100 + 1, (@Counter * 11) % 50 + 5),
            (@NewReceiptId, (@Counter * 7) % 100 + 1, (@Counter * 13) % 50 + 20);

        SET @Counter = @Counter + 1;
    END;


PRINT N'Генерация продаж (Ноябрь 2024 - Февраль 2025)...';
-- =========================================================================
-- 2. Добавляем 800 новых продаж (Sales) и их строки
-- =========================================================================
SET @Counter = 1;

WHILE @Counter <= 800
    BEGIN
        -- Генерируем даты от 15 ноября 2024 до начала февраля 2025
        SET @RandomDate = DATEADD(hour, (@Counter * 19) % 2000, '2024-11-15T09:00:00');

        INSERT INTO [dbo].[Sales] ([sale_date], [store_id])
        VALUES (@RandomDate, (@Counter % 50) + 1);

        -- Получаем ID только что созданной продажи
        SET @NewSaleId = SCOPE_IDENTITY();

        -- Добавляем 2 разные позиции в каждую продажу
        INSERT INTO [dbo].[Sales_lines] ([sale_id], [product_id], [quantity])
        VALUES
            (@NewSaleId, (@Counter * 2) % 100 + 1, (@Counter * 3) % 10 + 1),
            (@NewSaleId, (@Counter * 4) % 100 + 1, (@Counter * 5) % 10 + 1);

        SET @Counter = @Counter + 1;
    END;

PRINT N'Генерация успешно завершена!';
GO