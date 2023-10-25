-- Check if the database exists, and if not, create it
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'performance_management')
BEGIN
    CREATE DATABASE performance_management;
END;

-- Use the "performance_management" database
USE performance_management;

-- Continue with table creation and schema definition...
-- Create the "Users" table to store user information
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    JobTitle VARCHAR(255),
    Position VARCHAR(255),
    Role VARCHAR(255)
);

-- Create the "Objectives" table to store department objectives
CREATE TABLE Objectives (
    ObjectiveID INT PRIMARY KEY,
    Department VARCHAR(255),
    Description TEXT,
    Percentage DECIMAL(5, 2)
);

-- Create the "PerformanceRecords" table to store performance records
CREATE TABLE PerformanceRecords (
    RecordID INT PRIMARY KEY,
    UserID INT,  -- Foreign key to link with Users
    ObjectiveID INT,  -- Foreign key to link with Objectives
    RecordDate DATE,
    Description TEXT,
    Score INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ObjectiveID) REFERENCES Objectives(ObjectiveID)
);

-- Create the "KPIs" table to store Key Performance Indicators
CREATE TABLE KPIs (
    KPIID INT PRIMARY KEY,
    UserID INT,  -- Foreign key to link with Users
    ObjectiveID INT,  -- Foreign key to link with Objectives
    Name VARCHAR(255),
    Value DECIMAL(10, 2),
    Unit VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ObjectiveID) REFERENCES Objectives(ObjectiveID)
);

-- Add any additional tables or columns as needed

-- Commit the changes
COMMIT;

