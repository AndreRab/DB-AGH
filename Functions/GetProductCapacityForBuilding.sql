CREATE FUNCTION dbo.func_GetProductionCapacity
(
    @ProductID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @MaxPossible INT;

    SELECT @MaxPossible = MIN(FLOOR(CAST(e.quantityInStock AS FLOAT) / NULLIF(pe.quantity, 0)))
    FROM ProductElements pe
    JOIN Elements e ON e.id = pe.elementID
    WHERE pe.productID = @ProductID;

    RETURN ISNULL(@MaxPossible, 0);
END;