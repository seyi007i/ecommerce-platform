
# Stage 1: Build frontend
FROM node:14 as frontend-build

# Set the working directory for the frontend
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for frontend
COPY ./webapp/package*.json ./

# Install frontend dependencies
RUN npm install

# Copy frontend source code
COPY ./webapp .

# Build the frontend
RUN npm run build


# Stage 2: Build backend
FROM node:14 as backend-build

# Set the working directory for the backend
WORKDIR /app/backend

# Copy package.json and package-lock.json for backend
COPY ./api/package*.json ./

# Install backend dependencies
RUN npm install

# Copy backend source code
COPY ./backend .

# Build the backend
RUN npm run build


# Stage 3: Production environment
FROM node:14-alpine

# Set the working directory for the app
WORKDIR /app

# Copy built frontend files from the frontend-build stage
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Copy built backend files from the backend-build stage
COPY --from=backend-build /app/backend/build ./backend/build

# Install production dependencies for backend (if any)
WORKDIR /app/backend
RUN npm install --only=production

# Expose port 3000 (adjust as needed for your backend)
EXPOSE 3000

# Command to run the backend server
CMD ["node", "backend/build/index.js"]
