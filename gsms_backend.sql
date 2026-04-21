-- ============================================================
-- GROCERY STORE MANAGEMENT SYSTEM
-- MySQL Backend — Full Schema + Sample Data + Views + Procedures
-- ============================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS grocery_store_db;
USE grocery_store_db;

-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE Category (
    category_id    INT            PRIMARY KEY AUTO_INCREMENT,
    category_name  VARCHAR(100)   NOT NULL UNIQUE,
    description    TEXT,
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Supplier (
    supplier_id    INT            PRIMARY KEY AUTO_INCREMENT,
    supplier_name  VARCHAR(150)   NOT NULL,
    contact_person VARCHAR(100),
    phone          VARCHAR(20),
    email          VARCHAR(100)   UNIQUE,
    address        TEXT,
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Product (
    product_id     INT             PRIMARY KEY AUTO_INCREMENT,
    product_name   VARCHAR(150)    NOT NULL,
    category_id    INT             NOT NULL,
    supplier_id    INT             NOT NULL,
    unit_price     DECIMAL(10,2)   NOT NULL CHECK (unit_price > 0),
    stock_quantity INT             NOT NULL DEFAULT 0,
    reorder_level  INT             DEFAULT 10,
    created_at     TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE RESTRICT
);

CREATE TABLE Customer (
    customer_id       INT           PRIMARY KEY AUTO_INCREMENT,
    first_name        VARCHAR(100)  NOT NULL,
    last_name         VARCHAR(100)  NOT NULL,
    email             VARCHAR(150)  UNIQUE,
    phone             VARCHAR(20),
    city              VARCHAR(100),
    registration_date DATE          DEFAULT (CURRENT_DATE),
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    order_id       INT             PRIMARY KEY AUTO_INCREMENT,
    customer_id    INT             NOT NULL,
    order_date     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount   DECIMAL(10,2)   NOT NULL DEFAULT 0,
    payment_method VARCHAR(50)     NOT NULL,
    status         VARCHAR(50)     DEFAULT 'Pending',
    notes          TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE RESTRICT
);

CREATE TABLE Order_Items (
    item_id    INT           PRIMARY KEY AUTO_INCREMENT,
    order_id   INT           NOT NULL,
    product_id INT           NOT NULL,
    quantity   INT           NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal   DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id)   REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE RESTRICT
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO Category (category_name, description) VALUES
    ('Dairy',      'Milk, cheese, butter and other dairy products'),
    ('Bakery',     'Fresh breads, cakes and baked goods'),
    ('Fruits',     'Fresh seasonal and imported fruits'),
    ('Grains',     'Rice, wheat, dal and pulses'),
    ('Beverages',  'Juices, soft drinks, water and tea'),
    ('Snacks',     'Biscuits, chips and packaged snacks');

INSERT INTO Supplier (supplier_name, contact_person, phone, email, address) VALUES
    ('AgroFresh Farms',   'Kiran Reddy',   '9876543210', 'kiran@agrofresh.com',     '12 Farm Lane, Kurnool'),
    ('GrainMaster Co.',   'Anjali Mehta',  '9123456780', 'anjali@grainmaster.com',  '45 Market Rd, Hyderabad'),
    ('FruitVille Ltd.',   'Suresh Kumar',  '9988776655', 'suresh@fruitville.com',   '7 Orchard St, Bengaluru'),
    ('BakePro Supplies',  'Lata Iyer',     '9012345678', 'lata@bakepro.com',        '88 Mill Avenue, Chennai'),
    ('DrinkWell Inc.',    'Mohan Varma',   '9345678901', 'mohan@drinkwell.com',     '33 Spring St, Pune');

INSERT INTO Product (product_name, category_id, supplier_id, unit_price, stock_quantity, reorder_level) VALUES
    ('Full Cream Milk 1L',  1, 1,  48.00, 200, 50),
    ('Cheddar Cheese 200g', 1, 1, 120.00,  80, 20),
    ('Whole Wheat Bread',   2, 4,  35.00, 150, 30),
    ('Butter Croissant',    2, 4,  25.00,  90, 20),
    ('Alphonso Mangoes 1kg',3, 3, 180.00,  60, 15),
    ('Red Apples 1kg',      3, 3, 140.00,  75, 20),
    ('Basmati Rice 5kg',    4, 2, 320.00, 100, 25),
    ('Toor Dal 1kg',        4, 2,  95.00, 120, 30),
    ('Mango Juice 1L',      5, 5,  65.00, 180, 40),
    ('Mineral Water 1L',    5, 5,  20.00, 300, 80),
    ('Potato Chips 150g',   6, 2,  40.00,  50, 15),
    ('Butter 500g',         1, 1,  85.00,  45, 10);

INSERT INTO Customer (first_name, last_name, email, phone, city, registration_date) VALUES
    ('Priya',   'Sharma',  'priya.sharma@gmail.com',   '9871234567', 'Hyderabad', '2023-06-15'),
    ('Rahul',   'Nair',    'rahul.nair@gmail.com',     '9812345678', 'Bengaluru', '2023-07-20'),
    ('Ananya',  'Reddy',   'ananya.reddy@yahoo.com',   '9934567812', 'Kurnool',   '2023-08-05'),
    ('Vikram',  'Patel',   'vikram.patel@gmail.com',   '9845678123', 'Pune',      '2023-09-10'),
    ('Sneha',   'Iyer',    'sneha.iyer@gmail.com',     '9823456781', 'Chennai',   '2023-10-01'),
    ('Arjun',   'Menon',   'arjun.menon@gmail.com',    '9765432198', 'Kochi',     '2023-11-15'),
    ('Deepika', 'Singh',   'deepika.singh@yahoo.com',  '9756341290', 'Delhi',     '2024-01-05');

INSERT INTO Orders (customer_id, order_date, total_amount, payment_method, status) VALUES
    (1, '2024-03-01 10:15:00', 416.00, 'UPI',          'Delivered'),
    (2, '2024-03-02 11:30:00', 510.00, 'Credit Card',  'Delivered'),
    (3, '2024-03-03 14:00:00', 275.00, 'Cash',         'Delivered'),
    (4, '2024-03-04 09:45:00', 640.00, 'Debit Card',   'Delivered'),
    (1, '2024-03-05 16:20:00', 195.00, 'UPI',          'Delivered'),
    (5, '2024-03-06 13:00:00', 390.00, 'Net Banking',  'Delivered'),
    (6, '2024-03-07 10:00:00', 735.00, 'UPI',          'Shipped'),
    (7, '2024-03-08 15:30:00', 460.00, 'Cash',         'Pending');

INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 4, 48.00), (1, 3, 2, 35.00), (1, 9, 2, 65.00),
    (2, 7, 1, 320.00),(2, 8, 2, 95.00),
    (3, 5, 1, 180.00),(3, 6, 1, 140.00),
    (4, 7, 2, 320.00),
    (5, 3, 3, 35.00), (5, 10, 6, 20.00),
    (6, 2, 1, 120.00),(6, 9, 4, 65.00),
    (7, 5, 2, 180.00),(7, 6, 2, 140.00),(7, 1, 3, 48.00),
    (8, 3, 4, 35.00), (8, 4, 4, 25.00), (8, 8, 2, 95.00);

-- ============================================================
-- VIEWS
-- ============================================================

CREATE OR REPLACE VIEW SalesSummary AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    COUNT(DISTINCT oi.order_id)  AS total_orders,
    SUM(oi.quantity)             AS total_units_sold,
    SUM(oi.subtotal)             AS total_revenue,
    ROUND(AVG(oi.unit_price), 2) AS avg_selling_price
FROM Product p
JOIN Category    c  ON p.category_id = c.category_id
JOIN Order_Items oi ON p.product_id  = oi.product_id
JOIN Orders      o  ON oi.order_id   = o.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_revenue DESC;

CREATE OR REPLACE VIEW LowStockAlert AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock_quantity       AS current_stock,
    p.reorder_level,
    (p.reorder_level - p.stock_quantity) AS units_needed,
    s.supplier_name,
    s.phone                AS supplier_phone,
    s.email                AS supplier_email,
    CASE
        WHEN p.stock_quantity = 0                        THEN 'CRITICAL'
        WHEN p.stock_quantity <= p.reorder_level / 2     THEN 'HIGH'
        ELSE                                                  'MEDIUM'
    END AS urgency_level
FROM Product p
JOIN Category c ON p.category_id = c.category_id
JOIN Supplier s ON p.supplier_id = s.supplier_id
WHERE p.stock_quantity <= p.reorder_level
ORDER BY p.stock_quantity ASC;

CREATE OR REPLACE VIEW CustomerOrderSummary AS
SELECT
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.city,
    cu.email,
    COUNT(o.order_id)    AS total_orders,
    SUM(o.total_amount)  AS lifetime_spending,
    MAX(o.order_date)    AS last_order_date
FROM Customer cu
LEFT JOIN Orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name, cu.city, cu.email
ORDER BY lifetime_spending DESC;

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- Procedure: Place a new order
CREATE PROCEDURE PlaceOrder(
    IN p_customer_id INT,
    IN p_payment_method VARCHAR(50),
    OUT p_order_id INT
)
BEGIN
    INSERT INTO Orders (customer_id, payment_method, total_amount, status)
    VALUES (p_customer_id, p_payment_method, 0, 'Pending');
    SET p_order_id = LAST_INSERT_ID();
END$$

-- Procedure: Add item to order and update stock
CREATE PROCEDURE AddOrderItem(
    IN p_order_id   INT,
    IN p_product_id INT,
    IN p_quantity   INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;

    SELECT unit_price, stock_quantity INTO v_price, v_stock
    FROM Product WHERE product_id = p_product_id;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

    INSERT INTO Order_Items (order_id, product_id, quantity, unit_price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price);

    UPDATE Product SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;

    UPDATE Orders
    SET total_amount = (
        SELECT SUM(subtotal) FROM Order_Items WHERE order_id = p_order_id
    )
    WHERE order_id = p_order_id;
END$$

DELIMITER ;

-- ============================================================
-- USEFUL QUERIES FOR REPORTING
-- ============================================================

-- Q1: Products with category and supplier
SELECT p.product_id, p.product_name, c.category_name, s.supplier_name,
       p.unit_price, p.stock_quantity
FROM Product p
JOIN Category c ON p.category_id = c.category_id
JOIN Supplier s ON p.supplier_id = s.supplier_id
ORDER BY c.category_name, p.product_name;

-- Q2: Revenue per category
SELECT c.category_name, SUM(oi.subtotal) AS total_revenue
FROM Category c
JOIN Product p     ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id  = oi.product_id
GROUP BY c.category_name
HAVING SUM(oi.subtotal) > 500
ORDER BY total_revenue DESC;

-- Q3: High-value customers
SELECT CONCAT(cu.first_name,' ',cu.last_name) AS customer_name,
       cu.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS lifetime_spending
FROM Customer cu
JOIN Orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name, cu.city
HAVING SUM(o.total_amount) > 500
ORDER BY lifetime_spending DESC;

-- Q4: Products below average stock
SELECT p.product_name, p.stock_quantity, p.reorder_level
FROM Product p
WHERE p.stock_quantity < (SELECT AVG(stock_quantity) FROM Product)
ORDER BY p.stock_quantity ASC;
