# -----------------------------
# Stage 1 : Build the WAR
# -----------------------------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml first
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests


# -----------------------------
# Stage 2 : Run on Tomcat
# -----------------------------
FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat

# Remove default applications
RUN rm -rf webapps/*

# Copy generated WAR
COPY --from=builder /app/target/*.war webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]
