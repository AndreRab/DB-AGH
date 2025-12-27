CREATE OR ALTER VIEW dbo.vw_CostsByCategory_Month
AS
SELECT
    DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS PeriodMonth,
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(LineCostNet) AS ProductionCostNet
FROM dbo.vw_OrderLineFinancials
GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1), Category;
GO