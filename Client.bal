import ballerina/io;
import ballerina/http;

public function main() {
  // Replace with the actual URL of your GraphQL server.
    string graphqlServerURL = "http://localhost:4000/graphql";

    // Define your GraphQL query.
    string graphqlQuery = `
      {
        departmentId
        department
        objectives
        EmployeesTotalScores {
          id
          name
        }
      }
    `;

    // Create a GraphQL client.
    graphql:Client client = new(graphqlServerURL);

    // Send the query to the GraphQL server.
    var response = client->executeQuery(graphqlQuery);

    // Handle the response.
    if (response is graphql:Response) {
        json responseData = response.data;
        io:println("Department ID: " + responseData.departmentId.toString());
        io:println("Department: " + responseData.department.toString());
        io:println("Objectives: " + responseData.objectives.toString());

        // Process the EmployeesTotalScores array.
        json[] employees = responseData.EmployeesTotalScores;
        foreach var emp in employees {
            io:println("Employee ID: " + emp.id.toString());
            io:println("Employee Name: " + emp.name.toString());
        }
    } else {
        io:println("Error accessing the GraphQL server: " + response.toString());
    }




  graphql:Response|error allDepartmentsResponse = client->executeQuery(allDepartmentsQuery);
    // Handle the response...

    // 2. Search for a department by Department ID.
    // Documentation: Searches for a department by Department ID.
    string searchDepartmentQuery = `
        query($depId: String!) {
            searchDeparment(DepId: $depId) {
                departmentId
                department
                objectives
            }
        }
    `;
    graphql:Response|error searchDepartmentResponse = client->executeQuery(searchDepartmentQuery, { "depId": "yourDepId" });
    // Handle the response...

    // 3. Get all EmployeesTotalScores.
    // Documentation: Retrieves all Employees' total scores.
    string employeesTotalScoresQuery = `
        query {
            EmployeesTotalScores {
                id
                name
                // Include other fields as needed
            }
        }
    `;
    graphql:Response|error employeesTotalScoresResponse = client->executeQuery(employeesTotalScoresQuery);
    // Handle the response...

    // You can similarly create client code for other GraphQL operations.



}
