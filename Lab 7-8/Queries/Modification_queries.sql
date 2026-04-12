-- 1. Увеличение стоимости товаров из определенной группы
DECLARE @TargetGroup VARCHAR(80) = 'Snacks & Candy';
UPDATE p
SET p.price = p.price * 1.15
FROM Products AS p
JOIN Product_groups AS pg ON pg.group_id = p.group_id
WHERE pg.group_name = @TargetGroup

-- 2. Уценка на все товары, которые еще не были ни разу проданы
UPDATE Products
SET price = price * 0.9
WHERE NOT EXISTS(
    SELECT 1
    FROM Sales_lines AS sl
    WHERE sl.product_id = Products.product_id
)

-- 3. Выравнивание цены товаров, стоимостью меньше 10 у.е.
UPDATE p
SET p.price = (
        SELECT AVG(temp_p.price)
        FROM Products AS temp_p
        WHERE temp_p.price < 10
        )
FROM Products AS p
WHERE p.price < 10

-- 4. Удаление заголовков ведомостей продаж без строк
DELETE FROM Sales
WHERE NOT EXISTS(
    SELECT 1
    FROM Sales_lines AS sl
    WHERE sl.sale_id = Sales.sale_id
)

-- 5. Удаление истории продаж конкретного магазина в конкретную дату
DECLARE @TargetStoreID INT = 39;
DECLARE @TargetDate DATETIME2 = '2025-05-01'
DELETE FROM Sales_lines
WHERE sale_id IN (
    SELECT s.sale_id
    FROM Sales AS s
    WHERE s.store_id = @TargetStoreID
      AND CAST(s.sale_date AS DATE) = CAST(@TargetDate AS DATE)
    )

-- 6. Создать представление с выручкой магазинов
CREATE VIEW Store_with_revenue AS
SELECT st.store_name,
       CAST(ISNULL(SUM(sl.quantity * p.price), 0) AS DECIMAL(18, 2)) AS revenue
FROM Stores AS st
LEFT JOIN Sales AS s ON s.store_id = st.store_id
LEFT JOIN Sales_lines AS sl ON sl.sale_id = s.sale_id
LEFT JOIN Products AS p ON sl.product_id = p.product_id
GROUP BY st.store_name

-- 7. Увеличение цены на самые популярные товары
UPDATE p
SET p.price = p.price * 1.10
FROM Products AS p
WHERE p.product_id IN (
    SELECT TOP(10)
        sl.product_id
    FROM Sales_lines AS sl
    GROUP BY sl.product_id
    ORDER BY SUM(sl.quantity) DESC
    )

-- 8. Очистка от неиспользуемых товаров
DELETE FROM Products
WHERE NOT EXISTS (
    SELECT 1
    FROM Receipt_lines AS rl
    WHERE rl.product_id = Products.product_id
)
  AND NOT EXISTS (
    SELECT 1
    FROM Sales_lines AS sl
    WHERE sl.product_id = Products.product_id
);

-- 9. Переоценка сразу нескольких ценовых категорий
UPDATE Products
SET price = CASE
    WHEN price > 10 AND price <= 20 THEN price * 1.05
    WHEN price > 20 AND price <= 50 THEN price * 0.95
END
WHERE price > 10 AND price <= 50

-- 10. Текущий остаток товаров на сладе
CREATE VIEW Goods_remaining AS
WITH TotalIn AS (
    SELECT product_id,
           SUM(quantity) AS quantity_in
    FROM Receipt_lines
    GROUP BY product_id
),
TotalOut AS (
    SELECT product_id,
           SUM(quantity) AS quantity_out
    FROM Sales_lines
    GROUP BY product_id
)
SELECT p.product_name,
       pg.group_id,
       p.unit,
       CAST(p.price AS DECIMAL(18, 2)) AS price,
       CAST(ISNULL(tin.quantity_in, 0) - ISNULL(tout.quantity_out, 0) AS DECIMAL(18, 2)) AS remnant
FROM Products AS p
JOIN Product_groups AS pg ON pg.group_id = p.group_id
LEFT JOIN TotalIn AS tin ON tin.product_id = p.product_id
LEFT JOIN TotalOut AS tout ON tout.product_id = p.product_id


