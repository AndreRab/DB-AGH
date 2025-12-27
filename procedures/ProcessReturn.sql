CREATE PROCEDURE dbo.proc_ProcessReturn (
    @orderID INT,
    @productID INT,
    @quantity INT,
    @reason NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @PurchasedQty INT;

        -- 1. Sprawdzenie, czy produkt był zamówiony oraz w jakiej ilości
        SELECT @PurchasedQty = quantity
        FROM OrderPosition
        WHERE orderID = @orderID AND productID = @productID;

        IF @PurchasedQty IS NULL
            THROW 50005, 'Ten produkt nie występuje w podanym zamówieniu.', 1;

        IF @quantity > @PurchasedQty
            THROW 50006, 'Nie można zwrócić większej ilości niż została zakupiona.', 1;

        -- 2. Dodanie rekordu zwrotu do tabeli Returns
        INSERT INTO Returns (orderID, productID, quantity, reason)
        VALUES (@orderID, @productID, @quantity, @reason);

        -- 3. Aktualizacja pozycji zamówienia (zmniejszenie ilości)
        UPDATE OrderPosition
        SET quantity = quantity - @quantity
        WHERE orderID = @orderID AND productID = @productID;

        -- 4. Zwrócenie towaru na magazyn (dodatnia zmiana ilości w proc_UpdateStock)
        EXEC dbo.proc_UpdateStock @productID, @quantityChange = @quantity;

        -- 5. Przeliczenie całkowitej wartości zamówienia po zwrocie
        UPDATE Orders
        SET price = dbo.func_CalculateOrderTotal(@orderID)
        WHERE id = @orderID;

        -- 6. Ustawienie statusu zamówienia w zależności od ilości pozostałych pozycji
        IF (SELECT SUM(quantity) FROM OrderPosition WHERE orderID = @orderID) = 0
        BEGIN
            UPDATE Orders SET status = 'Zwrócono całkowicie' WHERE id = @orderID;
        END
        ELSE
        BEGIN
            UPDATE Orders SET status = 'Częściowy zwrot' WHERE id = @orderID;
        END

        COMMIT TRANSACTION;
        PRINT 'Zwrot przetworzony pomyślnie.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO