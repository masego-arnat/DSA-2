// import ballerina/http;
import ballerina/graphql;
import ballerina/io;
import ballerina/log;
import ballerina/sql;
// import ballerina/sql;
// import ballerinax/mysql;
// import ballerinax/mysql.driver as _;
import ballerinax/mongodb;
import ballerinax/mssql;
import ballerinax/mssql.driver as _;

// mssql:ClientConfiguration dbConfig = {
//     url: "jdbc:sqlserver://(localdb)/MSSQLLocalDB",
//     username: "<username>",
//     password: "<password>"
// };

mssql:Client|sql:Error dbClient = new (host = "(localdb)/MSSQLLocalDB", user = "root", password = "<password>", database = "<dbName>", port = 4096);

// 
public type CovidEntry record {|
    readonly string DepId;
    string Name;
    string objectives;

|};

public type DepartmentEntry record {|
    string Name;
    string Objective;

|};

public type Employees record {|
    readonly string StaffId;
    string Name;
    string KPIs;
    int TotalScore;

|};

mongodb:ConnectionConfig mongoConfig = {

    connection: {
        url: "mongodb+srv://masego:bossokemang1@cluster0.myiqh55.mongodb.net/"
    },
    databaseName: "GraphQL"

};

mongodb:Client mongoClient = check new (mongoConfig);

table<CovidEntry> key(DepId) covidEntriesTable = table [
    {DepId: "La", Name: "Geology", objectives: "To lead"},
    {DepId: "SL", Name: "Law ", objectives: "ewrwe"},
    {DepId: "CS", Name: "Computer Science", objectives: "sdfsdf"}
];

table<Employees> key(StaffId) EmplaoyeesEntries = table [
    {StaffId: "Nust01", Name: "Geology", KPIs: "To lead", TotalScore: 12},
    {StaffId: "Nust02", Name: "Law ", KPIs: "ewrwe", TotalScore: 21},
    {StaffId: "Nust03", Name: "Computer Science", KPIs: "sdfsdf", TotalScore: 34}
];

# Description.
public distinct service class CovidDat {
    private final readonly & Employees entryRecddord;
    function init(Employees entryRecddord) {
        self.entryRecddord = entryRecddord.cloneReadOnly();
        // self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get Emplaoyees() returns string {
        return self.entryRecddord.StaffId;
    }
}

public distinct service class CovidDataWW {
    private final readonly & CovidEntry entryRecord;
    private final readonly & Employees entryRecddord;
    function init(CovidEntry? entryRecord, Employees? entryRecddord) {

        self.entryRecord = <CovidEntry & readonly>entryRecord.cloneReadOnly();

        // if (entryRecddord != null)
        // {
            self.entryRecddord = <Employees & readonly>entryRecddord.cloneReadOnly();

        // }
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

    // resource function get EmployeesTotalScores() returns Employees {
    //     Employees ed =  ed.KPIs,
    //     ed.Name,
    //     ;
    //     return self.entryRecord.objectives;
    // }

    // resource function get cases() returns decimal? {
    //     if self.entryRecord.cases is decimal {
    //         return self.entryRecord.cases / 1000;
    //     }
    //     return;
    // }

    // resource function get deaths() returns decimal? {
    //     if self.entryRecord.deaths is decimal {
    //         return self.entryRecord.deaths / 1000;
    //     }
    //     return;
    // }

    // resource function get recovered() returns decimal? {
    //     if self.entryRecord.recovered is decimal {
    //         return self.entryRecord.recovered / 1000;
    //     }
    //     return;
    // }

    // resource function get active() returns decimal? {
    //     if self.entryRecord.active is decimal {
    //         return self.entryRecord.active / 1000;
    //     }
    //     return;
    // }
}

// final mysql:Client dbClient = check new(
//     host=HOST, user=USER, password=PASSWORD, port=PORT, database="Graph"
// );

// init (string host, string? user, string? password, string? database, int port, string instance, Options? options, ConnectionPool? connectionPool)

service /covid19 on new graphql:Listener(9000) {
    resource function get all() returns CovidDataWW[] {
        CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        return covidEntries.map(entry => new CovidDataWW(entry, null));
    }

    resource function get filter(string DepId) returns CovidDataWW? {

        log:printInfo("Error in replacing data");

        io:println("doc");
        CovidEntry? covidEntry = covidEntriesTable[DepId];
        if covidEntry is CovidEntry {
            return new (covidEntry, null);
        }
        return;
    }

    resource function get EmployeesTotalScore(string Name) returns   Employees[]|error? {

        log:printInfo("Error in replacing data");
        // function find(string collectionName, string? databaseName, map<json>? filter, map<json>? projection, map<json>? sort, int 'limit, int skip, typedesc<record {}> rowType) returns stream<rowType, error?>|Error
        io:println("doc");

        stream<Employees, error?> sddf = checkpanic mongoClient->find("Employees", (), null, null, null, -1, -1);

           io:println("doc", sddf.toString());

        // stream<string[], error?> sdddddf = sddf.'map(Employees => Employees.toArray());

        // io:println("doc1", sdddddf);

          Employees[] employees = [];

    _ = check sddf.forEach(function(Employee emp) {
        employees.push(emp);
              io:println("doc1", emp);
    });

   

        Employees? covidEntry = EmplaoyeesEntries[Name];
        if covidEntry is Employees {
            return new (null, covidEntry);
        }
        return;
    }

    remote function add(CovidEntry entry) returns CovidDataWW {
        covidEntriesTable.add(entry);

        map<json> eventJson = {
        DepId: entry.DepId,
        Name: entry.Name,
        objectives: entry.objectives
    };

        do {

            check mongoClient->insert(eventJson, "DepartmentObjectives");
        } on fail var e {
            log:printInfo("Error in saving data", e);
        }

        io:println("doc");
        return new CovidDataWW(entry, null);
    }

    remote function CreateEmployees(Employees entry) returns CovidDataWW {

        map<json> eventJson = {
        Name: entry.Name,
            KPIs: entry.KPIs,
                
                TocalScore: entry.TotalScore
    };

        do {

            check mongoClient->insert(eventJson, "Employees");
        } on fail var e {
            log:printInfo("Error in saving data", e);
        }

        io:println("doc");
    //        readonly string DepId;
    // string Name;
    // string objectives;
CovidEntry entdry = {
    DepId: "DEP001",
    Name: "John Doe",
    objectives: "edf"
};
        return new CovidDataWW(entdry, entry);
    }

    remote function delete(CovidEntry entry) returns CovidDataWW {
        // map<json> deleteFilter = {"name": "ballerina"};
        int deleteRet = checkpanic mongoClient->delete("DepartmentObjectives", (), null, false);
        if (deleteRet > 0) {
            log:printInfo("Delete count: '" + deleteRet.toString() + "'.");
        } else {
            log:printInfo("Error in deleting data");
        }
        return new CovidDataWW(entry, null);
        //   check mongoClient->delete(eventJson, "DepartmentObjectives");
        //   function delete(string collectionName, string? databaseName, map<json>? filter, boolean isMultiple)
    }

    // resource function post Createobjectives(DepartmentEntry event) returns string|error|DepartmentData {
    //     string collection = "Q1";
    //     string updatse = "";
    //     map<json> eventJson = {
    //     DepartmentName: event.Name,
    //     DepartmentOjective: event.Objective
    // };
    //     //  map<json> docw = doc.toJson();
    //     log:printInfo("Error in replacing data");

    //     io:println("doc");
    //     map<json> docwsws = {"name": "Gmsdail", "version": "0.9asdaqsd9.1", "type": "Servasdasdice"};
    //     // map<json> update = {"$set": {"name": "Rdtmasegorui"}};
    //     check mongoClient->insert(eventJson, collection);
    //     // int response = check mongoClient->update(update, collection, "GraphQL", null, false, false);

    //     updatse = " The Document has been added ";
    //     // log:printInfo("Modified count: '" + response.toString() + "'.");
    //     Foo[] fooArray = [
    //     {id: 1, text: "one"},
    //     {id: 2, text: "two"},
    //     {id: 42, text: "forty-two"}
    // ];

    //     map<json> fooMap = map from Foo f in fooArray
    //         select [f.id.toString()];
    //       return new DepartmentData(event);
    // }
}

// # A service representing a network-accessible API
// # bound to port `9090`.
// service / on new http:Listener(9090) {

//     # A resource for generating greetings
//     # + name - the input string name
//     # + return - string name with hello message or error
//     resource function get greeting(string name) returns string|error {
//         // Send a response back to the caller.
//         if name is "" {
//             return error("name should not be empty!");
//         }
//         return "Hello, " + name;
//     }
// }
