DROP DATABASE IF EXISTS EcommerceDB;
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    product_price DECIMAL (10, 2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) CHECK (order_status IN ('Pending', 'Completed', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
    order_id INT,
    product_id INT,
    order_quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Home & Kitchen');

INSERT INTO Products (product_name, product_price, category_id) VALUES
('Laptop Dell XPS', 1500.00, 1),
('iPhone 15', 1000.00, 1),
('Wireless Mouse', 25.00, 1),
('T-Shirt Cotton', 20.00, 2),
('Jeans Slim Fit', 50.00, 2),
('Coffee Maker', 80.00, 3),
('Air Fryer', 120.00, 3);

INSERT INTO Customers (customer_name, customer_city) VALUES
('Nguyen Van A', 'Ha Noi'),
('Tran Thi B', 'HCM'),
('Le Van C', 'Da Nang'),
('Pham Thi D', 'Ha Noi'),
('Hoang Van E', 'HCM');

INSERT INTO Orders (customer_id, order_date, order_status) VALUES
(1, '2026-09-01', 'Completed'),
(2, '2026-09-02', 'Completed'),
(3, '2026-09-03', 'Cancelled'),
(1, '2026-09-05', 'Completed'),
(4, '2026-09-10', 'Completed'),
(5, '2026-09-12', 'Pending'),
(2, '2026-09-15', 'Completed');

INSERT INTO OrderDetails (order_id, product_id, order_quantity, unit_price) VALUES
(1, 1, 1, 1500.00),
(1, 3, 2, 25.00),
(2, 2, 1, 1000.00),
(2, 4, 3, 20.00),
(3, 5, 2, 50.00),
(4, 3, 5, 25.00),
(4, 6, 1, 80.00),
(5, 7, 2, 120.00),
(6, 1, 1, 1500.00),
(7, 2, 2, 1000.00),
(7, 5, 1, 50.00);

SELECT
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT
    c.category_name,
    AVG(p.product_price) AS avg_price,
    MAX(p.product_price) AS max_price,
    MIN(p.product_price) AS min_price
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY order_status;

SELECT
    cu.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers cu
JOIN Orders o ON cu.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY cu.customer_name;

SELECT
    o.order_id,
    o.order_date,
    SUM(od.order_quantity * od.unit_price) AS total_revenue
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.order_id, o.order_date;

SELECT
    p.product_name,
    SUM(od.order_quantity) AS total_quantity
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_name;

SELECT
    cu.customer_name,
    SUM(od.order_quantity * od.unit_price) AS total_spent
FROM Customers cu
JOIN Orders o ON cu.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
WHERE o.order_status = 'Completed'
GROUP BY cu.customer_name
HAVING SUM(od.order_quantity * od.unit_price) > 1000;

SELECT
    c.category_name,
    SUM(od.order_quantity) AS total_quantity
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY c.category_name
HAVING SUM(od.order_quantity) > 3;

SELECT
    cu.customer_city,
    SUM(od.order_quantity * od.unit_price) AS total_revenue
FROM Customers cu
JOIN Orders o ON cu.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY cu.customer_city
HAVING SUM(od.order_quantity * od.unit_price) > 1500;

