-- Creating WWI Database

CREATE DATABASE WWI


-- Creating Tables For WWI Database

USE WWI

-- 1- Locations Table
CREATE TABLE Locations (
	City_ID INT PRIMARY KEY,
	City NVARCHAR(50) NOT NULL,
	State NVARCHAR(50) NOT NULL,
	State_Code NVARCHAR(5) NOT NULL,
	Sales_Territory NVARCHAR(50) NOT NULL,
	Country NVARCHAR(60) NOT NULL,
	Continent NVARCHAR(30) NOT NULL,
	Region NVARCHAR(30) NOT NULL,
	SubRegion NVARCHAR(30) NOT NULL,
	City_Latest_Pop BIGINT,
	State_Latest_Pop BIGINT,
	Ctry_Latest_Pop BIGINT)


-- 2- Employees Table
CREATE TABLE Employees (
	Emp_ID INT PRIMARY KEY,
	Full_Name NVARCHAR(50) NOT NULL,
	Position NVARCHAR(20) NOT NULL)

-- 3- Customers Table
CREATE TABLE Customers (
	C_ID INT PRIMARY KEY,
	C_Name NVARCHAR(100) NOT NULL,
	Account_Opened_Date DATE NOT NULL,
	City_ID INT NOT NULL FOREIGN KEY REFERENCES Locations(City_ID),
	Category NVARCHAR(50) NOT NULL ,
	Buying_Group NVARCHAR(50) ,	
	Paying_Customer  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Credit_Limit DECIMAL (18,10),
	Payment_Days INT NOT NULL)


-- 4- Delivery_Methods Table
CREATE TABLE Delivery_Methods (
	DM_ID INT PRIMARY KEY,
	Method_Name NVARCHAR(50) NOT NULL)

-- 5- Transaction_Types Table
CREATE TABLE Transaction_Types (
	Trans_ID INT PRIMARY KEY,
	Trans_Name NVARCHAR(50) NOT NULL)

-- 6- Payment_Methods Table
CREATE TABLE Payment_Methods (
	Payment_ID INT PRIMARY KEY,
	Method NVARCHAR(50) NOT NULL)

-- 7- Suppliers Table
CREATE TABLE Suppliers (
	Supp_ID INT PRIMARY KEY,
	Supplier NVARCHAR(100) NOT NULL,
	Supplier_Category NVARCHAR(50) NOT NULL)

-- 8- Products Table
CREATE TABLE Products (
	P_ID INT PRIMARY KEY,
	P_Name NVARCHAR(100) NOT NULL,
	Product_Category NVARCHAR(50),
	Color  NVARCHAR(20),
	Q_on_Hand INT NOT NULL,
	Last_Take_Q INT NOT NULL,
	Target_Stock INT NOT NULL,
	Reorder_Level INT NOT NULL,
	Is_Chiller BIT NOT NULL,
	Unit_Cost DECIMAL(18,2) NOT NULL,
	WholeSale_Price DECIMAL(18,2) NOT NULL,
	Retail_Price DECIMAL(18,2) NOT NULL,
	Tax_Rate DECIMAL(18,2) NOT NULL,
	Lead_Time INT NOT NULL) 

-- 9- Sales_Orders Table
CREATE TABLE Sales_Orders (
	Order_ID INT PRIMARY KEY,
	Order_Date DATE NOT NULL,
	C_ID  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Salesperson  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Dry_Items INT,
	Chiller_Items INT,
	Picking_Date DATE,
	Expected_Delivery_Date DATE NOT NULL,
	Delivery_Date DATE, 
	DM_ID  INT FOREIGN KEY REFERENCES Delivery_Methods(DM_ID))

-- 10- Sales_Invoices Table
CREATE TABLE Sales_Invoices (
	Invoice_ID INT PRIMARY KEY,
	Invoce_Date DATE NOT NULL,
	Order_ID  INT FOREIGN KEY REFERENCES Sales_Orders(Order_ID),
	Bill_To  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Total_Sales DECIMAL (18,2) NOT NULL,
	Tax_Amount DECIMAL (18,2) NOT NULL,
	Net_Sales DECIMAL (18,2) NOT NULL,
	Outstanding_Bal DECIMAL (18,2) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))

-- 11- Returned_Sales Table
CREATE TABLE Returned_Sales (
	Returns_ID INT PRIMARY KEY,
	Returns_Date DATE NOT NULL,
	C_ID  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Returned_Amount DECIMAL (18,2) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))

-- 12- Sales_Details Table
CREATE TABLE Sales_Details (
	Line_ID INT PRIMARY KEY,
	Invoice_ID  INT NOT NULL FOREIGN KEY REFERENCES Sales_Invoices(Invoice_ID),
	Order_ID  INT NOT NULL FOREIGN KEY REFERENCES Sales_Orders(Order_ID),
	P_ID  INT NOT NULL FOREIGN KEY REFERENCES Products(P_ID),
	Picking_Date DATE,
	Quantity INT NOT NULL,
	Unit_Price DECIMAL(18,2),
	Tax_Rate DECIMAL(18,2) NOT NULL,
	Tax_Amount DECIMAL(18,2) NOT NULL,
	Extended_Price DECIMAL(18,2) NOT NULL,
	Line_Profit DECIMAL(18,2) NOT NULL)
	
-- 13- Purchase_Orders Table
CREATE TABLE Purchase_Orders (
	Purch_ID INT PRIMARY KEY,
	Order_Date DATE NOT NULL,
	Expected_Delivery_Date DATE, 
	Purchasing_Officer  INT NOT NULL FOREIGN KEY REFERENCES Employees(Emp_ID),
	Supp_ID  INT NOT NULL FOREIGN KEY REFERENCES Suppliers(Supp_ID),
	DM_ID  INT NOT NULL FOREIGN KEY REFERENCES Delivery_Methods(DM_ID))
	

-- 14- Purchase_Transactions Table
CREATE TABLE Purchase_Transactions (
	Purch_Trans_ID INT PRIMARY KEY,
	Issue_Date DATE NOT NULL,
	Purch_ID  INT NOT NULL FOREIGN KEY REFERENCES Purchase_Orders(Purch_ID),
	Supp_Invoice_Num INT,
	Total_Purchases DECIMAL (18,2) NOT NULL,
	Tax_Amount DECIMAL (18,2) NOT NULL,
	Net_Purchases DECIMAL (18,2) NOT NULL,
	Outstanding_Bal DECIMAL (18,2) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT NOT NULL FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))

-- 15- Returned_Purchases Table
CREATE TABLE Returned_Purchases (
	Purch_Returns_ID INT PRIMARY KEY,
	Purch_Returns_Date DATE NOT NULL,
	Supp_ID  INT NOT NULL FOREIGN KEY REFERENCES Suppliers(Supp_ID),
	Returned_Purch_Amount DECIMAL (18,2) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))
	
-- 16- Purchase_Details Table
CREATE TABLE Purchase_Details (
	Detail_ID INT PRIMARY KEY,
	Purch_ID  INT NOT NULL FOREIGN KEY REFERENCES Purchase_Orders(Purch_ID),
	P_ID  INT NOT NULL FOREIGN KEY REFERENCES Products(P_ID),
	Ordered_Quantity INT NOT NULL,
	Recieved_Quantity INT NOT NULL,
	Purchasing_Price DECIMAL(18,2) NOT NULL,
	Last_Receipt_Date DATE)	

