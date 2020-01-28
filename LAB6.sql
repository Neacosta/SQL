--1
CREATE ROLE OrderEntry;

GRANT INSERT, UPDATE
   ON Orders
   TO OrderEntry;

GRANT INSERT, UPDATE
   ON OrderItems
   TO OrderEntry;

ALTER ROLE db_datareader ADD MEMBER OrderEntry;

--2

CREATE LOGIN RobertHalliday WITH PASSWORD = 'HelloBob*1245',
    DEFAULT_DATABASE = MyGuitarShop;

CREATE USER  RobertHalliday FOR LOGIN RobertHalliday;

ALTER ROLE OrderEntry ADD MEMBER RobertHalliday;

--3
DECLARE @DynamicSQL VARCHAR(256),
        @LoginName VARCHAR(128),
		@TempPassword CHAR(8);

DECLARE Login_Cursor CURSOR
DYNAMIC
FOR 
  SELECT FirstName + LastName AS LoginName
  FROM Administrators;
  
  
OPEN Login_Cursor;

FETCH NEXT FROM Login_Cursor
   INTO @LoginName;

WHILE @@FETCH_STATUS = 0
   BEGIN
      SET @DynamicSQL ='CREATE LOGIN' + @LoginName + ' ' +
	                   'WITH PASSWORD = ''temp*1245'', ' +
					   'DEFAULT_DATABASE = MyGuitarSHOP';
	 EXEC (@DynamicSQL);

	 SET @DynamicSQL ='CREATE USER' + @LoginName + ' ' +
	                   'FOR LOGIN' + @LoginName
	 EXEC (@DynamicSQL);

	 SET @DynamicSQL ='ALTER ROLE OrderEntry ADD MEMBER' + @LoginName
	                   
	 EXEC (@DynamicSQL);

	 FETCH NEXT FROM Login_Cursor
	    INTO @LoginName;
     END;
CLOSE Login_Cursor;

DEALLOCATE Login_Cursor;


--6

GO
CREATE SCHEMA Admin;
GO

ALTER SCHEMA Admin TRANSFER dbo.Adresses;

ALTER USER RobertHalliday WITH DEFAULT_SCHEMA = Admin;

GRANT SELECT, UPDATE, INSERT,DELETE, EXECUTE
  ON SCHEMA :: Admin
TO RobertHalliday;