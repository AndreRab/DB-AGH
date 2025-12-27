CREATE OR ALTER VIEW dbo.vw_OrderLineFinancials
AS
SELECT
    o.id            AS OrderID,
    o.customerID    AS CustomerID,
    o.orderDate     AS OrderDate,
    o.status        AS OrderStatus,
    o.paymentMethod AS PaymentMethod,
    o.discount      AS OrderDiscount,

    op.id           AS OrderPositionID,
    op.productID    AS ProductID,
    p.category      AS Category,
    op.quantity     AS Quantity,
    op.unitPrice    AS UnitPriceGross,

    ph_at.productionPrice,
    ph_at.addingValue,
    ph_at.VatRate,

    CAST(op.quantity * CAST(op.unitPrice AS decimal(19,2)) AS decimal(19,2)) AS LineGross,
    CAST(op.quantity * (CAST(op.unitPrice AS decimal(19,2)) / (1.0 + ph_at.VatRate)) AS decimal(19,2)) AS LineNet,
    CAST(op.quantity * (CAST(op.unitPrice AS decimal(19,2)) - (CAST(op.unitPrice AS decimal(19,2)) / (1.0 + ph_at.VatRate))) AS decimal(19,2)) AS LineVat,

    CAST((CAST(ph_at.productionPrice AS decimal(19,2)) + CAST(ph_at.addingValue AS decimal(19,2))) AS decimal(19,2)) AS UnitCostNet,
    CAST(op.quantity * (CAST(ph_at.productionPrice AS decimal(19,2)) + CAST(ph_at.addingValue AS decimal(19,2))) AS decimal(19,2)) AS LineCostNet,

    CAST(
        op.quantity * (CAST(op.unitPrice AS decimal(19,2)) / (1.0 + ph_at.VatRate))
        - op.quantity * (CAST(ph_at.productionPrice AS decimal(19,2)) + CAST(ph_at.addingValue AS decimal(19,2)))
    AS decimal(19,2)) AS LineProfitNet

FROM dbo.Orders o
JOIN dbo.OrderPosition op ON op.orderID = o.id
JOIN dbo.Products p ON p.id = op.productID

OUTER APPLY (
    SELECT TOP (1)
        ph.productionPrice,
        ph.addingValue,
        v.rate AS VatRate
    FROM dbo.PriceHistory ph
    JOIN dbo.VAT v ON v.id = ph.vatID
    WHERE ph.productID = op.productID
      AND ph.changedAt <= o.orderDate
    ORDER BY ph.changedAt DESC
) ph_at

WHERE ph_at.VatRate IS NOT NULL;
GO

SELECT * FROM dbo.vw_OrderLineFinancials