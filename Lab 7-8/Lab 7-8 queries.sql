-- Форма 3.34
WITH invoice (group_name, total_price) AS (
    SELECT pg.group_name,
        SUM(rl.quantity * p.price) AS total_price FROM Receipt_lines AS rl
        JOIN Products AS p ON p.product_id = rl.product_id
        JOIN Product_groups AS pg ON pg.group_id = p.group_id
        GROUP BY pg.group_name
)
SELECT * FROM invoice