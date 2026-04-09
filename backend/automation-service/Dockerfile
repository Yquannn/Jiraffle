# Dockerfile for Automation Service

# Stage 1: build
FROM eclipse-temurin:21-jdk-alpine AS build
RUN apk add --no-cache maven
WORKDIR /workspace

# Copy full backend reactor so Maven can resolve all modules declared in backend/pom.xml
COPY backend backend

# Build dependency graph first
RUN mvn -f backend/pom.xml -pl automation-service -am -DskipTests dependency:go-offline

# Build the service JAR
RUN mvn -f backend/pom.xml -pl automation-service -am -DskipTests package

# Stage 2: runtime
FROM eclipse-temurin:21-jre-alpine AS runtime
RUN addgroup -S appgroup && adduser -S -G appgroup appuser \
    && apk add --no-cache curl

WORKDIR /app
COPY --from=build /workspace/backend/automation-service/target/*-SNAPSHOT.jar /app/app.jar
RUN chown -R appuser:appgroup /app
USER appuser

ENV JAVA_OPTS="-XX:InitialRAMPercentage=25.0 -XX:MaxRAMPercentage=75.0 -XX:+UseContainerSupport"

EXPOSE 8088
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -fsS http://localhost:8088/actuator/health || exit 1

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]