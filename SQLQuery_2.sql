USE performance_management;

-- Insert User Data
INSERT INTO Users (UserID, FirstName, LastName, JobTitle, Position, Role)
VALUES (1, 'Amalia', 'Numbala', 'Manager', 'Department A', 'HoD');

INSERT INTO Users (UserID, FirstName, LastName, JobTitle, Position, Role)
VALUES (2, 'Samantha', 'Smith', 'Employee', 'Department B', 'Employee');

-- Insert Objective Data
INSERT INTO Objectives (ObjectiveID, Department, Description, Percentage)
VALUES (1, 'Department A', 'Improve Sales', 30.0);

INSERT INTO Objectives (ObjectiveID, Department, Description, Percentage)
VALUES (2, 'Department B', 'Research and Development', 25.0);

-- Insert Performance Record Data
INSERT INTO PerformanceRecords (RecordID, UserID, ObjectiveID, RecordDate, Description, Score)
VALUES (1, 1, 1, '2023-01-15', 'Quarterly performance review', 85);

INSERT INTO PerformanceRecords (RecordID, UserID, ObjectiveID, RecordDate, Description, Score)
VALUES (2, 2, 2, '2023-01-15', 'Monthly progress update', 92);

-- Insert KPI Data
INSERT INTO KPIs (KPIID, UserID, ObjectiveID, Name, Value, Unit)
VALUES (1, 1, 1, 'Sales Revenue', 95000.0, 'USD');

INSERT INTO KPIs (KPIID, UserID, ObjectiveID, Name, Value, Unit)
VALUES (2, 2, 2, 'Research Projects Completed', 5.0, 'Count');
