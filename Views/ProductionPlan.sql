CREATE OR ALTER VIEW dbo.vw_ProductionPlan
AS
-- Widok prezentujący historię i bieżący plan produkcji:
-- produkt, pracownik, status, data startu
SELECT
    ph.id           AS ProductionHistoryID,
    ph.productId    AS ProductID,
    p.name          AS ProductName,
    p.category      AS Category,
    ph.employeeId   AS EmployeeID,
    e.name          AS EmployeeName,
    ph.status,
    ph.startDate
FROM dbo.ProductionHistory ph
JOIN dbo.Products  p ON p.id = ph.productId
JOIN dbo.Employee  e ON e.id = ph.employeeId;
GO