-- ============================================================
-- 04_Clinic_Queries.sql
-- Solutions for Clinic Management System (Part B, Q1-Q5)
-- ============================================================

-- Set the year parameter here (change as needed)
-- For MySQL/MariaDB you can use a variable:
SET @target_year  = 2021;
SET @target_month = 9;   -- used for Q4 and Q5

-- ============================================================
-- Q1: Revenue from each sales channel in a given year
-- ============================================================
-- Logic: Simple GROUP BY on sales_channel with SUM(amount).

SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = @target_year
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- ============================================================
-- Q2: Top 10 most valuable customers for a given year
-- ============================================================
-- Logic: Sum up all sales per customer for the year,
--        order descending, limit to 10.

SELECT
    c.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM customer c
JOIN clinic_sales cs ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = @target_year
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- ============================================================
-- Q3: Month-wise revenue, expense, profit, and
--     status (profitable / not-profitable) for a given year
-- ============================================================
-- Logic: Aggregate revenue from clinic_sales and expenses
--        from expenses separately per month, then JOIN and
--        compute profit = revenue - expense.

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @target_year
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS expense
    FROM expenses
    WHERE YEAR(datetime) = @target_year
    GROUP BY MONTH(datetime)
)
SELECT
    COALESCE(r.month_num, e.month_num)               AS month_num,
    COALESCE(r.revenue,  0)                           AS revenue,
    COALESCE(e.expense,  0)                           AS expense,
    COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)  AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0
             THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM monthly_revenue r
LEFT  JOIN monthly_expense e ON r.month_num = e.month_num
UNION
SELECT
    COALESCE(r.month_num, e.month_num),
    COALESCE(r.revenue,  0),
    COALESCE(e.expense,  0),
    COALESCE(r.revenue, 0) - COALESCE(e.expense, 0),
    CASE
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0
             THEN 'Profitable'
        ELSE 'Not-Profitable'
    END
FROM monthly_expense e
LEFT  JOIN monthly_revenue r ON e.month_num = r.month_num
WHERE r.month_num IS NULL
ORDER BY month_num;

-- ============================================================
-- Q4: For each city, find the most profitable clinic
--     for a given month
-- ============================================================
-- Logic: Compute (revenue - expense) per clinic for the month.
--        Use RANK() partitioned by city to get rank=1 = most
--        profitable clinic in each city.

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(SUM(cs.amount), 0)                    AS revenue,
        COALESCE(
            (SELECT SUM(e.amount)
             FROM expenses e
             WHERE e.cid = cl.cid
               AND YEAR(e.datetime)  = @target_year
               AND MONTH(e.datetime) = @target_month), 0
        )                                               AS expense,
        COALESCE(SUM(cs.amount), 0) -
        COALESCE(
            (SELECT SUM(e.amount)
             FROM expenses e
             WHERE e.cid = cl.cid
               AND YEAR(e.datetime)  = @target_year
               AND MONTH(e.datetime) = @target_month), 0
        )                                               AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs
           ON cl.cid = cs.cid
          AND YEAR(cs.datetime)  = @target_year
          AND MONTH(cs.datetime) = @target_month
    GROUP BY cl.cid, cl.clinic_name, cl.city
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, clinic_name, revenue, expense, profit
FROM ranked
WHERE rnk = 1
ORDER BY city;

-- ============================================================
-- Q5: For each state, find the 2nd LEAST profitable clinic
--     for a given month
-- ============================================================
-- Logic: Same profit calculation but RANK() ordered ASC
--        (ascending = least profitable first).
--        Filter rank = 2 for the second least profitable.

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(SUM(cs.amount), 0)                    AS revenue,
        COALESCE(
            (SELECT SUM(e.amount)
             FROM expenses e
             WHERE e.cid = cl.cid
               AND YEAR(e.datetime)  = @target_year
               AND MONTH(e.datetime) = @target_month), 0
        )                                               AS expense,
        COALESCE(SUM(cs.amount), 0) -
        COALESCE(
            (SELECT SUM(e.amount)
             FROM expenses e
             WHERE e.cid = cl.cid
               AND YEAR(e.datetime)  = @target_year
               AND MONTH(e.datetime) = @target_month), 0
        )                                               AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs
           ON cl.cid = cs.cid
          AND YEAR(cs.datetime)  = @target_year
          AND MONTH(cs.datetime) = @target_month
    GROUP BY cl.cid, cl.clinic_name, cl.city, cl.state
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, clinic_name, city, revenue, expense, profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
