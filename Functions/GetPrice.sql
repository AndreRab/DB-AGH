CREATE or ALTER FUNCTION dbo.func_GetPrice (@productID INT, @atDate DATETIME)
RETURNS TABLE
AS
RETURN
(
    -- Wybieramy wszystkie potrzebne kolumny oraz obliczoną cene końcową
    SELECT
        ph.id AS PriceHistoryId,
        ph.productID,
        ph.productionPrice,
        ph.addingValue,
        v.rate AS VatRate,
        -- Uproszczone obliczenie: (Cena Produkcyjna + Wartość dodana) * (1 + Stawka VAT)
        -- Używamy podstawowych typóww DECIMAL
        CAST(
            (ph.productionPrice + ph.addingValue) * (1 + v.rate)
        AS DECIMAL(10, 2)) AS FinalPrice
    FROM
        PriceHistory ph
    JOIN
        VAT v ON v.id = ph.VAT_ID
    WHERE
        ph.productID = @productID
        AND ph.changedAt = (
            -- Podzapytanie do znalezienia DATY ostatniej zmiany
            SELECT TOP 1 sub.changedAt
            FROM PriceHistory sub
            WHERE sub.productID = @productID
              AND sub.changedAt <= @atDate
            ORDER BY sub.changedAt DESC
        )
);