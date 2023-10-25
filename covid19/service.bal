// import ballerina/http;
import ballerina/graphql;
import ballerina/io;
import ballerina/log;
// import ballerina/sql;
// import ballerinax/mysql;
// import ballerinax/mysql.driver as _;
import ballerinax/mongodb;

//    mysql:Client mysqlClient = check new (host = "localhost", port = 3306, user = "root",
//                                           password = "Test@123");
// public function main() returns sql:Error? {
//                                               // Creates a database.
//     _ = check mysqlClient->execute(`CREATE DATABASE MUSIC_STORE;`);
// }

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

# Description.
public distinct service class CovidData {
    private final readonly & CovidEntry entryRecord;

    function init(CovidEntry entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
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

    // resource function get EmployeesTotalScores() returns string {
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

service /covid19 on new graphql:Listener(9000) {
    resource function get all() returns CovidData[] {
        CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        return covidEntries.map(entry => new CovidData(entry));
    }

    resource function get filter(string DepId) returns CovidData? {

        log:printInfo("Error in replacing data");

        io:println("doc");
        CovidEntry? covidEntry = covidEntriesTable[DepId];
        if covidEntry is CovidEntry {
            return new (covidEntry);
        }
        return;
    }

    remote function add(CovidEntry entry) returns CovidData {
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
        return new CovidData(entry);
    }
    remote function delete(CovidEntry entry) returns CovidData {
        // map<json> deleteFilter = {"name": "ballerina"};
        int deleteRet = checkpanic mongoClient->delete("DepartmentObjectives", (), null, false);
        if (deleteRet > 0) {
            log:printInfo("Delete count: '" + deleteRet.toString() + "'.");
        } else {
            log:printInfo("Error in deleting data");
        }
        return new CovidData(entry);
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
