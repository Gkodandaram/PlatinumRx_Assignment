-- ============================================================
-- 02_Hotel_Queries.sql
-- Solutions for Hotel Management System (Part A, Q1-Q5)
-- ============================================================

-- ============================================================
-- Q1: For every user, get user_id and LAST booked room_no
-- ============================================================
-- Logic: Find the booking with the MAX(booking_date) per user.
-- Use a subquery or window function to get the latest booking per user.

SELECT
    u.user_id,
    b.room_no AS last_booked_room
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);

-- ============================================================
-- Q2: booking_id and total billing amount for every booking
--     created in November 2021
-- ============================================================
-- Logic: Join bookings -> booking_commercials -> items.
--        Multiply item_quantity * item_rate for each line,
--        then SUM per booking_id.
--        Filter bookings where booking_date is in Nov 2021.

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i                ON bc.item_id    = i.item_id
WHERE YEAR(b.booking_date)  = 2021
  AND MONTH(b.booking_date) = 11
GROUP BY b.booking_id;

-- ============================================================
-- Q3: bill_id and bill amount of all bills raised in
--     October 2021 having bill amount > 1000
-- ============================================================
-- Logic: Group by bill_id, sum up (quantity * rate),
--        filter by bill_date month, then apply HAVING.

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- ============================================================
-- Q4: Most ordered and least ordered item of each month
--     of year 2021
-- ============================================================
-- Logic: Aggregate total quantity ordered per item per month.
--        Use RANK() window function partitioned by month to
--        find rank=1 (most) and the last rank (least).

WITH monthly_item_totals AS (
    SELECT
        MONTH(bc.bill_date)         AS month_num,
        i.item_name,
        SUM(bc.item_quantity)       AS total_qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
),
ranked AS (
    SELECT
        month_num,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY month_num ORDER BY total_qty DESC) AS rnk_most,
        RANK() OVER (PARTITION BY month_num ORDER BY total_qty ASC)  AS rnk_least
    FROM monthly_item_totals
)
SELECT
    month_num,
    MAX(CASE WHEN rnk_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rnk_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
WHERE rnk_most = 1 OR rnk_least = 1
GROUP BY month_num
ORDER BY month_num;

-- ============================================================
-- Q5: Customers with the 2nd highest bill value
--     of each month of year 2021
-- ============================================================
-- Logic: Compute total bill per customer per month.
--        Use DENSE_RANK() so ties in 1st place don't skip 2nd.
--        Then filter for rank = 2.

WITH customer_monthly_bills AS (
    SELECT
        MONTH(bc.bill_date)                  AS month_num,
        u.user_id,
        u.name,
        SUM(bc.item_quantity * i.item_rate)  AS total_bill
    FROM bookings b
    JOIN booking_commercials bc ON b.booking_id = bc.booking_id
    JOIN items i                ON bc.item_id    = i.item_id
    JOIN users u                ON b.user_id     = u.user_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), u.user_id, u.name
),
ranked AS (
    SELECT
        month_num,
        user_id,
        name,
        total_bill,
        DENSE_RANK() OVER (PARTITION BY month_num ORDER BY total_bill DESC) AS bill_rank
    FROM customer_monthly_bills
)
SELECT
    month_num,
    user_id,
    name,
    total_bill AS second_highest_bill
FROM ranked
WHERE bill_rank = 2
ORDER BY month_num;
