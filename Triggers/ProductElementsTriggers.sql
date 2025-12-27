-- Have a requirements for that in create tables
CREATE TRIGGER trg_ProductElements_Validate
ON dbo.ProductElements
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN dbo.Products p
            ON p.id = i.productID
        WHERE p.id IS NULL
    )
    BEGIN
        RAISERROR(
            'Invalid ProductID in ProductElements: referenced product does not exist.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN dbo.Elements e
            ON e.id = i.elementID
        WHERE e.id IS NULL
    )
    BEGIN
        RAISERROR(
            'Invalid ElementID in ProductElements: referenced element does not exist.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.quantity <= 0
    )
    BEGIN
        RAISERROR(
            'Quantity in ProductElements must be greater than 0.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO