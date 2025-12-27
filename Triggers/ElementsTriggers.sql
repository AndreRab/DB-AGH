CREATE TRIGGER trg_Elements_PreventDeleteIfUsed
ON dbo.Elements
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.ProductElements pe
            ON pe.elementID = d.id
    )
    BEGIN
        RAISERROR(
            'Cannot delete element: it is used in ProductElements. Remove links first.',
            16, 1
        );
        RETURN;
    END;

    DELETE e
    FROM dbo.Elements e
    JOIN deleted d
        ON e.id = d.id;
END;
GO