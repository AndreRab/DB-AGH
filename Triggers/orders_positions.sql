-- Sprawdzenie czy mozemy stwoezyc zamowienie
CREATE OR ALTER TRIGGER dbo.trg_OrderPosition_AI_CheckStock
ON dbo.OrderPosition
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.Products p ON p.id = i.productID
        WHERE i.quantity > p.UnitsInStock
    )
    BEGIN
        RAISERROR('OrderPosition INSERT blocked: not enough product stock (UnitsInStock).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

-- Spradzenie czy mozemy zmieniac zamowienie na wiecej niz stock produktow
CREATE OR ALTER TRIGGER dbo.trg_OrderPosition_AU_CheckStock
ON dbo.OrderPosition
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF (UPDATE(quantity) OR UPDATE(productID))
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN dbo.Products p ON p.id = i.productID
            WHERE i.quantity > p.UnitsInStock
        )
        BEGIN
            RAISERROR('OrderPosition UPDATE blocked: not enough product stock (UnitsInStock).', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END
END
GO