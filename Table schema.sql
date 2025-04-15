-- Advanced SQL Project -- Walmart Datasets

-- create table
DROP TABLE IF EXISTS walmart;

CREATE TABLE walmart (
    invoice_id INT PRIMARY KEY,
    Branch VARCHAR(10),
    City VARCHAR(50),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2),
    quantity DECIMAL(10, 2),
    date VARCHAR(10),
    time VARCHAR(10),
    payment_method VARCHAR(20),
    rating DECIMAL(3, 1),
    profit_margin DECIMAL(4, 2),
    total DECIMAL(12, 2)
);