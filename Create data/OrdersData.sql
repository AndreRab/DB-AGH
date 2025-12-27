WITH N AS (
    SELECT TOP (100)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO dbo.Orders (
    customerID,
    discount,
    orderDate,
    deliveryDate,
    realisationTime,
    status,
    paymentMethod
)
SELECT
    -- 15 klientów w kółko: 1..15
    ((n - 1) % 15) + 1                 AS customerID,

    -- rabat: trochę zróżnicowany
    CAST(
        CASE
            WHEN n % 10 = 0 THEN 50       -- co 10-ty większy rabat
            WHEN n % 5  = 0 THEN 20
            ELSE 0
        END AS DECIMAL(10,2)
    ) AS discount,

    -- daty: rozrzucone po 2024 roku
    DATEADD(DAY,  n,  '2024-01-01')    AS orderDate,
    DATEADD(DAY,  n+3,'2024-01-01')    AS deliveryDate,
    DATEADD(DAY,  n+1,'2024-01-01')    AS realisationTime,

    -- status: Completed / In progress / Cancelled
    CASE
        WHEN n % 10 = 0 THEN 'Cancelled'
        WHEN n % 3  = 0 THEN 'In progress'
        ELSE 'Completed'
    END AS status,

    -- metoda płatności: Card / Bank transfer / Blik / Cash
    CASE (n % 4)
        WHEN 0 THEN 'Card'
        WHEN 1 THEN 'Bank transfer'
        WHEN 2 THEN 'Blik'
        ELSE 'Cash'
    END AS paymentMethod
FROM N;
GO