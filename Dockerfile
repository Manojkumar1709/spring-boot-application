# Use a base image with Java and Maven installed
FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /app

# Copy the Maven configuration files and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src src
RUN mvn package -DskipTests

# Create a lightweight Docker image with the built WAR
FROM tomcat:9.0-jdk17-openjdk-slim
WORKDIR /usr/local/tomcat/webapps
COPY --from=build /app/target/app.war .

# Set the command to run Tomcat
CMD ["catalina.sh", "run"]

