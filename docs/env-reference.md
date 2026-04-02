# Backend Environment Reference

The backend now reads a repo-root `.env` file automatically for every microservice that depends on `backend/common-lib`.

Actual OS environment variables still win over `.env`, so production deployments can keep using platform secrets.

## Required Secrets

| Variable | Purpose |
| --- | --- |
| `DB_USER` | Shared PostgreSQL username used by the database-backed services |
| `DB_PASSWORD` | Shared PostgreSQL password used by the database-backed services |
| `JWT_SECRET` | Signing secret for `auth-service` JWT tokens |

## Database Settings

| Variable | Default | Used By |
| --- | --- | --- |
| `DB_HOST` | `postgres` | Ads, Analytics, Auth, Task |
| `DB_PORT` | `5432` | Ads, Analytics, Auth, Task |
| `ADS_DB_NAME` | `jiraffle_ads` | Ads |
| `ANALYTICS_DB_NAME` | `jiraffle_analytics` | Analytics |
| `AUTH_DB_NAME` | `jiraffle_auth` | Auth |
| `TASK_DB_NAME` | `jiraffle_tasks` | Task |

## JWT Settings

| Variable | Default | Used By |
| --- | --- | --- |
| `JWT_EXPIRATION` | `86400000` | Auth |

## Optional Override

| Variable | Purpose |
| --- | --- |
| `JIRAFFE_ENV_FILE` | Absolute path to a different `.env` file if you do not want to use the repo root |

## Notes

- The checked-in `.env.example` and local `.env` only contain placeholders.
- Real secrets should stay in the ignored root `.env` or in deployment-managed environment variables.
