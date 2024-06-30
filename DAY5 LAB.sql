CREATE DATABASE TEST;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    Region NVARCHAR(50),
    Product NVARCHAR(50),
    Amount DECIMAL(10, 2)
);

INSERT INTO Sales (SaleID, SaleDate, Region, Product, Amount) VALUES
(1, '2023-01-01', 'North', 'ProductA', 100.00),
(2, '2023-01-02', 'South', 'ProductB', 200.00),
(3, '2023-01-03', 'North', 'ProductA', 150.00),
(4, '2023-01-04', 'East', 'ProductC', 300.00),
(5, '2023-01-05', 'West', 'ProductA', 250.00),
(6, '2023-01-06', 'South', 'ProductB', 50.00),
(7, '2023-01-07', 'North', 'ProductC', 400.00),
(8, '2023-01-08', 'East', 'ProductA', 350.00),
(9, '2023-01-09', 'West', 'ProductB', 100.00),
(10, '2023-01-10', 'North', 'ProductC', 200.00);

-------------------------------------------------------------------------------------------------------------
-- Q1

USE TEST;
SELECT Region, Product, SUM(Amount) AS TOTAL_AMOUNT
FROM Sales
GROUP BY 
ROLLUP (Region, Product);

----------------------------------------------------------------------------------------------------
-- Q2

USE TEST;
SELECT Region, Product, SUM(Amount) AS TOTAL_AMOUNT
FROM Sales
GROUP BY 
CUBE (Region, Product);

----------------------------------------------------------------------------------------------------
-- Q3

USE TEST;
SELECT Region, Product, SUM(Amount) AS TOTAL_AMOUNT
FROM Sales
GROUP BY 
GROUPING SETS (Region, Product);

----------------------------------------------------------------------------------------------------
-- Q4

DECLARE @XML XML;
SET @XML = 
'
<sales>
    <sale>
        <saleID>1</saleID>
        <saleDate>2023-01-01</saleDate>
        <region>North</region>
        <product>ProductA</product>
        <amount>100.00</amount>
    </sale>
    <sale>
        <saleID>2</saleID>
        <saleDate>2023-01-02</saleDate>
        <region>South</region>
        <product>ProductB</product>
        <amount>200.00</amount>
    </sale>
    <!-- More sales -->
</sales>
'

DECLARE @HDOC INT

EXEC SP_XML_PREPAREDOCUMENT @HDOC OUTPUT, @XML

SELECT * INTO NEW_TABLE2
FROM OPENXML (@HDOC, '//sale') 
WITH (SALE_ID INT 'saleID',
	  SALE_DATE DATE 'saleDate', 
	  REGION VARCHAR(50) 'region',
	  PRODUCT VARCHAR(50) 'product',
	  AMOUNT FLOAT 'amount'
	  )

EXEC sp_xml_removedocument @HDOC
SELECT * FROM NEW_TABLE;

SELECT SUM (AMOUNT) FROM NEW_TABLE;

-------------------------------------------------------------------------------------------------------------------------------
-- Q5

DECLARE @JSON NVARCHAR(3000) = 
N'
{
    "sales": [
        {
            "saleID": 1,
            "saleDate": "2023-01-01",
            "region": "North",
            "product": "ProductA",
            "amount": 100.00
        },
        {
            "saleID": 2,
            "saleDate": "2023-01-02",
            "region": "South",
            "product": "ProductB",
            "amount": 200.00
        }
        // More sales
    ]
}
';


WITH CTE
AS (
SELECT 
  JSON_VALUE(@json,'$.sales[0].saleID') AS 'sale_ID',
  JSON_VALUE(@json,'$.sales[0].saleDate') AS 'sale_Date',
  JSON_VALUE(@json,'$.sales[0].region') AS 'region',
  JSON_VALUE(@json,'$.sales[0].product') AS 'product',
  JSON_VALUE(@json,'$.sales[0].amount') AS 'amount'

UNION ALL

SELECT 
  JSON_VALUE(@json,'$.sales[1].saleID') AS 'sale_ID',
  JSON_VALUE(@json,'$.sales[1].saleDate') AS 'sale_Date',
  JSON_VALUE(@json,'$.sales[1].region') AS 'region',
  JSON_VALUE(@json,'$.sales[1].product') AS 'product',
  JSON_VALUE(@json,'$.sales[1].amount') AS 'amount' )
  select * into saltab from cte

  select * from saltab
--Write a query to extract the total sales amount from the above JSON.
  select SUM(convert (float, amount) ) [total sales amount] from saltab



SELECT * FROM OPENJSON(@JSON);

