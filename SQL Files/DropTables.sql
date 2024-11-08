-- DropTables.sql
-- Created by Jay Kuehmeier and Adam Smith 

USE PizzaDB;

-- Drop views
DROP VIEW IF EXISTS ToppingPopularity;
DROP VIEW IF EXISTS ProfitByPizza;
DROP VIEW IF EXISTS ProfitByOrderType;

-- Drop bridge
DROP TABLE IF EXISTS pizza_topping;
DROP TABLE IF EXISTS pizza_discount;
DROP TABLE IF EXISTS order_discount;

-- Drop dependent tables 
DROP TABLE IF EXISTS dinein;
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS pickup;
DROP TABLE IF EXISTS pizza;

-- Drop base tables that are referenced by others
DROP TABLE IF EXISTS ordertable;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS discount;
DROP TABLE IF EXISTS topping;
DROP TABLE IF EXISTS baseprice;

-- Drop the database itself
DROP DATABASE IF EXISTS PizzaDB;