# syntax=docker/dockerfile:1

# Build stage
FROM maven:3.9.8-eclipse-temurin-11 AS build
WORKDIR /workspace

# Cache dependencies first
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline

# Copy sources and build
COPY src ./src
RUN mvn -q -e -DskipTests package

# Runtime stage
FROM eclipse-temurin:11-jre
WORKDIR /app

# Copy the built jar (version-agnostic)
COPY --from=build /workspace/target/*.jar /app/app.jar

# Run the application; explicit main class since manifest isn't set
ENTRYPOINT ["java","-cp","/app/app.jar","com.example.app.App"]
