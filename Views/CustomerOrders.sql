CREATE OR ALTER VIEW dbo.vw_CustomerOrders
AS
-- Widok prezentujący historię zamówień klientów:
-- data, status, rabat, cena po rabacie
SELECT
    c.id   AS CustomerID,
    c.name AS Klient,
    o.id   AS OrderID,
    o.orderDate,
    o.status,
    o.discount AS Rabat,
    o.price AS Cena_Po_Rabacie,
    o.paymentMethod
FROM dbo.Orders o
JOIN dbo.Customers c ON c.id = o.customerID;
GO