# 📚 Library Database – SQL (Basic) Assignment

## Assignment Overview

This assignment demonstrates fundamental SQL skills including:
- **Data Definition Language (DDL)**: Creating tables with constraints
- **Data Manipulation Language (DML)**: INSERT, UPDATE, DELETE
- **Data Retrieval**: SELECT queries with filtering, sorting, and limiting
- **Aggregate Functions**: COUNT, SUM, AVG, MAX, MIN
- **Grouping**: GROUP BY and HAVING clauses
- **Joins**: INNER JOIN, LEFT JOIN, RIGHT JOIN

---

## Database Schema

### `Authors` Table

| Column       | Data Type    | Constraints |
|--------------|-------------|-------------|
| `author_id`  | INT          | PRIMARY KEY |
| `author_name`| VARCHAR(100) | NOT NULL    |
| `country`    | VARCHAR(50)  | NOT NULL    |

### `Books` Table

| Column           | Data Type     | Constraints              |
|------------------|--------------|--------------------------|
| `book_id`        | INT           | PRIMARY KEY              |
| `title`          | VARCHAR(100)  | NOT NULL                 |
| `author_id`      | INT           | NOT NULL, FOREIGN KEY    |
| `category`       | VARCHAR(50)   | NOT NULL                 |
| `price`          | DECIMAL(10,2) | NOT NULL                 |
| `published_year` | INT           | NOT NULL                 |

### `Publishers` Table *(Task 21)*

| Column             | Data Type    | Constraints              |
|--------------------|-------------|--------------------------|
| `publisher_id`     | INT          | PRIMARY KEY              |
| `publisher_name`   | VARCHAR(150) | NOT NULL, UNIQUE         |
| `country`          | VARCHAR(50)  | NOT NULL, DEFAULT 'India'|
| `established_year` | INT          | NOT NULL                 |

---

## Sample Data

- **7 Authors** from India, USA, Israel, United Kingdom, and Brazil
- **12 Books** across 4 categories: Fiction, Non-Fiction, Programming, Mystery

---

## Tasks Covered

| Section | Tasks  | Topics                          |
|---------|--------|---------------------------------|
| 1       | 1–4    | Basic SELECT queries            |
| 2       | 5–9    | WHERE clause filtering          |
| 3       | 10–11  | ORDER BY & LIMIT                |
| 4       | 12     | Aggregate functions             |
| 5       | 13–14  | GROUP BY & HAVING               |
| 6       | 15–17  | INNER, LEFT, RIGHT JOINs        |
| 7       | 18–20  | INSERT, UPDATE, DELETE          |
| 8       | 21     | Table creation with constraints |

---

## Steps to Execute the SQL Script

### Prerequisites
- MySQL 8.0+ (or compatible) installed and running
- A MySQL client: MySQL Workbench, DBeaver, or the MySQL CLI

### Option 1: MySQL Command Line

```bash
# Log in to MySQL
mysql -u root -p

# Run the SQL script
mysql -u root -p < library_assignment.sql
```

### Option 2: MySQL Workbench / DBeaver

1. Open your SQL client.
2. Create a new connection to your local MySQL server.
3. Go to **File → Open SQL Script** and select `library_assignment.sql`.
4. Click **Run / Execute All** (or press `Ctrl+Shift+Enter` in Workbench).

### Option 3: Run inside MySQL CLI

```sql
SOURCE /path/to/library_assignment.sql;
```

---

## Project Structure

```
BE assignment 3/
├── library_assignment.sql   -- Main SQL file with all queries
└── README.md                -- This file
```

---

## Author

**Harshavardhan Gaikwad**  
BE Backend Development Assignment – SQL Basics
