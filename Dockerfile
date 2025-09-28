# Build Stage
FROM maven:3.8.6-jdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime Stage
FROM amazoncorretto:11-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
RUN addgroup -S mygroup && adduser -S myuser -G mygroup
USER myuser
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=prod
CMD ["java", "-jar", "app.jar"]
