create schema `euromart_stores`;
Use `euromart_stores`;

CREATE TABLE `Customers` (
`Customer_ID` varchar(64) NOT NULL, 
PRIMARY KEY (`Customer_ID`),
`Customer_Name` varchar(255) NOT NULL, 
`Segment` varchar(255) NOT NULL);

CREATE TABLE `Suppliers` (
`Supplier_ID` varchar(64) NOT NULL, 
PRIMARY KEY (`Supplier_ID`),
`Country` varchar(255) NOT NULL, 
`State` varchar(255) NOT NULL,
`City` varchar(255) NOT NULL, 
`Region` varchar(255) NOT NULL)
;

CREATE TABLE `Ship` (
`Ship_ID` varchar(64) NOT NULL, 
PRIMARY KEY (`Ship_ID`),
`Ship_Type` varchar(255) NOT NULL);


CREATE TABLE `Products` (
`Product_ID` varchar(64) NOT NULL,	
PRIMARY KEY (`Product_ID`),
`Category` varchar(255) NOT NULL, 
`Sub_Category` varchar(255) NOT NULL,
`Product_Name` varchar(255) NOT NULL);

-- select * from Suppliers;

CREATE TABLE `Orders` (
`Order_ID` varchar(64) NOT NULL,
PRIMARY KEY (`Order_ID`),
`Order_Date` DATE,
`Customer_ID` varchar(255) NOT NULL, 
`Supplier_ID` varchar(255) NOT NULL, 
`Ship_ID` varchar(255) NOT NULL,
CONSTRAINT `Customer_ID` FOREIGN KEY (`Customer_ID`) REFERENCES `Customers` (`Customer_ID`) ON DELETE CASCADE  ON UPDATE CASCADE,
CONSTRAINT `Supplier_ID` FOREIGN KEY (`Supplier_ID`) REFERENCES `Suppliers` (`Supplier_ID`) ON DELETE CASCADE  ON UPDATE CASCADE,
CONSTRAINT `Ship_ID` FOREIGN KEY (`Ship_ID`) REFERENCES `Ship` (`Ship_ID`) ON DELETE CASCADE  ON UPDATE CASCADE
);



CREATE TABLE `Sales` (
`Key` varchar(64) NOT NULL, 
 PRIMARY KEY (`Key`),
`Order_ID` varchar(64) NOT NULL, 
`Customer_ID` varchar(64) NOT NULL, 
`Supplier_ID` varchar(64) NOT NULL,
`Ship_ID`	varchar(64) NOT NULL, 
`Product_ID` varchar(64) NOT NULL, 
`Discount` FLOAT NOT NULL, 
`Sales` FLOAT NOT NULL, 
`Profit` FLOAT NOT NULL, 	
`Quantity` int(11) NOT NULL,	
`Feedback` varchar(255) NOT NULL,
CONSTRAINT `Product_ID_111` FOREIGN KEY (`Product_ID`) REFERENCES `Products` (`Product_ID`) ON DELETE CASCADE  ON UPDATE CASCADE,
CONSTRAINT `Order_ID_111` FOREIGN KEY (`Order_ID`) REFERENCES `Orders` (`Order_ID`) ON DELETE CASCADE  ON UPDATE CASCADE,
CONSTRAINT `Customer_ID_111` FOREIGN KEY (`Customer_ID`) REFERENCES `Customers` (`Customer_ID`) ON DELETE CASCADE  ON UPDATE CASCADE,
CONSTRAINT `Supplier_ID_111` FOREIGN KEY (`Supplier_ID`) REFERENCES `Suppliers` (`Supplier_ID`) ON DELETE CASCADE  ON UPDATE CASCADE,
CONSTRAINT `Ship_ID_111` FOREIGN KEY (`Ship_ID`) REFERENCES `Ship` (`Ship_ID`)ON DELETE CASCADE  ON UPDATE CASCADE);


-- ============================ 
-- Stored Procedures:
DELIMITER //
CREATE PROCEDURE `Top_Customers`() 
BEGIN
	select  Customers.Customer_Name, SUM(Sales.Sales) AS `Total_Sales` from Customers join Sales on Customers.Customer_ID = Sales.Customer_ID group by customers.Customer_Name order by Total_Sales DESC limit 5;
END //
DELIMITER ;

CALL `Top_Customers`();


-- ==========================================================

-- 1. Top 10 customers based on the total sales value made 
SELECT Customer_ID, sum(Sales) AS 'Total Sales'  FROM euromart_stores.sales WHERE Customer_ID IS NOT NULL GROUP BY Customer_ID ORDER BY sum(Profit) DESC LIMIT 10; 
-- CREATE INDEX idx_orderID ON orders (Order_ID);

select * from orders;
-- 2. Top 10 customers based on the number of times they have placed orders 
-- Used 1 instead of * in Count to better query performane
SELECT Customer_ID, count(1) AS 'Total Orders placed' FROM euromart_stores.sales WHERE Customer_ID IS NOT NULL GROUP BY Customer_ID ORDER BY count(Order_ID) DESC LIMIT 10; 

 -- 3. Finding the Top 5 customers 
select Customers.Customer_Name, SUM(Sales.Sales) AS `Total_Sales` from Customers join Sales on Customers.Customer_ID = Sales.Customer_ID group by customers.Customer_Name order by Total_Sales DESC limit 5; 

 
-- 4. Finding the best Shipping mode: 
select  Ship.Ship_Type, SUM(Sales.Sales) AS `Total_Sales` from Ship join Sales on Ship.Ship_ID = Sales.Ship_ID group by Ship.Ship_Type order by Total_Sales DESC limit 5; 

--  5.  Finding the category and sub-category sales 
select  Products.Category, Products.Sub_Category, SUM(Sales.Sales) AS `Total_Sales` from Products join Sales on Products.Product_ID = Sales.Product_ID group by Products.Category, Products.Sub_Category order by Total_Sales DESC limit 5; 

-- 6. Change in sales of products with time 
select  year(Orders.Order_Date) AS Years, Sub_Category, SUM(Sales.Sales) AS `Total_Sales` from Products join Sales on Products.Product_ID = Sales.Product_ID join Orders on Orders.Order_ID=Sales.Order_ID group by Years, Products.Sub_Category order by Years, Total_Sales DESC limit 10; 

 -- 7. Sales in all regions 
Select Suppliers.Region, CAST((SUM(Sales.Sales) * 100.0 / (Select SUM(Sales.Sales) From Sales)) AS SIGNED) AS Percentage  from Sales join Suppliers on Suppliers.Supplier_ID=Sales.Supplier_ID  Group By Suppliers.Region limit 10; 

 
 
