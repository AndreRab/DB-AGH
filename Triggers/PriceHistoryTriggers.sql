IF OBJECT_ID('dbo.trg_PriceHistory_PreventDeleteLast', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_PriceHistory_PreventDeleteLast;
GO

CREATE TRIGGER dbo.trg_PriceHistory_PreventDeleteLast
ON dbo.PriceHistory
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM deleted d
        WHERE NOT EXISTS (
            SELECT 1
            FROM dbo.PriceHistory ph
            WHERE ph.productID = d.productID
        )
    )
    BEGIN
        RAISERROR(
            'Cannot delete the last PriceHistory entry for a product. Each product must have at least one price history record.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO