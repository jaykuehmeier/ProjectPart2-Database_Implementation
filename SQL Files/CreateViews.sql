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


-- ProfitByOrderType View
CREATE VIEW ProfitByOrderType AS
WITH MonthlyProfits AS (
    SELECT
        ordertable_Type as customerType,
        CONCAT(MIN(MONTH(ordertable_Time)), '/', MIN(YEAR(ordertable_Time))) as OrderMonth,
        CAST(SUM(ordertable_Price) AS DECIMAL(10,2)) as TotalOrderPrice,
        CAST(SUM(ordertable_Cost) AS DECIMAL(10,2)) as TotalOrderCost,
        CAST(SUM(ordertable_Price - ordertable_Cost) AS DECIMAL(10,2)) as Profit
    FROM ordertable
    GROUP BY
        ordertable_Type,
        MONTH(ordertable_Time),
        YEAR(ordertable_Time)
),
TotalProfits AS (
    SELECT
        'Grand Total' as customerType,
        '' as OrderMonth,
        CAST(SUM(ordertable_Price) AS DECIMAL(10,2)) as TotalOrderPrice,
        CAST(SUM(ordertable_Cost) AS DECIMAL(10,2)) as TotalOrderCost,
        CAST(SUM(ordertable_Price - ordertable_Cost) AS DECIMAL(10,2)) as Profit
    FROM ordertable
)
SELECT * FROM MonthlyProfits
UNION ALL
SELECT * FROM TotalProfits
ORDER BY
    CASE
        WHEN customerType = 'Grand Total' THEN 2
        ELSE 1
    END,
    customerType,
    OrderMonth;

SELECT * FROM ToppingPopularity;
SELECT * FROM ProfitByPizza;
SELECT * FROM ProfitByOrderType;