# Stage 1: Build the React frontend
FROM node:16-alpine as build-frontend

WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend/public ./public
COPY frontend/src ./src
RUN npm run build

# Stage 2: Set up the Python backend
FROM python:3.9-slim

WORKDIR /app/backend

# Install Python dependencies
COPY backend/requirements.txt .
RUN pip install -r requirements.txt

# Copy the backend app
COPY backend/ .

# Copy the built frontend from Stage 1 into the backend's static folder
COPY --from=build-frontend /app/frontend/build /app/frontend/build

# Expose the port for Flask
EXPOSE 8080

# Start the Flask app
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
