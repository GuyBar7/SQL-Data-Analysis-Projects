# AdventureWorks SQL Analysis

[![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-0B5CAD?logo=microsoftsqlserver&logoColor=white)](https://learn.microsoft.com/sql/samples/adventureworks-install-configure)
[![License: MIT](https://img.shields.io/badge/License-MIT-20B2AA.svg)](./LICENSE)

A portfolio project that answers 10 business-focused questions against Microsoft’s AdventureWorks sample database. The analysis covers customer activity, product demand, order value, monthly trends, and workforce history using reusable T-SQL patterns.

> This project was completed as the final SQL assignment in a Data Analyst course. The repository includes the questions, the full query script, and saved CSV outputs for review without a local database setup.

## What This Project Demonstrates

- Multi-table analysis across Sales, Production, Person, and Human Resources schemas
- CTEs and window functions for ranking, sequencing, and running totals
- Aggregation, conditional null handling, and string concatenation
- PIVOT-based monthly reporting
- Clear separation between business questions, SQL logic, and exported results

## Analysis Map

| # | Business question | Main SQL techniques | Output |
|---|---|---|---|
| 1 | Which products have never been purchased? | Subquery, `NOT IN`, sorting | [CSV](./results/Q1_results.csv) |
| 2 | Which customers have not placed an order? | `LEFT JOIN`, subquery, `ISNULL` | [CSV](./results/Q2_results.csv) |
| 3 | Who are the 10 most frequent customers? | Multi-table joins, `COUNT`, `TOP` | [CSV](./results/Q3_results.csv) |
| 4 | How many employees share each job title? | `COUNT() OVER`, partitioning | [CSV](./results/Q4_results.csv) |
| 5 | What are each customer’s two most recent order dates? | CTE, `LAG`, `RANK` | [CSV](./results/Q5_results.csv) |
| 6 | What was the highest-value order in each year? | Aggregation, CTE, `ROW_NUMBER` | [CSV](./results/Q6_results.csv) |
| 7 | How many orders were placed per month and year? | `PIVOT`, date extraction | [CSV](./results/Q7_results.csv) |
| 8 | How do discounted unit-price totals accumulate by month? | Running `SUM`, CTEs, `UNION` | [CSV](./results/Q8_results.csv) |
| 9 | How did hiring progress within each department? | `LAG`, `DATEDIFF`, partitioning | [CSV](./results/Q9_results.csv) |
| 10 | How can employees be grouped by department and hire date? | `STRING_AGG`, grouping | [CSV](./results/Q10_results.csv) |

Read the full [business questions](./quetions.md) or review the complete [T-SQL script](./sql_queries.sql).

## Selected Results

- Two customers—Dalton Perez and Mason Roberts—share the highest order count in the saved output, with 28 orders each.
- The highest calculated annual order total in the saved results occurs in 2013 at 163,930.4.
- The monthly order matrix makes the dataset’s partial-year coverage visible: 2011 begins in May, while 2014 ends in June.

These are snapshots from the included dataset and query run; results can vary with the AdventureWorks version used.

## Repository Structure

```text
.
├── README.md
├── quetions.md
├── sql_queries.sql
└── results/
    ├── Q1_results.csv
    ├── ...
    └── Q10_results.csv
```

## Run the Analysis

1. Install SQL Server and SQL Server Management Studio (SSMS), or use another client that supports SQL Server.
2. Download and restore an [AdventureWorks sample database](https://learn.microsoft.com/sql/samples/adventureworks-install-configure).
3. Open [`sql_queries.sql`](./sql_queries.sql) and connect to the restored database.
4. Run the query sections individually or execute the script in sequence.
5. Compare your output with the reference files in [`results/`](./results/).

> Query 9 calculates tenure with `GETDATE()`, so that column changes depending on the execution date.

## License

This project is available under the [MIT License](./LICENSE).

---

If you find this project useful, explore the rest of [my GitHub portfolio](https://github.com/GuyBar7).
