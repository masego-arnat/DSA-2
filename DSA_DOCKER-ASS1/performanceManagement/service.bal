import ballerina/graphql;
import ballerina/http;
import ballerinax/mysql; // Appropriate database connector based on my database.

// Define the Employee type based on my database schema
type Employee record {
    int userId;
    string firstName;
    string lastName;
    string jobTitle;
    string position;
    string role;
}

// Define the database configuration

mysql:Client databaseClient = new({
    host: "localhost",
    port: 1401,  // Database port
    name: "performance_management",
    username: "SA",
    password: "Justice1234"
});

// SQL queries
string getAllEmployeesQuery = "SELECT * FROM Employees;";
string getEmployeeByIdQuery = "SELECT * FROM Employees WHERE userId = ?;";
string insertEmployeeQuery = "INSERT INTO Employees (firstName, lastName, jobTitle, position, role) VALUES (?, ?, ?, ?, ?);";

// Resolver to get all employees
resource function all() returns Employee[] {
    // Implementation authentication and authorization check 
    authenticateAndAuthorize("HoD", "Supervisor"); 

    table<mysql:ParameterizedQueryRow> result = check databaseClient->select(getAllEmployeesQuery);
    Employee[] employees = mapToEmployeeArray(result);
    return employees;
}

// Resolver to get an employee by ID
resource function get(int userId) returns Employee? {
// Implementation authentication and authorization check 
    authenticateAndAuthorize("Employee"); 

    table<mysql:ParameterizedQueryRow> result = check databaseClient->select(getEmployeeByIdQuery, userId);
    if (result.length() == 1) {
        Employee employee = mapToEmployee(result[0]);
        return employee;
    }
    return ();
}

// Resolver to add a new employee
resource function add(Employee employee) returns Employee {
// Implementation authentication and authorization check 
    authenticateAndAuthorize("HoD"); 

    // Define the roles that are allowed to add new employees
    string[] allowedRoles = ["HoD"];

    // Check if the user's role is authorized to perform this action
    boolean isAuthorized = isUserAuthorized(allowedRoles);
    
    if (!isAuthorized) {
        // Unauthorized access
        http:Response errorResponse = new;
        errorResponse.setJsonPayload({ "error": "Unauthorized access" });
        errorResponse.statusCode = http:FORBIDDEN;
        return errorResponse;
    }

    // Execute the SQL query to insert the new employee
    var result = check databaseClient->update(
        insertEmployeeQuery,
        employee.firstName,
        employee.lastName,
        employee.jobTitle,
        employee.position,
        employee.role
    );

    if (result is int) {
        // Assuming the result is the last inserted ID
        employee.userId = result;
        return employee;
    }
    
    // Handle error
    http:Response errorResponse = new;
    errorResponse.setJsonPayload({ "error": "Employee not added" });
    errorResponse.statusCode = 500;
    return errorResponse;
}

// Function to map database rows to Employee type
function mapToEmployee(mysql:ParameterizedQueryRow row) returns Employee {
    return {
        userId: row.getInt("userId"),
        firstName: row.getString("firstName"),
        lastName: row.getString("lastName"),
        jobTitle: row.getString("jobTitle"),
        position: row.getString("position"),
        role: row.getString("role")
    };
}

// Function to map a result set to an array of Employee type
function mapToEmployeeArray(table<mysql:ParameterizedQueryRow> result) returns Employee[] {
    Employee[] employees = [];
    foreach row in result {
        employees.push(mapToEmployee(row));
    }
    return employees;
}

// Function to check if the user's role is authorized
function isUserAuthorized(string[] allowedRoles) returns boolean {
    // Retrieve the user's role,whether from an authorization token or database
    string userRole = getUserRoleFromAuthorizationHeader();

    // Check if the user's role is in the list of allowed roles
    return userRole in allowedRoles;
}

// Authentication and Authorization 
function getUserRoleFromAuthorizationHeader() returns string {
    http:Request req = check http:getRequest();
    string authorizationHeader = req.getHeader("Authorization");

    if (authorizationHeader == null) {
        return "";
    }

    // Extract username and password from Basic Authentication header
    string[] authParts = authorizationHeader.split(" ");
    if (authParts.length == 2 && authParts[0] == "Basic") {
        string basicAuth = check base64:decodeBase64URLSafe(authParts[1]);
        string[] authInfo = basicAuth.split(":");
        if (authInfo.length == 2) {
            string username = authInfo[0];
            string password = authInfo[1];

            if (isUserAuthenticated(username, password)) {
                return getUserRoleFromUsername(username);
            }
        }
    }
    return "";
}

// Check if the user is authenticated
function isUserAuthenticated(string username, string password) returns boolean {
    // Verify against your database or data source
    if (username == "amalianumbala" && password == "password") {
        return true;
    }
    return false;
}

// Get the user's role based on the username
function getUserRoleFromUsername(string username) returns string {
    // retrieve the user's role based on username
    if (username == "amalianumbala") {
        return "HoD";
    } else if (username == "supervisor1") {
        return "Supervisor";
    } else if (username == "employee1") {
        return "Employee";
    }
    return "";
}


// Ballerina GraphQL service
service /graphql on new graphql:Listener(9000) {
    resource function all() returns Employee[] {
        return all();
    }

    resource function get(int userId) returns Employee? {
        return get(userId);
    }

    resource function add(Employee employee) returns Employee {
        return add(employee);
    }
}
