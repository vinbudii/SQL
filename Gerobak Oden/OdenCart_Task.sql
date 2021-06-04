--Execute 'create+insert.sql' 
USE gerobak_oden

---------------------
	--Task 1--
--Display First Name (obtained from the first word of CustomerName), OdenName, OdenTopping for every transaction which oden price is higher than average of all oden price. 
---------------------
SELECT 
	[First Name] = LEFT(Customername, CHARINDEX(' ', Customername)),
	OdenName,
	OdenTopping
FROM MsCustomer mc 
	JOIN TrHeaderTransaction th ON mc.CustomerId = th.CustomerId 
	JOIN TrDetailTransaction td ON td.TransactionId = th.TransactionId 
	JOIN MsOden mo ON mo.OdenId = td.OdenId,
		(SELECT Average = AVG(OdenPrice) FROM MsOden) AS abc
WHERE 
	mo.OdenId IN (
		SELECT 
			OdenId
		FROM
			MsOden
		WHERE
			OdenPrice > abc.Average
	)
ORDER BY [First Name]

---------------------
	--Task 2--
--Add a column named StaffEmail on Staff table with varchar (200) data type and add a constraint named ‘CheckEmail’ to check the StaffEmail must be contains ‘@’. 
---------------------
BEGIN TRAN
ALTER TABLE MsStaff
ADD StaffEmail VARCHAR(200)
GO
ALTER TABLE MsStaff
ADD CONSTRAINT CheckEmail CHECK(CHARINDEX('@',StaffEmail)!=0 AND StaffEmail LIKE '%@%')
--ROLLBACK
COMMIT

---------------------
	--Task 3--
--Create a view named ‘HighestSoldOden’ to display OdenName, Total Price (obtained from total of quantity multiplied by oden price) for every transaction which oden name starts with 'A' or 'D' letters.  
---------------------
CREATE VIEW [HighestSoldOden]
AS
	SELECT
		o.OdenName,
		[Total Price] = 'Rp. '+CAST(SUM(td.Quantity *o.OdenPrice) AS VARCHAR) 
	FROM
		MsOden o, TrDetailTransaction td
	WHERE
		o.OdenId = td.OdenId AND
		LEFT(o.OdenName,1) IN ('A','D')
	GROUP BY o.OdenName
	ORDER BY o.OdenName DESC

---------------------
	--Task 4--
--Display Date, CustomerId, Total Type Oden (obtained from the total number of oden), and Total Price (obtained by adding ‘Rp.’ in front of the total of oden price) for every transaction occurred in August. Then, combine it with Date, CustomerId, Total Type Oden (obtained from the total number of oden), and Total Price (obtained by adding 'Rp.' in front of total of oden price) for every transaction which occurs in September. 
---------------------
SELECT Date,
		CustomerId,
		[Total Type Oden] = COUNT(mo.OdenId),
		[Total Price] = 'Rp.' + CAST(SUM(OdenPrice)AS VARCHAR)
FROM TrHeaderTransaction ht JOIN TrDetailTransaction dt ON
		ht.TransactionId = dt.TransactionId JOIN MsOden mo ON
		mo.OdenId = dt.OdenId
WHERE MONTH(Date) = 8
GROUP BY Date, CustomerId

UNION

SELECT Date,
		CustomerId,
		[Total Type Oden] = COUNT(mo.OdenId),
		[Total Price] = 'Rp.' + CAST(SUM(OdenPrice)AS VARCHAR)
FROM TrHeaderTransaction ht JOIN TrDetailTransaction dt ON
		ht.TransactionId = dt.TransactionId JOIN MsOden mo ON
		mo.OdenId = dt.OdenId
WHERE MONTH(Date) = 9
GROUP BY Date, CustomerId

---------------------
	--Task 5--
--Display TransactionId, Total Quantity (obtained from the total of quantity), and Date (obtained from Date in ‘Mon dd, yyyy’ format) for every customer whose id is ‘CU002’. 
---------------------
SELECT
	th.TransactionId,
	[Total Quantity] = SUM(td.Quantity),
	[Date] = CONVERT(VARCHAR,th.Date,107)
FROM
	TrHeaderTransaction th
	JOIN TrDetailTransaction td ON th.TransactionId = td.TransactionId
WHERE
	th.CustomerId LIKE 'CU002'
GROUP BY th.TransactionId,th.Date