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
