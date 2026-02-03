# Builder Stage
FROM golang:1.25 AS Builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

# Copy all file with go extension to our image
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o main


# Run Stage
FROM alpine:latest
RUN apk --no-cache add ca-certifications
WORKDIR /root/
COPY --from=Builder /app/main .
EXPOSE 8000
CMD ["./main"]