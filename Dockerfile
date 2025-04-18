# Etapa de compilación
FROM maven:3.8.6-openjdk-17-slim AS build
WORKDIR /backend
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa de ejecución
FROM amazoncorretto:17-alpine-jdk
WORKDIR /backend
COPY --from=build /backend/target/backend-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]