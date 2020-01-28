
--1
BEGIN TRAN;
 DELETE Addresses

 WHERE CustomerID=8;

 DELETE Customers
 
 WHERE CustomerID = 8;

COMMIT TRAN;

ELSE

 BEGIN

 ROLLBACK TRAN;

END;







--extra credit
--1

DECLARE @ProductName VARCHAR(50)
DECLARE @ListPrice NUMERIC(8,2)
DECLARE Product_Cursor CURSOR
FOR 
   SELECT ProductName, ListPrice 
   FROM PRODUCTS 
   WHERE ListPrice > 700 
   ORDER BY ListPrice DESC
OPEN Product_Cursor
IF @@CURSOR_ROWS > 0
   BEGIN 
FETCH NEXT FROM Product_Cursor INTO @ProductName,@ListPrice
WHILE @@Fetch_status = 0
   BEGIN
   PRINT @ProductName +', $'+CONVERT(VARCHAR,@ListPrice)
   FETCH NEXT FROM Product_Cursor INTO @ProductName,@ListPrice
   END;
END;
CLOSE Product_Cursor
DEALLOCATE Product_Cursor

--2
DECLARE Average_Cursor CURSOR
Static FOR

SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;
OPEN Average_Cursor
FETCH NEXT FROM Average_Cursor
WHILE @@FETCH_STATUS = 0
  BEGIN
 
  Fetch next from Average_Cursor;


END;
CLOSE Average_Cursor
DEALLOCATE Average_Cursor

--3
DECLARE @LastName VARCHAR(50)
DECLARE @ShipAmountAvg NUMERIC(8,2)
DECLARE Average_Cursor CURSOR
Static FOR

SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;
OPEN Average_Cursor
FETCH NEXT FROM Average_Cursor into @LastName, @ShipAmountAVG
WHILE @@FETCH_STATUS = 0
  BEGIN
  print @LastName +', $'+CONVERT(VARCHAR, @ShipAmountAVG)
  Fetch next from Average_Cursor;


END;
CLOSE Average_Cursor
DEALLOCATE Average_Cursor







