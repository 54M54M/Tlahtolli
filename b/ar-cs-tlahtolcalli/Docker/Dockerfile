# ============ Build stage ============
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ============ Runtime stage ============
FROM eclipse-temurin:21-jre-alpine
EXPOSE 8080

ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp"

WORKDIR /opt

RUN mkdir -p /tmp && chmod -R 777 /tmp

COPY --from=build /app/target/ar-cs-tlahtolcalli-0.0.1-SNAPSHOT.jar /opt/app.jar

ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "/opt/app.jar"]