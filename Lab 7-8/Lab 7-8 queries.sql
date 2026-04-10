-- Форма 3.34
WITH Incoming (group_id, total_price) AS (
    SELECT pg.group_id,
        ROUND(SUM(rl.quantity * p.price), 2) AS total_price FROM Receipt_lines AS rl
        JOIN Products AS p ON p.product_id = rl.product_id
        JOIN Product_groups AS pg ON pg.group_id = p.group_id
        GROUP BY pg.group_id
),
Outcoming(group_id, total_price) AS (
    SELECT pg.group_id,
        ROUND(SUM(sl.quantity * p.price), 2) AS total_price FROM Sales_lines AS sl
            JOIN Products AS p ON p.product_id = sl.product_id
            JOIN Product_groups AS pg ON pg.group_id = p.group_id
    GROUP BY pg.group_id
), semiresult_334 (group_name, starting_remnant, income, outcome, final_remnant) AS (
    SELECT pg.group_name,
       0.00 AS starting_remnant,
       ISNULL(i.total_price, 0) AS income,
       ISNULL(o.total_price, 0) AS outcome,
       ROUND((0.00 + ISNULL(i.total_price, 0) - ISNULL(o.total_price, 0)), 2) AS final_remnant
FROM Product_groups AS pg
LEFT JOIN Incoming AS i ON pg.group_id = i.group_id
LEFT JOIN Outcoming AS o ON pg.group_id = o.group_id)
SELECT * FROM semiresult_334
UNION
SELECT 'Result',
       SUM(starting_remnant),
       SUM(income),
       SUM(outcome),
       SUM(final_remnant) FROM semiresult_334
    GROUP BY group_name
