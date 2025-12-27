CREATE TABLE dbo.Customers (
    id      INT IDENTITY(1,1) NOT NULL,
    name    NVARCHAR(100)     NOT NULL,
    address NVARCHAR(200)     NULL,
    phone   NVARCHAR(50)      NULL,
    email   NVARCHAR(100)     NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (id),
    CONSTRAINT UQ_Customers_Email UNIQUE (email)
);
GO


CREATE TABLE dbo.Elements (
    id              INT IDENTITY(1,1) NOT NULL,
    type            NVARCHAR(100) NOT NULL,
    quantityInStock INT           NOT NULL
        CONSTRAINT DF_Elements_QuantityInStock DEFAULT (0),
    CONSTRAINT PK_Elements PRIMARY KEY (id),
    CONSTRAINT CK_Elements_QuantityInStock CHECK (quantityInStock >= 0)
);
GO


CREATE TABLE dbo.Products
(
    id              INT IDENTITY (1,1) NOT NULL,
    name            NVARCHAR(100)      NOT NULL,
    UnitsInStock    INT                NOT NULL
        CONSTRAINT DF_Products_UnitsInStock DEFAULT (0),
    quantityPerUnit INT                NOT NULL,
    category        NVARCHAR(100)      NOT NULL,
    productionTime  TIME               NOT NULL,

    CONSTRAINT PK_Products PRIMARY KEY (id),
    CONSTRAINT CK_Products_UnitsInStock CHECK (UnitsInStock >= 0),
    CONSTRAINT CK_Products_QuantityPerUnit CHECK (quantityPerUnit > 0)
);
GO


CREATE TABLE dbo.Employee (
    id             INT IDENTITY(1,1) NOT NULL,
    name           NVARCHAR(100)     NOT NULL,
    day_of_week    NVARCHAR(20)      NOT NULL,
    available_from TIME             NOT NULL,
    available_to   TIME             NOT NULL,

    CONSTRAINT PK_Employee PRIMARY KEY (id),
    CONSTRAINT CK_Employee_Availability CHECK (available_from < available_to)
);
GO


CREATE TABLE dbo.Orders (
    id              INT IDENTITY(1,1) NOT NULL,
    customerID      INT               NOT NULL,
    price           DECIMAL(10,2)     NOT NULL,
    discount        DECIMAL(10,2)     NOT NULL CONSTRAINT DF_Orders_Discount DEFAULT(0),
    orderDate       DATETIME          NOT NULL CONSTRAINT DF_Orders_OrderDate DEFAULT(GETDATE()),
    deliveryDate    DATETIME          NULL,
    realisationTime DATETIME          NULL,
    status          NVARCHAR(50)      NOT NULL,
    paymentMethod   NVARCHAR(50)      NOT NULL,

    CONSTRAINT PK_Orders PRIMARY KEY (id),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (customerID) REFERENCES dbo.Customers(id),
    CONSTRAINT CK_Orders_Price CHECK (price >= 0),
    CONSTRAINT CK_Orders_Discount CHECK (discount >= 0)
);
GO


CREATE TABLE dbo.OrderPosition (
    id        INT IDENTITY(1,1) NOT NULL,
    orderID   INT               NOT NULL,
    quantity  INT               NOT NULL,
    productID INT               NOT NULL,
    unitPrice DECIMAL(10,2)               NOT NULL,

    CONSTRAINT PK_OrderPosition PRIMARY KEY (id),
    CONSTRAINT FK_OrderPosition_Orders
        FOREIGN KEY (orderID) REFERENCES dbo.Orders(id),
    CONSTRAINT FK_OrderPosition_Products
        FOREIGN KEY (productID) REFERENCES dbo.Products(id),
    CONSTRAINT CK_OrderPosition_Quantity CHECK (quantity > 0),
    CONSTRAINT CK_OrderPosition_UnitPrice CHECK (unitPrice >= 0)
);
GO

CREATE TABLE dbo.Returns (
    id        INT IDENTITY(1,1) NOT NULL,
    orderID   INT               NOT NULL,
    quantity  INT               NOT NULL,
    productID INT               NOT NULL,
    reason    NVARCHAR(200)     NOT NULL,
    returnDate DATETIME         NOT NULL CONSTRAINT DF_Returns_ReturnDate DEFAULT(GETDATE()),

    CONSTRAINT PK_Returns PRIMARY KEY (id),
    CONSTRAINT FK_Returns_Orders
        FOREIGN KEY (orderID) REFERENCES dbo.Orders(id),
    CONSTRAINT FK_Returns_Products
        FOREIGN KEY (productID) REFERENCES dbo.Products(id),
    CONSTRAINT CK_Returns_Quantity CHECK (quantity > 0)
);
GO


CREATE TABLE dbo.ProductElements (
    id        INT IDENTITY(1,1) NOT NULL,
    productID INT               NOT NULL,
    elementID INT               NOT NULL,
    quantity  INT               NOT NULL,

    CONSTRAINT PK_ProductElements PRIMARY KEY (id),
    CONSTRAINT FK_ProductElements_Products
        FOREIGN KEY (productID) REFERENCES dbo.Products(id),
    CONSTRAINT FK_ProductElements_Elements
        FOREIGN KEY (elementID) REFERENCES dbo.Elements(id),
    CONSTRAINT CK_ProductElements_Quantity CHECK (quantity > 0),
    CONSTRAINT UQ_ProductElements UNIQUE (productID, elementID)
);
GO


CREATE TABLE dbo.ProductionHistory (
    id         INT IDENTITY(1,1) NOT NULL,
    employeeId INT               NOT NULL,
    productId  INT               NOT NULL,
    status     NVARCHAR(50)      NOT NULL,
    startDate  DATETIME          NOT NULL CONSTRAINT DF_ProductionHistory_StartDate DEFAULT(GETDATE()),

    CONSTRAINT PK_ProductionHistory PRIMARY KEY (id),
    CONSTRAINT FK_ProductionHistory_Employee
        FOREIGN KEY (employeeId) REFERENCES dbo.Employee(id),
    CONSTRAINT FK_ProductionHistory_Product
        FOREIGN KEY (productId) REFERENCES dbo.Products(id)
);
GO

CREATE TABLE dbo.VAT (
    id         INT IDENTITY(1,1) NOT NULL,
    rate       DECIMAL(5, 2)               NOT NULL,

    CONSTRAINT PK_ProductionHistory PRIMARY KEY (id),
);
GO


CREATE TABLE dbo.PriceHistory (
    id              INT IDENTITY(1,1) NOT NULL,
    productID        INT               NOT NULL,
    VAT_ID            INT             NOT NULL,
    addingValue      FLOAT             NOT NULL,
    productionPrice  INT               NOT NULL,
    changedAt        DATETIME          NOT NULL CONSTRAINT DF_PriceHistory_ChangedAt DEFAULT(GETDATE()),

    CONSTRAINT PK_PriceHistory PRIMARY KEY (id),
    CONSTRAINT FK_PriceHistory_Products
        FOREIGN KEY (productID) REFERENCES dbo.Products(id),
    CONSTRAINT FK_VAT
        FOREIGN KEY (VAT_ID) REFERENCES dbo.VAT(id),
    CONSTRAINT CK_PriceHistory_ProductionPrice CHECK (productionPrice >= 0)
);
GO


CREATE INDEX IX_Orders_CustomerID            ON dbo.Orders(customerID);
CREATE INDEX IX_Orders_OrderDate             ON dbo.Orders(orderDate);

CREATE INDEX IX_OrderPosition_OrderID        ON dbo.OrderPosition(orderID);
CREATE INDEX IX_OrderPosition_ProductID      ON dbo.OrderPosition(productID);

CREATE INDEX IX_ProductElements_ProductID    ON dbo.ProductElements(productID);
CREATE INDEX IX_ProductElements_ElementID    ON dbo.ProductElements(elementID);

CREATE INDEX IX_ProductionHistory_EmployeeID ON dbo.ProductionHistory(employeeId);
CREATE INDEX IX_ProductionHistory_ProductID  ON dbo.ProductionHistory(productId);
CREATE INDEX IX_ProductionHistory_StartDate  ON dbo.ProductionHistory(startDate);

CREATE INDEX IX_PriceHistory_ProductID       ON dbo.PriceHistory(productID);
CREATE INDEX IX_PriceHistory_ChangedAt       ON dbo.PriceHistory(changedAt);

CREATE INDEX IX_Returns_OrderID              ON dbo.Returns(orderID);
CREATE INDEX IX_Returns_ProductID            ON dbo.Returns(productID);
GO