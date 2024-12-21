# Stage 1: Build the Go application
FROM golang:1.20 AS builder

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

EXPOSE 80

# Keep the container running for inspection
CMD ["./wordsmith"]
