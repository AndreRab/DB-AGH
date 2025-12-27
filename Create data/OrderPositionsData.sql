WITH OP AS (
    SELECT TOP (300)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects o1
    CROSS JOIN sys.objects o2
)
INSERT INTO dbo.OrderPosition (orderID, quantity, productID)
SELECT
    ((n - 1) % 100) + 1                       AS orderID,
    1 + (n % 5)                               AS quantity,
    ((n - 1) % 27) + 1                        AS productID
FROM OP;
GO