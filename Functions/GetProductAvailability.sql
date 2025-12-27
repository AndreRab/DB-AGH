CREATE or ALTER FUNCTION dbo.func_CheckProductAvailability
(
    @ProductID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.id AS ProductID,
        ISNULL(p.UnitsInStock, 0) AS UnitsInStock,
        dbo.func_GetProductionCapacity(p.id) AS MaxProducibleFromElements,
        (ISNULL(p.UnitsInStock, 0) + dbo.func_GetProductionCapacity(p.id)) AS TotalAvailable
    FROM Products p
    WHERE p.id = @ProductID
);