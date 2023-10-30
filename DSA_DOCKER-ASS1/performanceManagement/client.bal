import ballerina/http;
import ballerina/io;

function main(string... args) {
    // GraphQL service URL
    string serviceURL = "http://localhost:9090";

    // Replace with your actual credentials
    string username = "amalianumbala";
    string password = "password";

    // Authenticate the user and get the user's role
    string userRole = authenticateUser(username, password);

    if (userRole == "Authentication failed") {
        io:println("Authentication failed. Please check your credentials.");
        return;
    }

    io:println("User authenticated as: " + userRole);

    // Actions based on the user's role
    match userRole {
        "HoD" => {
            // Actions for Head of Department (HoD)
            io:println("Welcome, Head of Department!");

            // Example: Create department objectives
            string createObjectivesMutation = `mutation {
                createObjectives(input: {
                    department: "Your Department Name",
                    objectives: ["Objective 1", "Objective 2"]
                }) {
                    id
                    department
                    objectives
                }
            }`;
            json hodResult = makeGraphQLMutation(serviceURL, createObjectivesMutation);
            io:println("HoD Action Result: " + hodResult.toString());
        }
        "Supervisor" => {
            // Actions for Supervisor
            io:println("Welcome, Supervisor!");

            // Example: Approve KPIs
            string approveKPIsMutation = `mutation {
                approveKPIs(input: {
                    employeeId: 123, // Replace with the employee's ID
                    approved: true
                }) {
                    success
                }
            }`;
            json supervisorResult = makeGraphQLMutation(serviceURL, approveKPIsMutation);
            io:println("Supervisor Action Result: " + supervisorResult.toString());
        }
        "Employee" => {
            // Actions for Employee
            io:println("Welcome, Employee!");

            // Example: View own scores
            string viewScoresQuery = `query {
                getEmployeeScores(userId: 123) {
                    scores
                }
            }`;
            json employeeResult = makeGraphQLQuery(serviceURL, viewScoresQuery);
            io:println("Employee Action Result: " + employeeResult.toString());
        }
        _ => {
            io:println("Unknown role: " + userRole);
        }
    }
}

// Function to authenticate the user and get the user's role
function authenticateUser(username, password) returns string {
    // Simulated user data with roles
    map<string> userCredentials = {
        "amalianumbala": "HoD",
        "samanthasmith": "Supervisor",
        "employee1": "Employee"
    };

    // Check if the user exists and the password matches
    if (userCredentials.hasKey(username) && userCredentials[username] == password) {
        return userCredentials[username];
    }

    return "Authentication failed";
}

// Function to make a GraphQL query
function makeGraphQLQuery(serviceURL, query) returns json {
    // Create an HTTP request
    http:Request request = new;
    request.setHeader("Content-Type", "application/json");
    request.setHeader("Authorization", "Bearer YOUR_AUTH_TOKEN"); // Include a valid authorization token

    // Prepare the GraphQL query
    request.setJsonPayload({ "query": query });

    // Send the GraphQL query to the service
    http:Response response = check http:post(serviceURL, request);

    // Check the response status and return the result
    if (response.statusCode == 200) {
        json responseJson = check response.getJsonPayload();
        return responseJson;
    } else {
        io:println("GraphQL query failed with status code: " + response.statusCode);
        return json({});
    }
}
