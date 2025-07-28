USE WWI

-- 1- Inserting values into Countries Table
INSERT INTO Countries
	SELECT	
		CountryID,
		CountryName,
		Continent,
		Region,
		Subregion,
		LatestRecordedPopulation
	FROM	
		WideWorldImporters.Application.Countries

SELECT	*
FROM	Countries

-- 2- Inserting values into States Table
INSERT INTO States
	SELECT 
		StateProvinceID,
		StateProvinceName,
		StateProvinceCode,
		CountryID,
		SalesTerritory,
		LatestRecordedPopulation
	FROM	
		WideWorldImporters.Application.StateProvinces

SELECT	*
FROM	States

-- 3- Inserting values into Cities Table
INSERT INTO Cities
	SELECT
		CityID,
		CityName,
		StateProvinceID,
		LatestRecordedPopulation
	FROM 
		WideWorldImporters.Application.Cities

SELECT	*
FROM	Cities

-- 4- Inserting values into Customer_Categories Table
INSERT INTO Customer_Categories
	SELECT
		CustomerCategoryID,
		CustomerCategoryName
	FROM	
		WideWorldImporters.Sales.CustomerCategories

SELECT	*
FROM	Customer_Categories

-- 5- Inserting values into Buying_Groups Table
INSERT INTO Buying_Groups
	SELECT
		BuyingGroupID,
		BuyingGroupName
	FROM	
		WideWorldImporters.Sales.BuyingGroups

SELECT	*
FROM	Buying_Groups

-- 6- Inserting values into Employee Table
INSERT INTO Employees
	SELECT
		PersonID,
		FullName,
		CASE
			WHEN IsSalesperson =1 THEN 'Sales_Person'
			ELSE 'Other_Employee'
		END
	FROM	
		WideWorldImporters.Application.People
	WHERE	
		IsEmployee = 1

SELECT	*
FROM	Employees

-- 7- Inserting values into Customers Table
INSERT INTO Customers
	SELECT
		CustomerID,
		CustomerName,
		AccountOpenedDate,
		DeliveryCityID,
		CustomerCategoryID,
		BuyingGroupID,
		BillToCustomerID,
		CreditLimit,
		PaymentDays
	FROM	
		WideWorldImporters.Sales.Customers

SELECT	*
FROM	Customers

-- 8- Inserting values into Delivery_Methods Table
INSERT INTO Delivery_Methods
	SELECT	
		DeliveryMethodID,
		DeliveryMethodName
	FROM	
		WideWorldImporters.Application.DeliveryMethods

SELECT	* 
FROM	Delivery_Methods

-- 9- Inserting values into Transaction_Types Table
INSERT INTO Transaction_Types
	SELECT
		TransactionTypeID,
		TransactionTypeName
	FROM	
		WideWorldImporters.Application.TransactionTypes

SELECT	*
FROM	Transaction_Types

-- 10- Inserting values into Payment_Methods Table
INSERT INTO Payment_Methods
	SELECT
		PaymentMethodID,
		PaymentMethodName
	FROM
		WideWorldImporters.Application.PaymentMethods

SELECT	*
FROM	Payment_Methods

-- 11- Inserting values into Product_Categories Table
INSERT INTO Product_Categories
	SELECT
		StockGroupID,
		StockGroupName
	FROM 
		WideWorldImporters.Warehouse.StockGroups


SELECT	*
FROM	Product_Categories

-- 12- Inserting values into Colors Table
INSERT INTO Colors
	SELECT	
		ColorID,
		ColorName
	FROM
		WideWorldImporters.Warehouse.Colors

SELECT	*
FROM	Colors

-- 13- Inserting values into  Supplier_Categories Table
INSERT INTO Supplier_Categories
	SELECT
		SupplierCategoryID,
		SupplierCategoryName
	FROM
		WideWorldImporters.Purchasing.SupplierCategories

SELECT	*
FROM	Supplier_Categories

-- 14- Inserting values into Suppliers Table
INSERT INTO Suppliers
	SELECT
		SupplierID,
		SupplierName,
		SupplierCategoryID
	FROM
		WideWorldImporters.Purchasing.Suppliers

SELECT	*
FROM	Suppliers

-- 15- Inserting values into Products Table
INSERT INTO Products
	SELECT DISTINCT
		SI.StockItemID,
		SI.StockItemName,
		FIRST_vALUE(STOCKGROUPID) OVER (PARTITION BY SG.STOCKITEMID  ORDER BY STOCKITEMSTOCKGROUPID),
		QuantityOnHand,
		LastStocktakeQuantity,
		TargetStockLevel,
		ReorderLevel,
		IsChillerStock,
		LastCostPrice,
		UnitPrice,
		RecommendedRetailPrice,
		TaxRate,LeadTimeDays,
		ColorID
	FROM 
		WideWorldImporters.Warehouse.StockItems SI 
			LEFT JOIN WideWorldImporters.Warehouse.StockItemStockGroups SG 
				ON SI.StockItemID=SG.StockItemID
			LEFT JOIN WideWorldImporters.Warehouse.StockItemHoldings SH 
				ON SI.StockItemID=SH.StockItemID 

SELECT	*
FROM	Products

-- 16- Inserting values into Special_Deals Table
INSERT INTO Special_Deals 
	SELECT 
		SpecialDealID,
		StartDate,
		EndDate,
		DealDescription,
		StockItemID,
		CustomerID,
		StockGroupID,
		BuyingGroupID,
		CustomerCategoryID,
		UnitPrice,
		DiscountPercentage,
		DiscountAmount
	FROM 
		WideWorldImporters.Sales.SpecialDeals

SELECT	*
FROM	Special_Deals

-- 17- Inserting into Orders Table
INSERT INTO Orders 
	SELECT
		O.OrderID,
		OrderDate,
		TotalDryItems,
		TotalChillerItems,
		PickingCompletedWhen,
		ExpectedDeliveryDate,
		ConfirmedDeliveryTime,
		DeliveryMethodID
	FROM 
		WideWorldImporters.Sales.Orders O
			LEFT JOIN WideWorldImporters.Sales.Invoices I
				ON O.OrderID = I.OrderID

SELECT	*
FROM	Orders

-- 18- Inserting into Sales_Invoices Table
INSERT INTO Sales_Invoices 
	SELECT
		CT.InvoiceID,
		InvoiceDate,
		OrderID,
		CT.CustomerID,
		SalespersonPersonID,
		AmountExcludingTax,
		TaxAmount,
		TransactionAmount,
		OutstandingBalance,
		IsFinalized,
		FinalizationDate,
		PaymentMethodID,
		TransactionTypeID
	FROM
		WideWorldImporters.Sales.CustomerTransactions CT
		 LEFT JOIN WideWorldImporters.Sales.Invoices I
			ON CT.InvoiceID=I.InvoiceID
	WHERE
		CT.InvoiceID IS NOT NULL

SELECT	*
FROM	Sales_Invoices

-- 19- Inserting values into Returned_Sales Table
INSERT INTO Returned_Sales 
	SELECT
		CustomerTransactionID,
		TransactionDate,
		CustomerID,
		TransactionAmount,
		IsFinalized,
		FinalizationDate,
		PaymentMethodID,
		TransactionTypeID
	FROM 
		WideWorldImporters.Sales.CustomerTransactions
	WHERE 
		InvoiceID IS NULL

SELECT	*
FROM	Returned_Sales

-- 20- Inserting values into Sales_Details
INSERT INTO Sales_Details
	SELECT DISTINCT
		InvoiceLineID,
		IL.InvoiceID,
		OL.OrderID,
		IL.StockItemID,
		PickingCompletedWhen,
		IL.Quantity,
		IL.UnitPrice,
		IL.TaxRate,
		IL.TaxAmount,
		ExtendedPrice,
		LineProfit		
	FROM 
		WideWorldImporters.Sales.InvoiceLines IL
			LEFT JOIN WideWorldImporters.Sales.Invoices I
				ON IL.InvoiceID=I.InvoiceID
			LEFT JOIN WideWorldImporters.Sales.OrderLines OL
				ON I.OrderID=OL.OrderID

SELECT	*
FROM	Sales_Details

-- 21- Inserting values into Purchase_Orders Table
INSERT INTO Purchase_Orders
	SELECT 
		PO.PurchaseOrderID,
		OrderDate,
		ExpectedDeliveryDate,
		ContactPersonID,
		PO.SupplierID,
		DeliveryMethodID,
		IsOrderFinalized,
		FinalizationDate
	FROM
		WideWorldImporters.Purchasing.PurchaseOrders PO
			LEFT JOIN WideWorldImporters.Purchasing.SupplierTransactions ST
				ON PO.PurchaseOrderID=ST.PurchaseOrderID

SELECT	*
FROM	Purchase_Orders

-- 22- Inserting Values into Puchase_Invoices Table
INSERT INTO Purchase_Transactions 
	SELECT
		SupplierTransactionID,
		TransactionDate,
		PurchaseOrderID,
		SupplierID,
		SupplierInvoiceNumber,
		AmountExcludingTax,
		TaxAmount,
		TransactionAmount,
		OutstandingBalance,
		PaymentMethodID,
		TransactionTypeID
	FROM
		WideWorldImporters.Purchasing.SupplierTransactions
	WHERE 
		PurchaseOrderID IS NOT NULL

SELECT	*
FROM	Purchase_Transactions

-- 23- Inserting values into Returned Purchases
INSERT INTO Returned_Purchases
	SELECT
		SupplierTransactionID,
		TransactionDate,
		SupplierID,
		TransactionAmount,
		IsFinalized,
		FinalizationDate,
		PaymentMethodID,
		TransactionTypeID
	FROM
		WideWorldImporters.Purchasing.SupplierTransactions
	WHERE 
		PurchaseOrderID IS  NULL

SELECT	*
FROM	Returned_Purchases

-- 24- Inserting Values into Purchase_Details
INSERT INTO Purchase_Details
	SELECT
		PurchaseOrderLineID,
		PurchaseOrderID,
		StockItemID,
		OrderedOuters,
		ReceivedOuters,
		ExpectedUnitPricePerOuter,
		LastReceiptDate
	FROM 
		WideWorldImporters.Purchasing.PurchaseOrderLines

	