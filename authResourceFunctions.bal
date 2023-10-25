import ballerina/http;
import ballerina/graphql;
import ballerina/auth;

// Define a data structure for user information
type User {
    int id;
    string firstName;
    string lastName;
    string jobTitle;
    string role;
    string username;
}

// In-memory user store for demonstration purposes (replace with a real database)
map<int, User> userStore = {};

// Remote function for user registration
@graphql:Mutation
@auth:Secure(enabled = false)
function register(
    graphql:Context ctx,
    string firstName,
    string lastName,
    string jobTitle,
    string role,
    string username,
    string password
) returns User? {
    // Perform user registration logic
    // - Validate input
    // - Hash and salt the password
    // - Store user data in the database (replace with your database logic)
    // - Return the created user
    // Ensure you handle errors and validation

    // Example: For demonstration purposes, we'll store the user in an in-memory map
    int userId = userStore.keys().length() + 1;
    User user = {
        id: userId,
        firstName: firstName,
        lastName: lastName,
        jobTitle: jobTitle,
        role: role,
        username: username,
    };
    userStore[userId] = user;
    return user;
}

// Remote function for user login
@graphql:Query
@auth:Secure(enabled = false)
function login(
    graphql:Context ctx,
    string username,
    string password
) returns User? {
    // Perform user login logic
    // - Validate input
    // - Retrieve user data from the database (replace with your database logic)
    // - Compare the provided password with the stored password
    // - Return the retrieved user if the passwords match
    // Ensure you handle errors and validation

} else {
    return null;
}

function getUserByUsername(string username) returns User? {
    for u in userStore.values() {
        if (u.username == username) {
            return u;
        }
    }
    return ();
}

// Helper function to validate the password (replace with more secure validation)
function validatePassword(User user, string password) returns boolean {
    return user.password == password;

}