CREATE OR ALTER TRIGGER dbo.trg_Orders_IDU_BlockIfHasPositions
ON dbo.Orders
INSTEAD OF DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- DELETE case
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM deleted d
            JOIN dbo.OrderPosition op ON op.orderID = d.id
        )
        BEGIN
            RAISERROR('Orders DELETE blocked: order has OrderPosition rows.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE o
        FROM dbo.Orders o
        JOIN deleted d ON d.id = o.id;

        RETURN;
    END

    -- UPDATE case
    IF EXISTS (SELECT 1 FROM deleted) AND EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Block changing Orders.id if positions exist
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON d.id = i.id
            JOIN dbo.OrderPosition op ON op.orderID = d.id
            WHERE i.id <> d.id
        )
        BEGIN
            RAISERROR('Orders UPDATE blocked: cannot change Orders.id when OrderPosition exists.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Perform the update (all columns except id are updated as provided)
        UPDATE o
            SET o.customerID       = i.customerID,
                o.price            = i.price,
                o.discount         = i.discount,
                o.orderDate        = i.orderDate,
                o.deliveryDate     = i.deliveryDate,
                o.realisationTime  = i.realisationTime,
                o.status           = i.status,
                o.paymentMethod    = i.paymentMethod
        FROM dbo.Orders o
        JOIN inserted i ON i.id = o.id;

        RETURN;
    END
END
GO