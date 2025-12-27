CREATE PROCEDURE dbo.proc_UpdateStock (
    @productID INT,
    @quantityChange INT -- Liczba dodatnia (dostawa/zwrot), liczba ujemna (sprzedaż/rezerwacja)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Walidacja: sprawdzenie, czy produkt istnieje
    IF NOT EXISTS (SELECT 1 FROM Products WHERE id = @productID)
    BEGIN
        RAISERROR('Produkt o ID %d nie istnieje.', 16, 1, @productID);
        RETURN;
    END

    -- 2. Aktualizacja stanu magazynowego w tabeli Products
    UPDATE Products
    SET UnitsInStock = UnitsInStock + @quantityChange
    WHERE id = @productID;

    -- 3. Opcjonalna kontrola stanów ujemnych
    -- W systemach produkcyjnych stany ujemne są rzadko dopuszczalne,
    -- chyba że celowo zdejmujemy stan "pod produkcję".
    IF EXISTS (SELECT 1 FROM Products WHERE id = @productID AND UnitsInStock < 0)
    BEGIN
        -- Miejsce na logowanie ostrzeżeń/alertów o ujemnym stanie magazynowym
        PRINT 'Uwaga: Stan magazynowy produktu ' + CAST(@productID AS VARCHAR) + ' spadł poniżej zera.';
    END
END
GO