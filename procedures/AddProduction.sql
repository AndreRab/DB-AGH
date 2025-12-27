CREATE PROCEDURE dbo.proc_AddProduction (
    @productID INT,
    @quantity INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Sprawdzenie maksymalnej możliwej produkcji na podstawie dostępnych komponentów
        DECLARE @MaxProducible INT;
        SET @MaxProducible = dbo.func_GetProductionCapacity(@productID);

        IF @MaxProducible < @quantity
        BEGIN
            RAISERROR('Niewystarczająca ilość komponentów w magazynie. Można wyprodukować maksymalnie: %d szt.', 16, 1, @MaxProducible);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Odjęcie komponentów z magazynu Elements
        -- Używamy korelacji z ProductElements, aby odjąć (ilość_na_sztukę * liczba_produktów)
        UPDATE E
        SET E.quantityInStock = E.quantityInStock - (PE.quantity * @quantity)
        FROM Elements E
        JOIN ProductElements PE ON E.id = PE.elementID
        WHERE PE.productID = @productID;

        -- 3. Dodanie wpisu do ProductionHistory
        -- Zakładamy, że pracownicy z tabeli Employee realizują proces produkcyjny dla danego produktu
        INSERT INTO ProductionHistory (employeeId, productId, status, startDate)
        SELECT
            E.id,
            @productID,
            'Rozpoczęto',
            GETDATE()
        FROM Employee E
        -- Tu można doprecyzować logikę wyboru pracowników dla danego zlecenia produkcyjnego
        WHERE E.id IN (
            SELECT DISTINCT E.id
            FROM Employee
            -- Miejsce na logikę przypisania pracownika do konkretnego zlecenia produkcyjnego
        );

        -- Uwaga: jeśli jeden produkt wymaga pracy wielu osób, powstanie wiele rekordów w ProductionHistory.

        COMMIT TRANSACTION;
        PRINT 'Produkcja została pomyślnie zlecona.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO