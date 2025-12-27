CREATE TRIGGER dbo.trg_OrderPosition_StockAndPrice
ON dbo.OrderPosition
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    /* ============================================================
       1. KONTROLA MAGAZYNU (Products.UnitsInStock)
       ============================================================
       - liczymy łączną zmianę ilości (delta) dla każdego produktu
         na podstawie inserted / deleted
       - sprawdzamy, czy przy zwiększeniu zamówienia nie schodzimy
         poniżej zera w magazynie
       - aktualizujemy UnitsInStock
    */

    DECLARE @Agg TABLE (
        productID INT,
        delta     INT
    );

    INSERT INTO @Agg (productID, delta)
    SELECT
        productID,
        SUM(qtyChange) AS delta
    FROM (
        -- wstawiane / zmieniane rekordy → zwiększamy pobranie z magazynu
        SELECT i.productID, SUM(i.quantity) AS qtyChange
        FROM inserted i
        GROUP BY i.productID

        UNION ALL

        -- usuwane / zmniejszane rekordy → oddajemy towar do magazynu
        SELECT d.productID, -SUM(d.quantity) AS qtyChange
        FROM deleted d
        GROUP BY d.productID
    ) AS S
    GROUP BY productID
    HAVING SUM(qtyChange) <> 0;  -- tylko produkty, gdzie cokolwiek się zmieniło

    -- Sprawdzenie, czy mamy wystarczający stan magazynowy
    IF EXISTS (
        SELECT 1
        FROM @Agg a
        JOIN dbo.Products p ON p.id = a.productID
        WHERE a.delta > 0              -- netto pobieramy towar z magazynu
          AND p.UnitsInStock < a.delta -- magazyn ma mniej niż chcemy zabrać
    )
    BEGIN
        RAISERROR(
            'Not enough stock for one of the products to apply this order change.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Aktualizacja magazynu: UnitsInStock = UnitsInStock - delta
    UPDATE p
    SET p.UnitsInStock = p.UnitsInStock - a.delta
    FROM dbo.Products p
    JOIN @Agg a ON p.id = a.productID;


    /* ============================================================
       2. USTAWIENIE unitPrice DLA NOWYCH POZYCJI
       ============================================================
       - interesują nas tylko NOWE wiersze (INSERT),
         czyli te, które są w inserted i nie ma ich w deleted
       - pobieramy cenę sprzedaży przez func_GetPrice(productID, orderDate)
       - zapisujemy ją jako unitPrice (snapshot ceny z dnia zamówienia)
    */

    ;WITH NewRows AS (
        SELECT i.*
        FROM inserted i
        LEFT JOIN deleted d ON d.id = i.id
        WHERE d.id IS NULL  -- tylko czyste INSERT, nie UPDATE
    )
    UPDATE op
    SET op.unitPrice = fp.FinalPrice
    FROM dbo.OrderPosition op
    JOIN NewRows nr       ON nr.id = op.id
    JOIN dbo.Orders o     ON o.id = nr.orderID
    CROSS APPLY dbo.func_GetPrice(nr.productID, o.orderDate) fp;
    -- Uwaga: jeśli func_GetPrice nic nie zwróci (brak ceny dla tej daty),
    --        wiersz NIE zostanie zaktualizowany i unitPrice pozostanie taki jak był (np. 0).


    /* ============================================================
       3. PRZELICZENIE CENY ZAMÓWIENIA (Orders.price)
       ============================================================
       - wybieramy wszystkie zamówienia, których pozycje się zmieniły
       - odświeżamy price korzystając z funkcji func_CalculateOrderTotal
    */

    ;WITH AffectedOrders AS (
        SELECT DISTINCT orderID FROM inserted
        UNION
        SELECT DISTINCT orderID FROM deleted
    )
    UPDATE o
    SET o.price = ISNULL(dbo.func_CalculateOrderTotal(o.id), 0)
    FROM dbo.Orders o
    JOIN AffectedOrders ao ON ao.orderID = o.id;
END;
GO