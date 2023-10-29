import ballerina/http;

function main() {
    http:Client client = new;
    http:Request request = new;
    request.setPayload("your GraphQL query");

    // Make a request to the GraphQL service and process the response
    http:Response response = client->post("http://graphql-service-url", request);
    if (response is http:Response) {
        io:println(response.getJsonPayload().toString());
    }
}
