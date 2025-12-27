CREATE OR ALTER VIEW dbo.vw_SalesByCategory_PerWeekMonth
AS
-- Widok menedżerski:
-- - przychód ze sprzedaży produktów (na podstawie OrderPosition.unitPrice)
-- - koszt produkcji (na podstawie func_GetPrice w dacie zamówienia)
-- - marża (Przychód - Koszt_Produkcji)
-- zagregowane po kategorii, roku, miesiącu i tygodniu
SELECT
    p.category,
    DATEPART(YEAR,  o.orderDate) AS Rok,
    DATEPART(MONTH, o.orderDate) AS Miesiac,
    DATEPART(WEEK,  o.orderDate) AS Tydzien,

    SUM(op.quantity * op.unitPrice) AS Przychod,
    SUM(ph.productionPrice * op.quantity) AS Koszt_Produkcji,
    SUM(op.quantity * op.unitPrice) - SUM(ph.productionPrice * op.quantity) AS Marza
FROM dbo.OrderPosition op
JOIN dbo.Orders o   ON o.id = op.orderID AND o.status = 'Completed'
JOIN dbo.Products p ON p.id = op.productID
CROSS APPLY dbo.func_GetPrice(p.id, o.orderDate) ph
GROUP BY
    p.category,
    DATEPART(YEAR,  o.orderDate),
    DATEPART(MONTH, o.orderDate),
    DATEPART(WEEK,  o.orderDate);
GO