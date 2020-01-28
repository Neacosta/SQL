DECLARE @NewCustomers XML;
SET @NewCustomers = '
<NewCustomers>
   <Customer EmailAddress="izzychan@yahoo.com" Password="" FirstName="Isabella" LastName="Chan"/>
   <Customer EmailAddress="johnprine@gmail.com" Password="" FirstName="John" LastName="Prine" />
   <Customer EmailAdress="kathykitchen@sbcglobal.net" Password="" FirstName="Kathy" LastName="Kitchen" />
</NewCustomers>
'
;

INSERT Customers(EmailAddress, Password, FirstName, LastName)
VALUES
(
   @NewCustomers.value('(/NewCustomers/Customer/@EmailAddress)[1]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@Password)[1]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@FirstName)[1]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@LastName)[1]', 'varchar(50)')
),
(
   @NewCustomers.value('(/NewCustomers/Customer/@EmailAddress)[2]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@Password)[2]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@FirstName)[2]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@LastName)[2]', 'varchar(50)')
),

(
   @NewCustomers.value('(/NewCustomers/Customer/@EmailAddress)[3]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@Password)[3]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@FirstName)[3]', 'varchar(50)'),
   @NewCustomers.value('(/NewCustomers/Customer/@LastName)[3]', 'varchar(50)')
);
--Clean up
--DELETE FROM Customers WHERE CustomerID >8;

--2

DECLARE @NewCustomers XML;
SET @NewCustomers = '
<NewCustomers>
   <Customer EmailAddress="izzychan@yahoo.com" Password="" FirstName="Isabella" LastName="Chan"/>
   <Customer EmailAddress="johnprine@gmail.com" Password="" FirstName="John" LastName="Prine" />
   <Customer EmailAdress="kathykitchen@sbcglobal.net" Password="" FirstName="Kathy" LastName="Kitchen" />
</NewCustomers>
'
;
DECLARE @NewCustomersHandle int;

EXEC sp_Xml_PrepareDocument @NewCustomersHandle OUTPUT, @NewCustomers;

SELECT *
FROM OPENXML (@NewCustomersHandle, '/NewCustomers/Customer')
WITH
(
   EmailAddress    VARCHAR(50)     '@EmailAddress',
   Password        VARCHAR(50)     '@Password',
   FirstName       VARCHAR(50)     'FirstName',
   LastName        VARCHAR(50)     'LastName'
   
);

EXEC sp_Xml_RemoveDocument @NewCustomerHandle;

--3
IF EXISTS (SELECT DB_ID('ProductDescriptions'))
DROP TABLE ProductDescriptions;
GO

CREATE TABLE ProductDescriptions
(
   DescriptionsID int NOT NULL IDENTITY PRIMARY KEY,
   ProductID int NOT NULL UNIQUE,
   Description xml NOT NULL
);

DECLARE @DescriptionXML xml;
SET @Description = '
<div>
   <h1>Tradition Redesigned</h1>
   <p>The Fender Stratocaster Electric Guitar is a Fender icon. Upgrades include a richer, deeper neck
   int for a more elegant and expensive apperance; glossed neck front for improved looks with satin back for smooth
   playability; saddle height screws are resixed to reduce eough feel, and string slot on saddle is elongated to reduce
   string friction or breakage.</p>

   <p> The return of the American Standard  Series Strat continues Fender''s tradition of commitment to the people who
   play Fender instruments out there in the real word. Today''s American Standard Stratocaste guitars are 
   worthy heirs of their revered ancestors-mindful of player needs and taking full advantage of modern advances,
   yet remaining complety true to the elements and spirit that made these instruments popular in the first place.
   Improvements include redesigned bridges, neck and body finishes, and a fender-exclusive high-tech molded case.
   still on board for the American Standard Strat are the beloved hand-rolled fingerboard edges, Alnico V pickups, the 
   Delta system that includes a high-output bridge pickup and a special no-load tone control, providing more gain,
   more high end, and a little more "raw" tone, and staggered tuning machines for tone and stability guarantee to
   last a lifetime (with its limited lifetime warranty)!</p>

   <h2> Redesigned American Standard Strat bridge</h2>
   <p> Gives sought-after tone with modern smooth trem travel. Block retains the mass and tone of a vintage bridge block,
       but is chamfered for access to deeper dives. Saddles have the classic look and tone, but with modern improvents
	   (spacing, slot elongation, height, screw length).</p>
	<h3>Features</h3>
	<ul>
	   <li> Solid alder body(urethane finish)</li>
	   <li>3 hot American Strat single-coil pickups</li>
	   <li> Rosewood or maple fretboard</li>
	   <li> Fende SKB hardshell case, cable, strap, and polishing cloth</li>
	   </ul>
</div>
'
;



