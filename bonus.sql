WITH
    total_revenue AS (
        SELECT
            DATE_FORMAT(sales.sale_date, '%M %Y') AS month_year,
            SUM(sales.total_price) AS monthly_revenue
        FROM sales
        GROUP BY month_year
    ),
    associates AS (
        SELECT
            CONCAT(first_name, ' ', last_name) AS employee_name,
            position,
            employee_id
        FROM employees
        WHERE position = 'Sales Associate'
    ),
    associate_sale_totals AS (
        SELECT
            associates.employee_name,
            associates.position,
            DATE_FORMAT(sales.sale_date, '%M %Y') AS month_year,
            SUM(sales.total_price) AS monthly_total,
            total_revenue.monthly_revenue AS TMR
        FROM associates
        JOIN sales ON sales.employee_id = associates.employee_id
        JOIN total_revenue ON month_year = total_revenue.month_year
        GROUP BY associates.employee_name, associates.position, DATE_FORMAT(sales.sale_date, '%M %Y'), total_revenue.monthly_revenue
    ),
    associate_bonus AS (
        SELECT
            employee_name,
            position,
            month_year,
            CASE
                WHEN monthly_total / TMR * 100 > 40 THEN 25000
                WHEN monthly_total / TMR * 100 BETWEEN 30 AND 40 THEN 15000
                WHEN monthly_total / TMR * 100 BETWEEN 20 AND 30 THEN 10000
                WHEN monthly_total / TMR * 100 BETWEEN 10 AND 20 THEN 5000
                WHEN monthly_total / TMR * 100 BETWEEN 5 AND 10 THEN 2000
                WHEN monthly_total / TMR * 100 < 5 THEN 0
            END AS employee_bonus
        FROM associate_sale_totals
    )
SELECT * from associate_bonus
    ORDER BY employee_bonus ASC;
