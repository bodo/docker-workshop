FROM golang:1.25.0 AS builder
WORKDIR /app
COPY src/hello-world.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/hello hello-world.go


FROM alpine:3.20.2
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder --chown=appuser:appgroup /go/bin/hello /hello
USER appuser

CMD ["/hello"]
