-- Форма 3.34
DECLARE @StartDate DATETIME2 = '2025-01-01';
DECLARE @EndDate DATETIME2 = '2025-01-31';

WITH IncomeStats AS (
    SELECT p.group_id,
           SUM(IIF(r.receipt_date < @StartDate,
                   rl.quantity * p.price,
                   0)) AS income_before_period,
           SUM(IIF(r.receipt_date >= @StartDate AND r.receipt_date < @EndDate,
                   rl.quantity * p.price,
                   0)) AS income_during_period
    FROM Receipt_lines AS rl
    JOIN Products AS p ON p.product_id = rl.product_id
    JOIN Receipts AS r ON r.receipt_id = rl.receipt_id
    GROUP BY p.group_id
),
ExpenseStats AS(
    SELECT p.group_id,
           SUM(IIF(s.sale_date < @StartDate,
                   sl.quantity * p.price,
                   0)) AS expense_before_period,
           SUM(IIF(s.sale_date >= @StartDate AND s.sale_date < @EndDate,
                   sl.quantity * p.price,
                   0)) AS expense_during_period
    FROM Sales_lines AS sl
    JOIN Products AS p ON p.product_id = sl.product_id
    JOIN Sales AS s ON s.sale_id = sl.sale_id
    GROUP BY p.group_id
),
ReportData AS (
    SELECT
        pg.group_name as [Товарная_группа],

        ISNULL(istats.income_before_period, 0)
            - ISNULL(estats.expense_before_period, 0) AS [Остаток_на_начало],

        ISNULL(istats.income_during_period, 0) AS [Приход],
        ISNULL(estats.expense_during_period, 0) AS [Расход],

        ISNULL(istats.income_before_period, 0)
            - ISNULL(estats.expense_before_period, 0)
            + ISNULL(istats.income_during_period, 0)
            - ISNULL(estats.expense_during_period, 0)
            AS [Остаток_на_конец]

    FROM Product_groups AS pg
    LEFT JOIN IncomeStats AS istats ON istats.group_id = pg.group_id
    LEFT JOIN ExpenseStats AS estats ON estats.group_id = pg.group_id
)

-- Финальный запрос
SELECT [Товарная_группа],
       CAST([Остаток_на_начало] AS DECIMAL(18, 2)) AS [Остаток_на_начало],
       CAST([Приход] AS DECIMAL(18, 2)) AS [Приход],
       CAST([Расход]AS DECIMAL(18, 2)) AS [Расход],
       CAST([Остаток_на_конец] AS DECIMAL(18, 2)) AS [Остаток_на_конец]
FROM (
SELECT 1 AS sort_order, * FROM ReportData
UNION ALL
SELECT 2 AS sort_order,
    'Result',
       SUM([Остаток_на_начало]),
       SUM([Приход]),
       SUM([Расход]),
       SUM([Остаток_на_конец]) FROM ReportData
                               ) AS FinalTable
    ORDER BY sort_order, [Товарная_группа]
