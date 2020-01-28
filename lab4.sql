--1
CREATE PROC spInsertCategory
@CategoryName VARCHAR(255)
AS
INSERT INTO Categories (CategoryName)
VAlUES (@CategoryName);

-- Test fail:
EXEC spInsertCategory 'Guitars';
GO
-- test success
EXEC spInsertCategory 'New category';
GO
--2
CREATE FUNCTION fnDiscountPrice(
   @ItemID INT
)
RETURNS MONEY
BEGIN
  DECLARE @DiscountPrice MONEY;

  SELECT @DiscountPrice = ItemPrice - DiscountAmount
  FROM OrderItems
  WHERE ItemID = @ItemID;

  RETURN @DiscountPrice;
  END;

SELECT ItemID, ItemPrice, DiscountAmount, dbo.fnDiscountPrice(ItemID) AS DiscountPrice
FROM OrderItems

--3
CREATE FUNCTION fnItemTotal
   (@ItemID INT)
   RETURNS MONEY

BEGIN
   DECLARE @ItemTotal MONEY;
   SELECT @ItemTotal= dbo.fnDiscountPrice(ItemID) * Quantity
FROM OrderItems
WHERE @ItemID = @ItemID;
RETURN @ItemTotal;
END;
GO

--4
CREATE PROC spInsertProduct
  @CategoryID       INT,
  @ProductCode      VARCHAR(10),
  @ProductName      VARCHAR(255),
  @ListPrice        MONEY,
  @DiscountPercent  MONEY

 AS
  
 IF @ListPrice < 0
   THROW 50001, 'The list price must be a positive number.', 1;
   
 IF @DiscountPercent < 0
   THROW 50001, 'The discount percent must be a positive number.', 1;

 INSERT INTO Products
   (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, DateAdded)
 VALUES
 (@CategoryID, @ProductCode, @ProductName, '', @ListPrice,  @DiscountPercent, GETDATE());

 EXEC spInsertProduct 1, 'G5122', 'Gretsch G5122 Double cutaway hollowbody', 999.9, 32;
 GO
 
 SELECT ProductName, ListPrice
 FROM Products

 --5

CREATE PROC spUpdateProductDiscount
   @ProductID        INT,
   @DiscountPercent  MONEY
AS

IF @DiscountPercent < 0
  THROW 50001, 'The discount percent must be a positive number.', 1;

UPDATE Products
SET DiscountPercent = @DiscountPercent
WHERE ProductID = @ProductID;

EXEC spUpdateProductDiscount 1, 30;

--6
CREATE TRIGGER Products_UPDATE
  ON Products
  AFTER UPDATE
AS

IF (SELECT DiscountPercent FROM inserted) >= 100
  THROW 50001, 'The discount percent must be less than 100.', 1;

IF (SELECT DiscountPercent FROM inserted) < 0
  THROW 50001, 'The discount percent must be a positive number', 1;

IF (SELECT DiscountPercent FROM inserted) >= 0 AND
   (SELECT DiscountPercent FROM inserted) < 1
      UPDATE Products
	  SET DiscountPercent = (SELECT DiscountPercent FROM inserted) * 100
	  WHERE ProductID = (SELECT ProductID FROM inserted);
 
SELECT ProductID, ProductCode, ProductName, DiscountPercent
FROM Products;

UPDATE Products
SET DiscountPercent = .25
WHERE ProductID = 1;

--8
CREATE TABLE ProductsAudit(
  AuditID          INT            PRIMARY KEY IDENTITY,
  ProductID        INT            NOT NULL,
  CategoryID       INT            NOT NULL,
  ProductCode      VARCHAR(10)    NOT NULL,
  ProductName      VARCHAR(255)   NOT NULL,
  ListPrice        MONEY          NOT NULL,
  DiscountPercent  MONEY          NOT NULL,    DEFAULT 0.00,
  DateUpdated      DATETIME                    DEFAULT NULL

);
SELECT *
FROM ProductsAudit

CREATE TRIGGER Products_UPDATE_AUDIT
  ON Products
  AFTER UPDATE
AS
  INSERT INTO ProductAudit
     (ProductID, CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, DateUpdated)
	 VALUES (
	 (SELECT ProductID FROM deleted),
	 (SELECT CategoryID FROM deleted),
	 (SELECT ProductCode FROM deleted),
	 (SELECT ProductName FROM deleted),
	 (SELECT ListPrice FROM deleted),
	 (SELECT DiscountPercent from deleted),
	 GETDATE());

UPDATE Products
SET ListPrice = 749.00
WHERE ProductID = 1;



