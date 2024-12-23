DELIMITER $$

CREATE PROCEDURE AddProduct(
    IN ProductName VARCHAR(255),
    IN Category VARCHAR(100),
    IN Price DECIMAL(10, 2),
    IN StockQuantity INT,
    IN Suppliers VARCHAR(255)
)
BEGIN
    INSERT INTO Product (Product_Name, Category, Price, Stock_Quantity, Suppliers)
    VALUES (ProductName, Category, Price, StockQuantity, Suppliers);
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE AddCustomer(
    IN CustomerID INT,
    IN CustomerName VARCHAR(255),
    IN CustomerAddress VARCHAR(255),
    IN CustomerPhone VARCHAR(15)
)
BEGIN
    INSERT INTO Customer (Customer_ID, Customer_Name, Customer_Address, Customer_Phone)
    VALUES (CustomerID, CustomerName, CustomerAddress, CustomerPhone);
END $$

DELIMITER ;






DELIMITER $$

CREATE PROCEDURE ProcessOrder(
    IN CustomerID INT,
    IN OrderDate DATETIME,
    IN TotalAmount DECIMAL(10, 2),
    IN ProductID INT,
    IN Quantity INT
)
BEGIN
    
    INSERT INTO Orders (Customer_ID, Order_Date, Total_Amount)
    VALUES (CustomerID, OrderDate, TotalAmount);

    
    SET @OrderID = LAST_INSERT_ID();


    INSERT INTO Order_Line (Order_ID, Product_ID, Quantity, Price)
    VALUES (@OrderID, ProductID, Quantity, (SELECT Price FROM Product WHERE Product_ID = ProductID));


    UPDATE Product
    SET Stock_Quantity = Stock_Quantity - Quantity
    WHERE Product_ID = ProductID;


    IF (SELECT Stock_Quantity FROM Product WHERE Product_ID = ProductID) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for the product.';
    END IF;
END $$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER AfterShipmentUpdate
AFTER UPDATE ON Shipment
FOR EACH ROW
BEGIN
    IF NEW.Shipment_Status = 'Shipped' THEN
        UPDATE Inventory
        SET Quantity = Quantity - (SELECT SUM(Order_Line.Quantity)
                                   FROM Order_Line
                                   WHERE Order_Line.Order_ID = NEW.Order_ID)
        WHERE Product_ID IN (SELECT Product_ID FROM Order_Line WHERE Order_ID = NEW.Order_ID)
          AND Warehouse_ID = NEW.Warehouse_ID;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER BeforeOrderInsert
BEFORE INSERT ON Order_Line
FOR EACH ROW
BEGIN
    IF (SELECT Stock_Quantity FROM Product WHERE Product_ID = NEW.Product_ID) < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this product.';
    END IF;
END $$

DELIMITER ;

