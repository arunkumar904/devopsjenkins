# Dockerfile

# Stage 1: Build the frontend
FROM node:16 AS build-frontend

WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend/public ./public
COPY frontend/src ./src
RUN npm run build

# Stage 2: Set up the Python backend
FROM python:3.9-slim

WORKDIR /app

# Copy frontend build files
COPY --from=build-frontend /app/frontend/build ./frontend/build

# Copy backend code
COPY backend/ ./backend/

# Install Python dependencies
RUN pip install --no-cache-dir -r backend/requirements.txt

# Expose the port Cloud Run expects
EXPOSE 8080

# Set environment variable for port
ENV PORT=8080

# Command to run the application
CMD ["python", "backend/app.py"]
