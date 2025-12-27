CREATE OR ALTER VIEW dbo.vw_UnitProductionCost_Current
AS
WITH last_ph AS (
    SELECT
        ph.*,
        ROW_NUMBER() OVER (PARTITION BY ph.productID ORDER BY ph.changedAt DESC) AS rn
    FROM dbo.PriceHistory ph
)
SELECT
    p.id AS ProductID,
    p.category AS Category,
    ph.productionPrice,
    ph.addingValue,
    CAST(CAST(ph.productionPrice AS decimal(19,2)) + CAST(ph.addingValue AS decimal(19,2)) AS decimal(19,2)) AS UnitCostNet,
    v.rate AS VatRate
FROM dbo.Products p
JOIN last_ph ph ON ph.productID = p.id AND ph.rn = 1
JOIN dbo.VAT v ON v.id = ph.vatID;
GO

SELECT * FROM dbo.vw_UnitProductionCost_Current