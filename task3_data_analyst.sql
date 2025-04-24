CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES (1, 'Alice', 'alice@example.com'), (2, 'Bob', 'bob@example.com');
INSERT INTO products VALUES (1, 'Laptop', 800.00), (2, 'Mouse', 20.00);
INSERT INTO orders VALUES (1, 1, '2024-01-10'), (2, 2, '2024-01-12');
INSERT INTO order_items VALUES (1, 1, 1, 1), (2, 1, 2, 2), (3, 2, 2, 1);
# total revanu of the product
SELECT p.product_name, SUM(p.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name; 
#Average revanue per user
SELECT c.name, AVG(p.price * oi.quantity) AS avg_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name;
#creat a view
 CREATE VIEW customer_revenue AS
SELECT c.customer_id, c.name, SUM(p.price * oi.quantity) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name;
# Inner Join with a Filter Condition
SELECT * FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.name = 'Alice';
#Ordering Results
SELECT * FROM products ORDER BY price DESC;
# Left Join to Include All Customers
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
#Subquery with Aggregate Function
SELECT name FROM customer_revenue
WHERE revenue > (
  SELECT AVG(revenue) FROM customer_revenue
);
#Handle NULL values:
SELECT IFNULL(c.name, 'No Name') AS customer_name, o.order_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id;
#Create Index
CREATE INDEX idx_customer_id ON orders(customer_id);


