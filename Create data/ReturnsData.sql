WITH Returned AS (
    SELECT TOP (10)
        op.orderID,
        op.productID,
        op.quantity AS orderedQty,
        ROW_NUMBER() OVER (ORDER BY o.orderDate) AS rn,
        ISNULL(o.deliveryDate, DATEADD(DAY, 3, o.orderDate)) AS baseReturnDate
    FROM dbo.OrderPosition op
    JOIN dbo.Orders o   ON o.id = op.orderID
    WHERE o.status = 'Completed'
    ORDER BY o.orderDate
)
INSERT INTO dbo.Returns (orderID, productID, quantity, reason, returnDate)
SELECT
    orderID,
    productID,
    CASE
        WHEN orderedQty > 1 AND rn IN (3,6,9) THEN 2
        ELSE 1
    END AS quantity,
    CASE rn % 10
        WHEN 1 THEN 'Damaged product'
        WHEN 2 THEN 'Does not match description'
        WHEN 3 THEN 'Missing components'
        WHEN 4 THEN 'Customer changed mind'
        WHEN 5 THEN 'Wrong size / dimensions'
        WHEN 6 THEN 'Defective mechanism'
        WHEN 7 THEN 'Color different than expected'
        WHEN 8 THEN 'Packaging damaged'
        WHEN 9 THEN 'Returned under warranty'
        ELSE      'Late delivery'
    END AS reason,
    DATEADD(DAY, rn * 2, baseReturnDate) AS returnDate
FROM Returned;
GO