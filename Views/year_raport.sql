CREATE OR ALTER VIEW dbo.vw_CostsByCategory_Year
AS
SELECT
    DATEFROMPARTS(YEAR(OrderDate), 1, 1) AS PeriodYear,
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(LineCostNet) AS ProductionCostNet
FROM dbo.vw_OrderLineFinancials
GROUP BY DATEFROMPARTS(YEAR(OrderDate), 1, 1), Category;
GO