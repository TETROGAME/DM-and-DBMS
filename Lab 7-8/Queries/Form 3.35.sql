-- Форма 3.35
DECLARE @ReportDate DATETIME2 = '2025-01-01';
DECLARE @StoreID INT = 50;  -- Доступны магазины с ID 1-50

WITH IncomeStats AS (
    SELECT rl.product_id,
           SUM(rl.quantity) AS total_income
    FROM Receipt_lines AS rl
    JOIN Receipts AS r ON r.receipt_id = rl.receipt_id
    WHERE r.store_id = @StoreID AND r.receipt_date <= @ReportDate
    GROUP BY rl.product_id
),
ExpenseStats AS(
    SELECT sl.product_id,
           SUM(sl.quantity) AS total_expense
    FROM Sales_lines AS sl
    JOIN Sales AS s ON s.sale_id = sl.sale_id
    WHERE s.store_id = @StoreID AND s.sale_date <= @ReportDate
    GROUP BY sl.product_id
),
ReportData AS(
    SELECT p.product_id AS [Номенклатурный_номер],
           p.product_name AS [Наименование],
           pg.group_name AS [Товарная_группа],
           p.unit AS [Единица_измерения],
           ISNULL(istats.total_income, 0) - ISNULL(estats.total_expense, 0) AS [Количество],
           p.price AS [Цена],
           p.price * (ISNULL(istats.total_income, 0) - ISNULL(estats.total_expense, 0)) AS [Стоимость]
    FROM Products AS p
    JOIN Product_groups AS pg ON pg.group_id = p.group_id
    LEFT JOIN IncomeStats AS istats ON istats.product_id = p.product_id
    LEFT JOIN ExpenseStats AS estats ON estats.product_id = p.product_id

    WHERE (ISNULL(istats.total_income, 0) - ISNULL(estats.total_expense, 0)) > 0
)

-- Финальный запрос
SELECT [Номенклатурный_номер],
       [Наименование],
       [Товарная_группа],
       [Единица_измерения],
       [Количество],
       [Цена],
       [Стоимость]
FROM (
    SELECT 1 AS sort_order,
           CAST([Номенклатурный_номер] AS VARCHAR(50)) AS [Номенклатурный_номер],
           [Наименование],
           [Товарная_группа],
           [Единица_измерения],
           CAST([Количество] AS DECIMAL(18, 2)) AS [Количество],
           CAST([Цена] AS DECIMAL(18, 2)) AS [Цена],
           CAST([Стоимость] AS DECIMAL(18, 2)) AS [Стоимость]
    FROM ReportData
    UNION ALL
    SELECT 2 AS sort_order,
           N'Итог',
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           SUM([Стоимость])
    FROM ReportData
    ) AS FinalTable
ORDER BY sort_order, [Номенклатурный_номер]