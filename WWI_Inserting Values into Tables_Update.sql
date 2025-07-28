USE WWI

-- 1- Inserting values into Locations Table
INSERT INTO Locations
	SELECT
		CityID,
		CityName,
		StateProvinceName,
		StateProvinceCode,
		SalesTerritory,
		CountryName,
		Continent,
		Region,
		Subregion,
		C.LatestRecordedPopulation,
		S.LatestRecordedPopulation,
		CO.LatestRecordedPopulation
	FROM 
		WideWorldImporters.Application.Cities C
			LEFT JOIN WideWorldImporters.Application.StateProvinces S
				ON C.StateProvinceID=S.StateProvinceID
			LEFT JOIN WideWorldImporters.Application.Countries CO
				ON S.CountryID=CO.CountryID

SELECT	*
FROM	Locations


-- 2- Inserting values into Employee Table
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

-- 3- Inserting values into Customers Table
INSERT INTO Customers
	SELECT
		CustomerID,
		CustomerName,
		AccountOpenedDate,
		DeliveryCityID,
		CustomerCategoryName,
		BuyingGroupName,
		BillToCustomerID,
		CreditLimit,
		PaymentDays
	FROM	
		WideWorldImporters.Sales.Customers C
			LEFT JOIN WideWorldImporters.Sales.CustomerCategories CC
				ON	C.CustomerCategoryID=CC.CustomerCategoryID
			LEFT JOIN WideWorldImporters.Sales.BuyingGroups BG
				ON	C.BuyingGroupID=BG.BuyingGroupID

SELECT	*
FROM	Customers

-- 4- Inserting values into Delivery_Methods Table
INSERT INTO Delivery_Methods
	SELECT	
		DeliveryMethodID,
		DeliveryMethodName
	FROM	
		WideWorldImporters.Application.DeliveryMethods

SELECT	* 
FROM	Delivery_Methods

-- 5- Inserting values into Transaction_Types Table
INSERT INTO Transaction_Types
	SELECT
		TransactionTypeID,
		TransactionTypeName
	FROM	
		WideWorldImporters.Application.TransactionTypes

SELECT	*
FROM	Transaction_Types

-- 6- Inserting values into Payment_Methods Table
INSERT INTO Payment_Methods
	SELECT
		PaymentMethodID,
		PaymentMethodName
	FROM
		WideWorldImporters.Application.PaymentMethods

SELECT	*
FROM	Payment_Methods


-- 7- Inserting values into Suppliers Table
INSERT INTO Suppliers
	SELECT
		SupplierID,
		SupplierName,
		SupplierCategoryName
	FROM
		WideWorldImporters.Purchasing.Suppliers S
			LEFT JOIN WideWorldImporters.Purchasing.SupplierCategories SC 
				ON S.SupplierCategoryID=SC.SupplierCategoryID

SELECT	*
FROM	Suppliers

-- 8- Inserting values into Products Table
INSERT INTO Products
	SELECT DISTINCT
		SI.StockItemID,
		SI.StockItemName,
		FIRST_VALUE(StockGroupName) OVER (PARTITION BY SG.STOCKITEMID  ORDER BY STOCKITEMSTOCKGROUPID),
		ColorName,
		QuantityOnHand,
		LastStocktakeQuantity,
		TargetStockLevel,
		ReorderLevel,
		IsChillerStock,
		LastCostPrice,
		UnitPrice,
		RecommendedRetailPrice,
		TaxRate/100,
		LeadTimeDays
	FROM 
		WideWorldImporters.Warehouse.StockItems SI 
			LEFT JOIN WideWorldImporters.Warehouse.StockItemStockGroups SG 
				ON SI.StockItemID=SG.StockItemID
			LEFT JOIN WideWorldImporters.Warehouse.StockItemHoldings SH 
				ON SI.StockItemID=SH.StockItemID 
			LEFT JOIN WideWorldImporters.Warehouse.StockGroups G 
				ON SG.StockGroupID=G.StockGroupID
			LEFT JOIN WideWorldImporters.Warehouse.Colors c 
				ON SI.ColorID=C.ColorID
SELECT	*
FROM	Products


-- 9- Inserting into Sales_Orders Table
INSERT INTO Sales_Orders 
	SELECT
		O.OrderID,
		OrderDate,
		O.CustomerID,
		O.SalespersonPersonID,
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
FROM	Sales_Orders

-- 10- Inserting into Sales_Invoices Table
INSERT INTO Sales_Invoices 
	SELECT
		CT.InvoiceID,
		InvoiceDate,
		OrderID,
		I.BillToCustomerID,
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

-- 11- Inserting values into Returned_Sales Table
INSERT INTO Returned_Sales 
	SELECT
		CustomerTransactionID,
		TransactionDate,
		CustomerID,
		TransactionAmount*-1,
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

-- 12- Inserting values into Sales_Details
INSERT INTO Sales_Details
	SELECT DISTINCT
		InvoiceLineID,
		IL.InvoiceID,
		OL.OrderID,
		IL.StockItemID,
		PickingCompletedWhen,
		IL.Quantity,
		IL.UnitPrice,
		IL.TaxRate/100,
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

-- 13- Inserting values into Purchase_Orders Table
INSERT INTO Purchase_Orders
	SELECT 
		PurchaseOrderID,
		OrderDate,
		ExpectedDeliveryDate,
		ContactPersonID,
		SupplierID,
		DeliveryMethodID
	FROM
		WideWorldImporters.Purchasing.PurchaseOrders 

SELECT	*
FROM	Purchase_Orders

-- 14- Inserting Values into Purchase_Transactions Table
INSERT INTO Purchase_Transactions 
	SELECT
		SupplierTransactionID,
		TransactionDate,
		PurchaseOrderID,
		SupplierInvoiceNumber,
		AmountExcludingTax,
		TaxAmount,
		TransactionAmount,
		OutstandingBalance,
		IsFinalized,
		FinalizationDate,
		PaymentMethodID,
		TransactionTypeID
	FROM
		WideWorldImporters.Purchasing.SupplierTransactions
	WHERE 
		PurchaseOrderID IS NOT NULL

SELECT	*
FROM	Purchase_Transactions

-- 15- Inserting values into Returned Purchases
INSERT INTO Returned_Purchases
	SELECT
		SupplierTransactionID,
		TransactionDate,
		SupplierID,
		TransactionAmount *-1,
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

-- 16- Inserting Values into Purchase_Details
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

SELECT	*
FROM	Purchase_Details