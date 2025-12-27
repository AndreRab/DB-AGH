CREATE PROCEDURE dbo.proc_PlaceOrder (
    @productID INT,
    @quantity INT,
    @orderID INT = NULL,
    @customerID INT = NULL,
    @paymentMethod NVARCHAR(50) = NULL,
    @discount DECIMAL(10, 2) = 0.00
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UnitPrice MONEY;
        DECLARE @UnitsInStock INT;
        DECLARE @Producible INT;
        DECLARE @NeededFromProduction INT = 0;

        -- 1. Pobranie aktualnej ceny oraz informacji o dostępności
        SELECT @UnitPrice = FinalPrice FROM dbo.func_GetPrice(@productID, GETDATE());

        SELECT
            @UnitsInStock = UnitsInStock,
            @Producible = Producible
        FROM dbo.func_CheckProductAvailability(@productID);

        -- 2. Walidacja: czy łącznie (magazyn + potencjalna produkcja) wystarczy na zamówioną ilość
        IF (@UnitsInStock + @Producible) < @quantity
        BEGIN
            RAISERROR('Brak wystarczających zasobów i surowców dla produktu %d.', 16, 1, @productID);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Nagłówek zamówienia: tworzenie nowego zamówienia, jeśli nie istnieje
        IF @orderID IS NULL OR NOT EXISTS (SELECT 1 FROM Orders WHERE id = @orderID)
        BEGIN
            INSERT INTO Orders (customerID, price, discount, orderDate, status, paymentMethod)
            VALUES (@customerID, 0, @discount, GETDATE(), 'W realizacji', @paymentMethod);
            SET @orderID = SCOPE_IDENTITY();
        END

        -- 4. Obsługa magazynu i produkcji
        IF @UnitsInStock >= @quantity
        BEGIN
            -- Mamy wystarczający stan magazynowy – tylko zdejmujemy produkty z magazynu
            EXEC dbo.proc_UpdateStock @productID, @quantity;
        END
        ELSE
        BEGIN
            -- Brakuje produktów na magazynie – zdejmujemy to, co jest, a resztę zlecamy do produkcji
            @NeededFromProduction = @quantity - @UnitsInStock;

            -- Opróżniamy magazyn z danego produktu (jeśli coś na nim jest)
            IF @UnitsInStock > 0
                EXEC dbo.proc_UpdateStock @productID, -@UnitsInStock;

            -- Zlecenie produkcji brakującej ilości (odejmuje surowce i zapisuje w ProductionHistory)
            EXEC dbo.proc_AddProduction @productID, @NeededFromProduction;

            -- Opcjonalnie: zmiana statusu zamówienia na "Czeka na produkcję"
            UPDATE Orders SET status = 'Czeka na produkcję' WHERE id = @orderID;
        END

        -- 5. Dodanie pozycji zamówienia i przeliczenie całkowitej ceny
        INSERT INTO OrderPosition (orderID, quantity, productID, unitPrice)
        VALUES (@orderID, @quantity, @productID, @UnitPrice);

        UPDATE Orders
        SET price = dbo.func_CalculateOrderTotal(@orderID)
        WHERE id = @orderID;

        COMMIT TRANSACTION;
        SELECT @orderID AS OrderID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END