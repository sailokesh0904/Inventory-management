USE inventory_management;

CREATE TABLE Supplier (
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(255) NOT NULL,
    Supplier_Contact VARCHAR(50),
    Product_Supplied INT
);


CREATE TABLE Product (
    Product_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Name VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Price DECIMAL(10, 2),
    Stock_Quantity INT,
    Suppliers VARCHAR(255)
);


CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(255) NOT NULL,
    Customer_Address VARCHAR(255),
    Customer_Phone VARCHAR(15)
);


CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATETIME NOT NULL,
    Total_Amount BIGINT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);


CREATE TABLE Order_Line (
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);


CREATE TABLE Warehouse (
    Warehouse_ID INT AUTO_INCREMENT PRIMARY KEY,
    Warehouse_Name VARCHAR(255),
    Warehouse_Location VARCHAR(255),
    Warehouse_Manager INT
);


CREATE TABLE Inventory (
    Product_ID INT,
    Warehouse_ID INT,
    Quantity INT,
    PRIMARY KEY (Product_ID, Warehouse_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES Warehouse(Warehouse_ID)
);


CREATE TABLE Employee (
    Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    Employee_Name VARCHAR(255),
    Manager_ID INT
);


CREATE TABLE Shipment (
    Shipment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Shipment_Date DATE NOT NULL,
    Order_ID INT NOT NULL,
    Warehouse_ID INT NOT NULL,
    Shipment_Status ENUM('Pending', 'Shipped', 'Delivered'),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES Warehouse(Warehouse_ID)
);

