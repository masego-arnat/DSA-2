import ballerina/http;
import ballerina/crypto;

// Define a data structure for user information
type User {
    string username;
    string password;
    string token;
}
 
map<string, User> userStore = {};

// Function to generate a random API token
function generateApiToken() returns string {
    string randomToken = crypto:randomString(32);
    return randomToken;
}

service<http:Service> authService bind {
    port: 9090
} {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/register"
    }
    resource function register(http:Request req, http:Response res) {
        // Parse the request body to extract registration data
        json payload = check req.getJsonPayload();
        string username = payload.username.toString();
        string password = payload.password.toString();

        // Check if the username is already registered
        if (userStore.hasKey(username)) {
            res.statusCode = http:Status.CONFLICT;
            res.setJsonPayload({"error": "Username already taken"});
            return;
        }

        // Generate an API token
        string token = generateApiToken();

        // Create a new user
        User user = {
            username: username,
            password: password,
            token: token
        };

        // Store the user in the in-memory user store
        userStore[username] = user;

        // Return the token in the response
        res.setJsonPayload({"token": token});
    }

@http:ResourceConfig {
    methods: ["POST"],
    path: "/register"
}
resource function register(http:Request req, http:Response res) {
    // Parse the request body to extract registration data
    json payload = check req.getJsonPayload();
    string username = payload.username.toString();
    string password = payload.password.toString();

    // Check if the username is already registered in the database
    // You can use a MongoDB query to check for an existing user with the same username

    // If the username is already registered, return an error response
    // Otherwise, proceed with user registration

    // Create a new user document
 

    // Insert the user data into the MongoDB database
    error? insertResult = insertIntoMongoDB("Users", userDocument);

    if (insertResult is error) {
        // Handle the error and return an appropriate response
        res.statusCode = http:Status.INTERNAL_SERVER_ERROR;
        res.setJsonPayload({"error": "User registration failed"});
        return;
    }

    // Registration successful
    // You may choose to issue an API token at this point for the newly registered user
    string token = generateApiToken();

    // Return a success response with the token
    res.statusCode = http:Status.CREATED;
    res.setJsonPayload({"message": "User registered successfully", "token": token});
}

@http:ResourceConfig {
    methods: ["POST"],
    path: "/login"
}
resource function login(http:Request req, http:Response res) {
    // Parse the request body to extract login credentials
    json payload = check req.getJsonPayload();
    string username = payload.username.toString();
    string password = payload.password.toString();

    // Check if a user with the provided username exists in the MongoDB database
    // You can use a MongoDB query to retrieve user data based on the username

    // If the user doesn't exist, return an error response
    // If the user exists, proceed with credential validation

    // Validate the provided password against the stored user password in the database
    // You should use the hashed and salted password stored in the database

    // If the password is valid, generate an API token for the user
    // Store the token in the user document in the database for future authentication

    // Return a success response with the generated token
    res.statusCode = http:Status.OK;
    res.setJsonPayload({"message": "Login successful", "token": generatedToken});
}
