# Use a base image with OpenJDK 17 installed
FROM openjdk:17-jdk-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven Wrapper script and the Maven configuration files
COPY mvnw .
COPY mvnw.cmd .
COPY .mvn .mvn
COPY pom.xml .

# Copy the source code
COPY src src

# Ensure Maven Wrapper script is executable
RUN chmod +x mvnw

# Build the application using Maven (skipping tests)
RUN ./mvnw package -DskipTests

# Create a lightweight Docker image with Tomcat
FROM tomcat:9.0-jdk17-openjdk-slim

# Copy the WAR file from the build stage to the Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
