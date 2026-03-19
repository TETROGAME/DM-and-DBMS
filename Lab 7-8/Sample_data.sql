-- =========================================================================
-- 1. Заполнение справочника [Product_groups] (30 категорий)
-- =========================================================================
INSERT INTO [dbo].[Product_groups] ([group_name]) VALUES
                                                      ('Beverages'), ('Dairy & Eggs'), ('Fresh Produce'), ('Meat & Poultry'), ('Seafood'),
                                                      ('Bakery'), ('Frozen Foods'), ('Snacks & Candy'), ('Canned Goods'), ('Condiments & Sauces'),
                                                      ('Breakfast & Cereal'), ('Pasta & Grains'), ('Baking Supplies'), ('Spices & Herbs'), ('Deli'),
                                                      ('Coffee & Tea'), ('Baby Food & Care'), ('Pet Supplies'), ('Household Cleaning'), ('Laundry Supplies'),
                                                      ('Paper Products'), ('Personal Care'), ('Health & Medicine'), ('Beauty & Cosmetics'), ('Office & School'),
                                                      ('Home Appliances'), ('Electronics'), ('Tools & Hardware'), ('Garden & Outdoor'), ('Automotive');
GO

-- =========================================================================
-- 2. Заполнение справочника [Stores] (50 магазинов)
-- =========================================================================
INSERT INTO [dbo].[Stores] ([store_name]) VALUES
                                              ('Central Market - Downtown'), ('Central Market - Uptown'), ('Westside Superstore'), ('East End Groceries'), ('North District Mart'),
                                              ('South Park Express'), ('Metro Station Grocery'), ('Lakeside Supermarket'), ('Hilltop Fresh Food'), ('Valley Discount Store'),
                                              ('Riverfront Market'), ('Highland Foods'), ('Sunset Boulevard Mart'), ('Oceanview Grocery'), ('Pioneer Square Shop'),
                                              ('Harbor Retail & Food'), ('Forest Green Supermarket'), ('Silver Lake Groceries'), ('Golden Gate Market'), ('City Center Express'),
                                              ('Maple Street Mart'), ('Oak Avenue Groceries'), ('Pine Road Superstore'), ('Cedar Lane Market'), ('Elm Street Express'),
                                              ('Washington Blvd Foods'), ('Lincoln Park Supermarket'), ('Jefferson Square Mart'), ('Adams Way Groceries'), ('Franklin Ave Market'),
                                              ('Grand Central Foods'), ('Union Station Groceries'), ('Liberty Bell Mart'), ('Victory Square Express'), ('Independence Superstore'),
                                              ('Main Street Grocers'), ('Broadway Food Market'), ('Park Avenue Fresh'), ('5th Avenue Express'), ('Lexington Supermarket'),
                                              ('Springfield Mart'), ('Riverside Discount'), ('Brookside Fresh Market'), ('Meadow Market'), ('Woodland Groceries'),
                                              ('Stone Creek Superstore'), ('Clearwater Express'), ('Blue Ridge Foods'), ('Rocky Mountain Mart'), ('Desert Springs Grocer');
GO

-- =========================================================================
-- 3. Заполнение справочника [Products] (100 уникальных товаров)
-- Внешний ключ group_id привязан к категориям (от 1 до 30)
-- =========================================================================
INSERT INTO [dbo].[Products] ([product_name], [group_id], [unit], [price]) VALUES
-- Beverages & Dairy
('Coca-Cola 1.5L', 1, 'bottle', 2.50), ('Orange Juice 1L', 1, 'pack', 3.20), ('Sparkling Water', 1, 'bottle', 1.10), ('Green Tea 500ml', 1, 'bottle', 1.80), ('Whole Milk 1L', 2, 'bottle', 1.50),
('Cheddar Cheese', 2, 'kg', 12.00), ('Greek Yogurt', 2, 'pack', 4.50), ('Salted Butter', 2, 'pack', 3.80), ('Free-Range Eggs 12', 2, 'box', 4.00), ('Almond Milk', 2, 'bottle', 3.50),
-- Produce, Meat & Seafood
('Red Apples', 3, 'kg', 2.20), ('Bananas', 3, 'kg', 1.10), ('Carrots', 3, 'kg', 0.90), ('Potatoes', 3, 'kg', 0.80), ('Fresh Tomatoes', 3, 'kg', 2.50),
('Beef Ribeye Steak', 4, 'kg', 25.00), ('Chicken Breast', 4, 'kg', 8.50), ('Pork Chops', 4, 'kg', 10.00), ('Ground Turkey', 4, 'kg', 7.50), ('Lamb Leg', 4, 'kg', 18.00),
('Fresh Salmon Fillet', 5, 'kg', 22.00), ('Frozen Shrimp', 5, 'pack', 15.00), ('Canned Tuna', 5, 'tin', 2.00), ('Smoked Mackerel', 5, 'kg', 14.00), ('Oysters 12pcs', 5, 'box', 20.00),
-- Bakery, Frozen, Snacks
('Whole Wheat Bread', 6, 'pcs', 2.50), ('French Baguette', 6, 'pcs', 1.50), ('Chocolate Croissant', 6, 'pcs', 2.00), ('Blueberry Muffin', 6, 'pcs', 1.80), ('Burger Buns 6pcs', 6, 'pack', 3.00),
('Vanilla Ice Cream 1L', 7, 'tub', 5.50), ('Frozen Pizza', 7, 'pcs', 4.80), ('Frozen Peas', 7, 'pack', 2.20), ('French Fries', 7, 'kg', 3.50), ('Mixed Vegetables', 7, 'pack', 2.50),
('Potato Chips', 8, 'pack', 1.50), ('Tortilla Chips', 8, 'pack', 2.00), ('Mixed Nuts', 8, 'pack', 6.50), ('Milk Chocolate Bar', 8, 'pcs', 1.20), ('Gummy Bears', 8, 'pack', 1.80),
-- Canned, Condiments, Breakfast
('Baked Beans', 9, 'tin', 1.20), ('Sweet Corn', 9, 'tin', 1.00), ('Tomato Soup', 9, 'tin', 1.50), ('Canned Peaches', 9, 'tin', 2.20), ('Coconut Milk', 9, 'tin', 1.80),
('Tomato Ketchup', 10, 'bottle', 2.50), ('Mayonnaise', 10, 'jar', 3.00), ('Yellow Mustard', 10, 'bottle', 1.80), ('Soy Sauce', 10, 'bottle', 2.20), ('Olive Oil 500ml', 10, 'bottle', 6.50),
('Corn Flakes', 11, 'box', 3.50), ('Oatmeal', 11, 'pack', 2.80), ('Honey Nut Cheerios', 11, 'box', 4.20), ('Pancake Mix', 11, 'box', 3.00), ('Maple Syrup', 11, 'bottle', 7.50),
-- Pasta, Baking, Spices
('Spaghetti', 12, 'pack', 1.50), ('Penne Rigate', 12, 'pack', 1.60), ('Basmati Rice', 12, 'kg', 3.50), ('Quinoa', 12, 'pack', 4.50), ('Egg Noodles', 12, 'pack', 2.00),
('All-Purpose Flour', 13, 'kg', 1.20), ('White Sugar', 13, 'kg', 1.10), ('Baking Powder', 13, 'tin', 2.00), ('Vanilla Extract', 13, 'bottle', 5.00), ('Cocoa Powder', 13, 'pack', 3.50),
('Black Pepper', 14, 'jar', 2.50), ('Sea Salt', 14, 'jar', 1.50), ('Garlic Powder', 14, 'jar', 2.00), ('Paprika', 14, 'jar', 2.20), ('Oregano', 14, 'jar', 1.80),
-- Deli, Coffee, Baby, Pet
('Sliced Ham', 15, 'pack', 4.50), ('Salami', 15, 'pack', 5.00), ('Provolone Cheese', 15, 'pack', 4.80), ('Hummus', 15, 'tub', 3.50), ('Olives', 15, 'jar', 3.00),
('Ground Coffee 500g', 16, 'pack', 8.50), ('Coffee Beans 1kg', 16, 'pack', 15.00), ('Earl Grey Tea 50 bags', 16, 'box', 4.00), ('Instant Coffee', 16, 'jar', 6.00), ('Chamomile Tea', 16, 'box', 3.50),
('Baby Formula', 17, 'tin', 18.00), ('Diapers Size 4', 17, 'pack', 12.50), ('Baby Wipes', 17, 'pack', 3.00), ('Dry Dog Food 5kg', 18, 'bag', 15.00), ('Canned Cat Food', 18, 'tin', 1.50),
-- Cleaning, Paper, Personal Care, Electronics, etc.
('Dish Soap', 19, 'bottle', 2.50), ('Glass Cleaner', 19, 'bottle', 3.00), ('Sponges 3-pack', 19, 'pack', 1.50), ('Laundry Detergent', 20, 'bottle', 9.50), ('Fabric Softener', 20, 'bottle', 5.00),
('Paper Towels', 21, 'pack', 4.50), ('Toilet Paper 12-roll', 21, 'pack', 8.00), ('Tissues', 21, 'box', 2.00), ('Shampoo 400ml', 22, 'bottle', 4.50), ('Toothpaste', 22, 'tube', 2.80),
('Pain Reliever (Ibuprofen)', 23, 'box', 5.00), ('Band-Aids', 23, 'box', 3.00), ('Hand Cream', 24, 'tube', 4.00), ('Lip Balm', 24, 'pcs', 2.50), ('Notebook A4', 25, 'pcs', 2.00),
('Ballpoint Pens 5-pack', 25, 'pack', 1.50), ('LED Light Bulb', 26, 'pcs', 3.50), ('AA Batteries 4-pack', 27, 'pack', 4.00), ('Duct Tape', 28, 'roll', 3.00), ('Potting Soil 10L', 29, 'bag', 5.50);
GO

-- =========================================================================
-- 4. Заполнение [Receipts] (100 поступлений)
-- Имитируем разные даты поступлений за последние несколько месяцев
-- store_id (1-50)
-- =========================================================================
DECLARE @i INT = 1;
WHILE @i <= 100
    BEGIN
        INSERT INTO [dbo].[Receipts] ([receipt_date], [store_id])
        VALUES (
                   DATEADD(day, -(@i * 2) % 365, DATEADD(hour, -(@i * 7) % 24, GETDATE())),
                   (@i % 50) + 1
               );
        SET @i = @i + 1;
    END;
GO

-- =========================================================================
-- 5. Заполнение [Receipt_lines] (100 строк поступлений)
-- Привязка к receipt_id (1-100) и product_id (1-100)
-- =========================================================================
DECLARE @j INT = 1;
WHILE @j <= 100
    BEGIN
        INSERT INTO [dbo].[Receipt_lines] ([receipt_id], [product_id], [quantity])
        -- Генерируем количество от 10 до 110
        VALUES (@j, (@j * 7) % 100 + 1, (@j * 13) % 100 + 10);
        SET @j = @j + 1;
    END;
GO

-- =========================================================================
-- 6. Заполнение [Sales] (100 продаж)
-- Имитируем разные даты продаж, store_id (1-50)
-- =========================================================================
DECLARE @k INT = 1;
WHILE @k <= 100
    BEGIN
        INSERT INTO [dbo].[Sales] ([sale_date], [store_id])
        VALUES (
                   DATEADD(minute, -(@k * 43) % 10000, GETDATE()),
                   (@k % 50) + 1
               );
        SET @k = @k + 1;
    END;
GO

-- =========================================================================
-- 7. Заполнение [Sales_lines] (100 строк продаж)
-- Привязка к sale_id (1-100) и product_id (1-100)
-- =========================================================================
DECLARE @m INT = 1;
WHILE @m <= 100
    BEGIN
        INSERT INTO [dbo].[Sales_lines] ([sale_id], [product_id], [quantity])
        -- Генерируем случайное количество от 1 до 10
        VALUES (@m, (@m * 11) % 100 + 1, (@m * 3) % 10 + 1);
        SET @m = @m + 1;
    END;
GO