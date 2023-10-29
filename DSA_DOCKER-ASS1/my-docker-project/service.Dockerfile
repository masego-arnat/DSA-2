# Use the official Ballerina runtime as a parent image
FROM ballerina/ballerina:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy your Ballerina service source code to the container
COPY service.bal service.bal

# Expose the port on which the service will run (if applicable)
EXPOSE 9090

# Specify the command to run when the container starts
CMD ballerina run service.bal
