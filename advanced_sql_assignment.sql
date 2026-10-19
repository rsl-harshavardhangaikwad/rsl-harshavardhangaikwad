 -- ─────────────────────────────────────────────
--  DATABASE SETUP
-- ─────────────────────────────────────────────
DROP DATABASE IF EXISTS online_shopping;
CREATE DATABASE online_shopping;
USE online_shopping;

-- ─────────────────────────────────────────────
--  TABLE CREATION
-- ─────────────────────────────────────────────

-- Customers table
CREATE TABLE Customers (
    customer_id   INT          PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL
);

-- Products table
CREATE TABLE Products (
    product_id   INT            PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150)   NOT NULL,
    category     VARCHAR(100)   NOT NULL,
    price        DECIMAL(10, 2) NOT NULL
);

-- Orders table
CREATE TABLE Orders (
    order_id    INT  PRIMARY KEY AUTO_INCREMENT,
    customer_id INT  NOT NULL,
    product_id  INT  NOT NULL,
    quantity    INT  NOT NULL DEFAULT 1,
    order_date  DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES Products(product_id)
);

-- Order_Audit table (used by trigger in Section 10)
CREATE TABLE Order_Audit (
    audit_id    INT          PRIMARY KEY AUTO_INCREMENT,
    order_id    INT          NOT NULL,
    customer_id INT          NOT NULL,
    product_id  INT          NOT NULL,
    quantity    INT          NOT NULL,
    order_date  DATE         NOT NULL,
    inserted_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action      VARCHAR(50)  NOT NULL DEFAULT 'INSERT'
);

-- ─────────────────────────────────────────────
--  SAMPLE DATA - CUSTOMERS  (12 rows + 1 with no orders)
-- ─────────────────────────────────────────────
INSERT INTO Customers (customer_name, city, email) VALUES
('Aarav Sharma',    'Mumbai',    'aarav.sharma@email.com'),
('Priya Patel',     'Ahmedabad', 'priya.patel@email.com'),
('Rohit Verma',     'Delhi',     'rohit.verma@email.com'),
('Sneha Iyer',      'Chennai',   'sneha.iyer@email.com'),
('Karan Mehta',     'Pune',      'karan.mehta@email.com'),
('Divya Nair',      'Bangalore', 'divya.nair@email.com'),
('Arjun Reddy',     'Hyderabad', 'arjun.reddy@email.com'),
('Pooja Joshi',     'Jaipur',    'pooja.joshi@email.com'),
('Vikram Singh',    'Chandigarh','vikram.singh@email.com'),
('Meera Pillai',    'Kochi',     'meera.pillai@email.com'),
('Rahul Gupta',     'Kolkata',   'rahul.gupta@email.com'),
('Anjali Desai',    'Surat',     'anjali.desai@email.com'),
('Tanvi Kulkarni',  'Nagpur',    'tanvi.kulkarni@email.com');  -- no orders (for Task 3 demo)

-- ─────────────────────────────────────────────
--  SAMPLE DATA - PRODUCTS  (12 rows)
-- ─────────────────────────────────────────────
INSERT INTO Products (product_name, category, price) VALUES
('iPhone 15',           'Electronics',  79999.00),
('Samsung Galaxy S23',  'Electronics',  69999.00),
('Sony WH-1000XM5',     'Electronics',  24999.00),
('Dell Inspiron 15',    'Electronics',  55000.00),
('Nike Air Max',        'Footwear',      8999.00),
('Adidas Ultraboost',   'Footwear',     12999.00),
('Puma RS-X',           'Footwear',      6499.00),
("Levi's 511 Jeans",    'Clothing',      3499.00),
('Allen Solly Shirt',   'Clothing',      1299.00),
('Peter England Suit',  'Clothing',      7999.00),
('Prestige Cooker',     'Kitchen',       2499.00),
('Philips Air Fryer',   'Kitchen',       5999.00);

-- ─────────────────────────────────────────────
--  SAMPLE DATA - ORDERS  (25 rows)
-- ─────────────────────────────────────────────
INSERT INTO Orders (customer_id, product_id, quantity, order_date) VALUES
(1,  1,  1, '2024-01-05'),
(1,  3,  1, '2024-02-10'),
(2,  2,  1, '2024-01-15'),
(2,  5,  2, '2024-03-20'),
(3,  4,  1, '2024-02-25'),
(3,  8,  3, '2024-04-10'),
(4,  6,  1, '2024-01-30'),
(4,  9,  2, '2024-03-15'),
(5,  1,  1, '2024-04-05'),
(5, 10,  1, '2024-05-12'),
(6,  7,  2, '2024-02-18'),
(6, 11,  1, '2024-03-22'),
(7,  2,  1, '2024-05-01'),
(7, 12,  1, '2024-06-08'),
(8,  3,  2, '2024-01-25'),
(8,  5,  1, '2024-04-19'),
(9,  4,  1, '2024-06-14'),
(9,  6,  1, '2024-07-03'),
(10, 8,  2, '2024-07-20'),
(10, 9,  3, '2024-08-05'),
(11, 10, 1, '2024-08-15'),
(11, 11, 2, '2024-09-01'),
(12, 12, 1, '2024-09-18'),
(12,  1, 1, '2024-10-02'),
(2,  12, 2, '2024-10-10');


-- ============================================================
--  SECTION 1: ADVANCED JOINS
-- ============================================================

-- Task 1: Display each customer along with the products they ordered
--         (INNER JOIN - only customers who placed at least one order)
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.order_date,
    (p.price * o.quantity) AS total_amount
FROM Customers c
JOIN Orders    o ON c.customer_id = o.customer_id
JOIN Products  p ON o.product_id  = p.product_id
ORDER BY c.customer_id, o.order_date;


-- Task 2: Display all possible combinations of customers and products
--         using CROSS JOIN
SELECT
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    p.price
FROM Customers c
CROSS JOIN Products p
ORDER BY c.customer_name, p.product_name;


-- Task 3: Display all customers and their orders, including customers
--         who have NOT placed any orders (LEFT JOIN)
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COALESCE(p.product_name, 'No Orders Placed')  AS product_name,
    COALESCE(CAST(o.quantity AS CHAR), 'N/A')      AS quantity,
    COALESCE(CAST(o.order_date AS CHAR), 'N/A')    AS order_date
FROM Customers c
LEFT JOIN Orders   o ON c.customer_id = o.customer_id
LEFT JOIN Products p ON o.product_id  = p.product_id
ORDER BY c.customer_id;


-- ============================================================
--  SECTION 2: SUBQUERIES
-- ============================================================

-- Task 4: Find products priced above the average product price
SELECT
    product_id,
    product_name,
    category,
    price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;


-- Task 5: Display customers whose total purchase amount is greater than
--         the average customer purchase amount
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(p.price * o.quantity) AS total_purchase_amount
FROM Customers c
JOIN Orders   o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING SUM(p.price * o.quantity) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            o2.customer_id,
            SUM(p2.price * o2.quantity) AS customer_total
        FROM Orders   o2
        JOIN Products p2 ON o2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) AS avg_table
)
ORDER BY total_purchase_amount DESC;


-- Task 6: Find the highest-priced product in each category
--         using a correlated subquery
SELECT
    p1.category,
    p1.product_name,
    p1.price
FROM Products p1
WHERE p1.price = (
    SELECT MAX(p2.price)
    FROM Products p2
    WHERE p2.category = p1.category   -- correlated reference
)
ORDER BY p1.category;


-- ============================================================
--  SECTION 3: SET OPERATIONS
-- ============================================================

-- Task 7: Combine products from two different categories using UNION
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics'

UNION

SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Footwear'

ORDER BY category, price DESC;


-- Task 8: MySQL alternatives for INTERSECT and EXCEPT
-- 8a) INTERSECT alternative - customers who ordered BOTH Electronics AND Footwear
SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM Customers c
JOIN Orders   o1 ON c.customer_id = o1.customer_id
JOIN Products p1 ON o1.product_id  = p1.product_id AND p1.category = 'Electronics'
JOIN Orders   o2 ON c.customer_id = o2.customer_id
JOIN Products p2 ON o2.product_id  = p2.product_id AND p2.category = 'Footwear'
ORDER BY c.customer_id;

-- 8b) EXCEPT alternative - customers who ordered Electronics but NOT Footwear
SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM Customers c
JOIN Orders   o1 ON c.customer_id = o1.customer_id
JOIN Products p1 ON o1.product_id  = p1.product_id AND p1.category = 'Electronics'
LEFT JOIN (
    SELECT o2.customer_id
    FROM Orders   o2
    JOIN Products p2 ON o2.product_id = p2.product_id AND p2.category = 'Footwear'
) AS footwear_buyers ON c.customer_id = footwear_buyers.customer_id
WHERE footwear_buyers.customer_id IS NULL
ORDER BY c.customer_id;


-- ============================================================
--  SECTION 4: WINDOW FUNCTIONS
-- ============================================================

-- Task 9: Rank products by price within each category
SELECT
    product_id,
    product_name,
    category,
    price,
    RANK()       OVER (PARTITION BY category ORDER BY price DESC) AS price_rank,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS row_num
FROM Products
ORDER BY category, price DESC;


-- Task 10: Display the previous product price (LAG) and
--          a running total of product prices using window functions
SELECT
    product_id,
    product_name,
    category,
    price,
    LAG(price, 1, 0) OVER (
        PARTITION BY category
        ORDER BY product_id
    )                                                   AS previous_price,
    price - LAG(price, 1, 0) OVER (
        PARTITION BY category
        ORDER BY product_id
    )                                                   AS price_difference,
    SUM(price) OVER (
        PARTITION BY category
        ORDER BY product_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                   AS running_total
FROM Products
ORDER BY category, product_id;


-- ============================================================
--  SECTION 5: COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================

-- Task 11: CTE to display customers whose total purchase amount
--          is above the average
WITH CustomerPurchase AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        SUM(p.price * o.quantity) AS total_purchase
    FROM Customers c
    JOIN Orders   o ON c.customer_id = o.customer_id
    JOIN Products p ON o.product_id  = p.product_id
    GROUP BY c.customer_id, c.customer_name, c.city
),
AvgPurchase AS (
    SELECT AVG(total_purchase) AS avg_purchase
    FROM CustomerPurchase
)
SELECT
    cp.customer_id,
    cp.customer_name,
    cp.city,
    cp.total_purchase,
    ap.avg_purchase,
    ROUND(cp.total_purchase - ap.avg_purchase, 2) AS above_avg_by
FROM CustomerPurchase cp
CROSS JOIN AvgPurchase ap
WHERE cp.total_purchase > ap.avg_purchase
ORDER BY cp.total_purchase DESC;


-- Task 12: Recursive CTE to generate a sequence of numbers from 1 to 10
WITH RECURSIVE NumberSeries AS (
    SELECT 1 AS num       -- Anchor member

    UNION ALL

    SELECT num + 1        -- Recursive member
    FROM NumberSeries
    WHERE num < 10
)
SELECT num AS sequence_number
FROM NumberSeries;


-- ============================================================
--  SECTION 6: VIEWS
-- ============================================================

-- Task 13: Create a view for products priced above 1000
--          and retrieve data from the view
DROP VIEW IF EXISTS vw_premium_products;

CREATE VIEW vw_premium_products AS
SELECT
    product_id,
    product_name,
    category,
    price
FROM Products
WHERE price > 1000;

-- Retrieve all records from the view
SELECT * FROM vw_premium_products
ORDER BY category, price DESC;

-- Retrieve only Electronics from the view
SELECT * FROM vw_premium_products
WHERE category = 'Electronics'
ORDER BY price DESC;


-- ============================================================
--  SECTION 7: INDEXES AND QUERY PERFORMANCE
-- ============================================================

-- Task 14: Create an index on the category column of the Products table
CREATE INDEX idx_products_category
ON Products (category);

-- Composite index for order lookups (customer + date)
CREATE INDEX idx_orders_customer_date
ON Orders (customer_id, order_date);


-- Task 15: Use EXPLAIN to analyse a query that filters products by category
EXPLAIN
SELECT
    product_id,
    product_name,
    price
FROM Products
WHERE category = 'Electronics';


-- ============================================================
--  SECTION 8: STORED PROCEDURES AND FUNCTIONS
-- ============================================================

-- Task 16: Stored procedure to retrieve products by category
DROP PROCEDURE IF EXISTS sp_GetProductsByCategory;

DELIMITER $$

CREATE PROCEDURE sp_GetProductsByCategory (
    IN  p_category VARCHAR(100)
)
BEGIN
    IF p_category IS NULL OR TRIM(p_category) = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Category parameter cannot be NULL or empty.';
    END IF;

    SELECT
        product_id,
        product_name,
        category,
        price
    FROM Products
    WHERE category = p_category
    ORDER BY price DESC;
END$$

DELIMITER ;

-- Test the procedure
CALL sp_GetProductsByCategory('Electronics');
CALL sp_GetProductsByCategory('Footwear');


-- Task 17: Function to calculate the total price of an order (price x quantity)
DROP FUNCTION IF EXISTS fn_CalculateOrderTotal;

DELIMITER $$

CREATE FUNCTION fn_CalculateOrderTotal (
    p_order_id INT
)
RETURNS DECIMAL(12, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12, 2) DEFAULT 0.00;

    SELECT SUM(p.price * o.quantity)
    INTO   v_total
    FROM   Orders   o
    JOIN   Products p ON o.product_id = p.product_id
    WHERE  o.order_id = p_order_id;

    RETURN IFNULL(v_total, 0.00);
END$$

DELIMITER ;

-- Test the function
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.quantity,
    p.price,
    fn_CalculateOrderTotal(o.order_id) AS order_total
FROM Orders   o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products  p ON o.product_id  = p.product_id
ORDER BY o.order_id;


-- ============================================================
--  SECTION 9: TRANSACTIONS
-- ============================================================

-- Task 18: Transaction with COMMIT and ROLLBACK demonstration

-- 18a) Successful transaction (COMMIT)
START TRANSACTION;

    SELECT product_id, product_name, price AS price_before
    FROM Products WHERE product_id = 1;

    -- Apply 10% price increase to iPhone 15
    UPDATE Products SET price = price * 1.10 WHERE product_id = 1;

    SELECT product_id, product_name, price AS price_after_update
    FROM Products WHERE product_id = 1;

COMMIT;  -- Permanently save the change

-- Verify committed price
SELECT product_id, product_name, price AS committed_price
FROM Products WHERE product_id = 1;


-- 18b) Rolled-back transaction (ROLLBACK)
START TRANSACTION;

    -- Attempt a 20% discount on Samsung Galaxy S23
    UPDATE Products SET price = price * 0.80 WHERE product_id = 2;

    SELECT product_id, product_name, price AS price_during_txn
    FROM Products WHERE product_id = 2;

    -- Simulate an error -> rollback all changes
ROLLBACK;  -- Undo the update

-- Verify original price was restored
SELECT product_id, product_name, price AS price_after_rollback
FROM Products WHERE product_id = 2;


-- ============================================================
--  SECTION 10: SQL TRIGGERS
-- ============================================================

-- Task 19: Trigger to record new orders in Order_Audit
--          whenever a new order is inserted
DROP TRIGGER IF EXISTS trg_AfterOrderInsert;

DELIMITER $$

CREATE TRIGGER trg_AfterOrderInsert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit (
        order_id,
        customer_id,
        product_id,
        quantity,
        order_date,
        inserted_at,
        action
    ) VALUES (
        NEW.order_id,
        NEW.customer_id,
        NEW.product_id,
        NEW.quantity,
        NEW.order_date,
        NOW(),
        'INSERT'
    );
END$$

DELIMITER ;

-- Test the trigger - insert a new order
INSERT INTO Orders (customer_id, product_id, quantity, order_date)
VALUES (3, 12, 2, '2024-10-15');

-- Verify the audit record was created automatically by the trigger
SELECT
    oa.audit_id,
    oa.order_id,
    c.customer_name,
    p.product_name,
    oa.quantity,
    oa.order_date,
    oa.inserted_at,
    oa.action
FROM Order_Audit oa
JOIN Customers   c ON oa.customer_id = c.customer_id
JOIN Products    p ON oa.product_id  = p.product_id
ORDER BY oa.audit_id DESC;


-- ============================================================
--  SECTION 11: PERFORMANCE TUNING
-- ============================================================

-- Task 20: Apply SQL performance tuning best practices

-- ORIGINAL (unoptimised) query:
-- SELECT DISTINCT *
-- FROM Products
-- WHERE YEAR(created_date) = 2024
-- AND category = 'Electronics';
--
-- Issues identified:
-- 1. SELECT *         : Fetches all columns, wastes I/O bandwidth
-- 2. SELECT DISTINCT  : Unnecessary when primary key is selected; forces sort/dedup
-- 3. YEAR(created_date): Wraps the column in a function, preventing index use

-- Add created_date column to Products for the demo
ALTER TABLE Products
    ADD COLUMN IF NOT EXISTS created_date DATE DEFAULT NULL;

UPDATE Products SET created_date = '2024-03-15' WHERE product_id IN (1, 3, 5, 7,  9, 11);
UPDATE Products SET created_date = '2023-06-20' WHERE product_id IN (2, 4, 6, 8, 10, 12);

-- Create a composite index to support the optimised query
CREATE INDEX idx_products_cat_date
ON Products (category, created_date);

-- OPTIMISED query:
-- 1. Select only needed columns (no SELECT *)
-- 2. Removed DISTINCT (primary key guarantees uniqueness)
-- 3. Replaced YEAR() function with a range predicate so the index is used
SELECT
    product_id,
    product_name,
    category,
    price,
    created_date
FROM Products
WHERE category     = 'Electronics'    -- exact match on leading index column
  AND created_date >= '2024-01-01'    -- range on second index column (no function)
  AND created_date <  '2025-01-01';   -- upper bound avoids function wrapping

-- Verify the optimised query uses the index
EXPLAIN
SELECT
    product_id,
    product_name,
    category,
    price,
    created_date
FROM Products
WHERE category     = 'Electronics'
  AND created_date >= '2024-01-01'
  AND created_date <  '2025-01-01';


-- ─────────────────────────────────────────────
--  END OF SCRIPT
-- ─────────────────────────────────────────────
