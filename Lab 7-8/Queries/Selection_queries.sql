-- 1. Поиск товара, который был получен, но еще ни разу не был продан
SELECT * FROM Products AS p
WHERE EXISTS(SELECT 1 FROM Receipt_lines WHERE Receipt_lines.product_id = p.product_id)
    AND NOT EXISTS(SELECT 1 FROM Sales_lines WHERE Sales_lines.product_id = p.product_id)

-- 2. Топ самых прибыльных товаров
SELECT TOP(5)
    p.product_name,
    SUM(p.price * sl.quantity) AS total
FROM Products AS p
JOIN Sales_lines AS sl ON sl.product_id = p.product_id
GROUP BY p.product_name
ORDER BY SUM(p.price * sl.quantity) DESC

-- 3. Магазины с выручкой ниже среднего по сети
WITH StoreSales AS (
SELECT st.*,
       SUM(sl.quantity * p.price) AS profit
FROM Stores AS st
JOIN Sales AS s ON s.store_id = st.store_id
JOIN Sales_lines AS sl ON sl.sale_id = s.sale_id
JOIN Products AS p ON p.product_id = sl.product_id
GROUP BY st.store_id, st.store_name
)

SELECT store_name,
       CAST(profit AS DECIMAL(18,2)) AS profit
FROM StoreSales AS ss
WHERE profit < (SELECT AVG(profit) FROM StoreSales)
ORDER BY profit DESC

-- 4. Товары, цена которых выше всех товаров группы [Товарная группа]
DECLARE @ProductGroupName VARCHAR(MAX) = 'Coffee & Tea';
SELECT product_name,
       price
FROM Products AS p
WHERE p.price > ALL(
    SELECT price From Products AS temp_p
                 JOIN Product_groups AS temp_pg ON temp_p.group_id = temp_pg.group_id
                 WHERE temp_pg.group_name = @ProductGroupName
    )

-- 5. Самая крупная покупка
SELECT TOP(1)
    s.sale_id,
    st.store_name,
    s.sale_date,
    SUM(p.price * sl.quantity) AS total
FROM Sales AS s
JOIN Sales_lines AS sl ON sl.sale_id = s.sale_id
JOIN Products AS p ON p.product_id = sl.product_id
JOIN Stores AS st ON st.store_id = s.store_id
GROUP BY s.sale_id, st.store_name, s.sale_date
ORDER BY SUM(p.price * sl.quantity) DESC

-- 6. Поиск магазинов, в которые были поступления, но не было ни одной продажи за конкретный год
DECLARE @Date DATETIME2 = '2025-01-01';
SELECT s.* FROM Stores AS s
JOIN Receipts AS r ON r.store_id = s.store_id
WHERE YEAR(r.receipt_date) = YEAR(@Date)
EXCEPT
SELECT s.* FROM Stores AS s
JOIN Sales AS sa ON sa.store_id = s.store_id
WHERE YEAR(sa.sale_date) = YEAR(@Date)

-- 7. Товары, проданные во всех магазинах
SELECT p.*
FROM Products AS p
JOIN Sales_lines AS sl ON sl.product_id = p.product_id
JOIN Sales AS s ON s.sale_id = sl.sale_id
JOIN Stores AS st ON st.store_id = s.store_id
GROUP BY p.product_id, product_name, group_id, unit, price
HAVING COUNT(DISTINCT st.store_id) = (
    SELECT COUNT(*) FROM Stores
    )

-- 8. Среднее количество товаров в одном чеке (по строкам и по единицам товара)
WITH SalesInfo AS (
    SELECT sl.sale_id,
           COUNT(sl.product_id) AS Positions_count,
           SUM(sl.quantity) AS Total_quantity
    FROM Sales_lines AS sl
    GROUP BY sl.sale_id
)
SELECT CAST(AVG(CAST(Positions_count AS FLOAT)) AS DECIMAL(18, 2)) AS Product_count,
       CAST(AVG(CAST(Total_quantity AS FLOAT)) AS DECIMAL(18, 2)) AS Total_quantity
FROM SalesInfo

-- 9. Товары без покупок в конкретном году
DECLARE @Date DATETIME2 = GETDATE();
SELECT p.* FROM Products AS p
LEFT JOIN (
    SELECT DISTINCT sl.product_id
    FROM Sales_lines AS sl
    JOIN Sales AS s ON s.sale_id = sl.sale_id
    WHERE YEAR(s.sale_date) = YEAR(@Date)
) AS SoldThisYear ON SoldThisYear.product_id = p.product_id
WHERE SoldThisYear.product_id IS NULL

-- 10. Доля товарной группы в общей выручке
WITH GroupRevenue AS (
    SELECT pg.group_name,
           SUM(p.price * sl.quantity) AS revenue
    FROM Product_groups AS pg
    JOIN Products AS p ON p.group_id = pg.group_id
    JOIN Sales_lines AS sl ON sl.product_id = p.product_id
    GROUP BY pg.group_name
),
FinalTable AS (SELECT gr.group_name,
       gr.revenue,
       (revenue / (SELECT SUM(revenue) FROM GroupRevenue)) * 100
           AS revenue_share
FROM GroupRevenue AS gr)
SELECT group_name,
       revenue,
       CAST(CAST(revenue_share AS DECIMAL(18, 2)) AS VARCHAR) + '%' AS revenue_share
       FROM FinalTable
UNION ALL
SELECT 'Total:',
       SUM(ft.revenue),
       CAST(CAST(SUM(ft.revenue_share) AS DECIMAL(18, 2)) AS VARCHAR) + '%'
FROM FinalTable AS ft