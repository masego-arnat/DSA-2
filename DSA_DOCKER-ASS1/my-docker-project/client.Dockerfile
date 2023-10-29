# Use the official Ballerina runtime as a parent image
FROM ballerina/ballerina:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy your Ballerina client source code to the container
COPY client.bal client.bal

# Expose the port on which the client will run (if applicable)
EXPOSE 8080

# Specify the command to run when the container starts
CMD ballerina run client.bal
