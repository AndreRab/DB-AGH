CREATE OR ALTER VIEW dbo.vw_CostsByCategory_Quarter
AS
SELECT
    DATEFROMPARTS(YEAR(OrderDate), (DATEPART(QUARTER, OrderDate) - 1) * 3 + 1, 1) AS PeriodQuarter,
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(LineCostNet) AS ProductionCostNet
FROM dbo.vw_OrderLineFinancials
GROUP BY DATEFROMPARTS(YEAR(OrderDate), (DATEPART(QUARTER, OrderDate) - 1) * 3 + 1, 1), Category
GO