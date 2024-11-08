-- PopulateData.sql
-- Created by Jay Kuehmeier and Adam Smith

USE PizzaDB;

-- Populate topping table
INSERT INTO topping (topping_Name, topping_Price, topping_Cost, topping_CurINV, topping_MinINV, topping_SmAMT, topping_MedAMT, topping_LgAMT, topping_XLAMT) VALUES
('Pepperoni', 1.25, 0.20, 100, 50, 2.00, 2.75, 3.50, 4.50),
('Sausage', 1.25, 0.15, 100, 50, 2.50, 3.00, 3.50, 4.25),
('Ham', 1.50, 0.15, 78, 25, 2.00, 2.50, 3.25, 4.00),
('Chicken', 1.75, 0.25, 56, 25, 1.50, 2.00, 2.25, 3.00),
('Green Pepper', 0.50, 0.02, 79, 25, 1.00, 1.50, 2.00, 2.50),
('Onion', 0.50, 0.02, 85, 25, 1.00, 1.50, 2.00, 2.75),
('Roma Tomato', 0.75, 0.03, 86, 10, 2.00, 3.00, 3.50, 4.50),
('Mushrooms', 0.75, 0.10, 52, 50, 1.50, 2.00, 2.50, 3.00),
('Black Olives', 0.60, 0.10, 39, 25, 0.75, 1.00, 1.50, 2.00),
('Pineapple', 1.00, 0.25, 15, 0, 1.00, 1.25, 1.75, 2.00),
('Jalapenos', 0.50, 0.05, 64, 0, 0.50, 0.75, 1.25, 1.75),
('Banana Peppers', 0.50, 0.05, 36, 0, 0.60, 1.00, 1.30, 1.75),
('Regular Cheese', 0.50, 0.12, 250, 50, 2.00, 3.50, 5.00, 7.00),
('Four Cheese Blend', 1.00, 0.15, 150, 25, 2.00, 3.50, 5.00, 7.00),
('Feta Cheese', 1.50, 0.18, 75, 0, 1.75, 3.00, 4.00, 5.50),
('Goat Cheese', 1.50, 0.20, 54, 0, 1.60, 2.75, 4.00, 5.50),
('Bacon', 1.50, 0.25, 89, 0, 1.00, 1.50, 2.00, 3.00);

-- Populate discount table
INSERT INTO discount (discount_Name, discount_Percent, discount_Amount) VALUES
('Employee', 15, NULL),
('Lunch Special Medium', NULL, 1.00),
('Lunch Special Large', NULL, 2.00),
('Specialty Pizza', NULL, 1.50),
('Happy Hour', 10, NULL),
('Gameday Special', 20, NULL);

-- Populate baseprice table
INSERT INTO baseprice (baseprice_Size, baseprice_Crust, baseprice_Price, baseprice_Cost) VALUES
('Small', 'Thin', 3.00, 0.50),
('Small', 'Original', 3.00, 0.75),
('Small', 'Pan', 3.50, 1.00),
('Small', 'Gluten-Free', 4.00, 2.00),
('Medium', 'Thin', 5.00, 1.00),
('Medium', 'Original', 5.00, 1.50),
('Medium', 'Pan', 6.00, 2.25),
('Medium', 'Gluten-Free', 6.25, 3.00),
('Large', 'Thin', 8.00, 1.25),
('Large', 'Original', 8.00, 2.00),
('Large', 'Pan', 9.00, 3.00),
('Large', 'Gluten-Free', 9.50, 4.00),
('XLarge', 'Thin', 10.00, 2.00),
('XLarge', 'Original', 10.00, 3.00),
('XLarge', 'Pan', 11.50, 4.50),
('XLarge', 'Gluten-Free', 12.50, 6.00);

-- Populate customers
INSERT INTO customer (customer_FName, customer_LName, customer_Phone) VALUES
('Andrew', 'Wilkes-Krier', '864-254-5861'),
('Matt', 'Engers', '864-474-9953'),
('Frank', 'Turner', '864-232-8944'),
('Milo', 'Auckerman', '864-878-5679');

-- Order 1: March 5th Dine-in
INSERT INTO ordertable (ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete) 
VALUES ('2024-03-05 12:03:00', 'dine-in', 19.75, 3.68, 1);

INSERT INTO dinein (ordertable_ID, dinein_TableNum)
SELECT ordertable_ID, 21 FROM ordertable WHERE ordertable_Time = '2024-03-05 12:03:00';

INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Large', 'Thin', 'Completed', '2024-03-05 12:03:00', 19.75, 3.68, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-05 12:03:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 1
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-03-05 12:03:00' AND t.topping_Name = 'Regular Cheese';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-03-05 12:03:00' AND t.topping_Name IN ('Pepperoni', 'Sausage');

INSERT INTO pizza_discount (pizza_ID, discount_ID)
SELECT p.pizza_ID, d.discount_ID
FROM pizza p, discount d
WHERE p.pizza_Date = '2024-03-05 12:03:00' AND d.discount_Name = 'Lunch Special Large';


-- Order 2: April 3rd Dine-in
INSERT INTO ordertable (ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete) 
VALUES ('2024-04-03 12:05:00', 'dine-in', 19.78, 4.63, 1);

INSERT INTO dinein (ordertable_ID, dinein_TableNum)
SELECT ordertable_ID, 4 FROM ordertable WHERE ordertable_Time = '2024-04-03 12:05:00';

-- First pizza of order 2
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Medium', 'Pan', 'Completed', '2024-04-03 12:05:00', 12.85, 3.23, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-03 12:05:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-03 12:05:00' AND p.pizza_Size = 'Medium'
AND t.topping_Name IN ('Feta Cheese', 'Black Olives', 'Roma Tomato', 'Mushrooms', 'Banana Peppers');

INSERT INTO pizza_discount (pizza_ID, discount_ID)
SELECT p.pizza_ID, d.discount_ID
FROM pizza p, discount d
WHERE p.pizza_Date = '2024-04-03 12:05:00' AND p.pizza_Size = 'Medium'
AND d.discount_Name IN ('Lunch Special Medium', 'Specialty Pizza');

-- Second pizza of order 2
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Small', 'Original', 'Completed', '2024-04-03 12:05:00', 6.93, 1.40, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-03 12:05:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-03 12:05:00' AND p.pizza_Size = 'Small'
AND t.topping_Name IN ('Regular Cheese', 'Chicken', 'Banana Peppers');

-- Order 3: March 3rd Pickup (Andrew Wilkes-Krier)
INSERT INTO ordertable (customer_ID, ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete)
SELECT customer_ID, '2024-03-03 21:30:00', 'pickup', 89.28, 19.80, 1
FROM customer WHERE customer_FName = 'Andrew' AND customer_LName = 'Wilkes-Krier';

INSERT INTO pickup (ordertable_ID, pickup_IsPickedUp)
SELECT ordertable_ID, 1 FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00';

-- Six identical pizzas for order 3
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Large', 'Original', 'Completed', '2024-03-03 21:30:00', 14.88, 3.30, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00'
UNION ALL
SELECT 'Large', 'Original', 'Completed', '2024-03-03 21:30:00', 14.88, 3.30, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00'
UNION ALL
SELECT 'Large', 'Original', 'Completed', '2024-03-03 21:30:00', 14.88, 3.30, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00'
UNION ALL
SELECT 'Large', 'Original', 'Completed', '2024-03-03 21:30:00', 14.88, 3.30, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00'
UNION ALL
SELECT 'Large', 'Original', 'Completed', '2024-03-03 21:30:00', 14.88, 3.30, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00'
UNION ALL
SELECT 'Large', 'Original', 'Completed', '2024-03-03 21:30:00', 14.88, 3.30, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-03 21:30:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-03-03 21:30:00' AND t.topping_Name IN ('Regular Cheese', 'Pepperoni');


-- Order 4: April 20th Delivery (Andrew Wilkes-Krier)
INSERT INTO ordertable (customer_ID, ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete)
SELECT customer_ID, '2024-04-20 19:11:00', 'delivery', 86.19, 23.62, 1
FROM customer WHERE customer_FName = 'Andrew' AND customer_LName = 'Wilkes-Krier';

INSERT INTO delivery (ordertable_ID, delivery_HouseNum, delivery_Street, delivery_City, delivery_State, delivery_Zip, delivery_IsDelivered)
SELECT ordertable_ID, 115, 'Party Blvd', 'Anderson', 'SC', 29621, 1 
FROM ordertable WHERE ordertable_Time = '2024-04-20 19:11:00';

-- First pizza of order 4
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'XLarge', 'Original', 'Completed', '2024-04-20 19:11:00', 27.94, 9.19, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-20 19:11:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-20 19:11:00' AND p.pizza_Price = 27.94
AND t.topping_Name IN ('Four Cheese Blend', 'Pepperoni', 'Sausage');

-- Second pizza of order 4
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'XLarge', 'Original', 'Completed', '2024-04-20 19:11:00', 31.50, 6.25, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-20 19:11:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, CASE WHEN t.topping_Name IN ('Ham', 'Pineapple') THEN 1 ELSE 0 END
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-20 19:11:00' AND p.pizza_Price = 31.50
AND t.topping_Name IN ('Four Cheese Blend', 'Ham', 'Pineapple');

INSERT INTO pizza_discount (pizza_ID, discount_ID)
SELECT p.pizza_ID, d.discount_ID
FROM pizza p, discount d
WHERE p.pizza_Date = '2024-04-20 19:11:00' AND p.pizza_Price = 31.50
AND d.discount_Name = 'Specialty Pizza';

-- Third pizza of order 4
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'XLarge', 'Original', 'Completed', '2024-04-20 19:11:00', 26.75, 8.18, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-20 19:11:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-20 19:11:00' AND p.pizza_Price = 26.75
AND t.topping_Name IN ('Four Cheese Blend', 'Chicken', 'Bacon');

INSERT INTO order_discount (ordertable_ID, discount_ID)
SELECT o.ordertable_ID, d.discount_ID
FROM ordertable o, discount d
WHERE o.ordertable_Time = '2024-04-20 19:11:00' AND d.discount_Name = 'Gameday Special';

-- Order 5: March 2nd Pickup (Matt Engers)
INSERT INTO ordertable (customer_ID, ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete)
SELECT customer_ID, '2024-03-02 17:30:00', 'pickup', 27.45, 7.88, 1
FROM customer WHERE customer_FName = 'Matt' AND customer_LName = 'Engers';

INSERT INTO pickup (ordertable_ID, pickup_IsPickedUp)
SELECT ordertable_ID, 1 FROM ordertable WHERE ordertable_Time = '2024-03-02 17:30:00';

INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'XLarge', 'Gluten-Free', 'Completed', '2024-03-02 17:30:00', 27.45, 7.88, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-02 17:30:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 0
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-03-02 17:30:00'
AND t.topping_Name IN ('Goat Cheese', 'Green Pepper', 'Onion', 'Roma Tomato', 'Mushrooms', 'Black Olives');

INSERT INTO pizza_discount (pizza_ID, discount_ID)
SELECT p.pizza_ID, d.discount_ID
FROM pizza p, discount d
WHERE p.pizza_Date = '2024-03-02 17:30:00' AND d.discount_Name = 'Specialty Pizza';

-- Order 6: March 2nd Delivery (Frank Turner)
INSERT INTO ordertable (customer_ID, ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete)
SELECT customer_ID, '2024-03-02 18:17:00', 'delivery', 25.81, 4.24, 1
FROM customer WHERE customer_FName = 'Frank' AND customer_LName = 'Turner';

INSERT INTO delivery (ordertable_ID, delivery_HouseNum, delivery_Street, delivery_City, delivery_State, delivery_Zip, delivery_IsDelivered)
SELECT ordertable_ID, 6745, 'Wessex St', 'Anderson', 'SC', 29621, 1 
FROM ordertable WHERE ordertable_Time = '2024-03-02 18:17:00';

INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Large', 'Thin', 'Completed', '2024-03-02 18:17:00', 25.81, 4.24, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-03-02 18:17:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, CASE WHEN t.topping_Name = 'Four Cheese Blend' THEN 1 ELSE 0 END
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-03-02 18:17:00'
AND t.topping_Name IN ('Four Cheese Blend', 'Chicken', 'Green Pepper', 'Onion', 'Mushrooms');

-- Order 7: April 13th Delivery (Milo Auckerman)
INSERT INTO ordertable (customer_ID, ordertable_Time, ordertable_Type, ordertable_Price, ordertable_Cost, ordertable_IsComplete)
SELECT customer_ID, '2024-04-13 20:32:00', 'delivery', 31.66, 6.00, 1
FROM customer WHERE customer_FName = 'Milo' AND customer_LName = 'Auckerman';

INSERT INTO delivery (ordertable_ID, delivery_HouseNum, delivery_Street, delivery_City, delivery_State, delivery_Zip, delivery_IsDelivered)
SELECT ordertable_ID, 8879, 'Suburban Home', 'Anderson', 'SC', 29621, 1 
FROM ordertable WHERE ordertable_Time = '2024-04-13 20:32:00';

-- First pizza of order 7
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Large', 'Thin', 'Completed', '2024-04-13 20:32:00', 18.00, 2.75, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-13 20:32:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, 1
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-13 20:32:00' AND p.pizza_Cost = 2.75
AND t.topping_Name = 'Four Cheese Blend';

-- Second pizza of order 7
INSERT INTO pizza (pizza_Size, pizza_Crust, pizza_State, pizza_Date, pizza_Price, pizza_Cost, ordertable_ID)
SELECT 'Large', 'Thin', 'Completed', '2024-04-13 20:32:00', 19.25, 3.25, ordertable_ID 
FROM ordertable WHERE ordertable_Time = '2024-04-13 20:32:00';

INSERT INTO pizza_topping (pizza_ID, topping_ID, pizza_topping_IsDouble)
SELECT p.pizza_ID, t.topping_ID, CASE WHEN t.topping_Name = 'Pepperoni' THEN 1 ELSE 0 END
FROM pizza p, topping t
WHERE p.pizza_Date = '2024-04-13 20:32:00' AND p.pizza_Cost = 3.25
AND t.topping_Name IN ('Regular Cheese', 'Pepperoni');

INSERT INTO order_discount (ordertable_ID, discount_ID)
SELECT o.ordertable_ID, d.discount_ID
FROM ordertable o, discount d
WHERE o.ordertable_Time = '2024-04-13 20:32:00' AND d.discount_Name = 'Employee';


