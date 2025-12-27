IF OBJECT_ID('dbo.trg_ProductionHistory_EnsureCompletedBeforeNewStart', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_ProductionHistory_EnsureCompletedBeforeNewStart;
GO

CREATE TRIGGER dbo.trg_ProductionHistory_EnsureCompletedBeforeNewStart
ON dbo.ProductionHistory
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        OUTER APPLY (
            SELECT TOP (1) ph.status
            FROM dbo.ProductionHistory ph
            WHERE ph.employeeId = i.employeeId
              AND ph.id < i.id
            ORDER BY ph.startDate DESC, ph.id DESC
        ) AS lastJob
        WHERE i.status = 'Started'
          AND lastJob.status IS NOT NULL
          AND lastJob.status <> 'Completed'
    )
    BEGIN
        RAISERROR(
            'Employee cannot start a new production task before completing the previous one.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO