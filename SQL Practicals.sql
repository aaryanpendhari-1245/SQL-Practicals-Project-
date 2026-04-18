-- SQL ADVANCED PORTFOLIO PROJECT
-- Section 1: Advanced Employee Analytics
-- Sample table creation
CREATE TABLE EmployeeSales (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    SaleAmount DECIMAL(10,2),
    SaleDate DATE
);

-- Sample data insertion
INSERT INTO EmployeeSales VALUES
(1, 'Alice', 'Electronics', 500.00, '2026-04-01'),
(2, 'Bob', 'Electronics', 300.00, '2026-04-02'),
(3, 'Charlie', 'Clothing', 200.00, '2026-04-01'),
(1, 'Alice', 'Electronics', 700.00, '2026-04-03'),
(2, 'Bob', 'Electronics', 400.00, '2026-04-04'),
(3, 'Charlie', 'Clothing', 350.00, '2026-04-02');

SELECT 
    EmployeeName,
    Department,
    SaleAmount,
    RANK() OVER (PARTITION BY Department ORDER BY SaleAmount DESC) AS RankInDept
FROM EmployeeSales;

SELECT 
    EmployeeName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (
        PARTITION BY EmployeeName 
        ORDER BY SaleDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM EmployeeSales;

SELECT 
    EmployeeName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (
        PARTITION BY EmployeeName 
        ORDER BY SaleDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS MovingAvg7Days
FROM EmployeeSales;

CREATE TABLE monthly_report (
    month VARCHAR(20) NOT NULL,   -- e.g., 'January', 'Feb 2026'
    sales DECIMAL(12,2) NOT NULL  -- numeric value with 2 decimal places
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept VARCHAR(30),
    salary DECIMAL(10,2)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);


-- Step 1: Create the EMPLOYEE table
CREATE TABLE EMPLOYEE (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(30),
    Salary DECIMAL(10,2)
);

-- Step 2: Insert sample data
INSERT INTO EMPLOYEE (EmpID, Name, Department, Salary) VALUES
(101, 'Alice', 'HR', 50000),
(102, 'Bob', 'HR', 40000),
(103, 'Carol', 'IT', 70000),
(104, 'Dave', 'IT', 60000),
(105, 'Eve', 'Finance', 55000),
(106, 'Frank', 'Finance', 65000),
(107, 'Grace', 'Marketing', 45000),
(108, 'Hank', 'Marketing', 48000);

-- Step 3: Run your window function query
SELECT 
    EmpID, 
    Name, 
    Department, 
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromAvg
FROM EMPLOYEE;

SELECT EmpID, Name, Department, Salary,
       ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RowNum
FROM EMPLOYEE;

SELECT EmpID, Name, Department, Salary,
       RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RankNum
FROM EMPLOYEE;

SELECT EmpID, Name, Department, Salary,
       DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DenseRankNum
FROM EMPLOYEE;


--Section 2: IPL Database (Sports)
-- Create IPL database
CREATE DATABASE IPL;

-- Switch to IPL database
USE IPL;

-- Players table
CREATE TABLE Players (
    PlayerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Team VARCHAR(30),
    Runs INT,
    Wickets INT
);

-- Matches table
CREATE TABLE Matches (
    MatchID INT PRIMARY KEY,
    Team1 VARCHAR(30),
    Team2 VARCHAR(30),
    Winner VARCHAR(30),
    Venue VARCHAR(50),
    MatchDate DATE
);

-- Performance table
CREATE TABLE Performance (
    PerfID INT PRIMARY KEY,
    MatchID INT,
    PlayerID INT,
    Runs INT,
    Wickets INT,
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);

-- Players
INSERT INTO Players VALUES
(1, 'Virat Kohli', 'RCB', 75, 0),
(2, 'MS Dhoni', 'CSK', 40, 0),
(3, 'Rohit Sharma', 'MI', 60, 0),
(4, 'Jasprit Bumrah', 'MI', 10, 3),
(5, 'Andre Russell', 'KKR', 30, 2);

-- Matches
INSERT INTO Matches VALUES
(101, 'RCB', 'CSK', 'RCB', 'Bangalore', '2026-04-10'),
(102, 'MI', 'KKR', 'MI', 'Mumbai', '2026-04-11');

-- Performance
INSERT INTO Performance VALUES
(201, 101, 1, 75, 0),
(202, 101, 2, 40, 0),
(203, 102, 3, 60, 0),
(204, 102, 4, 10, 3),
(205, 102, 5, 30, 2);

SELECT PlayerID, Name, Team, Runs,
       ROW_NUMBER() OVER (ORDER BY Runs DESC) AS RowNum
FROM Players;

SELECT PlayerID, Name, Team, Runs,
       RANK() OVER (ORDER BY Runs DESC) AS RankNum
FROM Players;

SELECT PlayerID, Name, Team, Runs,
       DENSE_RANK() OVER (ORDER BY Runs DESC) AS DenseRankNum
FROM Players;


-- Section 3: Stock Market (ZerodhaDB)
-- Create Zerodha database
CREATE DATABASE ZerodhaDB;

-- Switch to ZerodhaDB
USE ZerodhaDB;

-- Trades table
CREATE TABLE Trades (
    TradeID INT PRIMARY KEY,
    TradeDate DATE NOT NULL,
    StockSymbol VARCHAR(10) NOT NULL,
    OpenPrice DECIMAL(10,2),
    ClosePrice DECIMAL(10,2),
    Volume INT
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    TradeDate DATE NOT NULL,
    StockSymbol VARCHAR(10) NOT NULL,
    OrderType VARCHAR(10), -- BUY or SELL
    Quantity INT,
    Price DECIMAL(10,2)
);

-- Trades data
INSERT INTO Trades VALUES
(1, '2026-04-10', 'INFY', 1450.00, 1475.00, 120000),
(2, '2026-04-11', 'INFY', 1475.00, 1460.00, 95000),
(3, '2026-04-12', 'INFY', 1460.00, 1480.00, 110000),
(4, '2026-04-13', 'INFY', 1480.00, 1490.00, 130000),
(5, '2026-04-14', 'INFY', 1490.00, 1505.00, 125000);

-- Orders data
INSERT INTO Orders VALUES
(101, '2026-04-10', 'INFY', 'BUY', 50, 1450.00),
(102, '2026-04-11', 'INFY', 'SELL', 30, 1470.00),
(103, '2026-04-12', 'INFY', 'BUY', 40, 1465.00),
(104, '2026-04-13', 'INFY', 'SELL', 20, 1485.00),
(105, '2026-04-14', 'INFY', 'BUY', 60, 1495.00);

SELECT TradeDate, StockSymbol, ClosePrice,
       LAG(ClosePrice) OVER (ORDER BY TradeDate) AS PrevDayClose
FROM Trades
WHERE StockSymbol = 'INFY';

SELECT TradeDate, StockSymbol, ClosePrice,
       LEAD(ClosePrice) OVER (ORDER BY TradeDate) AS NextDayClose
FROM Trades
WHERE StockSymbol = 'INFY';

SELECT TradeDate, StockSymbol, ClosePrice,
       ClosePrice - LAG(ClosePrice) OVER (ORDER BY TradeDate) AS DayChange
FROM Trades
WHERE StockSymbol = 'INFY';

-- Section 4: Retail Database
-- Create new database
CREATE DATABASE RetailDB;

-- Switch to RetailDB
USE RetailDB;

-- Customer table
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(50),
    City VARCHAR(30)
);

-- Orders table
CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

-- Section 5: Banking System
-- Payments table
CREATE TABLE PAYMENTS (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    PaymentMode VARCHAR(20),
    Amount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES ORDERS(OrderID)
);

-- Customers
INSERT INTO CUSTOMER VALUES
(1, 'Aaryan Pendhari', '9876543210', 'aaryan@example.com', 'Mumbai'),
(2, 'Neha Sharma', '9123456780', 'neha@example.com', 'Delhi'),
(3, 'Ravi Kumar', '9988776655', 'ravi@example.com', 'Bangalore');

-- Orders
INSERT INTO ORDERS VALUES
(101, 1, '2026-04-10', 5000.00),
(102, 2, '2026-04-11', 3000.00),
(103, 3, '2026-04-12', 4500.00);

-- Payments
INSERT INTO PAYMENTS VALUES
(201, 101, '2026-04-10', 'UPI', 5000.00),
(202, 102, '2026-04-11', 'Credit Card', 3000.00),
(203, 103, '2026-04-12', 'Net Banking', 4500.00);

CREATE VIEW CUSTOMER_PUBLIC AS
SELECT CustomerID, Name, Phone, Email, City
FROM CUSTOMER;

SELECT * FROM CUSTOMER_PUBLIC;

CREATE DATABASE MyNewDB;

-- Switch to the new database
USE MyNewDB;

-- Customer table
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(50),
    City VARCHAR(30)
);

-- Account table
CREATE TABLE ACCOUNT (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20), -- e.g., Savings, Current
    Balance DECIMAL(12,2),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

-- Transaction table
CREATE TABLE TRANSACTION (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    Amount DECIMAL(12,2),
    TransactionType VARCHAR(10), -- e.g., Debit, Credit
    FOREIGN KEY (AccountID) REFERENCES ACCOUNT(AccountID)
);
-- Customers
INSERT INTO CUSTOMER VALUES
(1, 'Aaryan Pendhari', '9876543210', 'aaryan@example.com', 'Mumbai'),
(2, 'Neha Sharma', '9123456780', 'neha@example.com', 'Delhi');

-- Accounts
INSERT INTO ACCOUNT VALUES
(101, 1, 'Savings', 50000.00),
(102, 2, 'Current', 75000.00);

-- Transactions
INSERT INTO TRANSACTION VALUES
(1001, 101, '2026-04-10', 5000.00, 'Debit'),
(1002, 101, '2026-04-11', 2000.00, 'Credit'),
(1003, 102, '2026-04-12', 10000.00, 'Debit');

SELECT c.Name, a.AccountType, a.Balance
FROM CUSTOMER c
JOIN ACCOUNT a ON c.CustomerID = a.CustomerID;

SELECT t.TransactionID, c.Name, t.TransactionDate, t.Amount, t.TransactionType
FROM TRANSACTION t
JOIN ACCOUNT a ON t.AccountID = a.AccountID
JOIN CUSTOMER c ON a.CustomerID = c.CustomerID;


-- Section 6: LIC Housing Finance
CREATE DATABASE LIC_HousingFinance;
USE LIC_HousingFinance;

-- Customer table
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(50),
    City VARCHAR(30)
);

-- Loan table
CREATE TABLE LOAN (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    Principal DECIMAL(18,2),
    AnnualRate DECIMAL(5,2),
    TenureMonths INT,
    StartDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

-- Payment table (for amortization schedule)
CREATE TABLE PAYMENT (
    PaymentID INT PRIMARY KEY,
    LoanID INT,
    PaymentDate DATE,
    EMIAmount DECIMAL(18,2),
    PrincipalComponent DECIMAL(18,2),
    InterestComponent DECIMAL(18,2),
    FOREIGN KEY (LoanID) REFERENCES LOAN(LoanID)
);

DELIMITER $$

CREATE FUNCTION CalculateEMI(
    Principal DECIMAL(18,2),
    AnnualRate DECIMAL(5,2),
    TenureMonths INT
)
RETURNS DECIMAL(18,2)
DETERMINISTIC
BEGIN
    DECLARE MonthlyRate DECIMAL(18,10);
    DECLARE EMI DECIMAL(18,2);

    -- Convert annual rate to monthly rate
    SET MonthlyRate = AnnualRate / 12 / 100;

    -- EMI formula
    SET EMI = (Principal * MonthlyRate * POW(1 + MonthlyRate, TenureMonths)) /
              (POW(1 + MonthlyRate, TenureMonths) - 1);

    RETURN EMI;
END$$

DELIMITER ;

-- Customers
INSERT INTO CUSTOMER VALUES
(1, 'Aaryan Pendhari', '9876543210', 'aaryan@example.com', 'Mumbai'),
(2, 'Neha Sharma', '9123456780', 'neha@example.com', 'Delhi');

-- Loans
INSERT INTO LOAN VALUES
(101, 1, 5000000, 8.5, 240, '2026-04-01'),
(102, 2, 3000000, 9.0, 180, '2026-04-01');

SELECT LoanID, CustomerID,
       CalculateEMI(Principal, AnnualRate, TenureMonths) AS MonthlyEMI
FROM LOAN;









