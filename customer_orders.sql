-- Create the customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    FOREIGH KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create the order_items table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT, REFERENCES orders(order_id),
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGH KEY (order_id) REFERENCES orders(order_id)
);

-- Insert customers
INSERT INTO customers (first_name, last_name, email, signup_date) VALUES
('Alice', 'Johnson', 'alice@example.com', '2024-01-01'),
('Bob', 'Smith', 'bob@example.com', '2024-01-15'),
('Charlie', 'Brown', 'charlie@example.com', '2024-02-01');

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-02-10 14:30:00', 150.00),
(2, '2024-02-15 16:00:00', 90.50),
(3, '2024-02-20 10:45:00', 200.75);

-- Insert order items
INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1, 'Laptop', 1, 150.00),
(2, 'Keyboard', 1, 40.50),
(2, 'Mouse', 1, 50.00),
(3, 'Monitor', 1, 200.75);

--Get total sales by customer
SELECT c.customer_id, 
       c.first_name, 
       c.last_name, 
       COUNT(o.order_id) AS total_orders, 
       SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount) > 100
ORDER BY total_spent DESC;

--Running total of orders per customer
SELECT 
    customer_id,
    order_id,
    order_date,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders;


--Find orders with more than one item
SELECT order_id, COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
HAVING COUNT(*) > 1;

--Get the most recent orders
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= NOW() - INTERVAL 30 DAY 
ORDER BY order_date DESC;


