# Build stage
FROM golang:1.26-alpine AS builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o fuid-ise .

# Runtime stage
FROM alpine:3.21
RUN apk add --no-cache openssl ca-certificates bash && \
    rm -rf /var/cache/apk/*
WORKDIR /app
COPY --from=builder /build/fuid-ise /usr/local/bin/fuid-ise
ENTRYPOINT ["fuid-ise"]
