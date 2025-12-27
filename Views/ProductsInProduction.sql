CREATE OR ALTER VIEW dbo.vw_ProductsInProduction
AS
-- Widok prezentujący liczbę zleceń produkcyjnych w toku
-- dla każdego produktu (status różny od 'Zakończono')
SELECT
    ph.productId AS ProductID,
    p.name,
    COUNT(*) AS Ilosc_Zlecen_Produkcji_W_Toku,
    MIN(ph.startDate) AS Pierwsze_Zlecenie,
    MAX(ph.startDate) AS Ostatnie_Zlecenie
FROM dbo.ProductionHistory ph
JOIN dbo.Products p ON p.id = ph.productId
WHERE ph.status <> 'Zakończono'
GROUP BY ph.productId, p.name;
GO