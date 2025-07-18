-- Create database if not exists
CREATE DATABASE IF NOT EXISTS food_service_db;
USE food_service_db;

-- 1. Vendors table
-- Stores supplier information
CREATE TABLE vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    vendor_email VARCHAR(100),
    vendor_phone VARCHAR(20),
    vendor_address VARCHAR(255)
);

-- 2. Employee table
-- Stores employee information
CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    employee_contact_information VARCHAR(255)
);

-- 6. Ingredient table
-- Stores ingredient information
CREATE TABLE ingredient (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL
);

-- 3. Customer table
-- Stores customer information
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_contact_way VARCHAR(100),
    customer_address VARCHAR(255),
    customer_purchase_history TEXT
);

-- 4. Vendor order table
-- Stores orders placed to vendors
CREATE TABLE vendor_order (
    vendor_order_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    employee_id INT NOT NULL,
    vendor_order_date DATE NOT NULL,
    ingredient_unit_price DECIMAL(10,2),
    vendor_order_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

-- 5. Vendor order line item table
-- Details of items in vendor orders
CREATE TABLE vendor_order_line_item (
    vendor_order_line_item_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_order_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    ingredient_unit_quantity INT NOT NULL,
    ingredient_unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (vendor_order_id) REFERENCES vendor_order(vendor_order_id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredient(ingredient_id)
);

-- 7. Ingredient purchase table
-- Records ingredient purchase history
CREATE TABLE ingredient_purchase (
    ingredient_purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_id INT NOT NULL,
    ingredient_purchase_quantity INT NOT NULL,
    ingredient_purchase_date DATE NOT NULL,
    expiration_date DATE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredient(ingredient_id)
);

-- 8. Fixed cost table
-- Records fixed business expenses
CREATE TABLE fixed_cost (
    fixed_cost_id INT AUTO_INCREMENT PRIMARY KEY,
    cost_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT
);

-- 9. Container table
-- Stores container inventory information
CREATE TABLE container (
    container_id INT AUTO_INCREMENT PRIMARY KEY,
    container_type VARCHAR(50) NOT NULL,
    container_quantity INT NOT NULL,
    container_date DATE,
    container_unit_cost DECIMAL(10,2) NOT NULL
);

-- 10. Meal table
-- Stores menu item information
CREATE TABLE meal (
    meal_id INT AUTO_INCREMENT PRIMARY KEY,
    meal_name VARCHAR(100) NOT NULL,
    meal_cost_of_goods_sold DECIMAL(10,2)
);

-- 11. Meal-ingredient relation table (many-to-many)
-- Links meals to their ingredients
CREATE TABLE meal_making (
    ingredient_id INT NOT NULL,
    meal_id INT NOT NULL,
    quantity_used INT NOT NULL,
    PRIMARY KEY (ingredient_id, meal_id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredient(ingredient_id),
    FOREIGN KEY (meal_id) REFERENCES meal(meal_id)
);

-- 12. Customer order table
-- Stores customer orders
CREATE TABLE customer_order (
    customer_order_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    customer_id INT NOT NULL,
    customer_order_date DATE NOT NULL,
    customer_order_total DECIMAL(10,2) NOT NULL,
    customer_order_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 13. Customer order line item table
-- Details of items in customer orders
CREATE TABLE customer_order_line_item (
    customer_order_line_item_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_order_id INT NOT NULL,
    meal_id INT NOT NULL,
    container_id INT,
    meal_unit_quantity INT NOT NULL,
    meal_unit_price DECIMAL(10,2) NOT NULL,
    meal_total DECIMAL(10,2) NOT NULL,
    unit_cost DECIMAL(10,2),
    number_of_delivered_containers INT,
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),
    FOREIGN KEY (meal_id) REFERENCES meal(meal_id),
    FOREIGN KEY (container_id) REFERENCES container(container_id)
);

-- ---------------------------
-- Insert sample data (in dependency order)
-- ---------------------------

-- 1. Insert vendors (original + new)
INSERT INTO vendors (vendor_name, vendor_email, vendor_phone, vendor_address)
VALUES 
('Fresh Foods', 'fresh@example.com', '1234567890', '123 Main St'),
('Container Co', 'containers@example.com', '2345678901', '456 Elm St'),
('Green Farms', 'green@example.com', '3456789012', '789 Farm Rd'),
('Seafood Direct', 'seafood@example.com', '4567890123', '12 Fisherman Wharf'),
('Bakery Plus', 'bakery@example.com', '5678901234', '56 Bread St'),
('Spice World', 'spices@example.com', '6789012345', '98 Spice Ave'),
('Dairy Delights', 'dairy@example.com', '7890123456', '34 Milk Way');

-- 2. Insert employees (original + new)
INSERT INTO employee (employee_name, employee_contact_information)
VALUES 
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Robert Johnson', 'robert.j@example.com'),
('Mary Williams', 'mary.w@example.com'),
('David Brown', 'david.b@example.com'),
('Lisa Davis', 'lisa.d@example.com');

-- 3. Insert customers (original + new)
INSERT INTO customer (customer_name, customer_contact_way, customer_address, customer_purchase_history)
VALUES 
('ABC Corp', 'Phone: 555-1234', '789 Oak St', 'Regular buyer'),
('XYZ Inc', 'Email: xyz@example.com', '321 Pine St', 'Occasional orders'),
('Best Restaurants', 'Phone: 555-5678', '123 Dine St', 'Weekly orders'),
('Catering Pros', 'Email: catering@example.com', '456 Event Pl', 'Large bulk orders'),
('Family Diner', 'Phone: 555-9012', '789 Eat Ave', 'Monthly supplies'),
('Fast Food Inc', 'Email: fast@example.com', '321 Quick St', 'Daily deliveries'),
('Cafe Express', 'Phone: 555-3456', '567 Brew Rd', 'Bi-weekly orders'),
('Grocery Mart', 'Email: grocery@example.com', '890 Market St', 'Wholesale purchases');

-- 4. Insert ingredients (original + new)
INSERT INTO ingredient (ingredient_name)
VALUES 
('Chicken'), ('Beef'), ('Flour'), ('Tomato'),
('Potato'), ('Carrot'), ('Onion'), ('Cheese'), 
('Lettuce'), ('Tomato Sauce'), ('Bun'), ('Spices');

-- 5. Insert containers (original + new)
INSERT INTO container (container_type, container_quantity, container_date, container_unit_cost)
VALUES 
('Paper Box', 100, '2025-01-01', 2.50),
('Plastic Bag', 200, '2025-02-01', 1.20),
('Plastic Container', 150, '2025-03-15', 3.00),
('Aluminum Foil', 300, '2025-04-10', 0.50),
('Paper Bag', 250, '2025-05-05', 1.80),
('Styrofoam Box', 120, '2025-06-01', 2.20);

-- 6. Insert meals (original + new)
INSERT INTO meal (meal_name, meal_cost_of_goods_sold)
VALUES 
('Chicken Burger', 8.50),
('Beef Stew', 12.00),
('Vegetable Stir Fry', 7.20),
('Cheese Burger', 9.00),
('Chicken Salad', 6.80),
('Beef Sandwich', 10.50),
('Pasta with Sauce', 8.30),
('Vegetable Soup', 5.50);

-- 7. Insert meal-ingredient relations (original + new)
INSERT INTO meal_making (ingredient_id, meal_id, quantity_used)
VALUES 
-- Original data
(1, 1, 1),   -- 1kg Chicken in Burger
(3, 1, 0.5), -- 0.5kg Flour in Burger
(2, 2, 1),   -- 1kg Beef in Stew
(4, 2, 2),   -- 2kg Tomato in Stew
-- New data
(3, 3, 1.5), (5, 3, 1), (6, 3, 0.5), (7, 3, 0.2),   -- Vegetable Stir Fry (ID=3)
(1, 4, 1), (3, 4, 0.5), (8, 4, 0.2), (9, 4, 1),     -- Cheese Burger (ID=4)
(1, 5, 0.8), (5, 5, 0.5), (7, 5, 0.3), (10, 5, 0.1), -- Chicken Salad (ID=5)
(2, 6, 0.7), (3, 6, 0.3), (8, 6, 0.2), (9, 6, 1),   -- Beef Sandwich (ID=6)
(3, 7, 1), (6, 7, 0.8), (10, 7, 0.1),              -- Pasta with Sauce (ID=7)
(3, 8, 1), (4, 8, 0.5), (5, 8, 0.5), (6, 8, 0.3);   -- Vegetable Soup (ID=8)

-- 8. Insert vendor orders (original + new)
INSERT INTO vendor_order (vendor_id, employee_id, vendor_order_date, ingredient_unit_price, vendor_order_total)
VALUES 
-- Original data
(1, 1, '2025-03-01', 5.00, 500.00),  -- Order from Fresh Foods for Chicken
(1, 2, '2025-04-01', 6.00, 600.00),  -- Order from Fresh Foods for Beef
-- New data
(1, 1, '2025-03-15', 5.20, 520.00),  -- Chicken
(1, 2, '2025-04-15', 6.10, 610.00),  -- Beef
(1, 3, '2025-05-10', 5.30, 530.00),  -- Chicken
(3, 1, '2025-03-20', 1.20, 360.00),  -- Potato from Green Farms
(3, 2, '2025-04-20', 1.50, 450.00),  -- Carrot from Green Farms
(3, 3, '2025-05-20', 1.30, 390.00),  -- Onion from Green Farms
(5, 4, '2025-03-25', 4.50, 450.00),  -- Cheese from Dairy Delights
(5, 4, '2025-04-25', 4.60, 460.00),  -- Cheese from Dairy Delights
(4, 3, '2025-05-05', 0.80, 240.00),  -- Bun from Bakery Plus
(4, 3, '2025-06-05', 0.85, 255.00);  -- Bun from Bakery Plus

-- 9. Insert vendor order line items (original + new)
INSERT INTO vendor_order_line_item (vendor_order_id, ingredient_id, ingredient_unit_quantity, ingredient_unit_price, line_total)
VALUES 
-- Original data
(1, 1, 100, 5.00, 500.00),  -- 100kg Chicken @ $5
(2, 2, 100, 6.00, 600.00),  -- 100kg Beef @ $6
-- New data
(3, 1, 100, 5.20, 520.00),   -- Order 3: Chicken
(4, 2, 100, 6.10, 610.00),   -- Order 4: Beef
(5, 1, 100, 5.30, 530.00),   -- Order 5: Chicken
(6, 3, 300, 1.20, 360.00),   -- Order 6: Potato
(7, 4, 300, 1.50, 450.00),   -- Order 7: Carrot
(8, 5, 300, 1.30, 390.00),   -- Order 8: Onion
(9, 9, 100, 4.50, 450.00),   -- Order 9: Cheese
(10, 9, 100, 4.60, 460.00),  -- Order 10: Cheese
(11, 8, 300, 0.80, 240.00),  -- Order 11: Bun
(12, 8, 300, 0.85, 255.00);  -- Order 12: Bun

-- 10. Insert ingredient purchase records (original + new)
INSERT INTO ingredient_purchase (ingredient_id, ingredient_purchase_quantity, ingredient_purchase_date, expiration_date)
VALUES 
-- Original data
(1, 100, '2025-03-02', '2025-09-01'),  -- Chicken purchase
(2, 100, '2025-04-02', '2025-10-01'),  -- Beef purchase
-- New data
(3, 300, '2025-03-21', '2025-03-22'),  -- Potato
(4, 300, '2025-04-21', '2025-10-21'),  -- Carrot
(5, 300, '2025-05-21', '2025-11-21'),  -- Onion
(9, 100, '2025-03-26', '2025-09-26'),  -- Cheese
(9, 100, '2025-04-26', '2025-10-26'),  -- Cheese
(8, 300, '2025-05-06', '2025-05-13'),  -- Bun
(8, 300, '2025-06-06', '2025-12-06'),  -- Bun
(6, 200, '2025-03-10', '2025-09-10'),  -- Tomato Sauce
(7, 200, '2025-04-10', '2025-05-10'),  -- Lettuce
(10, 50, '2025-05-10', '2025-11-10');  -- Spices

-- 11. Insert fixed costs (original + new)
INSERT INTO fixed_cost (cost_type, amount, description)
VALUES 
-- Original data
('Rent', 5000.00, 'Monthly warehouse rent'),
('Utilities', 500.00, 'Monthly electricity'),
-- New data
('Salaries', 10000.00, 'Monthly employee salaries'),
('Insurance', 1500.00, 'Monthly business insurance'),
('Equipment Lease', 2000.00, 'Monthly kitchen equipment lease'),
('Marketing', 800.00, 'Monthly advertising expenses'),
('Maintenance', 1200.00, 'Monthly facility maintenance');

-- 12. Insert customer orders (original + new)
INSERT INTO customer_order (employee_id, customer_id, customer_order_date, customer_order_total, customer_order_status)
VALUES 
-- Original data
(1, 1, '2025-05-01', 170.00, 'in progress'),  -- John handles ABC order
(2, 2, '2025-05-02', 240.00, 'in progress'),  -- Jane handles XYZ order
-- New data
(1, 3, '2025-05-10', 170.00, 'completed'),
(1, 4, '2025-05-15', 270.00, 'in progress'),
(2, 5, '2025-05-12', 136.00, 'completed'),
(2, 6, '2025-05-18', 210.00, 'in progress'),
(3, 3, '2025-05-20', 165.00, 'completed'),
(3, 4, '2025-05-25', 315.00, 'pending'),
(4, 5, '2025-05-22', 176.00, 'completed'),
(4, 6, '2025-05-28', 255.00, 'in progress'),
(1, 3, '2025-04-10', 150.00, 'completed'),
(2, 4, '2025-04-15', 240.00, 'completed');

-- 13. Insert customer order line items (original + new)
INSERT INTO customer_order_line_item (customer_order_id, meal_id, container_id, meal_unit_quantity, meal_unit_price, meal_total, unit_cost, number_of_delivered_containers)
VALUES 
-- Original data
(1, 1, 1, 10, 17.00, 170.00, 8.50, 10),  -- 10 Chicken Burgers in paper boxes
(2, 2, 2, 10, 24.00, 240.00, 12.00, 20), -- 10 Beef Stews in plastic bags
-- New data
(3, 1, 1, 10, 17.00, 170.00, 8.50, 10),   -- Order 3: 10 Chicken Burgers
(4, 2, 2, 10, 24.00, 240.00, 12.00, 20),  -- Order 4: 10 Beef Stews
(4, 4, 3, 5, 18.00, 90.00, 9.00, 5),      -- Order 4: 5 Cheese Burgers
(5, 5, 4, 20, 13.60, 272.00, 6.80, 20),   -- Order 5: 20 Chicken Salads
(6, 6, 1, 10, 21.00, 210.00, 10.50, 10),  -- Order 6: 10 Beef Sandwiches
(7, 7, 3, 15, 17.00, 255.00, 8.30, 15),   -- Order 7: 15 Pasta with Sauce
(8, 8, 4, 20, 11.00, 220.00, 5.50, 20),   -- Order 8: 20 Vegetable Soups
(9, 3, 1, 10, 14.40, 144.00, 7.20, 10),   -- Order 9: 10 Vegetable Stir Frys
(9, 5, 4, 5, 13.60, 68.00, 6.80, 5),      -- Order 9: 5 Chicken Salads
(10, 4, 3, 15, 18.00, 270.00, 9.00, 15),  -- Order 10: 15 Cheese Burgers
(11, 1, 1, 10, 15.00, 150.00, 8.50, 10),  -- Historical order
(12, 2, 2, 10, 24.00, 240.00, 12.00, 10); -- Historical order