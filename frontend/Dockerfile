# ── Stage 1: Builder ──────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first (better Docker layer caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the React app
RUN npm run build

# ── Stage 2: Production Server ────────────────────
FROM nginx:alpine AS production

# Copy built files from Stage 1 into nginx's serve folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Replace default nginx config with our custom one
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]