-- CreateTables.sql
-- Created by Jay Kuehmeier and Adam Smith

-- Create database schema
DROP DATABASE IF EXISTS PizzaDB;
CREATE DATABASE PizzaDB;
USE PizzaDB;

-- Create baseprice table
CREATE TABLE baseprice (
    baseprice_Size VARCHAR(30),
    baseprice_Crust VARCHAR(30),
    baseprice_Price DECIMAL(5,2),
    baseprice_Cost DECIMAL(5,2),
    PRIMARY KEY (baseprice_Size, baseprice_Crust)
);

-- Create topping table
CREATE TABLE topping (
    topping_ID INT AUTO_INCREMENT,
    topping_Name VARCHAR(20),
    topping_Price DECIMAL(5,2),
    topping_Cost DECIMAL(5,2),
    topping_MinINV INT,
    topping_CurINV INT,
    topping_SmAMT DECIMAL(5,2),
    topping_MedAMT DECIMAL(5,2),
    topping_LgAMT DECIMAL(5,2),
    topping_XLAMT DECIMAL(5,2),
    PRIMARY KEY (topping_ID)
);

-- Create customer table
CREATE TABLE customer (
    customer_ID INT AUTO_INCREMENT,
    customer_FName VARCHAR(30),
    customer_LName VARCHAR(30),
    customer_Phone VARCHAR(30),
    PRIMARY KEY (customer_ID)
);

-- Create discount table
CREATE TABLE discount (
    discount_ID INT AUTO_INCREMENT,
    discount_Name VARCHAR(30),
    discount_Percent TINYINT,
    discount_Amount DECIMAL(5,2),
    PRIMARY KEY (discount_ID)
);

-- Create ordertable 
CREATE TABLE ordertable (
    ordertable_ID INT AUTO_INCREMENT,
    customer_ID INT,
    ordertable_Type VARCHAR(30),
    ordertable_Time DATETIME,
    ordertable_Cost DECIMAL(5,2),
    ordertable_Price DECIMAL(5,2),
    ordertable_IsComplete TINYINT(1),
    PRIMARY KEY (ordertable_ID),
    FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID)
);

-- Create dinein table
CREATE TABLE dinein (
    ordertable_ID INT,
    dinein_TableNum INT,
    PRIMARY KEY (ordertable_ID),
    FOREIGN KEY (ordertable_ID) REFERENCES ordertable(ordertable_ID)
);

-- Create delivery table
CREATE TABLE delivery (
    ordertable_ID INT,
    delivery_HouseNum INT,
    delivery_Street VARCHAR(30),
    delivery_City VARCHAR(30),
    delivery_State VARCHAR(2),
    delivery_Zip INT,
    delivery_IsDelivered TINYINT(1),
    PRIMARY KEY (ordertable_ID),
    FOREIGN KEY (ordertable_ID) REFERENCES ordertable(ordertable_ID)
);

-- Create pickup table
CREATE TABLE pickup (
    ordertable_ID INT,
    pickup_IsPickedUp TINYINT(1),
    PRIMARY KEY (ordertable_ID),
    FOREIGN KEY (ordertable_ID) REFERENCES ordertable(ordertable_ID)
);

-- Create pizza table
CREATE TABLE pizza (
    pizza_ID INT AUTO_INCREMENT,
    pizza_Size VARCHAR(30),
    pizza_Crust VARCHAR(30),
    pizza_State VARCHAR(30),
    pizza_Date DATETIME,
    pizza_Price DECIMAL(5,2),
    pizza_Cost DECIMAL(5,2),
    ordertable_ID INT,
    PRIMARY KEY (pizza_ID),
    FOREIGN KEY (ordertable_ID) REFERENCES ordertable(ordertable_ID),
    FOREIGN KEY (pizza_Size, pizza_Crust) REFERENCES baseprice(baseprice_Size, baseprice_Crust)
);

-- Create pizza_topping table
CREATE TABLE pizza_topping (
    pizza_ID INT,
    topping_ID INT,
    pizza_topping_IsDouble INT,
    PRIMARY KEY (pizza_ID, topping_ID),
    FOREIGN KEY (pizza_ID) REFERENCES pizza(pizza_ID),
    FOREIGN KEY (topping_ID) REFERENCES topping(topping_ID)
);

-- Create pizza_discount table
CREATE TABLE pizza_discount (
    pizza_ID INT,
    discount_ID INT,
    PRIMARY KEY (pizza_ID, discount_ID),
    FOREIGN KEY (pizza_ID) REFERENCES pizza(pizza_ID),
    FOREIGN KEY (discount_ID) REFERENCES discount(discount_ID)
);

-- Create order_discount table
CREATE TABLE order_discount (
    ordertable_ID INT,
    discount_ID INT,
    PRIMARY KEY (ordertable_ID, discount_ID),
    FOREIGN KEY (ordertable_ID) REFERENCES ordertable(ordertable_ID),
    FOREIGN KEY (discount_ID) REFERENCES discount(discount_ID)
);