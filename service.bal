import ballerina/graphql;
import ballerina/io;
import ballerina/log;
import ballerina/sql;
import ballerinax/mongodb;
import ballerinax/mssql;
import ballerinax/mssql.driver as _;

public type DepartmentEntry record {|
    readonly string DepId;
    string Name;
    string objectives;

|};

public type Employees record {|
    readonly string EmployeesId;
    string Name;
    string KPIs;
    int TotalScore;

|};

public type Supervisor record {|
    readonly string SupervisorId;
    string EmployeesId;
    string Name;
    string KPIs;
    int TotalScore;

|};

// Define MongoDB Connection Configuration
mongodb:ConnectionConfig mongoConfig = {

    connection: {
        url: "mongodb+srv://masego:bossokemang1@cluster0.myiqh55.mongodb.net/"
    },
    databaseName: "GraphQL"

};

// Create a new MongoDB client using the provided configuration
mongodb:Client mongoClient = check new (mongoConfig);

table<DepartmentEntry> key(DepId) covidEntriesTable = table [
    {DepId: "GE", Name: "Geology", objectives: "To lead"},
    {DepId: "lW", Name: "Law ", objectives: ""},
    {DepId: "CS", Name: "Computer Science", objectives: "Teach t"}
];

table<Employees> key(EmployeesId) EmplaoyeesEntries = table [
    {EmployeesId: "Nust01", Name: "Geology", KPIs: "To", TotalScore: 12},
    {EmployeesId: "Nust02", Name: "Law ", KPIs: "ewrwe", TotalScore: 21},
    {EmployeesId: "Nust03", Name: "Computer Science", KPIs: "sdfsdf", TotalScore: 34}
];

public distinct service class GraphQL {
    /// The department entry record, marked as readonly.
    private final readonly & DepartmentEntry entryRecord;
    /// The Employees entry record, marked as readonly.
    private final readonly & Employees entryRecddord;
    function init(DepartmentEntry? entryRecord, Employees? entryRecddord) {

        self.entryRecord = <DepartmentEntry & readonly>entryRecord.cloneReadOnly();

        self.entryRecddord = <Employees & readonly>entryRecddord.cloneReadOnly();

    }

    resource function get deparmentId() returns string {

        return self.entryRecord.DepId;
    }

    resource function get deparment() returns string {
        return self.entryRecord.Name;
    }

    resource function get objectives() returns string {
        return self.entryRecord.objectives;
    }

    resource function get EmployeesTotalScores() returns Employees[] {
      //  getting data from mongo db
        stream<Employees, error?> sddf = checkpanic mongoClient->find("Employees", (), null, null, null, -1, -1);

        // creting a array of emplapyees to pass the data from the database to or local array 
        Employees[] employees = [];

        _ = check sddf.forEach(function(Employees emp) {
            
                employees.push(emp);
          

        });

        return employees;
    }

}

service on new graphql:Listener(9000) {
    resource function get all() returns GraphQL[] {
        DepartmentEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        return covidEntries.map(entry => new GraphQL(entry, null));
    }

    resource function get searchDeparment(string DepId) returns GraphQL? {

        DepartmentEntry? covidEntry = covidEntriesTable[DepId];
        if covidEntry is DepartmentEntry {
            return new (covidEntry, null);
        }
        return;
    }

    resource function get EmployeesTotalScore(string Name) returns Employees[]|error? {
        // string collectionName : Name of the collection
        // string? databaseName : Name of the database
        // map<json>? filter : Filter for the query
        // map<json>? projection : The projection document
        // map<json>? sort : Sort options for the query
        // int limit : The limit of documents that should be returned. If the limit is -1, all the documents in the result will be returned.
        // int skip : The number of documents that should be skipped. If the skip is -1, no documents will be skipped.

        //  getting data from mongo db
        stream<Employees, error?> sddf = checkpanic mongoClient->find("Employees", (), null, null, null, -1, -1);

        // creting a array of emplapyees to pass the data from the database to or local array 
        Employees[] employees = [];

        _ = check sddf.forEach(function(Employee emp) {
            employees.push(emp);

        });

        return new (null, employees);
    }

// A remote function to add a department entry to a MongoDB collection.
remote function add(DepartmentEntry entry) returns GraphQL {

    // Create a JSON object representing the department entry.
    map<json> eventJson = {
        DepId: entry.DepId,
        Name: entry.Name,
        objectives: entry.objectives
    };

    // Insert the department entry JSON into the "DepartmentObjectives" collection in MongoDB.
    // Use the `mongoClient->insert` method to insert data into the database.
    do {
        check mongoClient->insert(eventJson, "DepartmentObjectives");
    } on fail var e {
        // If an error occurs during data insertion, log the error for debugging.
        log:printInfo("Error in saving data", e);
    }

    // Return a new GraphQL object with the added entry and a null error.
    return new GraphQL(entry, null);
}


   // A remote function to create an employee entry in a MongoDB collection.
remote function CreateEmployees(Employees entry) returns GraphQL {

    // Create a JSON object representing the employee entry.
    map<json> eventJson = {
        Name: entry.Name,
        KPIs: entry.KPIs,
        TocalScore: entry.TotalScore
    };

    // Insert the employee entry JSON into the "Employees" collection in MongoDB.
    // Use the `mongoClient->insert` method to insert data into the database.
    do {
        check mongoClient->insert(eventJson, "Employees");
    } on fail var e {
        // If an error occurs during data insertion, log the error for debugging.
        log:printInfo("Error in saving data", e);
    }

    // Return a new GraphQL object with `null` entry and the added employee data.
    return new GraphQL(null, entry);
}

// A remote function to delete department objectives from a MongoDB collection.
remote function delete(DepartmentEntry entry) returns GraphQL {

    // Use the `mongoClient->delete` method to delete documents from the "DepartmentObjectives" collection.
    int deleteRet = checkpanic mongoClient->delete("DepartmentObjectives", (), null, false);

    if (deleteRet > 0) {
        // Log the number of deleted documents if successful.
        log:printInfo("Deleted the doc: '", deleteRet);
    } else {
        // Log an error message if deletion fails.
        log:printInfo("Error in deleting data");
    }

    // Return a new GraphQL object with the deleted department entry and `null`.
    return new GraphQL(entry, null);
}


   // A remote function to assign a supervisor to an employee and store the data in a MongoDB collection.
remote function AssignEmployeeSupervisor(Employees entry) returns GraphQL {

    // Create a JSON object representing the supervisor-employee relationship.
    map<json> eventJson = {
        SupervisorName: entry.SupervisorName,
        EmployeeName: entry.EmployeeName
    };

    // Insert the relationship data into the "Employees" collection in MongoDB.
    // Use the `mongoClient->insert` method to insert data into the database.
    do {
        check mongoClient->insert(eventJson, "Employees");
    } on fail var e {
        // If an error occurs during data insertion, log the error for debugging.
        log:printInfo("Error in saving data", e);
    }

    // Return a new GraphQL object with `null` as the entry and the assigned supervisor-employee data.
    return new GraphQL(null, entry);
}
 
// A remote function to approve an employee's Key Performance Indicators (KSI) and store the data in a MongoDB collection.
remote function ApproveEmployeesKSI(Employees entry) returns GraphQL {

    // Create a JSON object representing the approved KSI data.
    map<json> eventJson = {
        KSI: entry.KSI,
        EmployeeName: entry.EmployeeName
    };

    // Insert the approved KSI data into the "Employees" collection in MongoDB.
    // Use the `mongoClient->insert` method to insert data into the database.
    do {
        check mongoClient->insert(eventJson, "Employees");
    } on fail var e {
        // If an error occurs during data insertion, log the error for debugging.
        log:printInfo("Error in saving data", e);
    }

    // Return a new GraphQL object with `null` as the entry and the approved KSI data.
    return new GraphQL(null, entry);
}


    remote function DeleteEmployeesKSI(Employees entry) returns GraphQL {
        // string collectionName : Name of the collection
        // string? databaseName : Name of the database
        // map<json>? filter : Filter for the query
        // map<json>? projection : The projection document
        // map<json>? sort : Sort options for the query
        // int limit : The limit of documents that should be returned. If the limit is -1, all the documents in the result will be returned.
        // int skip : The number of documents that should be skipped. If the skip is -1, no documents will be skipped.

        int deleteRet = checkpanic mongoClient->delete("DepartmentObjectives", (), null, false);
        if (deleteRet > 0) {
            log:printInfo("Deleted the doc: '" + deleteRet);
        } else {
            log:printInfo("Error in deleting data");
        }

        return new GraphQL(null, entry);
    }

    remote function UpdateEmployeeSKPIs(Employees entry) returns GraphQL {

        map<json> eventJson = {
        KSI: entry.KSI,
        EmaployeeName: entry.EmaployeeName,

        };

        check mongoClient->insert(eventJson, "Employees");

        return new GraphQL(null, entry);
    }

    remote function ViewEmployeeScores(Supervisor SupervisorId) returns Employees[] {

        //  getting data from mongo db
        stream<Employees, error?> sddf = checkpanic mongoClient->find("Employees", (), null, null, null, -1, -1);

        // creting a array of emplapyees to pass the data from the database to or local array 
        Employees[] employees = [];

        _ = check sddf.forEach(function(Employees emp) {
            if (emp.EmployeesId == SupervisorId) {
                employees.push(emp);
            }

        });

        return employees;
    }

    remote function GradeemployeeKPIs(Supervisor entry) returns Employees[] {

        //  getting data from mongo db
        stream<Employees, error?> sddf = checkpanic mongoClient->find("Employees", (), null, null, null, -1, -1);

        // creting a array of emplapyees to pass the data from the database to or local array 
        Employees[] employees = [];

        _ = check sddf.forEach(function(Employees emp) {
            if (emp.EmployeesId == SupervisorId) {
                employees.push(emp);
            }

        });

        return employees;
    }

    remote function GradeTheEmployeesKPIs(Supervisor entry) returns Employees[] {

        //  getting data from mongo db
        stream<Employees, error?> findEmployee = checkpanic mongoClient->find("Employees", (), null, null, null, -1, -1);

        // creting a array of emplapyees to pass the data from the database to or local array 
        Employees[] employees = [];
        // looop thru and fin the specific employee 
        _ = check findEmployee.forEach(function(Employees emp) {
            if (emp.EmployeesId == SupervisorId) {

                employees.push(emp);

                do {

                    check mongoClient->insert(emp, "Employees");
                } on fail var e {
                    log:printInfo("Error in saving data", e);
                }

            }

        });

        return employees;
    }
  
    remote function CreateKPIs(Employees entry) returns Employees {

        map<json> eventJson = {
        
        KPIs: entry.KPIs,

        };

        do {

            check mongoClient->insert(eventJson, "Employees");
        } on fail var e {
            log:printInfo("Error in saving data", e);
        }

        return entry;
    }

    remote function GradeSupervisor(Employees entry) returns Employees {

        //  getting data from mongo db
        stream<Employees, error?> findSupervisor = checkpanic mongoClient->find("Supervisor", (), null, null, null, -1, -1);
        // creting a array of emplapyees to pass the data from the database to or local array 
        Supervisor[] employees = [];
        // looop thru and fin the specific employee 
        _ = check findSupervisor.forEach(function(Supervisor emp) {
            if (emp.SupervisorId == entry.EmployeesId) {

                do {

                    check mongoClient->insert(emp, "Employees");
                } on fail var e {
                    log:printInfo("Error in saving data", e);
                }

            }

        });

        return entry;
    }

    // View Their Scores

}
