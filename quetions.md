# Project Questions

## Question 1
Write a query that displays information about products that have not been purchased.
- Display: ProductID, ProductName, Color, ListPrice, Size
- Sort the report by ProductID.

## Question 2
Write a query that displays information about customers who have not made any orders.
- Display: CustomerID, LastName, FirstName
- Sort the report by CustomerID.
- If the customer does not have a FirstName or LastName, display 'Unknown' instead.

## Question 3
Write a query that displays the top 10 customers who have made the most orders.
- Display: CustomerID, FirstName, LastName, NumberOfOrders
- Sort the report by NumberOfOrders in descending order.

## Question 4
Write a query that displays information about employees and their job titles.
- Display: FirstName, LastName, JobTitle, HireDate
- Include the number of employees holding each job title.

## Question 5
Write a query that displays for each customer the last order date and the order date before the last one.
- Display: CustomerID, FirstName, LastName, LastOrderDate, PreviousOrderDate

## Question 6
Write a query that displays the total amount of the most expensive orders each year and the customers to whom these orders belong.
- Display: OrderDate, OrderID, CustomerFirstName, CustomerLastName, Total
- The total is based on the calculation: UnitPrice * (1 - UnitPriceDiscount) * OrderQty.
- Format the Total column as shown in the diagram.

## Question 7
Display the number of orders made each month of the year using a matrix.

## Question 8
Write a query that displays the total amount of products ordered each month of the year and the cumulative total for the year.
- Ensure the report's layout is visually clear.
- Display a row emphasizing the yearly summary.

## Question 9
Write a query that displays employees in each department by the order of their hire date, from the newest to the oldest.
- Display: DepartmentName, EmployeeID, FullName, HireDate, TenureInMonths, PreviousEmployeeHireDate, DaysBetweenHireDates

## Question 10
Write a query that displays details of employees working in the same department who were hired on the same date.
- The employees should be listed against each combination of hire date and department number.
- Sort by hire dates in descending order. Use XML Path as one possible solution.
