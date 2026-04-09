# Jiraffle Backend Documentation

## Overview

Jiraffle is a microservices-based project management system built with Spring Boot and Maven. The backend consists of multiple independent microservices, each handling specific business domains, along with a shared common library for cross-cutting concerns.

## Architecture

### Microservices

The backend is organized into the following microservices:

- **api-gateway** - API Gateway service routing external requests to appropriate microservices
- **auth-service** - Authentication and authorization service (JWT-based)
- **ads-service** - Advertisement management service
- **analytics-service** - Analytics and reporting service
- **automation-service** - Automation and workflow execution service
- **docs-service** - Document management service
- **notification-service** - Notification delivery service (email, SMS, push)
- **repo-service** - Repository and version control service
- **task-service** - Task and issue management service
- **common-lib** - Shared library with common utilities (not a service)

### Module Structure

The backend is organized as a Maven multi-module project. All modules are defined in `backend/pom.xml`:

```xml
<modules>
    <module>common-lib</module>
    <module>ads-service</module>
    <module>api-gateway</module>
    <module>analytics-service</module>
    <module>auth-service</module>
    <module>automation-service</module>
    <module>docs-service</module>
    <module>notification-service</module>
    <module>repo-service</module>
    <module>task-service</module>
</modules>
```

## Common Library

The `common-lib` module is a shared library (packaged as JAR, not a service) that contains cross-cutting concerns and shared code:

### Contents

- **Constants** - Application-wide constant values
- **Entities** - JPA entities and domain models
- **DTOs** - Data Transfer Objects for inter-service communication
- **Exceptions** - Common exception classes
- **Utility Functions** - Helper and utility methods

### Usage

To use the common library in any microservice, add the following dependency to your service's `pom.xml`:

```xml
<dependency>
    <groupId>com.yourcompany</groupId>
    <artifactId>common</artifactId>
    <version>${project.version}</version>
</dependency>
```

### Example Import

```java
import com.pms.common.entities.Message;
```

## Building the Project

### Build All Modules

```bash
mvn clean install
```

> **Note**: This command must be run from the `backend/` directory.

### Build a Specific Module

```bash
mvn clean install -pl module-name
```

## Running Services

### Running the API Gateway

```bash
mvn spring-boot:run -pl api-gateway
```

The API Gateway will start and listen for requests on its configured port.

### Running Individual Services

```bash
mvn spring-boot:run -pl service-name
```

Replace `service-name` with any of the microservices listed above.

## Configuration

### Application Configuration

Each microservice includes an `application.yml` configuration file located in `src/main/resources/`. This file contains service-specific configurations including:

- Server port
- Database connection settings
- External service URLs
- Logging configuration
- Security settings

### Updating Service URLs

When running services locally (outside of containers), update the service URLs in `application.yml`:

**Example - Default (Docker)**
```yaml
auth-service:
  uri: http://auth-service:8083
```

**Local Development**
```yaml
auth-service:
  uri: http://localhost:8083
```

## Development Guidelines

### Packaging Configuration

**Microservice** - Use standard JAR packaging:
```xml
<packaging>jar</packaging>
```

**Shared Library** - Also uses JAR packaging, but is not intended to be run as a standalone service.

### Best Practices

1. Put shared code in `common-lib`, not in individual services
2. Keep services loosely coupled with well-defined APIs
3. Use DTOs for inter-service communication
4. Document custom exceptions and error handling
5. Follow Spring Boot conventions for configuration

## Deployment

Services are containerized using Docker. Each backend service has its own `Dockerfile`, and the API gateway communicates with other services over a shared Docker network.

### Docker Compose Deployment

The recommended way to deploy the backend services is using Docker Compose. The `backend/docker-compose.yml` file defines all services and their dependencies.

#### Prerequisites

1. Ensure Docker and Docker Compose are installed on your system.
2. Navigate to the `/` directory.

#### Starting Services

```bash
docker-compose -f backend/docker-compose.yml up
```

This will start all microservices defined in the compose file. The services will be available on their respective ports (8080 for API Gateway, 8081 for ads-service, etc.).

#### Stopping Services

```bash
docker-compose down
```

#### Viewing Logs

```bash
docker-compose logs -f [service-name]
```

Replace `[service-name]` with the name of the service (e.g., `api-gateway`, `auth-service`).

#### Infrastructure Services

The docker-compose file includes commented-out infrastructure services (PostgreSQL, Redis, MinIO). To enable them:

1. Uncomment the relevant service blocks in `backend/docker-compose.yml`
2. Uncomment the corresponding environment variables in each service
3. Uncomment the volume definitions at the bottom of the file
4. Run `docker-compose up -d` to start with infrastructure

### Manual Docker Deployment (Alternative)

If you prefer manual Docker commands:

1. Create a shared network for the services.

```bash
docker network create jiraffle-net
```

2. Build each backend image from the repository root. Use the root of the repository as the Docker build context so the service Dockerfiles can access the full Maven reactor in `backend/`.

```bash
docker build -t jiraffle-api -f backend/api-gateway/Dockerfile .
docker build -t jiraffle-ads -f backend/ads-service/Dockerfile .
docker build -t jiraffle-analytics -f backend/analytics-service/Dockerfile .
docker build -t jiraffle-auth -f backend/auth-service/Dockerfile .
docker build -t jiraffle-automation -f backend/automation-service/Dockerfile .
docker build -t jiraffle-docs -f backend/docs-service/Dockerfile .
docker build -t jiraffle-notification -f backend/notification-service/Dockerfile .
docker build -t jiraffle-repo -f backend/repo-service/Dockerfile .
docker build -t jiraffle-task -f backend/task-service/Dockerfile .
```

3. Run the containers on the same Docker network so services can reach each other by container name.

```bash
docker run -d --name jiraffle-api --network jiraffle-net -p 8080:8080 jiraffle-api
docker run -d --name ads-service --network jiraffle-net jiraffle-ads
docker run -d --name analytics-service --network jiraffle-net jiraffle-analytics
docker run -d --name auth-service --network jiraffle-net jiraffle-auth
docker run -d --name automation-service --network jiraffle-net jiraffle-automation
docker run -d --name docs-service --network jiraffle-net jiraffle-docs
docker run -d --name notification-service --network jiraffle-net jiraffle-notification
docker run -d --name repo-service --network jiraffle-net jiraffle-repo
docker run -d --name task-service --network jiraffle-net jiraffle-task
```

4. Verify service-to-service connectivity from inside the gateway container.

```bash
docker exec jiraffle-api curl http://ads-service:8081/hello
```

5. Inspect the running containers and network when troubleshooting.

```bash
docker ps
docker network inspect jiraffle-net
```

6. Remove a container when you need to recreate it.

```bash
docker rm -f container-id-or-container-name
```

## Dependencies and Versions

Dependency versions are managed at the parent project level in `backend/pom.xml`. All microservices inherit these versions, ensuring consistency across the application.

## Testing

Run backend tests using:

```bash
./scripts/run-backend-tests.sh
```

## Additional Resources

- See [module-dependencies.md](../module-dependencies.md) for detailed micro-service dependencies
- See [ADR-001-service-boundaries.md](../adr/ADR-001-service-boundaries.md) for service architecture decisions
- See [ADR-002-authentication-and-jwt.md](../adr/ADR-002-authentication-and-jwt.md) for authentication details 



