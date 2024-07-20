/*
Q1: Write a query that displays information about products that have not been purchased.

Display: ProductID, ProductName, Color, ListPrice, Size
Sort the report by ProductID.
*/

SELECT ProductID, Name AS ProductName,Color,ListPrice,Size
FROM Production.Product
WHERE ProductID  NOT IN (SELECT ProductID
FROM Sales.SalesOrderDetail)
ORDER BY ProductID

/*
Q2: Write a query that displays information about customers who have not made any orders.

Display: CustomerID, LastName, FirstName
Sort the report by CustomerID.
If the customer does not have a FirstName or LastName, display 'Unknown' instead.
*/

SELECT C.CustomerID,ISNULL(P.LastName, 'Unknown') AS LastName,ISNULL(P.FirstName, 'Unknown') AS FirstName
FROM Sales.Customer C LEFT JOIN Person.Person P ON C.CustomerID = P.BusinessEntityID
WHERE C.CustomerID NOT IN (SELECT CustomerID FROM Sales.SalesOrderHeader)
ORDER BY C.CustomerID

/*
Q3: Write a query that displays the top 10 customers who have made the most orders.

Display: CustomerID, FirstName, LastName, NumberOfOrders
Sort the report by NumberOfOrders in descending order.
*/

SELECT TOP 10 C.CustomerID,P.FirstName,P.LastName,COUNT(*) AS CountOfOrders
FROM Person.Person P JOIN Sales.Customer C ON C.PersonID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader SH ON SH.CustomerID = C.CustomerID
GROUP BY C.CustomerID,P.FirstName,P.LastName
ORDER BY COUNT(*) DESC

/*
Q4: Write a query that displays information about employees and their job titles.

Display: FirstName, LastName, JobTitle, HireDate
Include the number of employees holding each job title.
*/

SELECT P.FirstName,P.LastName,E.JobTitle,HireDate,COUNT(*) OVER (PARTITION BY E.JobTitle) AS CountOfTitle
FROM Person.Person P JOIN HumanResources.Employee E ON E.BusinessEntityID = P.BusinessEntityID
GROUP BY E.JobTitle,P.FirstName,P.LastName,HireDate

/*
Q5: Write a query that displays for each customer the last order date and the order date before the last one.
Display: CustomerID, FirstName, LastName, LastOrderDate, PreviousOrderDate
*/

GO
WITH RankedOrders AS (
    SELECT P.FirstName,P.LastName,C.CustomerID,SH.SalesOrderID,
MAX(SH.OrderDate) OVER(PARTITION BY C.CustomerID ) AS LastOrder,
LAG(OrderDate) OVER (PARTITION BY C.CustomerID ORDER BY OrderDate) AS PreviousOrder,
RANK() OVER (PARTITION BY C.CustomerID ORDER BY SH.OrderDate DESC) AS OrderRank
    FROM Person.Person P JOIN Sales.Customer C ON C.PersonID = P.BusinessEntityID
      JOIN Sales.SalesOrderHeader SH ON SH.CustomerID = C.CustomerID
)
SELECT SalesOrderID,CustomerID,FirstName,LastName,LastOrder,PreviousOrder
FROM RankedOrders
WHERE OrderRank =1

/*
Q6: Write a query that displays the total amount of the most expensive orders each year and the customers to whom these orders belong.

Display: OrderDate, OrderID, CustomerFirstName, CustomerLastName, Total
The total is based on the calculation: UnitPrice * (1 - UnitPriceDiscount) * OrderQty.
Format the Total column as shown in the diagram.
*/

WITH RankedSumOrders AS (
    SELECT YEAR(SH.OrderDate) AS 'YEAR',SH.SalesOrderID,C.PersonID,
           SUM((SD.UnitPrice - (SD.UnitPrice * SD.UnitPriceDiscount)) * SD.OrderQty) AS Total,
           ROW_NUMBER() OVER (PARTITION BY YEAR(SH.OrderDate) ORDER BY SUM((SD.UnitPrice - (SD.UnitPrice * SD.UnitPriceDiscount)) * SD.OrderQty) DESC) AS RowNum
    FROM Sales.SalesOrderHeader SH JOIN Sales.SalesOrderDetail SD ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer C ON SH.CustomerID = C.CustomerID
    GROUP BY YEAR(SH.OrderDate), SH.SalesOrderID, C.PersonID
)
SELECT
    R.YEAR,R.SalesOrderID,P.LastName,P.FirstName,FORMAT(ROUND(R.Total, 1), 'N1') AS Total
FROM RankedSumOrders R JOIN Person.Person P ON R.PersonID = P.BusinessEntityID
WHERE R.RowNum = 1

/*
Q7: Display the number of orders made each month of the year using a matrix.
*/

SELECT Month,[2011],[2012],[2013],[2014]
FROM (
    SELECT SalesOrderID, YEAR(OrderDate) AS 'Year', MONTH(OrderDate) AS 'Month'
    FROM Sales.SalesOrderHeader) TBL
PIVOT (
    COUNT(SalesOrderID) FOR Year IN ([2011],[2012],[2013],[2014])) PVT
ORDER BY Month

/*
Q8: Write a query that displays the total amount of products ordered each month of the year and the cumulative total for the year.

Ensure the report's layout is visually clear.
Display a row emphasizing the yearly summary.
*/

WITH totalYearMonth AS (
    SELECT DISTINCT
        YEAR(h.OrderDate) AS s_year,
        MONTH(h.OrderDate) AS s_month,
        SUM(UnitPrice * (1 - UnitPriceDiscount)) AS sumPerYearMonth
    FROM Sales.SalesOrderHeader h JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID 
    GROUP BY YEAR(h.OrderDate), MONTH(h.OrderDate)
),
RunningSum AS (
    SELECT 
        s_year AS Year,
        s_month AS Month,
        sumPerYearMonth AS sumPrice,
        SUM(sumPerYearMonth) OVER (PARTITION BY s_year ORDER BY s_year, s_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumSum
    FROM totalYearMonth
)
SELECT 
    Year,
    CAST(Month AS CHAR(12)) AS Month,
    ROUND(sumPrice,2) AS Sum_Price,
    ROUND(cumSum, 2) AS CumSum 
FROM RunningSum
UNION
SELECT 
	Year,
	'grand_total' AS Month,
	NULL AS Sum_Price,
	ROUND(MAX(cumSum), 2) AS CumSum 
FROM RunningSum
GROUP BY Year
ORDER BY Year,cumSum

/*
Q9: Write a query that displays employees in each department by the order of their hire date, from the newest to the oldest.

Display: DepartmentName, EmployeeID, FullName, HireDate, TenureInMonths, PreviousEmployeeHireDate, DaysBetweenHireDates
*/

WITH EmployeesHireRanked AS (
SELECT D.Name AS DepartmentName,E.BusinessEntityID AS Employeesid,P.FirstName + ' ' + P.LastName AS EmployeesFullMame,E.HireDate,
DATEDIFF(M,E.HireDate,GETDATE()) AS Seniority,
LAG (E.HireDate) OVER (PARTITION BY D.Name ORDER BY E.HireDate ) AS PreviousEmpHDate
FROM HumanResources.Employee E JOIN Person.Person P ON P.BusinessEntityID =E.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory EDH ON EDH.BusinessEntityID = E.BusinessEntityID
JOIN HumanResources.Department D ON D.DepartmentID = EDH.DepartmentID
)

SELECT DepartmentName,Employeesid,EmployeesFullMame,HireDate,Seniority,
LAG(EmployeesFullMame)OVER (PARTITION BY DepartmentName ORDER BY HireDate) AS PreviousEmpName,
PreviousEmpHDate,
DATEDIFF(D,PreviousEmpHDate,HireDate) AS DiffDays
FROM EmployeesHireRanked;

/*
Q10: Write a query that displays details of employees working in the same department who were hired on the same date.

The employees should be listed against each combination of hire date and department number.
Sort by hire dates in descending order. Use XML Path as one possible solution.
*/

WITH EmployeeData AS (
    SELECT EDH.DepartmentID,EDH.BusinessEntityID AS EmployeeID,E.HireDate,EDH.EndDate,P.FirstName ,P.LastName
 FROM   HumanResources.EmployeeDepartmentHistory EDH join HumanResources.Employee E on EDH.BusinessEntityID=E.BusinessEntityID
        JOIN person.person P ON P.BusinessEntityID = EDH.BusinessEntityID
		)
SELECT HireDate, EmpD.DepartmentID,
        STRING_AGG(CONCAT(EmpD.EmployeeID, ' ', EmpD.LastName, ' ', EmpD.FirstName), ', ') AS EmpDupDate
FROM EmployeeData EmpD
WHERE EndDate is null 
GROUP BY EmpD.DepartmentID, HireDate
ORDER BY HireDate DESC