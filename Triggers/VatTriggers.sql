IF OBJECT_ID('dbo.trg_VAT_PreventDeleteIfUsed', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_VAT_PreventDeleteIfUsed;
GO

CREATE TRIGGER dbo.trg_VAT_PreventDeleteIfUsed
ON dbo.VAT
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.PriceHistory ph
          ON ph.VAT_ID = d.id
    )
    BEGIN
        RAISERROR(
            'Cannot delete VAT rate: it is used in PriceHistory.',
            16, 1
        );
        RETURN;
    END;

    DELETE v
    FROM dbo.VAT v
    JOIN deleted d ON v.id = d.id;
END;
GO