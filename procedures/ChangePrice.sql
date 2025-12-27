create PROCEDURE dbo.proc_ChangePrice (
    @productID INT,
    @productionPrice INT = NULL,
    @addingValue FLOAT = NULL,
    @VAT_ID INT = NULL
)
AS
BEGIN
    -- Deklaracja zmiennych lokalnych do przechowywania ostatnich wartości, jeśli nowe nie zostały podane
    DECLARE @LastProductionPrice INT;
    DECLARE @LastAddingValue FLOAT;
    DECLARE @LastVAT_ID INT;

    -- 1. Walidacja: sprawdzenie czy produkt istnieje
    IF NOT EXISTS (SELECT 1 FROM Products WHERE id = @productID)
    BEGIN
        RAISERROR('Produkt o podanym ID nie istnieje.', 16, 1)
        RETURN
    END

    -- 2. Pobranie ostatniego wpisu z PriceHistory dla produktu
    SELECT TOP 1
        @LastProductionPrice = ph.productionPrice,
        @LastAddingValue = ph.addingValue,
        @LastVAT_ID = ph.VAT_ID
    FROM PriceHistory ph
    WHERE ph.productID = @productID
    ORDER BY ph.changedAt DESC; -- najnowszy rekord

    -- 3. Uzupełnienie brakujących parametrów wartościami z ostatniego wpisu
    SET @productionPrice = ISNULL(@productionPrice, @LastProductionPrice);
    SET @addingValue = ISNULL(@addingValue, @LastAddingValue);
    SET @VAT_ID = ISNULL(@VAT_ID, @LastVAT_ID);

    -- 4. Walidacja końcowa – sprawdzamy czy dane są kompletne
    IF @productionPrice IS NULL OR @VAT_ID IS NULL
    BEGIN
        RAISERROR('Nie można dodać historii cen – brak poprzedniej ceny lub nie podano wymaganych danych (cena, VAT).', 16, 1)
        RETURN
    END

    -- 5. Walidacja stawki VAT
    IF NOT EXISTS (SELECT 1 FROM VAT WHERE id = @VAT_ID)
    BEGIN
        RAISERROR('Podana stawka VAT nie istnieje.', 16, 1)
        RETURN
    END

    -- 6. Dodanie nowego wpisu do PriceHistory
    INSERT INTO PriceHistory (productID, productionPrice, addingValue, VAT_ID, changedAt)
    VALUES (@productID, @productionPrice, @addingValue, @VAT_ID, GETDATE())
END
GO