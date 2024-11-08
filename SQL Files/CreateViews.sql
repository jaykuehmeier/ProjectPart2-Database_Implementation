-- CreateViews.sql
-- Created by Jay Kuehmeier and Adam Smith

USE PizzaDB;

-- ToppingPopularity View
-- Shows rank order of all toppings from most popular to least popular, accounting for extra toppings
CREATE VIEW ToppingPopularity AS
SELECT 
    t.topping_Name as Topping,
    COUNT(pt.topping_ID) + SUM(CASE WHEN pt.pizza_topping_IsDouble = 1 THEN 1 ELSE 0 END) as ToppingCount
FROM topping t
LEFT JOIN pizza_topping pt ON t.topping_ID = pt.topping_ID
GROUP BY t.topping_ID, t.topping_Name
ORDER BY 
    ToppingCount DESC,
    Topping ASC;


    
-- ProfitByPizza View
-- Shows profit by pizza size and crust type each month
CREATE VIEW ProfitByPizza AS
SELECT 
    CONCAT(MONTHNAME(p.pizza_Date), ' ', YEAR(p.pizza_Date)) as OrderMonth,
    p.pizza_Size as Size,
    p.pizza_Crust as Crust,
    COUNT(*) as TotalPizzas,
    CAST(SUM(p.pizza_Price) AS DECIMAL(6,2)) as Revenue,
    CAST(SUM(p.pizza_Cost) AS DECIMAL(6,2)) as Cost,
    CAST(SUM(p.pizza_Price - p.pizza_Cost) AS DECIMAL(6,2)) as Profit
FROM pizza p
GROUP BY 
    YEAR(p.pizza_Date),
    MONTH(p.pizza_Date),
    p.pizza_Size,
    p.pizza_Crust
ORDER BY 
    Profit DESC,
    OrderMonth,
    Size,
    Crust;

-- ProfitByOrderType View
-- Shows profit by order type (dine-in, pickup, delivery) by month
CREATE VIEW ProfitByOrderType AS
WITH MonthlyProfits AS (
    SELECT 
        CONCAT(MONTHNAME(o.ordertable_Time), ' ', YEAR(o.ordertable_Time)) as OrderMonth,
        o.ordertable_Type as CustomerType,
        COUNT(DISTINCT o.ordertable_ID) as OrderCount,
        CAST(SUM(o.ordertable_Price) AS DECIMAL(6,2)) as Revenue,
        CAST(SUM(o.ordertable_Cost) AS DECIMAL(6,2)) as Cost,
        CAST(SUM(o.ordertable_Price - o.ordertable_Cost) AS DECIMAL(6,2)) as Profit
    FROM ordertable o
    GROUP BY 
        YEAR(o.ordertable_Time),
        MONTH(o.ordertable_Time),
        o.ordertable_Type
),
TotalProfits AS (
    SELECT 
        'Grand Total' as OrderMonth,
        'Total' as CustomerType,
        COUNT(DISTINCT o.ordertable_ID) as OrderCount,
        CAST(SUM(o.ordertable_Price) AS DECIMAL(6,2)) as Revenue,
        CAST(SUM(o.ordertable_Cost) AS DECIMAL(6,2)) as Cost,
        CAST(SUM(o.ordertable_Price - o.ordertable_Cost) AS DECIMAL(6,2)) as Profit
    FROM ordertable o
)
SELECT * FROM MonthlyProfits
UNION ALL
SELECT * FROM TotalProfits
ORDER BY 
    CASE 
        WHEN OrderMonth = 'Grand Total' THEN 2
        ELSE 1
    END,
    OrderMonth,
    CASE CustomerType
        WHEN 'dine-in' THEN 1
        WHEN 'pickup' THEN 2
        WHEN 'delivery' THEN 3
        WHEN 'Total' THEN 4
    END;



