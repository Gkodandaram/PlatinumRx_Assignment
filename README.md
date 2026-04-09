# PlatinumRx Data Analyst Assignment

## Folder Structure

```
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    # Table creation + sample data for Hotel system
│   ├── 02_Hotel_Queries.sql         # Solutions for Part A (Q1–Q5)
│   ├── 03_Clinic_Schema_Setup.sql   # Table creation + sample data for Clinic system
│   └── 04_Clinic_Queries.sql        # Solutions for Part B (Q1–Q5)
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx         # Excel workbook with ticket & feedback analysis
├── Python/
│   ├── 01_Time_Converter.py         # Minutes → human-readable time
│   └── 02_Remove_Duplicates.py      # Remove duplicate characters from string
└── README.md
```

---

## Phase 1: SQL Proficiency

### Tools
- Compatible with **MySQL / MariaDB** (uses `YEAR()`, `MONTH()`, `HOUR()`, window functions).
- Run `01_Hotel_Schema_Setup.sql` first, then `02_Hotel_Queries.sql`.
- Run `03_Clinic_Schema_Setup.sql` first, then `04_Clinic_Queries.sql`.

### Part A – Hotel Management System

| Q | Question | Key Technique |
|---|----------|---------------|
| 1 | Last booked room per user | Correlated subquery with `MAX(booking_date)` |
| 2 | Total billing per booking in Nov 2021 | 3-table JOIN + `quantity × rate` aggregation |
| 3 | Bills > 1000 in Oct 2021 | `GROUP BY bill_id` + `HAVING` clause |
| 4 | Most & least ordered item per month | CTE + `RANK()` window function (ASC & DESC) |
| 5 | Customer with 2nd highest bill per month | CTE + `DENSE_RANK()` window function |

### Part B – Clinic Management System

| Q | Question | Key Technique |
|---|----------|---------------|
| 1 | Revenue by sales channel (given year) | `GROUP BY sales_channel` + `SUM(amount)` |
| 2 | Top 10 most valuable customers | `GROUP BY uid` + `ORDER BY DESC LIMIT 10` |
| 3 | Month-wise revenue, expense, profit, status | Two CTEs joined + `CASE` for status label |
| 4 | Most profitable clinic per city (given month) | CTE + `RANK()` partitioned by city |
| 5 | 2nd least profitable clinic per state (given month) | CTE + `DENSE_RANK()` partitioned by state, ordered ASC |

> **Note:** For Q4 and Q5 in the clinic queries, change `@target_year` and `@target_month` variables at the top of `04_Clinic_Queries.sql` to filter for any desired period.

---

## Phase 2: Spreadsheet Proficiency

**File:** `Spreadsheets/Ticket_Analysis.xlsx`

### Sheets

| Sheet | Purpose |
|-------|---------|
| `ticket` | Raw ticket data (ticket_id, created_at, closed_at, outlet_id, cms_id) |
| `feedbacks` | Feedback data with `ticket_created_at` auto-populated via formula |
| `Time_Analysis` | Helper columns + outlet-wise summary for same-day / same-hour counts |
| `Notes` | Formula reference and approach explanation |

### Q1 – Populate `ticket_created_at`
Uses `INDEX/MATCH` to look up `cms_id` across sheets:
```excel
=IFERROR(INDEX(ticket!$B$3:$B$12, MATCH(A3, ticket!$E$3:$E$12, 0)), "")
```
- **Lookup key:** `cms_id` (common column between both sheets)
- **Returns:** `created_at` from the `ticket` sheet

### Q2 – Tickets Created & Closed Same Day / Same Hour

**Same Day helper column:**
```excel
=IF(INT(created_at) = INT(closed_at), "TRUE", "FALSE")
```
`INT()` strips the time component, leaving just the date serial number.

**Same Hour helper column:**
```excel
=IF(AND(INT(created_at)=INT(closed_at), HOUR(created_at)=HOUR(closed_at)), "TRUE", "FALSE")
```

**Outlet-wise count (Summary table):**
```excel
=COUNTIFS(outlet_col, outlet_id, same_day_col, "TRUE")
```

---

## Phase 3: Python Proficiency

### 01_Time_Converter.py
Converts an integer number of minutes to a human-readable string.

```
Logic:
  hours   = total_minutes // 60   (integer division)
  minutes = total_minutes %  60   (modulo / remainder)
```

**Sample output:**
```
130 minutes  ->  2 hrs 10 minutes
110 minutes  ->  1 hr 50 minutes
 60 minutes  ->  1 hr 0 minutes
 45 minutes  ->  0 hrs 45 minutes
```

### 02_Remove_Duplicates.py
Removes duplicate characters from a string using a `for` loop, preserving first-occurrence order.

```
Logic:
  result = ""
  for char in input_string:
      if char not in result:
          result += char
```

**Sample output:**
```
'programming'  ->  'progamin'
'hello world'  ->  'helo wrd'
'aabbcc'       ->  'abc'
```

---

## Assumptions

- SQL dialect: **MySQL 8.0+** (window functions supported).
- Sample data was constructed to cover all query scenarios (e.g., bills > 1000, multiple months, multiple cities/states).
- For clinic Q4 & Q5, the target month is set to `9` (September 2021) by default — change `@target_month` as needed.
- The Excel formulas use absolute references (`$`) to remain stable if rows are added.
- Python scripts handle edge cases: empty strings, single characters, 0 minutes, invalid input.
