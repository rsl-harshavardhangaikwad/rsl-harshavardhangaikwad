# Advanced SQL Assignment — Online Shopping Platform

## Overview

This assignment demonstrates advanced SQL concepts applied to an **Online Shopping Platform** database.  
It covers a complete database lifecycle — from schema design and sample data population to complex querying,
automation, and performance optimization — across **11 sections** and **20 tasks**.

---

## Database Schema

```
┌─────────────────────────────┐        ┌─────────────────────────────┐
│          Customers          │        │          Products            │
├─────────────────────────────┤        ├─────────────────────────────┤
│ customer_id  INT (PK, AI)   │        │ product_id   INT (PK, AI)   │
│ customer_name VARCHAR(100)  │        │ product_name VARCHAR(150)   │
│ city          VARCHAR(100)  │        │ category     VARCHAR(100)   │
│ email         VARCHAR(150)  │        │ price        DECIMAL(10,2)  │
└──────────────┬──────────────┘        └──────────────┬──────────────┘
               │                                      │
               │          ┌───────────────────────────┘
               │          │
               ▼          ▼
        ┌──────────────────────────────────┐
        │              Orders             │
        ├──────────────────────────────────┤
        │ order_id    INT (PK, AI)         │
        │ customer_id INT (FK → Customers) │
        │ product_id  INT (FK → Products)  │
        │ quantity    INT                  │
        │ order_date  DATE                 │
        └──────────┬───────────────────────┘
                   │
                   │ (auto-populated by trigger)
                   ▼
        ┌──────────────────────────────────┐
        │           Order_Audit           │
        ├──────────────────────────────────┤
        │ audit_id    INT (PK, AI)         │
        │ order_id    INT                  │
        │ customer_id INT                  │
        │ product_id  INT                  │
        │ quantity    INT                  │
        │ order_date  DATE                 │
        │ inserted_at DATETIME             │
        │ action      VARCHAR(50)          │
        └──────────────────────────────────┘
```

### Sample Data Volume
| Table        | Rows |
|--------------|------|
| Customers    | 13   |
| Products     | 12   |
| Orders       | 26   |
| Order_Audit  | auto |

---

## Steps to Execute the SQL Script

### Prerequisites
- MySQL 8.0 or higher
- MySQL Workbench **or** any MySQL client (DBeaver, HeidiSQL, CLI)

### Using MySQL Workbench
1. Open MySQL Workbench and connect to your local server.
2. Go to **File → Open SQL Script** and select `advanced_sql_assignment.sql`.
3. Click the ⚡ **Execute All** button (or press `Ctrl+Shift+Enter`).
4. Review results in the **Result Grid** tabs below.

### Using MySQL CLI
```bash
# Option 1: Run the entire script at once
mysql -u root -p < advanced_sql_assignment.sql

# Option 2: Connect first, then source the file
mysql -u root -p
mysql> SOURCE /path/to/advanced_sql_assignment.sql;
```

> **Note:** The script begins with `DROP DATABASE IF EXISTS online_shopping;`  
> This will **drop and recreate** the database on every run — safe for fresh starts.

---

## Implemented SQL Concepts — Summary

| Section | Task | Concept | Description |
|---------|------|---------|-------------|
| **1 — Advanced Joins** | 1 | INNER JOIN | Customers with their ordered products |
| | 2 | CROSS JOIN | All possible customer-product combinations |
| | 3 | LEFT JOIN | All customers including those with no orders |
| **2 — Subqueries** | 4 | Scalar Subquery | Products priced above average |
| | 5 | HAVING + Subquery | Customers above average spend |
| | 6 | Correlated Subquery | Highest-priced product per category |
| **3 — Set Operations** | 7 | UNION | Products from two categories combined |
| | 8a | INTERSECT alt. | Customers who bought Electronics AND Footwear |
| | 8b | EXCEPT alt. | Customers who bought Electronics but NOT Footwear |
| **4 — Window Functions** | 9 | RANK / DENSE_RANK | Price ranking within each category |
| | 10 | LAG + SUM (running total) | Previous price and cumulative total |
| **5 — CTEs** | 11 | Multi-step CTE | Customers above average spend |
| | 12 | Recursive CTE | Number sequence 1–10 |
| **6 — Views** | 13 | CREATE VIEW | Premium products (price > ₹1,000) |
| **7 — Indexes** | 14 | CREATE INDEX | Index on `category`; composite index on `(customer_id, order_date)` |
| | 15 | EXPLAIN | Query execution plan analysis |
| **8 — Procedures & Functions** | 16 | Stored Procedure | `sp_GetProductsByCategory(category)` |
| | 17 | User-Defined Function | `fn_CalculateOrderTotal(order_id)` |
| **9 — Transactions** | 18 | COMMIT / ROLLBACK | Price update with commit and simulated rollback |
| **10 — Triggers** | 19 | AFTER INSERT Trigger | Auto-log new orders into `Order_Audit` |
| **11 — Performance Tuning** | 20 | Query Optimization | Remove SELECT *, DISTINCT; avoid functions on columns; use composite index + range predicate |

---

## Key Database Objects

| Object Type | Name | Purpose |
|-------------|------|---------|
| View | `vw_premium_products` | Products priced above ₹1,000 |
| Index | `idx_products_category` | Faster category filtering |
| Index | `idx_orders_customer_date` | Faster order lookups by customer + date |
| Index | `idx_products_cat_date` | Composite index for optimised query (Task 20) |
| Stored Procedure | `sp_GetProductsByCategory` | Retrieve products filtered by category |
| Function | `fn_CalculateOrderTotal` | Calculate total price for an order |
| Trigger | `trg_AfterOrderInsert` | Auto-audit all new order inserts |

---

## Author
**Harshavardhan Gaikwad**  
BE Assignment 4 — Advanced SQL
