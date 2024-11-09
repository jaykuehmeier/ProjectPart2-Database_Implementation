-- CreateViews.sql
-- Created by Jay Kuehmeier and Adam Smith

USE PizzaDB;

-- ToppingPopularity View
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


-- ProfitbyPizza View (Now works)
CREATE VIEW ProfitByPizza AS
SELECT
    pizza_Size as Size,
    pizza_Crust as Crust,
    CAST(SUM(pizza_Price - pizza_Cost) AS DECIMAL(10,2)) as Profit,
    CONCAT(MIN(MONTH(pizza_Date)), '/', MIN(YEAR(pizza_Date))) as OrderMonth
FROM pizza
GROUP BY
    pizza_Size,
    pizza_Crust,
    MONTH(pizza_Date),
    YEAR(pizza_Date)
ORDER BY
    Profit ASC;

CREATE VIEW ProfitByOrderType AS
WITH MonthlyProfits AS (
    SELECT
        ordertable_Type AS customerType,
        CONCAT(MONTH(ordertable_Time), '/', YEAR(ordertable_Time)) AS OrderMonth,
        CAST(SUM(ordertable_Price) AS DECIMAL(10,2)) AS TotalOrderPrice,
        CAST(SUM(ordertable_Cost) AS DECIMAL(10,2)) AS TotalOrderCost,
        CAST(SUM(ordertable_Price - ordertable_Cost) AS DECIMAL(10,2)) AS Profit
    FROM ordertable
    GROUP BY
        ordertable_Type,
        CONCAT(MONTH(ordertable_Time), '/', YEAR(ordertable_Time))
)
SELECT customerType, OrderMonth, TotalOrderPrice, TotalOrderCost, Profit
FROM (
    SELECT customerType, OrderMonth, TotalOrderPrice, TotalOrderCost, Profit
    FROM MonthlyProfits
    UNION ALL
    SELECT
        'Grand Total' AS customerType,
        '' AS OrderMonth,
        CAST(SUM(TotalOrderPrice) AS DECIMAL(10,2)) AS TotalOrderPrice,
        CAST(SUM(TotalOrderCost) AS DECIMAL(10,2)) AS TotalOrderCost,
        CAST(SUM(Profit) AS DECIMAL(10,2)) AS Profit
    FROM MonthlyProfits
) AS combined
ORDER BY
    CASE customerType
        WHEN 'dinein' THEN 1
        WHEN 'pickup' THEN 2
        WHEN 'delivery' THEN 3
        ELSE 4
    END,
    CASE WHEN OrderMonth = '' THEN 1 ELSE 0 END,
    OrderMonth ASC;



SELECT * FROM ToppingPopularity;
SELECT * FROM ProfitByPizza;
SELECT * FROM ProfitByOrderType;

