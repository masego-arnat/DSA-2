import ballerina/http;
import ballerina/io;
import ballerinax/mongodb;

public function main() {

    // Define MongoDB Connection Configuration
    mongodb:ConnectionConfig mongoConfig = {

    connection: {
        url: "mongodb+srv://masego:bossokemang1@cluster0.myiqh55.mongodb.net/"
    },
    databaseName: "GraphQL"
};

    // Create a new MongoDB client using the provided configuration
    mongodb:Client mongoClient = check new (mongoConfig);
}

//
// - Parameter id: The ID of the user to retrieve.
// - Returns: A JSON object representing the user data, or an error if the user is not found.
// Retrieves user data based on the provided user ID.
public function getUser(string id) returns json|error {
    // Construct a GraphQL query to get user information.
    string query = string `{
        "query": "{ user(id: \"${id}\") { id, firstName, lastName, jobTitle, position, role, department { id, name }, kpis { id, name } } }"
    }`;
    return self.graphqlQuery(query);
}

// Retrieves all user data.
public function getAllUsers() returns json|error {
    // Construct a GraphQL query to fetch all users.
    string query = "{\"query\": \"{ users { id, firstName, lastName, role } }\"}";
    return self.graphqlQuery(query);
}

// Retrieves department data based on the provided department ID.
public function getDepartment(string id) returns json|error {
    // Construct a GraphQL query to get department information.
    string query = "{\"query\": \"{ department(id: \"" + id + "\") { id, name, hod { id, firstName, lastName }, objectives { id, name }, users { id, firstName, lastName } } }\"}";
    return self.graphqlQuery(query);
}

// Retrieves all department data.
public function getAllDepartments() returns json|error {
    // Construct a GraphQL query to fetch all departments.
    string query = "{\"query\": \"{ departments { id, name } }\"}";
    return self.graphqlQuery(query);
}

// Retrieves department objective data based on the provided objective ID.
public function getDepartmentObjective(string id) returns json|error {
    // Construct a GraphQL query to get department objective information.
    string query = "{\"query\": \"{ departmentObjective(id: \"" + id + "\") { id, name, weight, department { id, name }, relatedKPIs { id, name } } }\"}";
    return self.graphqlQuery(query);
}

// Retrieves all department objectives.
public function getAllDepartmentObjectives() returns json|error {
    // Construct a GraphQL query to fetch all department objectives.
    string query = "{\"query\": \"{ departmentObjectives { id, name, weight } }\"}";
    return self.graphqlQuery(query);
}

// Retrieves KPI data based on the provided KPI ID.
public function getKPI(string id) returns json|error {
    // Construct a GraphQL query to get KPI information.
    string query = "{\"query\": \"{ kpi(id: \"" + id + "\") { id, user { id, firstName, lastName }, name, metric, unit, score, relatedObjectives { id, name } } }\"}";
    return self.graphqlQuery(query);
}

// Retrieves all KPIs.
public function getAllKPIs() returns json|error {
    // Construct a GraphQL query to fetch all KPIs.
    string query = "{\"query\": \"{ kpis { id, name, metric, unit, score } }\"}";
    return self.graphqlQuery(query);
}

// Mutations for Departments

// Updates an existing department.
public function updateDepartment(string id, string name) returns json|error {
    // Construct a GraphQL mutation to update a department.
    string mutation = "{\"mutation\": \"mutation { updateDepartment(id: \\\"" + id + "\\\", name: \\\"" + name + "\\\") { id, name } }\"}";
    return self.graphqlQuery(mutation);
}

// Deletes a department based on the provided department ID.
public function deleteDepartment(string id) returns json|error {
    // Construct a GraphQL mutation to delete a department.
    string mutation = "{\"mutation\": \"mutation { deleteDepartment(id: \\\"" + id + "\\\") }\"}";
    return self.graphqlQuery(mutation);
}

// Retrieves KPI data base / Retrieves all KPIs.

// Mutations for User ==============================================

// Creates a new user.
public function createUser(string firstName, string lastName, string jobTitle, string position, string role, string departmentId) returns json|error {
    // Construct a GraphQL mutation to create a user.
    string mutation = "{\"mutation\": \"mutation { createUser(firstName: \"" + firstName + "\", lastName: \"" + lastName + "\", jobTitle: \"" + jobTitle + "\", position: \"" + position + "\", role: " + role + ", departmentId: \"" + departmentId + "\") { id, firstName, lastName } }\"}";
    return self.graphqlQuery(mutation);
}

// Updates an existing user.
public function updateUser(string id, string firstName, string lastName, string jobTitle, string position, string role, string departmentId) returns json|error {
    // Construct a GraphQL mutation to update a user.
    string mutation = "{\"query\": \"mutation { updateUser(id: \"" + id + "\", firstName: \"" + firstName + "\", lastName: \"" + lastName + "\", jobTitle: \"" + jobTitle + "\", position: \"" + position + "\", role: " + role + ", departmentId: \"" + departmentId + "\") { id, firstName, lastName } }\"}";
    return self.graphqlQuery(mutation);
}

// Mutations for Departments ====================================================

// Creates a new department.
public function createDepartment(string name) returns json|error {
    // Construct a GraphQL mutation to create a department.
    string mutation = "{\"mutation\": \"mutation { createDepartment(name: \\\"" + name + "\\\") { id, name } }\"}";
    return self.graphqlQuery(mutation);
}

// Deletes a department based on the provided department ID.
public function deleteDepartmentobjectives(string id) returns json|error {
    // Construct a GraphQL mutation to delete a department.
    string mutation = "{\"mutation\": \"mutation { deleteDepartment(id: \\\"" + id + "\\\") }\"}";
    return self.graphqlQuery(mutation);
}

public function AssignEmployee(string employeeId, string supervisorId) returns json|error {
    // Construct a GraphQL mutation to assing an amployye to a sypervisor .
    string mutation = "{\"mutation\": \"mutation { assignEmployee(id: \"" + employeeId + "\", firstName: \"" + supervisorId + "\" ) { id, firstName, lastName } }\"}";

    return self.graphqlQuery(mutation);

}

// Supervisor

public function ApproveEmployeeKPIs(string employeeId ) returns boolean|error {
    // Construct a GraphQL mutation to approve an employee's KPIs.
    string mutation = "{\"mutation\": \"mutation { approveEmployeeKPIs(employeeId: \\\"" + employeeId + "\\\") }\"}";

    // Send the mutation to the GraphQL server.
    var response = self.graphqlQuery(mutation);

}

public function DeleteEmployeeKPIs(string employeeId ) returns boolean|error {
    // Construct a GraphQL mutation to delet an employee's KPIs.
    string mutation = "{\"mutation\": \"mutation { deleteEmployeeKPIs(employeeId: \\\"" + employeeId + "\\\") }\"}";

    // Send the mutation to the GraphQL server.
    var response = self.graphqlQuery(mutation);

}
public function UpdateEmployeeKPIs(string employeeId ) returns boolean|error {
    // Construct a GraphQL mutation to delet an employee's KPIs.
    string mutation = "{\"mutation\": \"mutation { UpdateEmployeeKPIs(employeeId: \\\"" + employeeId + "\\\") }\"}";

    // Send the mutation to the GraphQL server.
    var response = self.graphqlQuery(mutation);

}

public function ViewEmployeeKPIs(string supervisorId ) returns json|error {
    // Construct a GraphQL mutation to delet an employee's KPIs.
    string mutation = "{\"query\:  { ViewEmployeeKPIs(supervisorId: \\\"" + supervisorId + "\\\") }\"}";

    // Send the mutation to the GraphQL server.
    var response = self.graphqlQuery(mutation);

}


public function GrademployeeKPIs(string supervisorId, string employeeId, string  KPI ) returns json|error {
    // Construct a GraphQL mutation to delet an employee's KPIs.
    string mutation = "{\"query\:  { grademployeeKPIs("supervisorId": " + supervisorId , "employeeId": employeeId , ) }\"}";

   string mutation = "{\"query\": \"mutation { grademployeeKPIs(supervisorId: \"" + supervisorId + "\", employeeId: \"" + employeeId + "\", KPI: \"" + KPI + "\", jobTitle: \"" + jobTitle + "\", position: \"" + position + "\", role: " + role + ", departmentId: \"" + departmentId + "\") { supervisorId, firstName, lastName } }\"}";
   
    // Send the mutation to the GraphQL server.
    var response = self.graphqlQuery(mutation);

}