# Stage 1: Build the Go application
FROM golang:1.20 AS builder

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Initialize and tidy Go module dependencies
RUN go mod init wordsmith
RUN go mod tidy

# Build the Go application with a specific output name
RUN go build -o wordsmith dispatcher.go

# Debug: Check if the binary exists
RUN ls -l /app

EXPOSE 80

# Keep the container running for inspection
CMD ["./wordsmith"]
