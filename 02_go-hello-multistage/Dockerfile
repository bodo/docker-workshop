# stage 1: compile the GO source code to a /go/bin/hello binary executable
FROM golang:1.25.0 AS builder
WORKDIR /app
# cp <source-outside> <dest-inside>
COPY ./src/hello-world.go ./

# ChatGPT can explain each part nicely ;-)
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/hello hello-world.go



# stage 2: copy the bin from previous stage into the final image
FROM alpine:3.20.2
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# --from=builder references the image in the step above!
#
COPY --from=builder --chown=appuser:appgroup /go/bin/hello /hello
USER appuser

CMD ["/hello"]
