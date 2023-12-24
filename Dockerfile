FROM --platform=linux/amd64 golang:1.21.5-alpine as builder
ENV GOARCH=amd64

# set the working directory
WORKDIR /web

#copy source
COPY .  .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

FROM --platform=linux/amd64 alpine:3.19.0 as final

# Create a non-root user to limit privilegs as container would be web facing
RUN addgroup -S app && adduser -S app -G app

USER app
WORKDIR /app

# Copy the built application from the builder stage and change ownership
COPY --chown=app:app --from=builder /web/main  /app/main
COPY --chown=app:app --from=builder /web/static  /app/static

# Run the application
CMD ["./main"]