CREATE OR ALTER VIEW dbo.vw_ProductUnitCost
AS
-- Widok prezentujący historię kosztu jednostkowego produktu
-- na podstawie tabeli PriceHistory (koszt produkcji + wartość dodana)
SELECT
    p.id AS ProductID,
    p.name,
    p.category,
    ph.productionPrice,
    ph.addingValue,
    (ph.productionPrice + ph.addingValue) AS UnitCost,
    ph.changedAt,
    YEAR(ph.changedAt) AS Rok,
    MONTH(ph.changedAt) AS Miesiac,
    DATEPART(QUARTER, ph.changedAt) AS Kwartal
FROM dbo.PriceHistory ph
JOIN dbo.Products p ON p.id = ph.productID;
GO

CREATE OR ALTER VIEW dbo.vw_ProductCost_Quarterly
AS
-- Widok prezentujący średnie i łączne koszty jednostkowe
-- dla kategorii produktów w ujęciu kwartalnym
SELECT
    category,
    Rok,
    Kwartal,
    AVG(UnitCost) AS Sredni_Koszt_Jednostkowy,
    SUM(UnitCost) AS Koszt_Laczny
FROM dbo.vw_ProductUnitCost
GROUP BY category, Rok, Kwartal;
GO

CREATE OR ALTER VIEW dbo.vw_ProductCost_Monthly
AS
-- Widok prezentujący średnie i łączne koszty jednostkowe
-- dla kategorii produktów w ujęciu miesięcznym
SELECT
    category,
    Rok,
    Miesiac,
    AVG(UnitCost) AS Sredni_Koszt,
    SUM(UnitCost) AS Koszt_Laczny
FROM dbo.vw_ProductUnitCost
GROUP BY category, Rok, Miesiac;
GO

CREATE OR ALTER VIEW dbo.vw_ProductCost_Yearly
AS
-- Widok prezentujący średnie i łączne koszty jednostkowe
-- dla kategorii produktów w ujęciu rocznym
SELECT
    category,
    Rok,
    AVG(UnitCost) AS Sredni_Koszt,
    SUM(UnitCost) AS Koszt_Laczny
FROM dbo.vw_ProductUnitCost
GROUP BY category, Rok;
GO
