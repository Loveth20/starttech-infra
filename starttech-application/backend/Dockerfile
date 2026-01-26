# Stage 1: Build
FROM golang:1.25.5-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum first
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go binary
RUN go build -o backend .

# Stage 2: Minimal runtime image
FROM alpine:latest

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/backend .

# Expose port 8080
EXPOSE 8080

# Run the binary
CMD ["./backend"]

