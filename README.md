# Production & Order Management System Database

## Project Overview
This project is a comprehensive SQL Server database designed to manage the entire lifecycle of a production-based retail business. It handles everything from raw material inventory (**Elements**) and production processes to customer orders, sales analysis, and returns.

The system is built with advanced database features including **Stored Procedures** for business logic, **Triggers** for data integrity, **Functions** for dynamic calculations, and **Views** for reporting.

## Features
*   **Complete Order Lifecycle**: Manage orders from placement to delivery and returns.
*   **Dynamic Inventory & Production**: Automatically triggers production orders when stock is insufficient, calculating theoretical capacity based on raw materials (**Elements**).
*   **Price History & VAT**: tracks product production costs and added value over time to calculate final prices with VAT.
*   **Employee Management**: Tracks employee availability and production history.
*   **Automated Validations**: Triggers ensure no new production task starts before the previous one is finished, and stock levels are maintained correctly.

---

## Database Schema

<img width="566" height="552" alt="image" src="https://github.com/user-attachments/assets/219f86ff-4a06-49da-aab7-09cbff3b7c20" />


---

## Tables Reference

### Core Master Data
| Table | Description | Key Fields |
| :--- | :--- | :--- |
| **Customers** | Stores customer contact details. | `id`, `name`, `email`, `phone`, `address` |
| **Products** | The catalogs of sellable items. | `id`, `name`, `UnitsInStock`, `category`, `productionTime` |
| **Elements** | Raw materials/components used to build products. | `id`, `type`, `quantityInStock` |
| **Employee** | Staff members details and working hours. | `id`, `name`, `day_of_week`, `available_from`, `available_to` |
| **VAT** | Tax rates definition. | `id`, `rate` |

### Transactional Data
| Table | Description | Key Fields |
| :--- | :--- | :--- |
| **Orders** | Customer orders headers. | `id`, `customerID`, `price`, `status`, `paymentMethod`, `orderDate`, `discount` |
| **OrderPosition** | Line items for each order. | `id`, `orderID`, `productID`, `quantity`, `unitPrice` |
| **Returns** | Records of returned items. | `id`, `orderID`, `productID`, `quantity`, `reason` |
| **PriceHistory** | Historical record of product costs to determine pricing at any date. | `id`, `productID`, `productionPrice`, `addingValue`, `VAT_ID`, `changedAt` |

### Products Production
| Table | Description | Key Fields |
| :--- | :--- | :--- |
| **ProductElements** | Bill of Materials (BOM) - defines which elements make a product. | `id`, `productID`, `elementID`, `quantity` |
| **ProductionHistory** | Log of production tasks assigned to employees. | `id`, `employeeId`, `productId`, `status`, `startDate` |

---

## Database Objects Documentation

### Stored Procedures
These procedures handle the main business operations.

*   **`proc_PlaceOrder (@productID, @quantity, ...)`**
    *   **Logic**: Checks stock availability. If stock is sufficient, it reserves items. If irrelevant, it checks if enough raw materials exist to *produce* the items. If yes, it triggers production (updates `Elements` stock and adds to `ProductionHistory`) and places the order with status "Pending Production".
*   **`proc_AddProduction (@productID, @quantity)`**
    *   **Logic**: Manually adds a production task. Validates if enough raw materials (`Elements`) exist, deducts them, and assigns the task to available employees.
*   **`proc_ProcessReturn (@orderID, @productID, @quantity, @reason)`**
    *   **Logic**: Handles customer returns. Verifies purchase history, updates stock (increments), and updates the order status (Partial/Full Return).
*   **`proc_ChangePrice (@productID, ...)`**
    *   **Logic**: Inserts a new record into `PriceHistory`. Automatically inherits previous values if partial data is provided.
*   **`proc_UpdateStock (@productID, @quantityChange)`**
    *   **Logic**: A low-level utility to safely increment or decrement physical stock levels.

### Functions
Helper functions for calculations and data retrieval.

*   **`func_GetPrice (@productID, @atDate)`**
    *   **Returns**: The final calculated price (Production Cost + Added Value + VAT) for a product at a specific point in time.
*   **`func_CheckProductAvailability (@ProductID)`**
    *   **Returns**: Table showing current stock, maximum producible quantity (based on elements), and total potential availability.
*   **`func_GetProductionCapacity (@ProductID)`**
    *   **Returns**: Integer representing how many units of a product *could* be built right now with current raw material stock.

### Views
Pre-built reports for analysis.

*   **`vw_CustomerOrders`**: Readable history of orders with customer names and statuses.
*   **`vw_ProductUnitCost`** & **`vw_SalesByCategory_PerWeekMonth`**: Financial analysis showing margins, costs, and revenue aggregated by time periods.
*   **`vw_StockAndCapacity`**: Strategic view for inventory managers connecting products with their raw material potential.
*   **`vw_ProductsInProduction`** & **`vw_ProductionPlan`**: Operational views for tracking active manufacturing jobs.

### Triggers
Automated rules enforced by the database to ensure data integrity and logical consistency.

*   **`trg_OrderPosition_StockAndPrice`**:
    *   Locks the price of an item at the moment of order creation.
    *   Ensures stock doesn't drop below zero inappropriately.
    *   Recalculates the total `Orders.price` whenever a line item changes.
*   **`trg_ProductionHistory_EnsureCompletedBeforeNewStart`**:
    *   Prevents an employee from starting a new production task if their previous distinct task is not marked as 'Completed'.
*   **Deletion Prevention Triggers** (Integrity Safeguards):
    *   **`trg_Customers_PreventDeleteWithOrders`**: Prevents deleting a customer who has existing orders to avoid orphan records.
    *   **`trg_Elements_PreventDeleteIfUsed`**: Prevents deleting a raw material (Element) if it is part of a product's recipe (BOM).
    *   **`trg_Employee_ID_BlockDeleteIfProductionHistory`**: Prevents deleting an employee who has assigned production history.
    *   **`trg_Products_PreventDeleteIfUsed`**: Prevents deleting a product if it has a defined manufacturing recipe (entries in `ProductElements`).
    *   **`trg_VAT_PreventDeleteIfUsed`**: Prevents deleting a VAT rate that is currently linked to historical prices.
*   **Validation Triggers**:
    *   **`trg_PriceHistory_PreventDeleteLast`**: Ensures a product always has at least one price history record (prevents deleting the last remaining entry).
    *   **`trg_ProductElements_Validate`**: Validates integrity on `ProductElements` (checking existence of IDs and positive quantities) - *Note: reinforces Foreign Key constraints*.

---

## Project Structure

The project files are organized by object type:

*   **`/Create data`**: contains `INSERT` scripts to populate the database with sample data (Customers, Products, etc.).
*   **`/Functions`**: SQL scripts for scalar and table-valued functions.
*   **`/procedures`**: Stored Procedure definitions.
*   **`/Triggers`**: Database triggers.
*   **`/Views`**: Virtual tables for reporting.
*   **`create_bases.sql`**: The main DDL script that initializes the database schema (CREATE TABLE statements).

---

## Getting Started

### Prerequisites
*   **Microsoft SQL Server** (LocalDB, Express, or standard edition).
*   **DataGrip**, **SSMS** (SQL Server Management Studio), or **Azure Data Studio**.

### Installation
1.  **Clone the repository**.
2.  **Create the Database**: Open your SQL tool and create a new empty database.
3.  **Run Schema Script**: Execute `create_bases.sql` to create all tables and constraints.
4.  **Create Objects**: Execute all scripts in the `/Functions`, `/Views`, `/procedures`, and `/Triggers` folders.
    *   *Tip*: Create Functions and Views first, then Procedures and Triggers to avoid dependency errors.
5.  **Load Data**: Run the scripts in `/Create data` in the following logical order:
    1.  `CustomersData.sql`, `ElementsData.sql`, `VATData.sql`
    2.  `ProductsData.sql`, `EmployeeData.sql`
    3.  `ProductElementsData.sql`, `PriceHistoryData.sql`
    4.  `OrdersData.sql`
    5.  `OrderPositionsData.sql`, `ProductionHistoryData.sql`, etc.

## Usage Examples

### Placing an Order
Use the stored procedure to place a new order safely:
```sql
DECLARE @NewOrderID INT;
-- Order 5 units of Product ID 1 for Customer ID 2
EXEC dbo.proc_PlaceOrder 
    @productID = 1, 
    @quantity = 5, 
    @customerID = 2, 
    @paymentMethod = 'Credit Card';
```

### Checking Product Price
Get the historical price of a product for a specific date:
```sql
SELECT * FROM dbo.func_GetPrice(1, '2023-11-01');
```

### Analyze Production Capacity
See how much you can build given current raw materials:
```sql
SELECT * FROM dbo.vw_StockAndCapacity WHERE ProductID = 1;
```
