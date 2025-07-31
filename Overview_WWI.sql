USE	WWI;

-- Dataset Overview
-- 1- Customers
SELECT	
	*
FROM	
	Customers;

SELECT
	COUNT(*) Total_customers
FROM
	Customers;

SELECT
	 DISTINCT C2.C_Name Head_Office,
	 COUNT(C2.Paying_Customer) Branches_Count
FROM
	Customers C1 
		LEFT JOIN Customers C2 
			ON C1.Paying_Customer = C2.C_ID
GROUP BY
	C2.C_Name
ORDER BY
	Branches_Count DESC,
	Head_Office;

SELECT
	Category,
	COUNT(*) Customers_Count
FROM
	Customers 
GROUP BY
	Category
ORDER BY
	Customers_Count DESC,
	Category;

SELECT
	City, 
	COUNT(C_ID) AS Customers_count
FROM 
	Customers C
		LEFT JOIN Locations L
			ON	C.City_ID=L.City_ID
GROUP BY
	City
ORDER BY
	Customers_count DESC;

SELECT
	State_Code, 
	COUNT(C_ID) AS Customers_count
FROM 
	Customers C
		LEFT JOIN Locations L
			ON	C.City_ID=L.City_ID
GROUP BY
	State_Code
ORDER BY
	Customers_count DESC;

SELECT
	CASE
		WHEN Account_Opened_Date BETWEEN '2012-11-01' AND '2013-10-31' THEN '1st Fisical Year'
		WHEN Account_Opened_Date BETWEEN '2013-11-01' AND '2014-10-31' THEN '2nd Fisical Year'
		WHEN Account_Opened_Date BETWEEN '2014-11-01' AND '2015-10-31' THEN '3rd Fisical Year'
		ELSE '4th Fisical Year'
	END AS Fisical_Year,
	COUNT(*) Joined_Customers

FROM
	Customers
GROUP BY 
	CASE
		WHEN Account_Opened_Date BETWEEN '2012-11-01' AND '2013-10-31' THEN '1st Fisical Year'
		WHEN Account_Opened_Date BETWEEN '2013-11-01' AND '2014-10-31' THEN '2nd Fisical Year'
		WHEN Account_Opened_Date BETWEEN '2014-11-01' AND '2015-10-31' THEN '3rd Fisical Year'
		ELSE '4th Fisical Year'
	END
ORDER BY
	Fisical_Year;

-- 2-Employees
SELECT	
	*
FROM 
	Employees;

SELECT
	Position,
	COUNT(*) Employee_Num
FROM 
	Employees
GROUP BY
	Position
ORDER BY
	Employee_Num DESC;

-- 3- Suppliers
SELECT	
	*
FROM
	Suppliers;

SELECT	
	COUNT(*) Suppliers_Count
FROM
	Suppliers;

SELECT	
	Supplier_Category,
	COUNT(*) Suppliers_Count
FROM
	Suppliers
GROUP BY
	Supplier_Category
ORDER BY
	Suppliers_Count DESC;

-- 4- Products
SELECT	
	*
FROM
	Products;
	
	
SELECT
	COUNT(*) AS Total_Products,
	(SELECT 
		COUNT(Is_Chiller)  
	FROM 
		Products 
	WHERE 
		Is_Chiller=1) AS Total_Chill_Items,
	(SELECT 
		COUNT(Is_Chiller)  
	FROM 
		Products 
	WHERE 
		Is_Chiller=0) AS Total_Dry_Items,
	COUNT(DISTINCT Product_Category) AS Categories,
	CAST(ROUND(AVG(Unit_Cost),2)AS DECIMAL(10,2)) AS Average_Cost,
	CAST(ROUND(AVG(WholeSale_Price),2)AS DECIMAL(10,2)) AS Average_Wholesale_Price,
	CAST(ROUND(AVG(Retail_Price),2)AS DECIMAL(10,2)) AS Average_Retail_Price,
	ROUND(AVG(Lead_Time),2) AS Average_Lead_Time
FROM
	Products;


SELECT
	Product_Category,
	COUNT(*) AS Total_Products,
	SUM(CASE WHEN Is_Chiller =1 THEN 1 END) Total_Chill_Items,
	SUM(CASE WHEN Is_Chiller =0 THEN 1 END)  AS Total_Dry_Items,
	CAST(ROUND(AVG(Unit_Cost),2)AS DECIMAL(10,2)) AS Average_Cost,
	CAST(ROUND(AVG(WholeSale_Price),2)AS DECIMAL(10,2)) AS Average_Wholesale_Price,
	CAST(ROUND(AVG(Retail_Price),2)AS DECIMAL(10,2)) AS Average_Retail_Price,
	CAST(ROUND(AVG(Tax_Rate),2)AS DECIMAL(10,2)) AS Average_Tax_Rate,
	ROUND(AVG(Lead_Time),2) AS Average_Lead_Time
FROM
	Products
GROUP BY
	Product_Category;


SELECT
	P_ID,
	Q_on_Hand,
	Target_Stock,
	Reorder_Level,
	CASE
		WHEN Q_on_Hand> Target_Stock THEN 'Above_Target'
		WHEN Q_on_Hand <= Target_Stock AND Q_on_Hand>Reorder_Level THEN 'Optimal'
		ELSE 'Restock'
	END AS Stock_Status
FROM 
	Products;
