CREATE 	TABLE PRODUCT_T (
	PRODUCT_ID INTEGER primary key,
	PRODUCT_NAME VARCHAR(50),
	PRODUCT_FINISH VARCHAR(20),
	STANDARD_PRICE DECIMAL(6,2),
	PRODUCT_LINE_ID INTEGER,
CHECK (PRODUCT_FINISH IN ('Cherry', 'Natural Ash', 'White Ash', 'Red Oak', 'Natural Oak', 'Walnut'))
);

CREATE TABLE CUSTOMER_T (
	CUSTOMER_ID INTEGER primary key,
	CUSTOMER_NAME VARCHAR(30) NOT NULL,
	CUSTOMER_ADDRESS VARCHAR(50),
	CITY VARCHAR(20),
	STATE VARCHAR(2),
	ZIPCODE VARCHAR(10)
);

CREATE TABLE ORDER_T(
	ORDER_ID NUMERIC(4,0) primary key,
	ORDER_DATE DATETIME,
	CUSTOMER_ID INTEGER,
CONSTRAINT ORDER_T_FK FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER_T(CUSTOMER_ID)
);

CREATE TABLE ORDER_LINE_T (
	ORDER_ID NUMERIC(4,0) NOT NULL,
	PRODUCT_ID INTEGER NOT NULL,
	ORDER_QUANTITY NUMERIC(11,0),
CONSTRAINT ORDER_LINE_T_PK PRIMARY KEY (ORDER_ID, PRODUCT_ID),
CONSTRAINT ORDER_LINE_T_FK1 FOREIGN KEY (ORDER_ID) REFERENCES ORDER_T(ORDER_ID),
CONSTRAINT ORDER_LINE_T_FK2 FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT_T(PRODUCT_ID)
);


INSERT INTO PRODUCT_T VALUES(1, 'End Table', 'Cherry', 175, 1);
INSERT INTO PRODUCT_T VALUES(2, 'Coffee Table', 'Natural Ash', 200, 2);
INSERT INTO PRODUCT_T VALUES(3, 'Computer Desk', 'Natural Ash', 375, 2);
INSERT INTO PRODUCT_T VALUES(4, 'Entertainment Center', 'Natural Oak', 650, 3);
INSERT INTO PRODUCT_T VALUES(5, 'Writers Desk', 'Cherry', 325, 1);
INSERT INTO PRODUCT_T VALUES(6, '8-Drawer Desk', 'White Ash', 750, 2);
INSERT INTO PRODUCT_T VALUES(7, 'Dining Table', 'Natural Ash', 800, 2);
INSERT INTO PRODUCT_T VALUES(8, 'Computer Table', 'Walnut', 250, 3);


INSERT INTO CUSTOMER_T VALUES(1, 'Contemporary Casuals', '1355 S Hines Blvd', 'Gainesville', 'FL', '32601-2871');
INSERT INTO CUSTOMER_T VALUES(2, 'Value Furniture', '15145 s. W. 17th St.', 'Plano', 'TX', '75094-7743');
INSERT INTO CUSTOMER_T VALUES(3, 'Home Furnishings', '1900 Allard ave.', 'Albany', 'NY', '12209-1125');
INSERT INTO CUSTOMER_T VALUES(4, 'Eastern Furniture', '1925 Beltline Rd.', 'Carteret', 'NJ', '07008-3188');
INSERT INTO CUSTOMER_T VALUES(5, 'Impressions', '5585 Westcott Ct.', 'Sacramento', 'CA', '94206-4056');
INSERT INTO CUSTOMER_T VALUES(6, 'Furniture Gallery', '325 Flatiron Dr.', 'Boulder', 'CO', '80514-4432');
INSERT INTO CUSTOMER_T VALUES(7, 'Period Furniture', '394 Rainbow Dr.', 'Seattle', 'WA', '97954-5589');
INSERT INTO CUSTOMER_T VALUES(8, 'Calfornia Classics', '816 Peach Rd.', 'Santa Clara', 'CA', '96915-7754');
INSERT INTO CUSTOMER_T VALUES(9, 'Syracuse Furniture', '720 Jamesville Rd.', 'Syracuse', 'NY', '13244-2444');


INSERT INTO ORDER_T VALUES(1001, '2008-10-21', 1);
INSERT INTO ORDER_T VALUES(1002, '2008-10-21', 8);
INSERT INTO ORDER_T VALUES(1003, '2008-10-22', 7);
INSERT INTO ORDER_T VALUES(1004, '2008-10-22', 5);
INSERT INTO ORDER_T VALUES(1005, '2008-10-24', 3);
INSERT INTO ORDER_T VALUES(1006, '2008-10-24', 2);
INSERT INTO ORDER_T VALUES(1007, '2008-10-27', 6);
INSERT INTO ORDER_T VALUES(1008, '2008-10-30', 5);
INSERT INTO ORDER_T VALUES(1009, '2008-11-05', 4);
INSERT INTO ORDER_T VALUES(1010, '2008-11-05', 1);

INSERT INTO ORDER_LINE_T VALUES(1001, 1, 2);
INSERT INTO ORDER_LINE_T VALUES(1001, 2, 2);
INSERT INTO ORDER_LINE_T VALUES(1001, 4, 1);
INSERT INTO ORDER_LINE_T VALUES(1002, 3, 5);
INSERT INTO ORDER_LINE_T VALUES(1003, 3, 3);
INSERT INTO ORDER_LINE_T VALUES(1004, 6, 2);
INSERT INTO ORDER_LINE_T VALUES(1004, 8, 2);
INSERT INTO ORDER_LINE_T VALUES(1005, 4, 4);
INSERT INTO ORDER_LINE_T VALUES(1006, 4, 1);
INSERT INTO ORDER_LINE_T VALUES(1006, 5, 2);
INSERT INTO ORDER_LINE_T VALUES(1006, 7, 1);
INSERT INTO ORDER_LINE_T VALUES(1007, 1, 3);
INSERT INTO ORDER_LINE_T VALUES(1007, 2, 2);
INSERT INTO ORDER_LINE_T VALUES(1008, 3, 3);
INSERT INTO ORDER_LINE_T VALUES(1008, 8, 3);
INSERT INTO ORDER_LINE_T VALUES(1009, 4, 2);
INSERT INTO ORDER_LINE_T VALUES(1009, 7, 3);
INSERT INTO ORDER_LINE_T VALUES(1010, 8, 10);



SELECT SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY)
FROM ORDER_LINE_T ol
INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_ID
WHERE ol.ORDER_ID = 1001;

/*SCALAR FUNCTION*/
/*call the scalar function*/
CREATE FUNCTION one_order_balance(@orderID INT) 
RETURNS DECIMAL(10,1)
AS BEGIN
	DECLARE @ret INT;
	SELECT @ret=SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY)
	FROM ORDER_LINE_T ol
	INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_id
	WHERE ol.ORDER_ID=@orderID
	RETURN @ret;
END;

/*call the scaler function*/
SELECT dbo.one_order_balance(1001) AS 'Balance';
/*drop the scaler function*/
DROP FUNCTION dbo.one_order_balance;

/*the total balances of all orders*/
SELECT ol.ORDER_ID, SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY) AS 'Total Price'
FROM ORDER_LINE_T ol
INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_ID
GROUP BY ol.ORDER_ID

/*Valued Functions (No Input*/
CREATE FUNCTION all_order_balance()
RETURNS TABLE
AS
RETURN
(SELECT ol.ORDER_ID, SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY) AS 'Total Price'
FROM ORDER_LINE_T ol
INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_ID
GROUP BY ol.ORDER_ID)

/*call the function*/
SELECT * FROM dbo.all_order_balance();

/*the orders brought in revenue over $1000*/
SELECT ol.ORDER_ID, SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY) AS 'Total Price'
FROM ORDER_LINE_T ol
INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_ID
GROUP BY ol.ORDER_ID
HAVING SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY)>1000

/*it takes one input, and returns a table*/
CREATE FUNCTION selected_order_balance (@threshold INT)
RETURNS TABLE
AS
RETURN
(SELECT ol.ORDER_ID, SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY) AS 'Total Price'
FROM ORDER_LINE_T ol
INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_ID
GROUP BY ol.ORDER_ID
HAVING SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY)> @threshold
)

/*Call the function with threshold*/

/*each customer wants to know his/her own balance*/
ALTER TABLE CUSTOMER_T ADD balance DECIMAL (6,2);
CREATE PROCEDURE one_customer_order_total_price (@customerID INTEGER)
AS
BEGIN
	UPDATE CUSTOMER_T
	SET balance = balanceCount.balance
	FROM
	(SELECT o.CUSTOMER_ID, SUM(ol.ORDER_QUANTITY*p.STANDARD_PRICE) 'balance'
	FROM ORDER_T o
	INNER JOIN ORDER_LINE_T ol
	ON o.ORDER_ID = ol.ORDER_ID
	INNER JOIN  PRODUCT_T p
	ON ol.PRODUCT_ID=p.PRODUCT_ID
	GROUP BY o.CUSTOMER_ID) AS balanceCount
	WHERE CUSTOMER_T.CUSTOMER_ID = @customerID
		AND balanceCount.CUSTOMER_ID= @customerID
	END;
	/*calling procedure without input*/
	EXEC one_customer_order_total_price 2;

	/*UPDATE ALL CUSTOMERS' BALANCE WITHOUT TAKING ANY INPUT PARAMETER*/
CREATE PROCEDURE customer_order_total_price
AS
BEGIN
	UPDATE CUSTOMER_T
	SET balance = balanceCount.balance
	FROM
	(SELECT o.CUSTOMER_ID, SUM(ol.ORDER_QUANTITY*p.STANDARD_PRICE) 'balance'
	FROM ORDER_T o
	INNER JOIN ORDER_LINE_T ol
	ON o.ORDER_ID = ol.ORDER_ID
	INNER JOIN  PRODUCT_T p
	ON ol.PRODUCT_ID=p.PRODUCT_ID
	GROUP BY o.CUSTOMER_ID) AS balanceCount
	WHERE CUSTOMER_T.CUSTOMER_ID = balanceCount.Customer_id
	END;
/*Calling procedure without input*/
EXEC customer_order_total_price;

/*a scaler function that returns the number of distinct products given an orderID*/
CREATE FUNCTION one_order_product(@productNo INT) 
RETURNS DECIMAL(10,1)
AS BEGIN
	DECLARE @ret INT;
	SELECT @ret=SUM(p.STANDARD_PRICE*ol.ORDER_QUANTITY)
	FROM ORDER_LINE_T ol
	INNER JOIN PRODUCT_T p ON ol.PRODUCT_ID = p.PRODUCT_id
	WHERE ol.ORDER_ID=@orderID
	RETURN @ret;
END;

/*trigger1: automatically update customers' balance after order information is modified*/
CREATE TRIGGER updateOrderlineTrigger
ON ORDER_LINE_T
FOR INSERT, UPDATE
AS
IF @@ROWCOUNT >=1 /*holds the number of records changed by the last SQL statement executed*/
BEGIN
	UPDATE CUSTOMER_T
	SET balance = balanceCount.balance
	FROM 
	(SELECT o.CUSTOMER_ID, SUM(ol.ORDER_QUANTITY*p.STANDARD_PRICE) 'balance'
	FROM ORDER_T o
	INNER JOIN ORDER_LINE_T ol
		ON o.ORDER_ID = ol.ORDER_ID
	INNER JOIN PRODUCT_T p
		ON ol.PRODUCT_ID = p.PRODUCT_ID
		GROUP BY o.CUSTOMER_ID ) AS balanceCount
	WHERE CUSTOMER_T.CUSTOMER_ID = balanceCount.Customer_ID
END;	



/*trigger 2*/
CREATE TRIGGER updateOrderlineTrigger
ON ORDER_LINE_T
FOR INSERT, UPDATE
AS
IF @@ROWCOUNT >=1
BEGIN
	UPDATE CUSTOMER_T
	SET balance = balanceCount.balance
	FROM 
	(SELECT o.CUSTOMER_ID, SUM(ol.ORDER_QUANTITY*p.STANDARD_PRICE) 'balance'
	FROM ORDER_T o
	INNER JOIN ORDER_LINE_T ol
		ON o.ORDER_ID = ol.ORDER_ID
	INNER JOIN PRODUCT_T p
		ON ol.PRODUCT_ID = p.PRODUCT_ID
		GROUP BY o.CUSTOMER_ID ) AS balanceCount, inserted, ORDER_T
	WHERE CUSTOMER_T.CUSTOMER_ID = balanceCount.Customer_ID AND inserted.ORDER_ID=order_T.ORDER_ID
	AND order_T.CUSTOMER_ID=customer_T.customer_ID
END;	

UPDATE 
