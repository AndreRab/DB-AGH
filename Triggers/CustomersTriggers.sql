CREATE TRIGGER trg_Customers_PreventDeleteWithOrders
ON dbo.Customers
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.Orders o
            ON o.customerID = d.id
    )
    BEGIN
        RAISERROR ('Cannot delete customer with existing orders.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    DELETE c
    FROM dbo.Customers c
    JOIN deleted d
        ON c.id = d.id;
END;
GO