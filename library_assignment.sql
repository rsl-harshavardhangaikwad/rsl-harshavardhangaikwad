-- ============================================================
--  DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- ============================================================
--  TABLE CREATION
-- ============================================================

-- Drop tables if they already exist (for re-runs)
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;

-- Authors Table
CREATE TABLE Authors (
    author_id   INT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    country     VARCHAR(50)  NOT NULL
);

-- Books Table
CREATE TABLE Books (
    book_id        INT PRIMARY KEY,
    title          VARCHAR(100) NOT NULL,
    author_id      INT          NOT NULL,
    category       VARCHAR(50)  NOT NULL,
    price          DECIMAL(10, 2) NOT NULL,
    published_year INT          NOT NULL,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- ============================================================
--  SAMPLE DATA - Authors (at least 5)
-- ============================================================

INSERT INTO Authors (author_id, author_name, country) VALUES
(1, 'Chetan Bhagat',        'India'),
(2, 'Robert C. Martin',     'USA'),
(3, 'Yuval Noah Harari',    'Israel'),
(4, 'Agatha Christie',      'United Kingdom'),
(5, 'Paulo Coelho',         'Brazil'),
(6, 'Mark Lutz',            'USA'),
(7, 'Ruskin Bond',          'India');


-- ============================================================
--  SAMPLE DATA - Books (at least 10, varied categories)
-- ============================================================

INSERT INTO Books (book_id, title, author_id, category, price, published_year) VALUES
(1,  'The Alchemist',               5,  'Fiction',      650.00, 1988),
(2,  'Sapiens',                     3,  'Non-Fiction',  799.00, 2011),
(3,  'Clean Code',                  2,  'Programming',  899.00, 2008),
(4,  'Murder on the Orient Express',4,  'Mystery',      549.00, 1934),
(5,  'Five Point Someone',          1,  'Fiction',      399.00, 2004),
(6,  'Learning Python',             6,  'Programming',  999.00, 2013),
(7,  'Homo Deus',                   3,  'Non-Fiction',  749.00, 2015),
(8,  'And Then There Were None',    4,  'Mystery',      499.00, 1939),
(9,  'The Clean Coder',             2,  'Programming',  749.00, 2011),
(10, 'Stories by Ruskin Bond',      7,  'Fiction',      450.00, 2010),
(11, 'Revolution 2020',             1,  'Fiction',      349.00, 2011),
(12, '21 Lessons for the 21st C.',  3,  'Non-Fiction',  699.00, 2018);


-- ============================================================
--  SECTION 1: Basic Queries
-- ============================================================

-- Task 1: Display all books
SELECT * FROM Books;

-- Task 2: Display only the book title and price
SELECT title, price FROM Books;

-- Task 3: Display title as "Book Name" and price as "Book Price"
SELECT title AS "Book Name", price AS "Book Price" FROM Books;

-- Task 4: Display all unique book categories
SELECT DISTINCT category FROM Books;


-- ============================================================
--  SECTION 2: Filtering Data
-- ============================================================

-- Task 5: Display books priced above 700
SELECT * FROM Books
WHERE price > 700;

-- Task 6: Display books priced between 500 and 800
SELECT * FROM Books
WHERE price BETWEEN 500 AND 800;

-- Task 7: Display books that belong to the 'Programming' category
SELECT * FROM Books
WHERE category = 'Programming';

-- Task 8: Display books whose titles start with the letter 'S'
SELECT * FROM Books
WHERE title LIKE 'S%';

-- Task 9: Display books published after 2020
SELECT * FROM Books
WHERE published_year > 2020;


-- ============================================================
--  SECTION 3: Sorting and Limiting Results
-- ============================================================

-- Task 10: Display books sorted by price in descending order
SELECT * FROM Books
ORDER BY price DESC;

-- Task 11: Display the top 3 most expensive books
SELECT * FROM Books
ORDER BY price DESC
LIMIT 3;


-- ============================================================
--  SECTION 4: Aggregate Functions
-- ============================================================

-- Task 12: Total count, total price, average, highest, and lowest price
SELECT
    COUNT(*)     AS Total_Number_of_Books,
    SUM(price)   AS Total_Price,
    AVG(price)   AS Average_Price,
    MAX(price)   AS Highest_Price,
    MIN(price)   AS Lowest_Price
FROM Books;


-- ============================================================
--  SECTION 5: GROUP BY and HAVING
-- ============================================================

-- Task 13: Average book price for each category
SELECT
    category,
    ROUND(AVG(price), 2) AS Average_Price
FROM Books
GROUP BY category;

-- Task 14: Categories whose average price is greater than 650
SELECT
    category,
    ROUND(AVG(price), 2) AS Average_Price
FROM Books
GROUP BY category
HAVING AVG(price) > 650;


-- ============================================================
--  SECTION 6: Joins
-- ============================================================

-- Task 15: Each book with its author's name (INNER JOIN)
SELECT
    b.book_id,
    b.title,
    a.author_name,
    b.category,
    b.price,
    b.published_year
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

-- Task 16: All authors with the books they have written (LEFT JOIN)
SELECT
    a.author_id,
    a.author_name,
    a.country,
    b.title,
    b.category,
    b.price
FROM Authors a
LEFT JOIN Books b ON a.author_id = b.author_id;

-- Task 17: All books with their author details (RIGHT JOIN)
SELECT
    b.book_id,
    b.title,
    b.category,
    b.price,
    b.published_year,
    a.author_name,
    a.country
FROM Authors a
RIGHT JOIN Books b ON a.author_id = b.author_id;


-- ============================================================
--  SECTION 7: Data Manipulation
-- ============================================================

-- Task 18: Insert a new book into the Books table
INSERT INTO Books (book_id, title, author_id, category, price, published_year)
VALUES (13, 'The Secret', 5, 'Self-Help', 599.00, 2006);

-- Verify the insert
SELECT * FROM Books WHERE book_id = 13;

-- Task 19: Update the price of the inserted book
UPDATE Books
SET price = 699.00
WHERE book_id = 13;

-- Verify the update
SELECT * FROM Books WHERE book_id = 13;

-- Task 20: Delete the inserted book record
DELETE FROM Books
WHERE book_id = 13;

-- Verify the deletion
SELECT * FROM Books WHERE book_id = 13;


-- ============================================================
--  SECTION 8: Creating Tables and Constraints
-- ============================================================

-- Task 21: Create Publishers table with all required constraints
DROP TABLE IF EXISTS Publishers;

CREATE TABLE Publishers (
    publisher_id      INT            PRIMARY KEY,              -- PRIMARY KEY constraint
    publisher_name    VARCHAR(150)   NOT NULL UNIQUE,          -- NOT NULL + UNIQUE constraints
    country           VARCHAR(50)    NOT NULL DEFAULT 'India', -- NOT NULL + DEFAULT constraint
    established_year  INT            NOT NULL
);

-- Verify the table structure
DESC Publishers;
