-- Creating WWI Database

CREATE DATABASE WWI


-- Creating Tables For WWI Database

USE WWI

-- 1- Countries Table
CREATE TABLE Countries (
	Ctry_ID INT PRIMARY KEY,
	Ctry_Name NVARCHAR(60) NOT NULL,
	Continent NVARCHAR(30) NOT NULL,
	Region NVARCHAR(30) NOT NULL,
	SubRegion NVARCHAR(30) NOT NULL,
	Latest_Pop BIGINT)

-- 2- States Table
CREATE TABLE States (
	S_ID INT PRIMARY KEY,
	S_Name NVARCHAR(50) NOT NULL,
	S_Code NVARCHAR(5) NOT NULL,
	Ctry_ID INT NOT NULL FOREIGN KEY REFERENCES Countries(Ctry_ID),
	Sales_Territory NVARCHAR(50) NOT NULL,
	Latest_Pop BIGINT)

-- 3- Cities Table
CREATE TABLE Cities (
	City_ID INT PRIMARY KEY,
	City_Name NVARCHAR(50) NOT NULL,
	S_ID INT NOT NULL FOREIGN KEY REFERENCES States(S_ID),
	Latest_Pop BIGINT)

-- 4- Customer_Categories Table
CREATE TABLE Customer_Categories (
	CC_ID INT PRIMARY KEY,
	CC_Name NVARCHAR(50) NOT NULL)

-- 5- Buying_Groups Table
CREATE TABLE Buying_Groups (
	Buy_Grp_ID INT PRIMARY KEY,
	BG_Name NVARCHAR(50) NOT NULL)

-- 6- Employees Table
CREATE TABLE Employees (
	Emp_ID INT PRIMARY KEY,
	Full_Name NVARCHAR(50) NOT NULL,
	Position NVARCHAR(20) NOT NULL)

-- 7- Customers Table
CREATE TABLE Customers (
	C_ID INT PRIMARY KEY,
	C_Name NVARCHAR(100) NOT NULL,
	Account_Opened_Date DATE NOT NULL,
	City_ID INT NOT NULL FOREIGN KEY REFERENCES Cities(City_ID),
	CC_ID INT NOT NULL FOREIGN KEY REFERENCES Customer_Categories(CC_ID),
	Buy_Grp_ID INT FOREIGN KEY REFERENCES Buying_Groups(Buy_Grp_ID),
	Paying_Customer  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Credit_Limit DECIMAL (18,10),
	Payment_Days INT NOT NULL)


-- 8- Delivery_Methods Table
CREATE TABLE Delivery_Methods (
	DM_ID INT PRIMARY KEY,
	Method_Name NVARCHAR(50) NOT NULL)

-- 9- Transaction_Types Table
CREATE TABLE Transaction_Types (
	Trans_ID INT PRIMARY KEY,
	Trans_Name NVARCHAR(50) NOT NULL)

-- 10- Payment_Methods Table
CREATE TABLE Payment_Methods (
	Payment_ID INT PRIMARY KEY,
	Method NVARCHAR(50) NOT NULL)

-- 11- Product_Categories Table
CREATE TABLE Product_Categories (
	PC_ID INT PRIMARY KEY,
	PC_Name NVARCHAR(50) NOT NULL)

-- 12- Colors Table
CREATE TABLE Colors (
	Color_ID INT PRIMARY KEY,
	Color NVARCHAR(20) NOT NULL)

-- 13- Suppliers_Categories Table
CREATE TABLE Supplier_Categories (
	Supp_Cat_ID INT PRIMARY KEY,
	Supplier_Category NVARCHAR(50) NOT NULL)

-- 14- Suppliers Table
CREATE TABLE Suppliers (
	Supp_ID INT PRIMARY KEY,
	Supplier NVARCHAR(100) NOT NULL,
	Supp_Cat_ID  INT NOT NULL FOREIGN KEY REFERENCES Supplier_Categories(Supp_Cat_ID))

-- 15- Products Table
CREATE TABLE Products (
	P_ID INT PRIMARY KEY,
	P_Name NVARCHAR(100) NOT NULL,
	PC_ID  INT NOT NULL FOREIGN KEY REFERENCES Product_Categories(PC_ID),
	Q_on_Hand INT NOT NULL,
	Last_Take_Q INT NOT NULL,
	Target_Stock INT NOT NULL,
	Reorder_Level INT NOT NULL,
	Is_Chiller BIT NOT NULL,
	Unit_Cost DECIMAL(18,10) NOT NULL,
	WholeSale_Price DECIMAL(18,10) NOT NULL,
	Retail_Price DECIMAL(18,10) NOT NULL,
	Tax_Rate DECIMAL(18,10) NOT NULL,
	Lead_Time INT NOT NULL,
	Color_ID  INT FOREIGN KEY REFERENCES Colors(Color_ID)) 

-- 16- Special_Deals Table
CREATE TABLE Special_Deals (
	Deal_ID INT PRIMARY KEY,
	Starting_Date DATE NOT NULL,
	Ending_Date DATE NOT NULL,
	Deal NVARCHAR(30) NOT NULL,
	P_ID  INT FOREIGN KEY REFERENCES Products(P_ID),
	C_ID  INT FOREIGN KEY REFERENCES Customers(C_ID),
	PC_ID  INT FOREIGN KEY REFERENCES Product_Categories(PC_ID),
	Buy_Grp_ID INT FOREIGN KEY REFERENCES Buying_Groups(Buy_Grp_ID),
	CC_ID INT FOREIGN KEY REFERENCES Customer_Categories(CC_ID),
	Unit_Price DECIMAL (18,10),
	Discount_Pct DECIMAL (18,10),
	Discount DECIMAL (18,10))

-- 17- Orders Table
CREATE TABLE Orders (
	Order_ID INT PRIMARY KEY,
	Order_Date DATE NOT NULL,
	Dry_Items INT,
	Chiller_Items INT,
	Picking_Date DATE,
	Expected_Delivery_Date DATE NOT NULL,
	Delivery_Date DATE, 
	DM_ID  INT FOREIGN KEY REFERENCES Delivery_Methods(DM_ID))

-- 18- Sales_Invoices Table
CREATE TABLE Sales_Invoices (
	Invoice_ID INT PRIMARY KEY,
	Invoce_Date DATE NOT NULL,
	Order_ID  INT FOREIGN KEY REFERENCES Orders(Order_ID),
	C_ID  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Emp_ID  INT NOT NULL FOREIGN KEY REFERENCES Employees(Emp_ID),
	Total_Sales DECIMAL (18,10) NOT NULL,
	Tax_Amount DECIMAL (18,10) NOT NULL,
	Net_Sales DECIMAL (18,10) NOT NULL,
	Outstanding_Bal DECIMAL (18,10) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))

-- 19- Returned_Sales Table
CREATE TABLE Returned_Sales (
	Returns_ID INT PRIMARY KEY,
	Returns_Date DATE NOT NULL,
	C_ID  INT NOT NULL FOREIGN KEY REFERENCES Customers(C_ID),
	Returned_Amount DECIMAL (18,10) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))

-- 20- Sales_Details Table
CREATE TABLE Sales_Details (
	Line_ID INT PRIMARY KEY,
	Invoice_ID  INT NOT NULL FOREIGN KEY REFERENCES Sales_Invoices(Invoice_ID),
	Order_ID  INT NOT NULL FOREIGN KEY REFERENCES Orders(Order_ID),
	P_ID  INT NOT NULL FOREIGN KEY REFERENCES Products(P_ID),
	Picking_Date DATE,
	Quantity INT NOT NULL,
	Unit_Price DECIMAL(18,10),
	Tax_Rate DECIMAL(18,10) NOT NULL,
	Tax_Amount DECIMAL(18,10) NOT NULL,
	Extended_Price DECIMAL(18,10) NOT NULL,
	Line_Profit DECIMAL(18,10) NOT NULL)
	
-- 21- Purchase_Orders Table
CREATE TABLE Purchase_Orders (
	Purch_ID INT PRIMARY KEY,
	Order_Date DATE NOT NULL,
	Expected_Delivery_Date DATE, 
	Emp_ID  INT NOT NULL FOREIGN KEY REFERENCES Employees(Emp_ID),
	Supp_ID  INT NOT NULL FOREIGN KEY REFERENCES Suppliers(Supp_ID),
	DM_ID  INT NOT NULL FOREIGN KEY REFERENCES Delivery_Methods(DM_ID),
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE)

-- 22- Purchase_Invoices Table
CREATE TABLE Purchase_Transactions (
	Purch_Trans_ID INT PRIMARY KEY,
	Issue_Date DATE NOT NULL,
	Purch_ID  INT NOT NULL FOREIGN KEY REFERENCES Purchase_Orders(Purch_ID),
	Supp_ID  INT NOT NULL FOREIGN KEY REFERENCES Suppliers(Supp_ID),
	Supp_Invoice_Num INT,
	Total_Purchases DECIMAL (18,10) NOT NULL,
	Tax_Amount DECIMAL (18,10) NOT NULL,
	Net_Purchases DECIMAL (18,10) NOT NULL,
	Outstanding_Bal DECIMAL (18,10) NOT NULL,
	Payment_ID  INT NOT NULL FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))

-- 23- Returned_Purchases Table
CREATE TABLE Returned_Purchases (
	Purch_Returns_ID INT PRIMARY KEY,
	Purch_Returns_Date DATE NOT NULL,
	Supp_ID  INT NOT NULL FOREIGN KEY REFERENCES Suppliers(Supp_ID),
	Returned_Purch_Amount DECIMAL (18,10) NOT NULL,
	Is_Finalized BIT NOT NULL,
	Finalization_Date DATE,
	Payment_ID  INT FOREIGN KEY REFERENCES Payment_Methods(Payment_ID),
	Trans_ID  INT NOT NULL FOREIGN KEY REFERENCES Transaction_Types(Trans_ID))
	
-- 24- Purchase_Details Table
CREATE TABLE Purchase_Details (
	Detail_ID INT PRIMARY KEY,
	Purch_ID  INT NOT NULL FOREIGN KEY REFERENCES Purchase_Orders(Purch_ID),
	P_ID  INT NOT NULL FOREIGN KEY REFERENCES Products(P_ID),
	Ordered_Quantity INT NOT NULL,
	Recieved_Quantity INT NOT NULL,
	Purchasing_Price DECIMAL(18,10) NOT NULL,
	Last_Receipt_Date DATE)	

