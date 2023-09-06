# An official Node runtime
# FROM node:18

# Set working directory in the container
# WORKDIR /app

# Copy package files (package.json & package-lock.json) to container
# COPY package*.json ./

# Install ffmpeg
# RUN apt-get update && apt-get install -y ffmpeg

# Install dependencies
# RUN npm install

# Copy source code
# COPY . .

# Make port available
# EXPOSE 8030

# CMD ["npm", "start"]

# Stage 1: Build stage
FROM node:18 AS builder

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json into the working directory
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle app source inside the docker image
COPY . .

# Build the app
RUN npm run build

# Stage 2: Production stage
FROM node:18

# Install ffmpeg in the container
RUN apt-get update && apt-get install -y ffmpeg

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Copy built app from the builder stage
COPY --from=builder /app/dist ./dist

# Copy built app from the builder stage
COPY Demo.mp4 ./

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define the command to run your app using CMD which defines your runtime
CMD [ "npm", "run", "serve" ]

