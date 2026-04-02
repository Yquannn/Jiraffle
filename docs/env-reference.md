# Environment Variables Reference

This document describes all required environment variables used in the application.

---

## 🌐 App Configuration

| Variable     | Description                          | Example                     | Required |
|--------------|--------------------------------------|-----------------------------|----------|
| NODE_ENV     | Application environment              | development / production    | ✅       |
| PORT         | Port where the app runs              | 3000                        | ✅       |
| APP_NAME     | Name of the application              | Jiraffe                     | ❌       |
| APP_URL      | Base URL of the application          | http://localhost:3000       | ✅       |

---

## 🗄️ Database (MySQL)

| Variable             | Description                          | Example        | Required |
|----------------------|--------------------------------------|----------------|----------|
| DB_HOST              | Database host                        | localhost      | ✅       |
| DB_PORT              | Database port                        | 3306           | ✅       |
| DB_NAME              | Database name                        | my_database    | ✅       |
| DB_USER              | Database username                    | root           | ✅       |
| DB_PASSWORD          | Database password                    | password       | ✅       |
| DB_CONNECTION_LIMIT  | Max DB connections (pooling)         | 10             | ❌       |

---

## 🔐 JWT Authentication

| Variable                 | Description                          | Example              | Required |
|--------------------------|--------------------------------------|----------------------|----------|
| JWT_SECRET               | Secret key for signing access tokens | supersecretkey       | ✅       |
| JWT_REFRESH_SECRET       | Secret for refresh tokens            | refreshsecret        | ✅       |
| JWT_EXPIRES_IN           | Access token expiration              | 1h                   | ✅       |
| JWT_REFRESH_EXPIRES_IN   | Refresh token expiration             | 7d                   | ✅       |

---

## 📧 SMTP / Email Configuration

| Variable            | Description                          | Example                | Required |
|---------------------|--------------------------------------|------------------------|----------|
| SMTP_HOST           | SMTP server host                     | smtp.mailtrap.io       | ✅       |
| SMTP_PORT           | SMTP server port                     | 2525                   | ✅       |
| SMTP_USER           | SMTP username                        | username               | ✅       |
| SMTP_PASSWORD       | SMTP password                        | password               | ✅       |
| SMTP_FROM_EMAIL     | Sender email address                 | no-reply@yourapp.com   | ✅       |
| SMTP_FROM_NAME      | Sender display name                  | MyApp Support          | ❌       |

---

## 🔑 Git / Repository Integration

| Variable         | Description                          | Example              | Required |
|------------------|--------------------------------------|----------------------|----------|
| GIT_PROVIDER     | Git provider                         | github / gitlab      | ❌       |
| GIT_TOKEN        | Personal access token                | ghp_xxxxx            | ✅*      |
| GIT_REPO_OWNER   | Repository owner (user/org)          | your-username        | ✅*      |
| GIT_REPO_NAME    | Repository name                      | my-repo              | ✅*      |

> ✅* Required only if Git integration is enabled.

---

## 🧾 Logging

| Variable   | Description              | Example | Required |
|------------|--------------------------|---------|----------|
| LOG_LEVEL  | Logging verbosity level  | info    | ❌       |

---

## 🛡️ Security

| Variable              | Description                          | Example                  | Required |
|----------------------|--------------------------------------|--------------------------|----------|
| BCRYPT_SALT_ROUNDS   | Salt rounds for password hashing     | 10                       | ✅       |
| CORS_ORIGIN          | Allowed frontend origin              | http://localhost:3000    | ✅       |

---

## 📦 Feature Flags

| Variable                    | Description                          | Example | Required |
|-----------------------------|--------------------------------------|---------|----------|
| ENABLE_EMAIL_VERIFICATION   | Require email verification           | true    | ❌       |
| ENABLE_TWO_FACTOR_AUTH      | Enable 2FA                           | false   | ❌       |

---

## ⚠️ Notes

- Never commit `.env` files containing real secrets.
- Always use `.env.example` as the reference template.
- Validate environment variables at startup to avoid runtime errors.
- Use secure secret management in production (e.g., Vault, AWS Secrets Manager).

---

## ✅ Recommended Practices

- Keep variable names consistent across environments.
- Avoid hardcoding sensitive values in code.
- Rotate secrets regularly (especially JWT and Git tokens).