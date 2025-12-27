CREATE TRIGGER trg_Products_PreventDeleteIfUsed
ON dbo.Products
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.ProductElements pe
            ON pe.productID = d.id
    )
    BEGIN
        RAISERROR(
            'Cannot delete product: it is used in ProductElements. Remove links first.',
            16, 1
        );
        RETURN;
    END;

    DELETE p
    FROM dbo.Products p
    JOIN deleted d
        ON p.id = d.id;
END;
GO