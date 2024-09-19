CREATE TABLE Cafe
(
    Cafe_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255),
    Address VARCHAR(255),
    Contact_Number VARCHAR(50),
    Email VARCHAR(255)
);

CREATE TABLE Users
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(256),
    contact_num VARCHAR(256),
    email VARCHAR(256),
    password VARCHAR(256),
    role VARCHAR(256),
	cafe_id integer foreign key references Cafe(Cafe_ID)
);

CREATE TABLE Administrator
(
    Admin_ID INT PRIMARY KEY,
    Salary DECIMAL(10, 2),
	FOREIGN KEY (Admin_ID) REFERENCES Users(id)
);

CREATE TABLE Cashier
(
    Cashier_ID INT PRIMARY KEY,
    Salary decimal(10, 2),
	FOREIGN KEY (Cashier_ID) REFERENCES Users(id)
);

CREATE TABLE Customer
(
    Customer_ID INT PRIMARY KEY,
	FOREIGN KEY (Customer_ID) REFERENCES Users(id)
);

CREATE TABLE Inventory
(
    Inventory_ID INT PRIMARY KEY IDENTITY(1,1),
	inventory_Name varchar(256),
    Admin_ID INT FOREIGN KEY REFERENCES Administrator(Admin_ID)
);

CREATE TABLE Menu
(
    Menu_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255),
    Cafe_ID INT FOREIGN KEY REFERENCES Cafe(Cafe_ID)
);

CREATE TABLE Products
(
    Product_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255),
    price real,
    Inventory_ID INT FOREIGN KEY REFERENCES Inventory(Inventory_ID),
    menu_id INT FOREIGN KEY REFERENCES Menu(menu_id),
    Stock INT
);

CREATE TABLE Supplier
(
    Supplier_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255),
    Contact_Number VARCHAR(50),
    product_id INT FOREIGN KEY REFERENCES Products(Product_ID)
);

CREATE TABLE Orders
(
    Order_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customer(Customer_ID),
    Cashier_ID INT FOREIGN KEY REFERENCES Cashier(Cashier_ID),
	Product_ID INT FOREIGN KEY REFERENCES Products(Product_ID),
	Quantity INT,
	Order_Date DATE,
	Order_time time,
	Amount DECIMAL(10, 2)
);
CREATE TABLE Online_Orders
(
    Online_Order_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customer(Customer_ID),
	Product_ID INT FOREIGN KEY REFERENCES Products(Product_ID),
	Quantity INT,
	Order_Date DATE,
	Order_time time,
	Amount DECIMAL(10, 2)
);
-- Creating the Feedback table
CREATE TABLE Feedback
(
    Feedback_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customer(Customer_ID),
    Feedback_Text VARCHAR(MAX),
    Feedback_Date DATE
);

-- Trigger
CREATE TRIGGER SetMenuIDToNullOnMenuDelete
ON Menu
instead of DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedMenuID INT;
    SELECT @DeletedMenuID = Menu_ID FROM DELETED;

    UPDATE Products
    SET menu_id = NULL
    WHERE menu_id = @DeletedMenuID;

	delete from Menu where Menu_ID=@DeletedMenuID;
END;

--trigger
CREATE TRIGGER SetCustomerIDToNullOnCustomerDelete
ON Customer
instead of DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedCustomerID INT;
    SELECT @DeletedCustomerID = Customer_ID FROM DELETED;

    UPDATE Feedback
    SET Customer_ID = NULL
    WHERE Customer_ID = @DeletedCustomerID;
	UPDATE Orders
	SET Customer_ID = NULL
    WHERE Customer_ID = @DeletedCustomerID;
	delete from Customer where Customer_ID=@DeletedCustomerID;
END;

--trigger
CREATE TRIGGER SetProductIDToNullOnProductDelete
ON Products
instead of DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedProductID INT;
    SELECT @DeletedProductID = Product_ID FROM DELETED;

    UPDATE Orders
    SET Product_ID = NULL
    WHERE Product_ID = @DeletedProductID;
	UPDATE Supplier
	SET Product_ID = NULL
    WHERE Product_ID = @DeletedProductID;

	delete from Products where Product_ID=@DeletedProductID;
END;

-------
select * from Users;
select * from Customer;
select * from Cashier;
select * from Menu;
select * from Supplier;
select * from Products;
select * from Inventory;
select * from Administrator;
select * from Orders;
select * from Online_Orders;



insert into Cafe(Name,Email,Contact_Number,Address) values ('FASTCAFE','fastcafe@nu.edu.pk','12345','Islamabad');

insert into Users(name,contact_num,email,password,role,cafe_id) values('admin','123456789','admin','12345678','Administrator','1');


drop table Orders;
drop table Products;
drop table menu;
drop table Cashier;
drop table Customer;
drop table Inventory;
drop table Administrator;
drop table supplier;
drop table Order_Details;
drop table Users;
drop table Payment;
drop table Feedback;
drop table Cafe;

