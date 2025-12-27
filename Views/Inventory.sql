CREATE OR ALTER VIEW dbo.vw_Inventory_Products_Current
AS
SELECT
    p.id AS ProductID,
    p.category AS Category,
    p.UnitsInStock,
    cap.Producible,
    (p.UnitsInStock + cap.Producible) AS TotalAvailable
FROM dbo.Products p
CROSS APPLY (SELECT dbo.func_GetProductionCapacity(p.id) AS Producible) cap;
GO

CREATE OR ALTER VIEW dbo.vw_Production_Planned
AS
SELECT
    ph.productId AS ProductID,
    p.category   AS Category,
    ph.status    AS Status,
    CAST(ph.startDate AS date) AS StartDate,
    COUNT(*) AS PlannedCount
FROM dbo.ProductionHistory ph
JOIN dbo.Products p ON p.id = ph.productId
WHERE ph.status IN (N'Rozpoczęto', N'Zaplanowano', N'W toku')
GROUP BY ph.productId, p.category, ph.status, CAST(ph.startDate AS date);
GO