CREATE OR ALTER TRIGGER dbo.trg_Employee_ID_BlockDeleteIfProductionHistory
ON dbo.Employee
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.ProductionHistory ph ON ph.employeeId = d.id
    )
    BEGIN
        RAISERROR('Employee DELETE blocked: referenced in ProductionHistory.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE e
    FROM dbo.Employee e
    JOIN deleted d ON d.id = e.id;
END
GO