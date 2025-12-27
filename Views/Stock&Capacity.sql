CREATE OR ALTER VIEW dbo.vw_StockAndCapacity
AS
-- Widok prezentujący:
-- - aktualny stan magazynowy produktu
-- - maksymalną możliwą produkcję z dostępnych komponentów
-- - łączną potencjalną dostępność (magazyn + produkcja)
SELECT
    p.id AS ProductID,
    p.name,
    p.category,
    ISNULL(p.UnitsInStock, 0) AS Na_Magazynie,
    dbo.func_GetProductionCapacity(p.id) AS Mozliwe_Do_Wyprodukowania,
    (ISNULL(p.UnitsInStock, 0) + dbo.func_GetProductionCapacity(p.id)) AS Lacznie_Mozliwe
FROM dbo.Products p;
GO