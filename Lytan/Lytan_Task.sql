--Restore Database from 'LytAN.bak' in 'src' folder
USE LytAN_GameShop
--------------------------------------------
			--TASK 1--
--Add new column on MsCustomer table named CustomerEmail with varchar(50)data type and validate that CustomerEmail must be contains ‘@’ and ends with ‘.com’.
--------------------------------------------
GO
--add new column
ALTER TABLE MsCustomer
ADD CustomerEmail VARCHAR(50)

GO
--validate CustomerEmail
ALTER TABLE MsCustomer
ADD CONSTRAINT emailConstarint CHECK (CustomerEmail LIKE '%@%.com')
--------------------------------------------
			--TASK 2--
--Display CustomerName, CustomerPhone, and CustomerGender for every Customer whose  name contains letter  'a' and Female.
--------------------------------------------
GO
SELECT
    CustomerName,
    CustomerAddress,
    CustomerGender
FROM
	MsCustomer
WHERE 
	CustomerName LIKE '%a%' AND --to filter that contain a
	CustomerGender LIKE 'Female' --to filter that customer gender is female
--------------------------------------------
			--TASK 3--
--Insert following data into MsCustomer table;
	--CustomerID = CU011
	--CustomerName = Maria
	--CustomerGender = Female
	--CustomerAddress = Kembangan Street
	--CustomerPhone = 081235473829
	--CustomerEmail = maria11@gmail.com
--------------------------------------------
GO
INSERT INTO MsCustomer(CustomerID, CustomerName, CustomerGender, CustomerAddress, CustomerPhone, CustomerEmail)
VALUES ('CU011','Maria','Female','Kembangan Street','081235473829','maria11@gmail.com') --to insert data to table

GO
SELECT*FROM MsCustomer --to view all data from MsCustomer table
--------------------------------------------
			--TASK 4--
---	Delete Agent data on MsAgent table for all Agent who has done transaction in the June.
--------------------------------------------
BEGIN TRAN --to begin transaction, so that can be rollback(turn back the data before transcation) or commit(to submit the transaction)

DELETE 
	MsAgent
FROM 
	MsAgent ma, 
	HeaderTransaction ht
WHERE 
	ht.AgentID = ma.AgentID AND   -- join 2 table that MsAgent and headertransaction with the agentID
	MONTH(ht.TransactionDate) = 6 --filiter that transaction in June

--ROLLBACK --to rollback uncomment this line
--COMMIT --to commit uncomment this line